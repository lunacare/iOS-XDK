source 'https://github.com/CocoaPods/Specs.git'
if !ENV['LAYER_USE_CORE_SDK_LOCATION'].blank? then
  source ENV['LAYER_ADDITIONAL_SOURCE']
end

platform :ios, '8.0'

use_frameworks!

if !ENV['LAYER_USE_CORE_SDK_LOCATION'].blank? then
  pod 'LayerKit', path: ENV['LAYER_USE_CORE_SDK_LOCATION']
end

target 'Programmatic' do
  pod 'Atlas', path: '.'
end

target 'Storyboard' do
  pod 'Atlas', path: '.'
end

abstract_target 'test' do
  pod 'KIFViewControllerActions', '~> 1.0.2' 
  pod 'LYRCountDownLatch', git: 'https://github.com/layerhq/LYRCountDownLatch.git'
  pod 'KIF'
  pod 'Expecta'
  pod 'OCMock'
  pod 'Atlas', path: '.'

  target 'ProgrammaticTests'
  target 'StoryboardTests'
end

target 'UnitTests' do
  pod 'Expecta'
  pod 'OCMock'
  pod 'KIF'
  pod 'Atlas', path: '.'
end

# If we are building LayerKit from source then we need a post install hook to handle non-modular SQLite imports
unless ENV['LAYER_USE_CORE_SDK_LOCATION'].blank?
  post_install do |installer|
    installer.pods_project.build_configuration_list.build_configurations.each do |configuration|
      configuration.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
    end
  end
end

