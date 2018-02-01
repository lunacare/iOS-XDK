//
//  LYRUIStatusMessageCellLayout.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 09.01.2018.
//  Copyright (c) 2017 Layer. All rights reserved.
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

#import "LYRUIStatusMessageCellLayout.h"
#import "UIView+LYRUISafeArea.h"
#import "UIView+LYRUILayoutGuide.h"
#import "UILayoutGuide+LYRUILayoutGuide.h"

@interface LYRUIStatusMessageCellLayout ()

@property (nonatomic, strong) NSMutableArray *textLabelConstraints;

@end

@implementation LYRUIStatusMessageCellLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.textLabelConstraints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] init];
}

- (BOOL)isEqual:(id)other {
    return [self isKindOfClass:[other class]];
}

- (void)addConstraintsInView:(UIView<LYRUIStatusMessageView> *)view {
    NSMutableArray *constraints = self.textLabelConstraints;
    id<LYRUILayoutGuide> layoutGuide = view.lyr_safeAreaLayoutGuide ?: view;
    [constraints addObject:[view.textView.topAnchor constraintEqualToAnchor:view.topAnchor constant:1.0]];
    [constraints addObject:[view.textView.leftAnchor constraintEqualToAnchor:layoutGuide.leftAnchor constant:7.0]];
    [constraints addObject:[view.textView.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:-2.0]];
    [constraints addObject:[view.textView.rightAnchor constraintEqualToAnchor:layoutGuide.rightAnchor constant:-7.0]];
    view.textView.textAlignment = NSTextAlignmentCenter;
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)updateConstraintsInView:(UIView<LYRUIStatusMessageView> *)view {}

- (void)removeConstraintsFromView:(UIView<LYRUIStatusMessageView> *)view {
    [NSLayoutConstraint deactivateConstraints:self.textLabelConstraints];
    [self.textLabelConstraints removeAllObjects];
}

@end
