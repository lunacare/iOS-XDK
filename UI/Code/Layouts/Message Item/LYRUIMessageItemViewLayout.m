//
//  LYRUIMessageItemViewLayout.m
//  Layer-XDK-UI-iOS
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
#import "UIView+LYRUISafeArea.h"
#import "UIView+LYRUILayoutGuide.h"
#import "UILayoutGuide+LYRUILayoutGuide.h"

static CGFloat const LYRUIMessageItemViewHorizontalMargin = 12.0;
static CGFloat const LYRUIMessageItemViewSmallHorizontalMargin = 8.0;

static CGFloat const LYRUIMessageItemViewSmallWidth = 460.0;
static CGFloat const LYRUIMessageItemViewWideWidth = 600.0;

static CGFloat const LYRUIMessageItemContentViewSmallMaxWidthRatio = 0.6;
static CGFloat const LYRUIMessageItemContentViewMediumMaxWidthRatio = 0.75;
static CGFloat const LYRUIMessageItemContentViewWideMaxWidthRatio = 0.9;

static CGSize const LYRUIMessageItemPrimaryAccessoryViewSize = { 32.0, 32.0 };

@interface LYRUIMessageItemViewLayout ()

@property (nonatomic) LYRUIMessageItemViewLayoutDirection currentLayoutDirection;

@property (nonatomic, strong) NSMutableArray *primaryAccessoryViewConstraints;
@property (nonatomic, strong) NSMutableArray *primaryAccessoryViewContainerConstraints;
@property (nonatomic, strong) NSMutableArray *contentViewConstraints;
@property (nonatomic, strong) NSMutableArray *contentViewContainerConstraints;
@property (nonatomic, weak) NSLayoutConstraint *contentViewContainerDirectionSnapConstraint;
@property (nonatomic, weak) NSLayoutConstraint *contentWidthConstraint;
@property (nonatomic, strong) NSMutableArray *secondaryAccessoryViewConstraints;
@property (nonatomic, strong) NSMutableArray *secondaryAccessoryViewContainerConstraints;

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
        self.primaryAccessoryViewContainerConstraints = [[NSMutableArray alloc] init];
        self.primaryAccessoryViewConstraints = [[NSMutableArray alloc] init];
        self.contentViewConstraints = [[NSMutableArray alloc] init];
        self.contentViewContainerConstraints = [[NSMutableArray alloc] init];
        self.secondaryAccessoryViewConstraints = [[NSMutableArray alloc] init];
        self.secondaryAccessoryViewContainerConstraints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    LYRUIMessageItemViewLayout *layoutCopy = [[[self class] allocWithZone:zone] init];
    layoutCopy.layoutDirection = self.layoutDirection;
    return layoutCopy;
}

#pragma mark - LYRUIMessageItemViewLayout methods

- (void)addConstraintsInView:(LYRUIMessageItemView *)view {
    [self addPrimaryAccessoryViewLayoutInView:view];
    [self addPrimaryAccessoryViewContainerConstraintsInView:view];
    [self addContentViewLayoutInView:view];
    [self addContentViewContainerConstraintsInView:view];
    [self setupContentWidthConstraintInView:view];
    [self setupContentViewContainerDirectionSnapConstraintInView:view];
    [self addSecondaryAccessoryViewLayoutInView:view];
    [self addSecondaryAccessoryViewContainerConstraintsInView:view];
    self.currentLayoutDirection = self.layoutDirection;
}

- (void)updateConstraintsInView:(LYRUIMessageItemView *)view {
    [self setupContentWidthConstraintInView:view];
    [self setupContentViewContainerDirectionSnapConstraintInView:view];
    [self updateAccessoryViewsContainersConstraintsIfNeededInView:view];
    [self updatePrimaryAccessoryViewConstraintsInView:view];
    [self updateContentViewConstraintsInView:view];
    [self updateSecondaryAccessoryViewConstraintsInView:view];
    [view.contentView invalidateIntrinsicContentSize];
    self.currentLayoutDirection = self.layoutDirection;
}

- (void)removeConstraintsFromView:(LYRUIMessageItemView *)view {
    [self removeConstraints:self.primaryAccessoryViewConstraints];
    [self removeConstraints:self.primaryAccessoryViewContainerConstraints];
    [self removeConstraints:self.contentViewConstraints];
    [self removeConstraints:self.contentViewContainerConstraints];
    self.contentWidthConstraint.active = NO;
    self.contentViewContainerDirectionSnapConstraint.active = NO;
    [self removeConstraints:self.secondaryAccessoryViewConstraints];
    [self removeConstraints:self.secondaryAccessoryViewContainerConstraints];
}

#pragma mark - Layout

- (void)addContentViewContainerConstraintsInView:(LYRUIMessageItemView *)view {
    UIView *content = view.contentViewContainer;
    CGFloat horizontalMargin = LYRUIMessageItemViewHorizontalMargin;
    
    NSMutableArray *constraints = [NSMutableArray new];
    
    id<LYRUILayoutGuide> layoutGuide = view.lyr_safeAreaLayoutGuide ?: view;
    [constraints addObject:[content.leftAnchor constraintGreaterThanOrEqualToAnchor:layoutGuide.leftAnchor
                                                                           constant:horizontalMargin]];
    [constraints addObject:[content.rightAnchor constraintLessThanOrEqualToAnchor:layoutGuide.rightAnchor
                                                                         constant:-horizontalMargin]];
    [constraints addObject:[content.topAnchor constraintEqualToAnchor:view.topAnchor]];
    [constraints addObject:[content.bottomAnchor constraintEqualToAnchor:view.bottomAnchor]];
    
    [self.contentViewContainerConstraints addObjectsFromArray:constraints];
    [view addConstraints:constraints];
}

- (void)setupContentWidthConstraintInView:(LYRUIMessageItemView *)view {
    UIView *content = view.contentViewContainer;
    if (self.contentWidthConstraint) {
        self.contentWidthConstraint.active = NO;
    }
    CGFloat viewWidth = CGRectGetWidth(view.bounds);
    CGFloat multiplier;
    if (viewWidth < LYRUIMessageItemViewSmallWidth) {
        multiplier = LYRUIMessageItemContentViewWideMaxWidthRatio;
    } else if (viewWidth > LYRUIMessageItemViewWideWidth) {
        multiplier = LYRUIMessageItemContentViewSmallMaxWidthRatio;
    } else {
        multiplier = LYRUIMessageItemContentViewMediumMaxWidthRatio;
    }
    NSLayoutConstraint *contentWidthConstraint = [content.widthAnchor constraintLessThanOrEqualToAnchor:view.widthAnchor
                                                                                             multiplier:multiplier];
    self.contentWidthConstraint = contentWidthConstraint;
    contentWidthConstraint.active = YES;
}

- (void)setupContentViewContainerDirectionSnapConstraintInView:(LYRUIMessageItemView *)view {
    if (self.layoutDirection != self.currentLayoutDirection || self.contentViewContainerDirectionSnapConstraint == nil) {
        self.contentViewContainerDirectionSnapConstraint.active = NO;
        CGFloat horizontalMargin = LYRUIMessageItemViewHorizontalMargin;
        NSLayoutConstraint *snapConstraint;
        id<LYRUILayoutGuide> layoutGuide = view.lyr_safeAreaLayoutGuide ?: view;
        if (self.layoutDirection == LYRUIMessageItemViewLayoutDirectionLeft) {
            snapConstraint = [view.contentViewContainer.leftAnchor constraintEqualToAnchor:layoutGuide.leftAnchor
                                                                                  constant:horizontalMargin];
        } else {
            snapConstraint = [view.contentViewContainer.rightAnchor constraintEqualToAnchor:layoutGuide.rightAnchor
                                                                                   constant:-horizontalMargin];
        }
        snapConstraint.priority = UILayoutPriorityDefaultHigh;
        snapConstraint.active = YES;
        self.contentViewContainerDirectionSnapConstraint = snapConstraint;
    }
}

- (void)addPrimaryAccessoryViewContainerConstraintsInView:(LYRUIMessageItemView *)view {
    if (self.primaryAccessoryViewContainerConstraints.count > 0 || view.primaryAccessoryView == nil) {
        return;
    }
    UIView *accessoryView = view.primaryAccessoryViewContainer;
    UIView *content = view.contentViewContainer;
    NSLayoutConstraint *verticalConstraint = [content.bottomAnchor constraintEqualToAnchor:accessoryView.bottomAnchor];
    [self.primaryAccessoryViewContainerConstraints addObject:verticalConstraint];
    [self addAccessoryViewContainerConstraints:accessoryView
                                        inView:view
                                 toConstraints:self.primaryAccessoryViewContainerConstraints
                                     direction:self.layoutDirection];
}

- (void)addSecondaryAccessoryViewContainerConstraintsInView:(LYRUIMessageItemView *)view {
    if (self.secondaryAccessoryViewContainerConstraints.count > 0 || view.secondaryAccessoryView == nil) {
        return;
    }
    UIView *accessoryView = view.secondaryAccessoryViewContainer;
    UIView *content = view.contentViewContainer;
    NSLayoutConstraint *verticalConstraint = [accessoryView.centerYAnchor constraintEqualToAnchor:content.centerYAnchor];
    [self.secondaryAccessoryViewContainerConstraints addObject:verticalConstraint];
    [self addAccessoryViewContainerConstraints:accessoryView
                                        inView:view
                                 toConstraints:self.secondaryAccessoryViewContainerConstraints
                                     direction:self.layoutDirection];
}

- (void)addAccessoryViewContainerConstraints:(UIView *)accessoryView
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
    id<LYRUILayoutGuide> layoutGuide = view.lyr_safeAreaLayoutGuide ?: view;
    switch (direction) {
        case LYRUIMessageItemViewLayoutDirectionLeft:
            return @[
                    accessoryView.leftAnchor,
                    layoutGuide.leftAnchor,
                    view.contentViewContainer.leftAnchor,
                    accessoryView.rightAnchor
            ];
        case LYRUIMessageItemViewLayoutDirectionRight:
            return @[
                    layoutGuide.rightAnchor,
                    accessoryView.rightAnchor,
                    accessoryView.leftAnchor,
                    view.contentViewContainer.rightAnchor
            ];
    }
}

- (void)updateAccessoryViewsContainersConstraintsIfNeededInView:(LYRUIMessageItemView *)view {
    if ([self shouldUpdatePrimaryAccessoryContainerConstraintsInView:view]) {
        [self removeConstraints:self.primaryAccessoryViewContainerConstraints];
        [self addPrimaryAccessoryViewContainerConstraintsInView:view];
    }
    if ([self shouldUpdateSecondaryAccessoryContainerConstraintsInView:view]) {
        [self removeConstraints:self.secondaryAccessoryViewContainerConstraints];
        [self addSecondaryAccessoryViewContainerConstraintsInView:view];
    }
}

- (BOOL)shouldUpdatePrimaryAccessoryContainerConstraintsInView:(LYRUIMessageItemView *)view {
    return (self.layoutDirection != self.currentLayoutDirection ||
            (self.primaryAccessoryViewContainerConstraints.count > 0 && view.primaryAccessoryView == nil) ||
            (self.primaryAccessoryViewContainerConstraints.count == 0 && view.primaryAccessoryView != nil));
}

- (BOOL)shouldUpdateSecondaryAccessoryContainerConstraintsInView:(LYRUIMessageItemView *)view {
    return (self.layoutDirection != self.currentLayoutDirection ||
            (self.secondaryAccessoryViewContainerConstraints.count > 0 && view.secondaryAccessoryView == nil) ||
            (self.secondaryAccessoryViewContainerConstraints.count == 0 && view.secondaryAccessoryView != nil));
}

- (void)addPrimaryAccessoryViewLayoutInView:(LYRUIMessageItemView *)view {
    UIView *accessoryView = view.primaryAccessoryView;
    if (accessoryView == nil) {
        return;
    }
    CGSize size = LYRUIMessageItemPrimaryAccessoryViewSize;
    NSArray *constraints = [self layoutViewInSuperview:accessoryView];
    [self.primaryAccessoryViewConstraints addObjectsFromArray:constraints];
    
    NSMutableArray *sizeConstraint = [[NSMutableArray alloc] init];
    [sizeConstraint addObject:[accessoryView.widthAnchor constraintEqualToConstant:size.width]];
    [sizeConstraint addObject:[accessoryView.heightAnchor constraintEqualToConstant:size.height]];
    [NSLayoutConstraint activateConstraints:sizeConstraint];
    [self.primaryAccessoryViewConstraints addObjectsFromArray:sizeConstraint];
}

- (void)updatePrimaryAccessoryViewConstraintsInView:(LYRUIMessageItemView *)view {
    [self removeConstraints:self.primaryAccessoryViewConstraints];
    [self addPrimaryAccessoryViewLayoutInView:view];
}

- (void)addContentViewLayoutInView:(LYRUIMessageItemView *)view {
    UIView *contentView = view.contentView;
    NSArray *constraints = [self layoutViewInSuperview:contentView];
    [self.contentViewConstraints addObjectsFromArray:constraints];
}

- (void)updateContentViewConstraintsInView:(LYRUIMessageItemView *)view {
    [self removeConstraints:self.contentViewConstraints];
    [self addContentViewLayoutInView:view];
}

- (void)addSecondaryAccessoryViewLayoutInView:(LYRUIMessageItemView *)view {
    UIView *accessoryView = view.secondaryAccessoryView;
    NSArray *constraints = [self layoutViewInSuperview:accessoryView];
    [self.secondaryAccessoryViewConstraints addObjectsFromArray:constraints];
}

- (void)updateSecondaryAccessoryViewConstraintsInView:(LYRUIMessageItemView *)view {
    [self removeConstraints:self.secondaryAccessoryViewConstraints];
    [self addSecondaryAccessoryViewLayoutInView:view];
}

- (NSArray<NSLayoutConstraint *> *)layoutViewInSuperview:(UIView *)view {
    NSMutableArray *constraints = [NSMutableArray new];
    if (view != nil) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        
        [constraints addObject:[view.leadingAnchor constraintEqualToAnchor:view.superview.leadingAnchor]];
        [constraints addObject:[view.trailingAnchor constraintEqualToAnchor:view.superview.trailingAnchor]];
        [constraints addObject:[view.topAnchor constraintEqualToAnchor:view.superview.topAnchor]];
        [constraints addObject:[view.bottomAnchor constraintEqualToAnchor:view.superview.bottomAnchor]];
        
        [NSLayoutConstraint activateConstraints:constraints];
    }
    return constraints;
}

#pragma mark - Helpers

- (void)removeConstraints:(NSMutableArray<NSLayoutConstraint *> *)constraints {
    [NSLayoutConstraint deactivateConstraints:constraints];
    [constraints removeAllObjects];
}

@end
