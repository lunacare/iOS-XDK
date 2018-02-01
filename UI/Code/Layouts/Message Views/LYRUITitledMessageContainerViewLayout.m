//
//  LYRUITitledMessageContainerViewLayout.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 27.11.2017.
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

#import "LYRUITitledMessageContainerViewLayout.h"

@interface LYRUITitledMessageContainerViewLayout ()

@property (nonatomic, strong) NSMutableArray *constantConstraints;
@property (nonatomic, strong) NSMutableArray *contentConstraints;
@property (nonatomic, weak) UIView *contentView;

@end

@implementation LYRUITitledMessageContainerViewLayout

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

- (void)addConstraintsInView:(LYRUITitledMessageContainerView *)view {
    [self setupCompressionResistanceInView:view];
    [self addConstantConstraintsInView:view];
    [self addContentViewConstraintsInView:view];
}

- (void)updateConstraintsInView:(LYRUITitledMessageContainerView *)view {
    for (NSLayoutConstraint *constraint in [self.contentConstraints copy]) {
        if (constraint.isActive == NO) {
            [self.contentConstraints removeObject:constraint];
        }
    }
    if (view.contentView != nil && self.contentConstraints.count == 0) {
        [self addContentViewConstraintsInView:view];
    }
}

- (void)removeConstraintsFromView:(LYRUITitledMessageContainerView *)view {
    [self removeConstraintsFromArray:self.constantConstraints];
    [self removeConstraintsFromArray:self.contentConstraints];
}

- (void)setupCompressionResistanceInView:(LYRUITitledMessageContainerView *)view {
    [view.titleContainer setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [view.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [view.icon setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)addConstantConstraintsInView:(LYRUITitledMessageContainerView *)view {
    view.contentViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    view.titleContainer.translatesAutoresizingMaskIntoConstraints = NO;
    view.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    view.icon.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    
    [constraints addObject:[view.titleContainer.leftAnchor constraintEqualToAnchor:view.leftAnchor]];
    [constraints addObject:[view.titleContainer.rightAnchor constraintEqualToAnchor:view.rightAnchor]];
    [constraints addObject:[view.titleContainer.topAnchor constraintEqualToAnchor:view.topAnchor]];
    
    [constraints addObject:[view.icon.leftAnchor constraintEqualToAnchor:view.titleContainer.leftAnchor constant:12.0]];
    [constraints addObject:[view.icon.topAnchor constraintGreaterThanOrEqualToAnchor:view.titleContainer.topAnchor constant:12.0]];
    [constraints addObject:[view.icon.bottomAnchor constraintLessThanOrEqualToAnchor:view.titleContainer.bottomAnchor constant:-12.0]];
    [constraints addObject:[view.icon.widthAnchor constraintEqualToConstant:16.0]];
    [constraints addObject:[view.icon.heightAnchor constraintEqualToConstant:16.0]];
    
    [constraints addObject:[view.titleLabel.leftAnchor constraintEqualToAnchor:view.icon.rightAnchor constant:12.0]];
    [constraints addObject:[view.titleLabel.topAnchor constraintEqualToAnchor:view.titleContainer.topAnchor constant:12.0]];
    [constraints addObject:[view.titleLabel.rightAnchor constraintEqualToAnchor:view.titleContainer.rightAnchor constant:-12.0]];
    [constraints addObject:[view.titleLabel.bottomAnchor constraintEqualToAnchor:view.titleContainer.bottomAnchor constant:-12.0]];
    [constraints addObject:[view.titleLabel.centerYAnchor constraintEqualToAnchor:view.icon.centerYAnchor]];
    
    [constraints addObject:[view.contentViewContainer.topAnchor constraintEqualToAnchor:view.titleContainer.bottomAnchor]];
    [constraints addObject:[view.contentViewContainer.leftAnchor constraintEqualToAnchor:view.leftAnchor]];
    [constraints addObject:[view.contentViewContainer.rightAnchor constraintEqualToAnchor:view.rightAnchor]];
    [constraints addObject:[view.contentViewContainer.bottomAnchor constraintEqualToAnchor:view.bottomAnchor]];
    
    [NSLayoutConstraint activateConstraints:constraints];
    [self.constantConstraints addObjectsFromArray:constraints];
}

- (void)addContentViewConstraintsInView:(LYRUITitledMessageContainerView *)view {
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
