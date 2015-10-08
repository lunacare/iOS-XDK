platform :ios, '8.0'

# Import CocoaPods sources
source 'https://github.com/CocoaPods/Specs.git'
source 'git@github.com:layerhq/cocoapods-specs.git'

dropbox_path = ENV['LAYER_DROPBOX_PATH'] || '~/Dropbox (Layer)'

use_frameworks!

pod 'Atlas', path: '.'
pod 'LayerKit', path: "#{dropbox_path}/Layer/Builds/iOS/LayerKit-0.17.0-pre5"

target 'ProgrammaticTests' do
  pod 'KIFViewControllerActions', git: 'https://github.com/blakewatters/KIFViewControllerActions.git'
  pod 'LYRCountDownLatch', git: 'https://github.com/layerhq/LYRCountDownLatch.git'
  pod 'KIF'
  pod 'Expecta'
  pod 'OCMock'
end

target 'StoryboardTests' do
  pod 'KIFViewControllerActions', git: 'https://github.com/blakewatters/KIFViewControllerActions.git'
  pod 'LYRCountDownLatch', git: 'https://github.com/layerhq/LYRCountDownLatch.git'
  pod 'KIF'
  pod 'Expecta'
  pod 'OCMock'
end

target 'UnitTests' do
  pod 'Expecta'
  pod 'OCMock'
end
