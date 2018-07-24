//
//  LYRUILargePlayableMediaMessageContainerViewLayout.m
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 7/6/18.
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

#import "LYRUILargePlayableMediaMessageContainerViewLayout.h"
#import "LYRUILargeMediaMessageContainerView.h"

@implementation LYRUILargePlayableMediaMessageContainerViewLayout

- (NSArray<NSLayoutConstraint *> *)contentViewConstraintsForView:(LYRUIStandardMessageContainerView *)view {
    view.contentViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    return @[ [view.contentViewContainer.centerYAnchor constraintEqualToAnchor:view.centerYAnchor constant:-48.f],
              [view.contentViewContainer.leftAnchor constraintEqualToAnchor:view.leftAnchor],
              [view.contentViewContainer.rightAnchor constraintEqualToAnchor:view.rightAnchor] ];
}

- (NSArray<NSLayoutConstraint *> *)metadataContainerConstraintsForView:(LYRUILargeMediaMessageContainerView *)view {
    view.metadataContainer.translatesAutoresizingMaskIntoConstraints = NO;
    return @[ [view.metadataContainer.topAnchor constraintEqualToAnchor:view.contentViewContainer.bottomAnchor],
              [view.metadataContainer.leftAnchor constraintEqualToAnchor:view.leftAnchor],
              [view.metadataContainer.rightAnchor constraintEqualToAnchor:view.rightAnchor] ];
}

- (NSArray<NSLayoutConstraint *> *)additionalConstraintsForView:(LYRUILargeMediaMessageContainerView *)view {
    view.playbackControlView.translatesAutoresizingMaskIntoConstraints = NO;
    view.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    [view.progressView removeFromSuperview];
    [view addSubview:view.progressView];
    NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray array];
    [constraints addObject:[view.playbackControlView.leftAnchor constraintEqualToAnchor:view.leftAnchor]];
    [constraints addObject:[view.playbackControlView.rightAnchor constraintEqualToAnchor:view.rightAnchor]];
    [constraints addObject:[view.playbackControlView.bottomAnchor constraintEqualToAnchor:view.bottomAnchor]];
    [constraints addObject:[view.playbackControlView.heightAnchor constraintEqualToConstant:96.0f]];
    return constraints;
}

@end
