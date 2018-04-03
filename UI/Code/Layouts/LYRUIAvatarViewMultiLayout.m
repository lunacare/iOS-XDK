//
//  LYRUIAvatarViewMultiLayout.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 25.07.2017.
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

#import "LYRUIAvatarViewMultiLayout.h"
#import "LYRUIAvatarView+PrivateProperties.h"
#import "LYRUIImageWithLettersView.h"
#import "LYRUIPresenceView.h"

static CGFloat const LYRUIAvatarViewMultiLayoutSizeMultiplier = 0.75;
static CGFloat const LYRUIAvatarViewMultiLayoutPresenceViewSize = 12.0;

@interface LYRUIAvatarViewMultiLayout ()

@property (nonatomic) LYRUIAvatarViewLayoutSize currentSize;

@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *primaryAvatarSizeConstraints;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *primaryAvatarLayoutConstraints;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *secondaryAvatarConstraints;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *presenceConstraints;

@property (nonatomic, readonly) BOOL shouldHideAvatars;

@end

@implementation LYRUIAvatarViewMultiLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.primaryAvatarSizeConstraints = [[NSMutableArray alloc] init];
        self.primaryAvatarLayoutConstraints = [[NSMutableArray alloc] init];
        self.secondaryAvatarConstraints = [[NSMutableArray alloc] init];
        self.presenceConstraints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] init];
}

#pragma mark - LYRUIAvatarViewLayout methods

- (void)addConstraintsInView:(LYRUIAvatarView *)view {
    self.currentSize = [self layoutSizeForViewHeight:CGRectGetHeight(view.frame)];
    [self addPrimaryAvatarConstraintsInView:view];
    [self addSecondaryAvatarConstraintsInView:view];
    [self addPresenceViewConstraintsInView:view];
    [self updateViewsVisibilityInView:view];
}

- (void)removeConstraintsFromView:(LYRUIAvatarView *)view {
    [self removeConstraints:self.primaryAvatarSizeConstraints];
    [self removeConstraints:self.primaryAvatarLayoutConstraints];
    [self removeConstraints:self.secondaryAvatarConstraints];
    [self removeConstraints:self.presenceConstraints];
}

- (void)updateConstraintsInView:(LYRUIAvatarView *)view {
    self.currentSize = [self layoutSizeForViewHeight:CGRectGetHeight(view.frame)];
    [self updatePrimaryAvatarConstraintsConstantsInView:view];
    [self updateViewsVisibilityInView:view];
}

#pragma mark - Constraints

- (void)addPrimaryAvatarConstraintsInView:(LYRUIAvatarView *)view {
    CGFloat multiplier = LYRUIAvatarViewMultiLayoutSizeMultiplier;
    CGFloat layoutConstant = [self primaryAvatarConstraintsConstant:view.primaryAvatarView];
    CGFloat sizeConstant = layoutConstant * 2;
    NSMutableArray *constraints = [NSMutableArray new];
    [constraints addObject:[view.primaryAvatarView.widthAnchor constraintEqualToAnchor:view.widthAnchor
                                                                            multiplier:multiplier
                                                                              constant:sizeConstant]];
    [constraints addObject:[view.primaryAvatarView.heightAnchor constraintEqualToAnchor:view.heightAnchor
                                                                             multiplier:multiplier
                                                                               constant:sizeConstant]];
    
    [self.primaryAvatarSizeConstraints addObjectsFromArray:constraints];
    [view addConstraints:constraints];
    
    constraints = [NSMutableArray new];
    [constraints addObject:[view.primaryAvatarView.trailingAnchor constraintEqualToAnchor:view.trailingAnchor
                                                                                 constant:layoutConstant]];
    [constraints addObject:[view.primaryAvatarView.bottomAnchor constraintEqualToAnchor:view.bottomAnchor
                                                                               constant:layoutConstant]];
    
    [self.primaryAvatarLayoutConstraints addObjectsFromArray:constraints];
    [view addConstraints:constraints];
}

- (void)updatePrimaryAvatarConstraintsConstantsInView:(LYRUIAvatarView *)view {
    CGFloat constant = [self primaryAvatarConstraintsConstant:view.primaryAvatarView];
    for (NSLayoutConstraint *constraint in self.primaryAvatarLayoutConstraints) {
        constraint.constant = constant;
    }
    CGFloat sizeConstant = constant * 2;
    for (NSLayoutConstraint *constraint in self.primaryAvatarSizeConstraints) {
        constraint.constant = sizeConstant;
    }
}

- (CGFloat)primaryAvatarConstraintsConstant:(LYRUIImageWithLettersView *)view {
    if (view.borderColor == [UIColor clearColor]) {
        return 0.0;
    }
    return view.borderWidth;
}

- (void)addSecondaryAvatarConstraintsInView:(LYRUIAvatarView *)view {
    CGFloat multiplier = LYRUIAvatarViewMultiLayoutSizeMultiplier;
    NSMutableArray *constraints = [NSMutableArray new];
    [constraints addObject:[view.secondaryAvatarView.widthAnchor constraintEqualToAnchor:view.widthAnchor multiplier:multiplier]];
    [constraints addObject:[view.secondaryAvatarView.heightAnchor constraintEqualToAnchor:view.heightAnchor multiplier:multiplier]];
    [constraints addObject:[view.secondaryAvatarView.leadingAnchor constraintEqualToAnchor:view.leadingAnchor]];
    [constraints addObject:[view.secondaryAvatarView.topAnchor constraintEqualToAnchor:view.topAnchor]];
    
    [self.secondaryAvatarConstraints addObjectsFromArray:constraints];
    [view addConstraints:constraints];
}

- (void)addPresenceViewConstraintsInView:(LYRUIAvatarView *)view {
    CGFloat size = LYRUIAvatarViewMultiLayoutPresenceViewSize;
    NSMutableArray *constraints = [NSMutableArray new];
    [constraints addObject:[view.presenceView.centerXAnchor constraintEqualToAnchor:view.centerXAnchor]];
    [constraints addObject:[view.presenceView.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]];
    [constraints addObject:[view.presenceView.widthAnchor constraintEqualToConstant:size]];
    [constraints addObject:[view.presenceView.heightAnchor constraintEqualToConstant:size]];
    
    [self.presenceConstraints addObjectsFromArray:constraints];
    [view addConstraints:constraints];
}

#pragma mark - Views visibility

- (void)updateViewsVisibilityInView:(LYRUIAvatarView *)view {
    view.primaryAvatarView.hidden = self.shouldHideAvatars;
    view.secondaryAvatarView.hidden = self.shouldHideAvatars;
    view.presenceView.hidden = !self.shouldHideAvatars;
}

- (BOOL)shouldHideAvatars {
    return self.currentSize == LYRUIAvatarViewLayoutSizeTiny;
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
