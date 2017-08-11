//
//  LYRUIMessageItemViewLayout.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 11.08.2017.
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

#import "LYRUIMessageItemViewLayout.h"

static CGFloat const LYRUIMessageItemViewVerticalMargin = 2.0;
static CGFloat const LYRUIMessageItemViewHorizontalMargin = 12.0;
static CGFloat const LYRUIMessageItemViewSmallHorizontalMargin = 8.0;

@interface LYRUIMessageItemViewLayout ()

@property (nonatomic) LYRUIMessageItemViewLayoutDirection currentLayoutDirection;

@property (nonatomic, strong) NSMutableArray *primaryAccessoryViewConstraints;
@property (nonatomic, strong) NSMutableArray *contentViewConstraints;
@property (nonatomic, weak) NSLayoutConstraint *contentWidthConstraint;
@property (nonatomic, strong) NSMutableArray *secondaryAccessoryViewConstraints;

@end

@implementation LYRUIMessageItemViewLayout
@synthesize layoutDirection = _layoutDirection;

- (instancetype)init {
    self = [self initWithLayoutDirection:LYRUIMessageItemViewLayoutDirectionLeft];
    return self;
}

- (instancetype)initWithLayoutDirection:(LYRUIMessageItemViewLayoutDirection)direction {
    self = [super init];
    if (self) {
        self.layoutDirection = direction;
        self.currentLayoutDirection = direction;
        self.primaryAccessoryViewConstraints = [[NSMutableArray alloc] init];
        self.contentViewConstraints = [[NSMutableArray alloc] init];
        self.secondaryAccessoryViewConstraints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] init];
}

#pragma mark - LYRUIMessageItemViewLayout methods

- (void)addConstraintsInView:(LYRUIMessageItemView *)view {
    [self addPrimaryAccessoryViewConstraintsInView:view];
    [self addContentViewConstraintsInView:view];
    [self setupContentWidthConstraintInView:view];
    [self addSecondaryAccessoryViewConstraintsInView:view];
}

- (void)updateConstraintsInView:(LYRUIMessageItemView *)view {
    [self setupContentWidthConstraintInView:view];
    [self updateAccessoryViewsConstraintsIfNeededInView:view];
}

- (void)removeConstraintsFromView:(LYRUIMessageItemView *)view {
    [self removeConstraints:self.primaryAccessoryViewConstraints];
    [self removeConstraints:self.contentViewConstraints];
    self.contentWidthConstraint.active = NO;
    [self removeConstraints:self.secondaryAccessoryViewConstraints];
}

#pragma mark - Layout

- (void)addContentViewConstraintsInView:(LYRUIMessageItemView *)view {
    UIView *container = view.contentContainer;
    UIView *header = view.contentHeaderContainer;
    UIView *content = view.contentViewContainer;
    UIView *footer = view.contentFooterContainer;
    CGFloat verticalMargin = LYRUIMessageItemViewVerticalMargin;
    CGFloat horizontalMargin = LYRUIMessageItemViewHorizontalMargin;
    
    NSMutableArray *constraints = [NSMutableArray new];
    
    [constraints addObject:[container.leftAnchor constraintGreaterThanOrEqualToAnchor:view.leftAnchor
                                                                             constant:horizontalMargin]];
    [constraints addObject:[container.rightAnchor constraintLessThanOrEqualToAnchor:view.rightAnchor
                                                                           constant:-horizontalMargin]];
    [constraints addObject:[container.topAnchor constraintEqualToAnchor:view.topAnchor
                                                               constant:verticalMargin]];
    [constraints addObject:[container.bottomAnchor constraintEqualToAnchor:view.bottomAnchor
                                                                  constant:-verticalMargin]];
    
    [constraints addObject:[header.leftAnchor constraintEqualToAnchor:container.leftAnchor]];
    [constraints addObject:[header.topAnchor constraintEqualToAnchor:container.topAnchor]];
    [constraints addObject:[header.rightAnchor constraintEqualToAnchor:container.rightAnchor]];
    
    [constraints addObject:[content.leftAnchor constraintEqualToAnchor:container.leftAnchor]];
    [constraints addObject:[content.topAnchor constraintEqualToAnchor:header.bottomAnchor]];
    [constraints addObject:[content.rightAnchor constraintEqualToAnchor:container.rightAnchor]];
    [constraints addObject:[content.bottomAnchor constraintEqualToAnchor:footer.topAnchor]];
    
    [constraints addObject:[footer.leftAnchor constraintEqualToAnchor:container.leftAnchor]];
    [constraints addObject:[footer.rightAnchor constraintEqualToAnchor:container.rightAnchor]];
    [constraints addObject:[footer.bottomAnchor constraintEqualToAnchor:container.bottomAnchor]];
    
    [self.contentViewConstraints addObjectsFromArray:constraints];
    [view addConstraints:constraints];
}

- (void)setupContentWidthConstraintInView:(LYRUIMessageItemView *)view {
    if (self.contentWidthConstraint) {
        self.contentWidthConstraint.active = NO;
    }
    CGFloat viewWidth = CGRectGetWidth(view.bounds);
    CGFloat multiplier;
    if (viewWidth < 460.0) {
        multiplier = 0.9;
    } else if (viewWidth > 600.0) {
        multiplier = 0.6;
    } else {
        multiplier = 0.75;
    }
    NSLayoutConstraint *contentWidthConstraint = [view.contentContainer.widthAnchor constraintLessThanOrEqualToAnchor:view.widthAnchor multiplier:multiplier];
    self.contentWidthConstraint = contentWidthConstraint;
    contentWidthConstraint.active = YES;
}

- (void)addPrimaryAccessoryViewConstraintsInView:(LYRUIMessageItemView *)view {
    UIView *accessoryView = view.primaryAccessoryViewContainer;
    UIView *container = view.contentContainer;
    NSLayoutConstraint *verticalConstraint = [container.bottomAnchor constraintEqualToAnchor:accessoryView.bottomAnchor];
    [self.primaryAccessoryViewConstraints addObject:verticalConstraint];
    [self addAccessoryViewConstraints:accessoryView
                               inView:view
                        toConstraints:self.primaryAccessoryViewConstraints
                            direction:self.layoutDirection];
}

- (void)addSecondaryAccessoryViewConstraintsInView:(LYRUIMessageItemView *)view {
    UIView *accessoryView = view.secondaryAccessoryViewContainer;
    UIView *container = view.contentContainer;
    NSLayoutConstraint *verticalConstraint = [accessoryView.centerYAnchor constraintEqualToAnchor:container.centerYAnchor];
    [self.secondaryAccessoryViewConstraints addObject:verticalConstraint];
    [self addAccessoryViewConstraints:accessoryView
                               inView:view
                        toConstraints:self.secondaryAccessoryViewConstraints
                            direction:self.layoutDirection];
}

- (void)addAccessoryViewConstraints:(UIView *)accessoryView
                             inView:(LYRUIMessageItemView *)view
                      toConstraints:(NSMutableArray *)constraints
                          direction:(LYRUIMessageItemViewLayoutDirection)direction {
    CGFloat horizontalMargin = LYRUIMessageItemViewHorizontalMargin;
    CGFloat smallHorizontalMargin = LYRUIMessageItemViewSmallHorizontalMargin;
    
    BOOL primaryAccessory = (accessoryView == view.primaryAccessoryViewContainer);
    if (!primaryAccessory) {
        direction = direction * -1;
    }
    NSArray<NSLayoutAnchor *> *anchors = [self anchorsForAccessoryView:accessoryView inView:view direction:direction];
    if (primaryAccessory) {
        [constraints addObject:[anchors[0] constraintEqualToAnchor:anchors[1] constant:horizontalMargin]];
    } else {
        [constraints addObject:[anchors[0] constraintGreaterThanOrEqualToAnchor:anchors[1] constant:horizontalMargin]];
    }
    [constraints addObject:[anchors[2] constraintEqualToAnchor:anchors[3] constant:smallHorizontalMargin]];
    
    [view addConstraints:constraints];
}

- (NSArray<NSLayoutAnchor *> *)anchorsForAccessoryView:(UIView *)accessoryView
                                                inView:(LYRUIMessageItemView *)view
                                             direction:(LYRUIMessageItemViewLayoutDirection)direction {
    switch (direction) {
        case LYRUIMessageItemViewLayoutDirectionLeft:
            return @[
                    accessoryView.leftAnchor,
                    view.leftAnchor,
                    view.contentContainer.leftAnchor,
                    accessoryView.rightAnchor
            ];
        case LYRUIMessageItemViewLayoutDirectionRight:
            return @[
                    view.rightAnchor,
                    accessoryView.rightAnchor,
                    accessoryView.leftAnchor,
                    view.contentContainer.rightAnchor
            ];
    }
}

- (void)updateAccessoryViewsConstraintsIfNeededInView:(LYRUIMessageItemView *)view {
    if (self.layoutDirection != self.currentLayoutDirection) {
        [self removeConstraints:self.primaryAccessoryViewConstraints];
        [self removeConstraints:self.secondaryAccessoryViewConstraints];
        [self addPrimaryAccessoryViewConstraintsInView:view];
        [self addSecondaryAccessoryViewConstraintsInView:view];
        self.currentLayoutDirection = self.layoutDirection;
    }
}

#pragma mark - Helpers

- (void)removeConstraints:(NSMutableArray<NSLayoutConstraint *> *)constraints {
    [NSLayoutConstraint deactivateConstraints:constraints];
    [constraints removeAllObjects];
}

@end
