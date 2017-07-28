//
//  LYRUIAvatarViewSingleLayout.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 24.07.2017.
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

#import "LYRUIAvatarViewSingleLayout.h"
#import "LYRUIAvatarView+PrivateProperties.h"
#import "LYRUIImageWithLettersView.h"
#import "LYRUIPresenceView.h"

@interface LYRUIAvatarViewSingleLayout ()

@property (nonatomic) LYRUIAvatarViewLayoutSize currentSize;

@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *avatarConstraints;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *presenceCenterConstraints;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *presenceCornerConstraints;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *presenceSizeConstraints;

@property (nonatomic, readonly) BOOL shouldCenterPresenceView;
@property (nonatomic, readonly) BOOL shouldHideAvatar;
@property (nonatomic, readonly) CGFloat presenceViewSize;

@end

@implementation LYRUIAvatarViewSingleLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.avatarConstraints = [[NSMutableArray alloc] init];
        self.presenceCenterConstraints = [[NSMutableArray alloc] init];
        self.presenceCornerConstraints = [[NSMutableArray alloc] init];
        self.presenceSizeConstraints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] init];
}

#pragma mark - LYRUIAvatarViewLayout methods

- (void)addConstraintsInView:(LYRUIAvatarView *)view {
    self.currentSize = [self layoutSizeForViewHeight:CGRectGetHeight(view.frame)];
    [self addAvatarConstraintsInView:view];
    [self addPresenceCenterConstraintsInView:view];
    [self addPresenceCornerConstraintsInView:view];
    [self addPresenceSizeConstraintsInView:view];
    [self updateViewsVisibilityInView:view];
}

- (void)removeConstraintsFromView:(LYRUIAvatarView *)view {
    [self removeConstraints:self.avatarConstraints];
    [self removeConstraints:self.presenceCenterConstraints];
    [self removeConstraints:self.presenceCornerConstraints];
    [self removeConstraints:self.presenceSizeConstraints];
}

- (void)updateConstraintsInView:(LYRUIAvatarView *)view {
    self.currentSize = [self layoutSizeForViewHeight:CGRectGetHeight(view.frame)];
    [self updatePresenceSize];
    [self updatePresenceAlignment];
    [self updateViewsVisibilityInView:view];
}

#pragma mark - Constraints

- (void)addAvatarConstraintsInView:(LYRUIAvatarView *)view {
    NSMutableArray *constraints = [NSMutableArray new];
    [constraints addObject:[view.primaryAvatarView.widthAnchor constraintEqualToAnchor:view.widthAnchor]];
    [constraints addObject:[view.primaryAvatarView.heightAnchor constraintEqualToAnchor:view.heightAnchor]];
    [constraints addObject:[view.primaryAvatarView.centerXAnchor constraintEqualToAnchor:view.centerXAnchor]];
    [constraints addObject:[view.primaryAvatarView.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]];
    
    [self.avatarConstraints addObjectsFromArray:constraints];
    [view addConstraints:constraints];
}

- (void)addPresenceCenterConstraintsInView:(LYRUIAvatarView *)view {
    NSMutableArray *constraints = [NSMutableArray new];
    [constraints addObject:[view.presenceView.centerXAnchor constraintEqualToAnchor:view.centerXAnchor]];
    [constraints addObject:[view.presenceView.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]];
    
    [self.presenceCenterConstraints addObjectsFromArray:constraints];
    if (self.shouldCenterPresenceView) {
        [view addConstraints:constraints];
    }
}

- (void)addPresenceCornerConstraintsInView:(LYRUIAvatarView *)view {
    NSMutableArray *constraints = [NSMutableArray new];
    [constraints addObject:[view.presenceView.trailingAnchor constraintEqualToAnchor:view.trailingAnchor]];
    [constraints addObject:[view.presenceView.bottomAnchor constraintEqualToAnchor:view.bottomAnchor]];
    
    [self.presenceCornerConstraints addObjectsFromArray:constraints];
    if (!self.shouldCenterPresenceView) {
        [view addConstraints:constraints];
    }
}

- (void)updatePresenceAlignment {
    for (NSLayoutConstraint *constraint in self.presenceCenterConstraints) {
        constraint.active = self.shouldCenterPresenceView;
    }
    for (NSLayoutConstraint *constraint in self.presenceCornerConstraints) {
        constraint.active = !self.shouldCenterPresenceView;
    }
}

- (void)addPresenceSizeConstraintsInView:(LYRUIAvatarView *)view {
    NSMutableArray *constraints = [NSMutableArray new];
    [constraints addObject:[view.presenceView.widthAnchor constraintEqualToConstant:self.presenceViewSize]];
    [constraints addObject:[view.presenceView.heightAnchor constraintEqualToConstant:self.presenceViewSize]];
    
    [self.presenceSizeConstraints addObjectsFromArray:constraints];
    [view addConstraints:constraints];
}

- (void)updatePresenceSize {
    for (NSLayoutConstraint *constraint in self.presenceSizeConstraints) {
        constraint.constant = self.presenceViewSize;
    }
}

#pragma mark - Presence alignment

- (BOOL)shouldCenterPresenceView {
    return self.currentSize == LYRUIAvatarViewLayoutSizeTiny;
}

#pragma mark - Views visibility

- (void)updateViewsVisibilityInView:(LYRUIAvatarView *)view {
    view.presenceView.hidden = NO;
    view.secondaryAvatarView.hidden = YES;
    view.primaryAvatarView.hidden = self.shouldHideAvatar;
}

- (BOOL)shouldHideAvatar {
    return self.currentSize == LYRUIAvatarViewLayoutSizeTiny;
}

#pragma mark - Presence view size

- (CGFloat)presenceViewSize {
    switch (self.currentSize) {
        case LYRUIAvatarViewLayoutSizeTiny:
        case LYRUIAvatarViewLayoutSizeSmall:
        case LYRUIAvatarViewLayoutSizeMedium:
            return 12.0;
        case LYRUIAvatarViewLayoutSizeLarge:
            return 14.0;
        case LYRUIAvatarViewLayoutSizeXLarge:
            return 16.0;
    }
}

#pragma mark - Layout size

- (LYRUIAvatarViewLayoutSize)layoutSizeForViewHeight:(CGFloat)height {
    if (height >= 72) {
        return LYRUIAvatarViewLayoutSizeXLarge;
    } else if (height >= 48) {
        return LYRUIAvatarViewLayoutSizeLarge;
    } else if (height >= 40) {
        return LYRUIAvatarViewLayoutSizeMedium;
    } else if (height >= 32) {
        return LYRUIAvatarViewLayoutSizeSmall;
    } else {
        return LYRUIAvatarViewLayoutSizeTiny;
    }
}

#pragma mark - Helpers {

- (void)removeConstraints:(NSMutableArray<NSLayoutConstraint *> *)constraints {
    for (NSLayoutConstraint *constraint in constraints) {
        constraint.active = NO;
    }
    [constraints removeAllObjects];
}

@end
