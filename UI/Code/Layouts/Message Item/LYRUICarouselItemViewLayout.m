//
//  LYRUICarouselItemViewLayout.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 04.12.2017.
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

#import "LYRUICarouselItemViewLayout.h"

@interface LYRUICarouselItemViewLayout ()

@property (nonatomic) LYRUIMessageItemViewLayoutDirection currentLayoutDirection;

@property (nonatomic, strong) NSMutableArray *contentViewConstraints;
@property (nonatomic, strong) NSMutableArray *contentViewContainerConstraints;

@end

@implementation LYRUICarouselItemViewLayout
@synthesize layoutDirection = _layoutDirection;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentViewConstraints = [[NSMutableArray alloc] init];
        self.contentViewContainerConstraints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    LYRUICarouselItemViewLayout *layoutCopy = [[[self class] allocWithZone:zone] init];
    layoutCopy.layoutDirection = self.layoutDirection;
    return layoutCopy;
}

#pragma mark - LYRUIMessageItemViewLayout methods

- (void)addConstraintsInView:(LYRUIMessageItemView *)view {
    [self addContentViewLayoutInView:view];
    [self addContentViewContainerConstraintsInView:view];
}

- (void)updateConstraintsInView:(LYRUIMessageItemView *)view {
}

- (void)removeConstraintsFromView:(LYRUIMessageItemView *)view {
    [self removeConstraints:self.contentViewConstraints];
    [self removeConstraints:self.contentViewContainerConstraints];
}

#pragma mark - Layout

- (void)addContentViewContainerConstraintsInView:(LYRUIMessageItemView *)view {
    UIView *content = view.contentViewContainer;
    
    NSMutableArray *constraints = [NSMutableArray new];
    
    [constraints addObject:[content.leftAnchor constraintEqualToAnchor:view.leftAnchor]];
    [constraints addObject:[content.rightAnchor constraintEqualToAnchor:view.rightAnchor]];
    [constraints addObject:[content.topAnchor constraintEqualToAnchor:view.topAnchor]];
    [constraints addObject:[content.bottomAnchor constraintEqualToAnchor:view.bottomAnchor]];
    
    [self.contentViewContainerConstraints addObjectsFromArray:constraints];
    [view addConstraints:constraints];
}

- (void)addContentViewLayoutInView:(LYRUIMessageItemView *)view {
    UIView *contentView = view.contentView;
    NSArray *constraints = [self layoutViewInSuperview:contentView];
    [self.contentViewConstraints addObjectsFromArray:constraints];
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
