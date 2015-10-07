platform :ios, '8.0'

# Import CocoaPods sources
source 'https://github.com/CocoaPods/Specs.git'
source 'git@github.com:layerhq/cocoapods-specs.git'

use_frameworks!

target 'Programmatic' do
  pod 'Atlas', path: '.'
  pod 'LayerKit', :git => 'git@github.com:layerhq/LayerKit.git'
end

target 'Storyboard' do
  pod 'Atlas', path: '.'
  pod 'LayerKit', :git => 'git@github.com:layerhq/LayerKit.git'
end

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
