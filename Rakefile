require 'rubygems'
begin
  require 'bundler'
  require 'bundler/setup'
  require 'date' 
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

# Enable realtime output under Jenkins
if ENV['JENKINS_HOME']
  STDOUT.sync = true
  STDERR.sync = true
end

desc "Initialize the project for development and testing"
task :init do
  puts green("Update submodules...")
  run("git submodule update --init --recursive")
  puts green("Checking for Homebrew...")
  run("which brew > /dev/null && brew update; true")
  run("which brew > /dev/null || ruby -e \"$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)\"")
  puts green("Bundling Homebrew packages...")
  packages = %w{rbenv ruby-build rbenv-binstubs thrift}
  packages.each { |package| run("brew install #{package} || brew upgrade #{package}") }
  puts green("Checking rbenv version...")
  run("rbenv version-name || rbenv install")
  puts green("Checking for Bundler...")
  run("rbenv whence bundle | grep `cat .ruby-version` || rbenv exec gem install bundler")
  puts green("Bundling Ruby Gems...")
  run("rbenv exec bundle install --binstubs .bundle/bin --quiet")
  run("rbenv rehash")
  puts green("Ensuring Layer Specs repository")
  run("[ -d ~/.cocoapods/repos/layer ] || rbenv exec bundle exec pod repo add layer git@github.com:layerhq/cocoapods-specs.git")
  puts green("Installing CocoaPods...")
  run("rbenv exec bundle exec pod install --verbose")
end

desc "Clean project and run unit tests via xcodebuild"
task :test do
  unitTestsPassed = runTestsForScheme 'Atlas', { :clean => true }
  programmaticTestsPassed = runTestsForScheme 'Programmatic'
  storyboardTestsPassed = runTestsForScheme 'Storyboard'
  
  if unitTestsPassed != 0
    puts 'Unit tests failed'
  end
  if programmaticTestsPassed != 0
    puts 'Programmatic tests failed'
  end
  if storyboardTestsPassed != 0
    puts 'Storyboard tests failed'
  end
  
  if (programmaticTestsPassed | storyboardTestsPassed | unitTestsPassed) != 0
    fail('Testing failed.')
  end
end

def runTestsForScheme schemeName, options = {}
  command = "xcodebuild #{options[:clean]?'clean':''} test \
              -workspace Atlas.xcworkspace \
              -scheme #{schemeName} \
              -destination 'platform=iOS Simulator,OS=10.2,name=iPhone SE' \
              -configuration Debug"
  return run command, { :noautofail => true }
end

desc "Creates a Testing Simulator configured for Atlas Testing"
task :sim do
  # Check if LayerUIKit Test Device Exists
  device = `xcrun simctl list | grep Atlas-Test-Device`
  if $?.exitstatus.zero?
    puts ("Found Atlas Test Device #{device}")
    device.each_line do |line|
      if device_id = line.match(/\(([^\)]+)/)[1]
        puts green ("Deleting device with ID #{device_id}")
        run ("xcrun simctl delete #{device_id}")
      end
    end
  end
  puts green ("Creating iOS simulator for Atlas Testing")
  run("xcrun simctl create Atlas-Test-Device com.apple.CoreSimulator.SimDeviceType.iPhone-6 com.apple.CoreSimulator.SimRuntime.iOS-8-1")
end

desc "Prints the current version of Atlas"
task :version do  
  puts atlas_version
end

namespace :version do
  desc "Sets the version by updating Atlas.podspec and Code/Atlas.m"
  task :set => :fetch_origin do
    version = ENV['VERSION']
    if version.nil? || version == ''
      fail "You must specify a VERSION"
    end
    
    existing_tag = `git tag -l v#{version}`.chomp
    if existing_tag != ''
      fail "A tag already exists for version v#{version}: please specify a unique release version."
    end
    
    podspec_path = File.join(File.dirname(__FILE__), 'Atlas.podspec')
    podspec_content = File.read(podspec_path)
    unless podspec_content.gsub!(/(\.version\s+=\s+)['"](.+)['"]$/, "\\1'#{version}'")
      raise "Unable to update version of Podspec: version attribute not matched."
    end
    File.open(podspec_path, 'w') { |f| f << podspec_content }
    
    atlas_m_path = File.join(File.dirname(__FILE__), 'Code', 'Atlas.m')
    atlas_m_content = File.read(atlas_m_path)    
    unless atlas_m_content.gsub!(/(ATLVersionString\s+=\s+@\")(.+)(\";)/, "\\1#{version}\\3")
      raise "Unable to update ATLVersionString in #{atlas_m_path}: version string not matched."
    end
    File.open(atlas_m_path, 'w') { |f| f << atlas_m_content }
    
    run "git add Atlas.podspec Code/Atlas.m"
    
    require 'highline/import'    
    system("git diff --cached") if agree("Review package diff? (y/n) ")
    system("bundle exec pod update") if agree("Run `pod update`? (y/n) ")
    system("git commit -m 'Updating version to #{version}' Atlas.podspec Code/Atlas.m Podfile.lock") if agree("Commit package artifacts? (y/n) ")
    system("git push origin HEAD") if agree("Push version update to origin? (y/n)")
  end
end

desc "Verifies the Atlas release tag and package"
task :release => [:fetch_origin] do    
  with_clean_env do
    path = File.join(File.dirname(__FILE__), 'Atlas.podspec')
    version = File.read(path).match(/\.version\s+=\s+['"](.+)['"]$/)[1]  
    
    atlas_source = File.read(File.join(File.dirname(__FILE__), 'Code', 'Atlas.m'))
    unless atlas_source =~ /ATLVersionString \= \@\"#{Regexp.escape version}\"/
      puts red("Build failed: `ATLVersionString` != #{version}. Looks like you forgot to update Code/Atlas.m")
      exit -1
    end
    
    changelog = File.read(File.join(File.dirname(__FILE__), 'CHANGELOG.md'))
    version_prefix = version.gsub(/-[\w\d]+/, '')
    puts "Checking for #{version_prefix}"
    unless changelog =~ /^## #{version_prefix}/
      fail "Unable to locate CHANGELOG section for version #{version}"
    end
    
    puts "Fetching remote tags from origin..."
    run "git fetch origin --tags"
    existing_tag = `git tag -l v#{version}`.chomp
    if existing_tag != ''
      fail "A tag already exists for version v#{version}: Maybe you need to run `rake version:set`?"
    end
    
    puts green("Tagging Atlas v#{version}")
    run("git tag v#{version}")
    run("git push origin --tags")
    
    root_dir = File.expand_path(File.dirname(__FILE__))
    path = File.join(root_dir, 'Atlas.podspec')
    version = File.read(path).match(/\.version\s+=\s+['"](.+)['"]$/)[1]
    existing_tag = `git tag -l v#{version}`.chomp
    fail "Unable to find tag v#{version}" unless existing_tag
    
    with_clean_env do
      podspec = File.join(root_dir, "Atlas.podspec")
      puts green("Pushing podspec to CocoaPods trunk")
      run "rbenv exec bundle exec pod trunk push --allow-warnings #{podspec}"
    end
    
    Rake::Task["publish_github_release"].invoke
  end
end

task :fetch_origin do
  run "git fetch origin --tags"
end

# Safe to run when Bundler is not available
def with_clean_env(&block)
  if defined?(Bundler)
    Bundler.with_clean_env(&block)
  else
    yield
  end
end

def run(command, options = {})
  puts "Executing `#{command}`" unless options[:quiet]
  unless with_clean_env { system(command) }
    unless options[:noautofail]
      fail("Command exited with non-zero exit status (#{$?}): `#{command}`")
    else
      return $?.exitstatus
    end
  end
  
  return $?.exitstatus
end

def atlas_version
  path = File.join(File.dirname(__FILE__), 'Atlas.podspec')
  version = File.read(path).match(/\.version\s+=\s+['"](.+)['"]$/)[1]
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

def changelog_for_version(version)
  capturing = false
  Array.new.tap do |release_notes|
    File.read('./CHANGELOG.md').each_line do |line|
      if line =~ /^\#\#\s#{Regexp.escape(version)}$/
        capturing = true
      else
        if line =~ /^\#\#\s[\d\.]+$/
          capturing = false
        else
          if capturing
            release_notes << line
          end
        end
      end
    end
  end.join
end

def current_version
  root_dir = File.expand_path(File.dirname(__FILE__))
  path = File.join(root_dir, 'Atlas.podspec')
  File.read(path).match(/\.version\s+=\s+['"](.+)['"]$/)[1]
end

desc "Publishes a Github release including the changelog"
task :publish_github_release do
  if ENV['GITHUB_TOKEN']
    require 'json'
    run "rm -rf ~/Library/Caches/com.layer.Atlas"
    version = ENV['VERSION'] || current_version
    version_tag = "v#{version}"
    release_notes = changelog_for_version(version)
    puts "Creating Github release #{version_tag}..."
    puts "Release Notes:\n#{release_notes}"
    release = { tag_name: version_tag, body: release_notes }
    uri = URI('https://api.github.com/repos/layerhq/Atlas-iOS/releases')
    request = Net::HTTP::Post.new(uri)
    request.basic_auth ENV['GITHUB_TOKEN'], 'x-oauth-basic'
    request.body = JSON.generate(release)
    request["Content-Type"] = "application/json"
    http = Net::HTTP.new(uri.hostname, uri.port)
    http.use_ssl = true
    response = http.request(request)
    puts "Got response: #{response}"
    release = JSON.parse(response.body)
    puts "Created release: #{release.inspect}"
  else
    puts "!! Cannot create Github release on releases-ios: Please configure a personal Github token and export it as the `GITHUB_TOKEN` environment variable."
  end
end

task :extract_changelog do
  puts changelog_for_version(current_version)
end
