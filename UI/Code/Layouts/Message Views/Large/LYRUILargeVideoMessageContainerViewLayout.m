//
//  LYRUILargeVideoMessageContainerViewLayout.m
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 7/10/18.
//  Copyright (c) 2018 Layer. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "LYRUILargeVideoMessageContainerViewLayout.h"
#import "LYRUILargeMediaMessageContainerView.h"

@implementation LYRUILargeVideoMessageContainerViewLayout

- (NSArray<NSLayoutConstraint *> *)contentViewConstraintsForView:(LYRUIStandardMessageContainerView *)view {
    view.contentViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [view.contentViewContainer setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [view.contentViewContainer setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    return @[ [view.contentViewContainer.topAnchor constraintEqualToAnchor:view.topAnchor],
              [view.contentViewContainer.leftAnchor constraintEqualToAnchor:view.leftAnchor],
              [view.contentViewContainer.rightAnchor constraintEqualToAnchor:view.rightAnchor] ];
}

- (NSArray<NSLayoutConstraint *> *)metadataContainerConstraintsForView:(LYRUILargeMediaMessageContainerView *)view {
    view.metadataContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [view.metadataContainer setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [view.metadataContainer setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    return @[ [view.metadataContainer.topAnchor constraintEqualToAnchor:view.contentViewContainer.bottomAnchor],
              [view.metadataContainer.leftAnchor constraintEqualToAnchor:view.leftAnchor],
              [view.metadataContainer.rightAnchor constraintEqualToAnchor:view.rightAnchor],
              [view.metadataContainer.bottomAnchor constraintEqualToAnchor:view.playbackControlView.topAnchor] ];
}

@end
