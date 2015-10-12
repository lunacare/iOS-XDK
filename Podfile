platform :ios, '8.0'

# Import CocoaPods sources
source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

link_with 'Programmatic', 'Storyboard'

pod 'Atlas', path: '.'
pod 'LayerKit'

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
