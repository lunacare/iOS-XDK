//
//  LYRUIButtonsMessageCompositeViewLayout.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 13.10.2017.
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

#import "LYRUIButtonsMessageCompositeViewLayout.h"

@interface LYRUIButtonsMessageCompositeViewLayout ()

@property (nonatomic, strong) NSMutableArray *constantConstraints;
@property (nonatomic, strong) NSMutableArray *contentConstraints;
@property (nonatomic, strong) NSLayoutConstraint *marginConstraint;
@property (nonatomic, weak) UIView *contentView;

@end

@implementation LYRUIButtonsMessageCompositeViewLayout

- (instancetype)init{
    self = [super init];
    if (self) {
        self.constantConstraints = [[NSMutableArray alloc] init];
        self.contentConstraints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] init];
}

- (void)addConstraintsInView:(LYRUIButtonsMessageCompositeView *)view {
    [self addConstantConstraintsInView:view];
    [self addMarginConstraintInView:view];
    [self addContentViewConstraintsInView:view];
}

- (void)updateConstraintsInView:(LYRUIButtonsMessageCompositeView *)view {
    if (![view.contentView isEqual:self.contentView]) {
        [self removeConstraintsFromArray:self.contentConstraints];
        self.marginConstraint.constant = 0.0;
    }
    if (view.contentView != nil) {
        [self addContentViewConstraintsInView:view];
        self.marginConstraint.constant = 1.0;
    }
}

- (void)removeConstraintsFromView:(LYRUIButtonsMessageCompositeView *)view {
    [self removeConstraintsFromArray:self.constantConstraints];
    [self removeConstraintsFromArray:self.contentConstraints];
}

- (void)addConstantConstraintsInView:(LYRUIButtonsMessageCompositeView *)view {
    view.contentViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    view.buttonsStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    [constraints addObject:[view.contentViewContainer.topAnchor constraintEqualToAnchor:view.topAnchor]];
    [constraints addObject:[view.contentViewContainer.leftAnchor constraintEqualToAnchor:view.leftAnchor]];
    [constraints addObject:[view.contentViewContainer.rightAnchor constraintEqualToAnchor:view.rightAnchor]];
    [constraints addObject:[view.buttonsStackView.leftAnchor constraintEqualToAnchor:view.leftAnchor]];
    [constraints addObject:[view.buttonsStackView.rightAnchor constraintEqualToAnchor:view.rightAnchor]];
    [constraints addObject:[view.buttonsStackView.bottomAnchor constraintEqualToAnchor:view.bottomAnchor]];
    [constraints addObject:[view.widthAnchor constraintGreaterThanOrEqualToConstant:192.0]];
    [NSLayoutConstraint activateConstraints:constraints];
    [self.constantConstraints addObjectsFromArray:constraints];
}

- (void)addMarginConstraintInView:(LYRUIButtonsMessageCompositeView *)view {
    NSLayoutConstraint *marginConstraint = [view.buttonsStackView.topAnchor constraintEqualToAnchor:view.contentViewContainer.bottomAnchor];
    marginConstraint.active = YES;
    self.marginConstraint = marginConstraint;
}

- (void)addContentViewConstraintsInView:(LYRUIButtonsMessageCompositeView *)view {
    UIView *contentView = view.contentView;
    UIView *container = view.contentViewContainer;
    NSMutableArray *constraints = [NSMutableArray new];
    if (contentView != nil) {
        self.contentView = contentView;
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [constraints addObject:[contentView.leadingAnchor constraintEqualToAnchor:container.leadingAnchor]];
        [constraints addObject:[contentView.trailingAnchor constraintEqualToAnchor:container.trailingAnchor]];
        [constraints addObject:[contentView.topAnchor constraintEqualToAnchor:container.topAnchor]];
        [constraints addObject:[contentView.bottomAnchor constraintEqualToAnchor:container.bottomAnchor]];
        
        [NSLayoutConstraint activateConstraints:constraints];
        [self.contentConstraints addObjectsFromArray:constraints];
    }
}

- (void)removeConstraintsFromArray:(NSMutableArray *)constraints {
    [NSLayoutConstraint deactivateConstraints:constraints];
    [constraints removeAllObjects];
}

@end
