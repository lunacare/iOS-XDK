//
//  LYRUIAudioMessageContainerViewLayout.m
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 6/12/18.
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

#import "LYRUIAudioMessageContainerViewLayout.h"
#import "LYRUIMediaMessageContainerView.h"

@implementation LYRUIAudioMessageContainerViewLayout

- (NSArray<NSLayoutConstraint *> *)playButtonConstraintsForView:(LYRUIMediaMessageContainerView *)view {
    NSMutableArray<NSLayoutConstraint *> *constraints = [[NSMutableArray alloc] init];
    view.mediaControlButton.translatesAutoresizingMaskIntoConstraints = NO;
    [constraints addObject:[view.mediaControlButton.rightAnchor constraintEqualToAnchor:view.metadataContainer.rightAnchor constant:-12.0]];
    [constraints addObject:[view.mediaControlButton.bottomAnchor constraintEqualToAnchor:view.metadataContainer.bottomAnchor constant:-12.0]];
    [constraints addObject:[view.mediaControlButton.widthAnchor constraintEqualToConstant:24.0]];
    [constraints addObject:[view.mediaControlButton.heightAnchor constraintEqualToConstant:24.0]];
    return constraints;
}

@end
