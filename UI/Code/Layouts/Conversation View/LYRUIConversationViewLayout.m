//
//  LYRUIConversationViewLayout.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 31.08.2017.
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

#import "LYRUIConversationViewLayout.h"
#import "LYRUIMessageListView.h"
#import "LYRUIComposeBar.h"

@interface LYRUIConversationViewLayout ()

@property (nonatomic, strong) NSMutableArray *constraints;

@end

@implementation LYRUIConversationViewLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.constraints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] init];
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[self class]];
}

- (void)addConstraintsInView:(LYRUIConversationView *)view {
    view.messageListView.translatesAutoresizingMaskIntoConstraints = NO;
    view.composeBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.constraints addObject:[view.messageListView.topAnchor constraintEqualToAnchor:view.topAnchor]];
    [self.constraints addObject:[view.messageListView.rightAnchor constraintEqualToAnchor:view.rightAnchor]];
    [self.constraints addObject:[view.messageListView.leftAnchor constraintEqualToAnchor:view.leftAnchor]];
    [self.constraints addObject:[view.messageListView.bottomAnchor constraintEqualToAnchor:view.composeBar.topAnchor]];
    [self.constraints addObject:[view.composeBar.rightAnchor constraintEqualToAnchor:view.rightAnchor]];
    [self.constraints addObject:[view.composeBar.leftAnchor constraintEqualToAnchor:view.leftAnchor]];
    NSLayoutConstraint *bottomConstraint = [view.bottomAnchor constraintEqualToAnchor:view.composeBar.bottomAnchor];
    [self.constraints addObject:bottomConstraint];
    [NSLayoutConstraint activateConstraints:self.constraints];
    view.keyboardMaintainedConstraint = bottomConstraint;
}

- (void)updateConstraintsInView:(LYRUIConversationView *)view {}

- (void)removeConstraintsFromView:(LYRUIConversationView *)view {
    [NSLayoutConstraint deactivateConstraints:self.constraints];
    [self.constraints removeAllObjects];
}

@end
