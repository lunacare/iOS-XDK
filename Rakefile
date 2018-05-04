require 'rubygems'
begin
  require 'bundler'
  require 'bundler/setup'
  require 'date'
  require 'xcodeproj'
  begin
    Bundler.setup
  rescue Bundler::GemNotFound => gemException
    raise LoadError, gemException.to_s
  end
rescue LoadError => exception
  unless ARGV.include?('init')
    puts "Rescued exception: #{exception}"
    puts "WARNING: Failed to load dependencies: Is the project initialized? Run `rake init`"
  end
end

def current_version
  root_dir = File.expand_path(File.dirname(__FILE__))
  path = File.join(root_dir, 'LayerMessaging.podspec')
  File.read(path).match(/\.version\s+=\s+['"](.+)['"]$/)[1]
end

def version
  ENV['VERSION'] || current_version
end

#-------------------------------------------------------------------------#
# Project setup
#-------------------------------------------------------------------------#
desc "Initialize the project for development and testing"
task :init do
  puts green("Checking for Homebrew...")
  run("which brew > /dev/null && brew update; true")
  run("which brew > /dev/null || ruby -e \"$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)\"")
  puts green("Bundling Homebrew packages...")
  packages = %w{rbenv rbenv-binstubs xctool carthage}
  packages.each { |package| run("brew install #{package} || brew upgrade #{package}") }
  puts green("Checking rbenv version...")
  run("rbenv version-name || rbenv install")
  puts green("Checking for Bundler...")
  run("rbenv whence bundle | grep `cat .ruby-version` || rbenv exec gem install bundler")
  puts green("Bundling Ruby Gems...")
  run("rbenv exec bundle install --binstubs .bundle/bin --quiet")
  puts green("Ensuring Layer Specs repository")
  run("[ -d ~/.cocoapods/repos/layer ] || rbenv exec bundle exec pod repo add layer git@github.com:layerhq/cocoapods-specs.git")
  puts green("Updating Submodules")
  run("git submodule update --init --recursive")
  puts green("Installing CocoaPods...")
  run("rbenv exec bundle exec pod install")
  puts green("Checking rbenv configuration...")
  system <<-SH
  if [ -f ~/.zshrc ]; then
    grep -q 'rbenv init' ~/.zshrc || echo 'eval "$(rbenv init - --no-rehash)"' >> ~/.zshrc
  else
    grep -q 'rbenv init' ~/.bash_profile || echo 'eval "$(rbenv init - --no-rehash)"' >> ~/.bash_profile
  fi
  SH
  puts "\n" + yellow("If first initialization, load rbenv by executing:")
  puts grey("$ `eval \"$(rbenv init - --no-rehash)\"`")
end

#-------------------------------------------------------------------------#
# Testing
#-------------------------------------------------------------------------#
namespace :test do
  desc "Run XDK UI - iOS Tests."
  task :unit_tests do
    run_test_ios_scheme "UnitTests"
  end

  def run_test_ios_scheme scheme_name
    run_test_scheme(scheme_name, "platform=iOS Simulator,name=iPhone 7")
  end

  def run_test_tvos_scheme scheme_name
    run_test_scheme(scheme_name, "platform=tvOS Simulator,name=Apple TV 1080p")
  end

  def run_test_macos_scheme scheme_name
    run_test_scheme(scheme_name, "platform=macOS")
  end

  def run_test_scheme(scheme_name, destination)
    sh "set -eou pipefail && xcodebuild -workspace LayerMessaging.xcworkspace -scheme '#{scheme_name}' -configuration Debug -destination '#{destination}' test | xcpretty --report html --output Tests/Output/#{scheme_name}.html"
  end
end

namespace :carthage do
  desc "Initializes Carthage XCode project's schemes."
  task :initialize do
    root_dir = File.expand_path(File.dirname(__FILE__))
    ui_path = File.join(root_dir, "UI")
    carthage_path = "./UI/Carthage"
    carthage_project_filename = "UI.xcodeproj"

    # 0. Make sure carthage gets all dependencies.
    # run("cd #{ui_path} && carthage update")

    # 1. Purge existing Carthage XCode project.
    carthage_project_path = File.join(root_dir, carthage_path, carthage_project_filename)
    FileUtils.remove_dir(carthage_project_path, true)

    # 2. Create an empty project.
    xcproj = Xcodeproj::Project.new(carthage_project_path)

    # 3. Add target for the framework.
    framework_product_group = xcproj.new_group("UI", "../Code", :group)
    framework_target = xcproj.new_target(:framework, "UI", :ios, nil, framework_product_group, :objc)

    # 4. Add file references to the target (scan all .m files in `../Coode`,
    # there's about 232 files in total).
    ui_code_path = File.join(root_dir, "UI", "Code")
    source_files = Dir.glob("#{ui_code_path}/**/*.m").map { |source_file| xcproj.new_file(source_file, :group) }
    build_files = framework_target.add_file_references(source_files, nil)

    # 5. Add Public Headers (scan all .h files in `../Code`).
    header_files = Dir.glob("#{ui_code_path}/**/*.h").map { |header_file| xcproj.new_file(header_file, :group) }
    header_files.each do |f|
      build_file = framework_target.headers_build_phase.add_file_reference(f, nil)
    end

    # 6. Link LayerKit.framework.
    layerkit_framework_path = File.join("Build", "iOS", "LayerKit.framework")
    layerkit_framework_xcode_file = xcproj.new_file(layerkit_framework_path, :group)
    framework_target.frameworks_build_phase.add_file_reference(layerkit_framework_xcode_file, nil)

    # 7. Add framework search paths for LayerKit.
    framework_target.build_configuration_list.set_setting("LD_RUNPATH_SEARCH_PATHS", "@executable_path/Frameworks @loader_path/Frameworks")
    framework_target.build_configuration_list.set_setting("FRAMEWORK_SEARCH_PATHS", "${SRCROOT}/Build/iOS/**")
    framework_target.build_configuration_list.set_setting("GCC_PREFIX_HEADER", "${SRCROOT}/../Code/Support/LayerXDK-prefix.pch")

    # 6. Add system libraries (CoreLocation.framework, Foundation.framework,
    # MapKit.framework, MobileCoreServices.framework, QuickLook.framework,
    # SafariServices.framework, UIKit.framework)
    system_frameworks = %w{CoreLocation Foundation MapKit MobileCoreServices QuickLook SafariServices UIKit}
    framework_target.add_system_frameworks(system_frameworks)

    # 7. Add resource build phase and put all files from `../Resources` in it.

    # Save the changes to the newly created project.
    xcproj.recreate_user_schemes
    xcproj.save
  end
end

#-------------------------------------------------------------------------#
# Rake Helpers
#-------------------------------------------------------------------------#
# Safe to run when Bundler is not available
def with_clean_env(&block)
  if defined?(Bundler)
    Bundler.with_clean_env(&block)
  else
    yield
  end
end

trap('INT') { abort "PID:#{$$} Exiting due to interrupt." }

def execute(command, print_all: false, print_command: true)
  require 'pty'
  prefix ||= {}

  output = []
  command = command.join(" ") if command.kind_of?(Array)
  puts "Executing `#{command}`" if print_command

  begin
    PTY.spawn(command) do |stdin, stdout, pid|
      begin
        stdin.each do |l|
          line = l.strip # strip so that \n gets removed
          output << line

          next unless print_all

          puts line
        end
      rescue Errno::EIO
        # This is expected on some linux systems, that indicates that the subcommand finished
        # and we kept trying to read, ignore it
      ensure
        Process.wait(pid)
      end
    end
  rescue => ex
    # This could happen when the environment is wrong:
    # > invalid byte sequence in US-ASCII (ArgumentError)
    output << ex.to_s
    o = output.join("\n")
    puts o
    raise ex
  end

  # Exit status for build command, should be 0 if build succeeded
  status = $?.exitstatus
  if status != 0
    o = output.join("\n")
    puts o # the user has the right to see the raw output
    puts red("Exit status: #{status}")
  end
  return status
end

def run(command, autoexit = true)
  puts "Executing `#{command}`"
  unless with_clean_env { system(command) }
    fail("Command exited with non-zero exit status (#{$?}): `#{command}`") if autoexit
  end
end

def green(string)
  "\033[1;32m* #{string}\033[0m"
end

def yellow(string)
  "\033[1;33m>> #{string}\033[0m"
end

def grey(string)
  "\033[0;37m#{string}\033[0m"
end

def red(string)
  "\033[0;31m\!\! #{string}\033[0m"
end

def project_root
  File.expand_path(File.dirname(__FILE__))
end
