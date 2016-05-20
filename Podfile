source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

use_frameworks!

target 'Programmatic' do
  pod 'Atlas', path: '.'
end

target 'Storyboard' do
  pod 'Atlas', path: '.'
end

abstract_target 'test' do
  pod 'KIFViewControllerActions', git: 'https://github.com/blakewatters/KIFViewControllerActions.git'
  pod 'LYRCountDownLatch', git: 'https://github.com/layerhq/LYRCountDownLatch.git'
  pod 'KIF'
  pod 'Expecta'
  pod 'OCMock'

  target 'ProgrammaticTests'
  target 'StoryboardTests'
end

target 'UnitTests' do
  pod 'Expecta'
  pod 'OCMock'
end



