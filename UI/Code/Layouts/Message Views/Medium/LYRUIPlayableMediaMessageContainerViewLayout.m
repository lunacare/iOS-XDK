//
//  LYRUIPlayableMediaMessageContainerViewLayout.m
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 6/1/18.
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

#import "LYRUIPlayableMediaMessageContainerViewLayout.h"
#import "LYRUIMediaMessageContainerView.h"

CGFloat const LYRUIPlayableMediaMessageContainerViewProgressHeight = 2.0f;

@implementation LYRUIPlayableMediaMessageContainerViewLayout

- (NSArray<NSLayoutConstraint *> *)additionalConstraintsForView:(LYRUIMediaMessageContainerView *)view {
    NSMutableArray<NSLayoutConstraint *> *constraints = [[NSMutableArray alloc] init];
    view.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    [constraints addObject:[view.progressView.rightAnchor constraintEqualToAnchor:view.contentViewContainer.rightAnchor]];
    [constraints addObject:[view.progressView.topAnchor constraintEqualToAnchor:view.contentViewContainer.bottomAnchor]];
    [constraints addObject:[view.progressView.widthAnchor constraintEqualToAnchor:view.widthAnchor]];
    [constraints addObject:[view.progressView.heightAnchor constraintEqualToConstant:LYRUIPlayableMediaMessageContainerViewProgressHeight]];
    [constraints addObjectsFromArray:[self playButtonConstraintsForView:view]];
    return constraints;
}

- (NSArray<NSLayoutConstraint *> *)playButtonConstraintsForView:(LYRUIMediaMessageContainerView *)view {
    return @[ ];
}

@end
