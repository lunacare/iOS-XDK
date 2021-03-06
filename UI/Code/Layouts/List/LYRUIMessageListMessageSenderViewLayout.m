//
//  LYRUIMessageListMessageSenderViewLayout.m
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 05/10/2018.
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

#import "LYRUIMessageListMessageSenderViewLayout.h"

@interface LYRUIMessageListMessageSenderViewLayout ()

@property (nonatomic, strong) NSMutableArray *labelConstraints;

@end

@implementation LYRUIMessageListMessageSenderViewLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.labelConstraints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] init];
}

- (BOOL)isEqual:(id)other {
    return [self isKindOfClass:[other class]];
}

- (void)addConstraintsInView:(UIView<LYRUIListHeaderView> *)view {
    NSMutableArray *constraints = self.labelConstraints;
    [constraints addObject:[view.label.topAnchor constraintEqualToAnchor:view.topAnchor constant:2.0]];
    [constraints addObject:[view.label.leftAnchor constraintEqualToAnchor:view.leftAnchor constant:60.0]];
    [constraints addObject:[view.label.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:-2.0]];
    [constraints addObject:[view.label.rightAnchor constraintEqualToAnchor:view.rightAnchor constant:-60.0]];
    [constraints addObject:[view.label.heightAnchor constraintEqualToConstant:13.0]];
    view.label.textAlignment = NSTextAlignmentLeft;
    view.label.font = [UIFont systemFontOfSize:11.0];
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)updateConstraintsInView:(UIView<LYRUIListHeaderView> *)view {}

- (void)removeConstraintsFromView:(UIView<LYRUIListHeaderView> *)view {
    [NSLayoutConstraint deactivateConstraints:self.labelConstraints];
    [self.labelConstraints removeAllObjects];
}

@end
