//
//  LYRUIComposeBarLayout.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 10.08.2017.
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

#import "LYRUIComposeBarLayout.h"
#import "UIView+LYRUISafeArea.h"
#import "UIView+LYRUILayoutGuide.h"
#import "UILayoutGuide+LYRUILayoutGuide.h"

@interface LYRUIComposeBarLayout ()

@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *baseConstraints;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *leftItemsConstraints;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *rightItemsConstraints;

@end

@implementation LYRUIComposeBarLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.baseConstraints = [[NSMutableArray alloc] init];
        self.leftItemsConstraints = [[NSMutableArray alloc] init];
        self.rightItemsConstraints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] init];
}

#pragma mark - LYRUIComposeBarLayout methods

- (void)addConstraintsInView:(LYRUIComposeBar *)view {
    [self addBaseConstraintsInView:view];
    [self addLeftItemsConstraintsInView:view];
    [self addRightItemsConstraintsInView:view];
}

- (void)updateConstraintsInView:(LYRUIComposeBar *)view {
    [self removeConstraints:self.leftItemsConstraints];
    [self removeConstraints:self.rightItemsConstraints];
    [self addLeftItemsConstraintsInView:view];
    [self addRightItemsConstraintsInView:view];
}

- (void)removeConstraintsFromView:(LYRUIComposeBar *)view {
    [self removeConstraints:self.baseConstraints];
    [self removeConstraints:self.leftItemsConstraints];
    [self removeConstraints:self.rightItemsConstraints];
}

#pragma mark - Layout

- (void)addBaseConstraintsInView:(LYRUIComposeBar *)view {
    CGFloat margin = 8.0;
    id<LYRUILayoutGuide> layoutGuide = view.lyr_safeAreaLayoutGuide ?: view;
    NSMutableArray *constraints = [NSMutableArray new];
    [constraints addObject:[view.heightAnchor constraintGreaterThanOrEqualToConstant:48.0]];
    
    [constraints addObject:[view.inputTextView.leftAnchor constraintGreaterThanOrEqualToAnchor:layoutGuide.leftAnchor constant:margin]];
    [constraints addObject:[view.inputTextView.topAnchor constraintGreaterThanOrEqualToAnchor:layoutGuide.topAnchor constant:margin]];
    [constraints addObject:[view.inputTextView.rightAnchor constraintLessThanOrEqualToAnchor:layoutGuide.rightAnchor constant:-margin]];
    [constraints addObject:[view.inputTextView.bottomAnchor constraintLessThanOrEqualToAnchor:layoutGuide.bottomAnchor constant:-margin]];
    
    NSArray *highPriorityConstrints = @[
            [view.inputTextView.leftAnchor constraintEqualToAnchor:layoutGuide.leftAnchor constant:margin],
            [view.inputTextView.topAnchor constraintEqualToAnchor:layoutGuide.topAnchor constant:margin],
            [view.inputTextView.rightAnchor constraintEqualToAnchor:layoutGuide.rightAnchor constant:-margin],
            [view.inputTextView.bottomAnchor constraintEqualToAnchor:layoutGuide.bottomAnchor constant:-margin],
    ];
    for (NSLayoutConstraint *constraint in highPriorityConstrints) {
        constraint.priority = 750.0;
    }
    [constraints addObjectsFromArray:highPriorityConstrints];
    
    [constraints addObject:[view.inputTextView.heightAnchor constraintLessThanOrEqualToConstant:106.0]];
    [constraints addObject:[view.inputTextView.heightAnchor constraintGreaterThanOrEqualToConstant:32.0]];
    [constraints addObject:[view.inputTextView.widthAnchor constraintGreaterThanOrEqualToConstant:150.0]];
    
    [self.baseConstraints addObjectsFromArray:constraints];
    [view addConstraints:constraints];
}

- (void)addLeftItemsConstraintsInView:(LYRUIComposeBar *)view {
    CGFloat bottomMargin = 8.0;
    CGFloat margin = 12.0;
    CGFloat spacing = 16.0;
    id<LYRUILayoutGuide> layoutGuide = view.lyr_safeAreaLayoutGuide ?: view;
    NSMutableArray *constraints = [NSMutableArray new];
    
    UIView *previousItem = nil;
    for (UIView *item in view.leftItems) {
        if (previousItem == nil) {
            [constraints addObject:[item.leftAnchor constraintEqualToAnchor:layoutGuide.leftAnchor constant:margin]];
        } else {
            [constraints addObject:[item.leftAnchor constraintEqualToAnchor:previousItem.rightAnchor constant:spacing]];
            [constraints addObject:[item.centerYAnchor constraintEqualToAnchor:previousItem.centerYAnchor]];
        }
        if (item == view.leftItems.lastObject) {
            [constraints addObject:[item.rightAnchor constraintEqualToAnchor:view.inputTextView.leftAnchor constant:-margin]];
            if (view.rightItems.count > 0) {
                [constraints addObject:[item.centerYAnchor constraintEqualToAnchor:view.rightItems.firstObject.centerYAnchor]];
            }
        }
        [constraints addObject:[item.topAnchor constraintGreaterThanOrEqualToAnchor:layoutGuide.topAnchor constant:bottomMargin]];
        [constraints addObject:[item.bottomAnchor constraintLessThanOrEqualToAnchor:layoutGuide.bottomAnchor constant:-bottomMargin]];
        NSLayoutConstraint *lowerPriorityConstraint = [item.bottomAnchor constraintEqualToAnchor:layoutGuide.bottomAnchor constant:-bottomMargin];
        lowerPriorityConstraint.priority = 750.0;
        [constraints addObject:lowerPriorityConstraint];
        previousItem = item;
    }
    
    [self.leftItemsConstraints addObjectsFromArray:constraints];
    [view addConstraints:constraints];
}

- (void)addRightItemsConstraintsInView:(LYRUIComposeBar *)view {
    CGFloat bottomMargin = 8.0;
    CGFloat margin = 12.0;
    CGFloat spacing = 16.0;
    id<LYRUILayoutGuide> layoutGuide = view.lyr_safeAreaLayoutGuide ?: view;
    NSMutableArray *constraints = [NSMutableArray new];
    
    UIView *previousItem = nil;
    for (UIView *item in view.rightItems) {
        if (previousItem == nil) {
            [constraints addObject:[item.leftAnchor constraintEqualToAnchor:view.inputTextView.rightAnchor constant:margin]];
        } else {
            [constraints addObject:[item.leftAnchor constraintEqualToAnchor:previousItem.rightAnchor constant:spacing]];
            [constraints addObject:[item.centerYAnchor constraintEqualToAnchor:previousItem.centerYAnchor]];
        }
        if (item == view.rightItems.lastObject) {
            [constraints addObject:[item.rightAnchor constraintEqualToAnchor:layoutGuide.rightAnchor constant:-margin]];
        }
        [constraints addObject:[item.topAnchor constraintGreaterThanOrEqualToAnchor:layoutGuide.topAnchor constant:bottomMargin]];
        [constraints addObject:[item.bottomAnchor constraintLessThanOrEqualToAnchor:layoutGuide.bottomAnchor constant:-bottomMargin]];
        NSLayoutConstraint *lowerPriorityConstraint = [item.bottomAnchor constraintEqualToAnchor:layoutGuide.bottomAnchor constant:-bottomMargin];
        lowerPriorityConstraint.priority = 750.0;
        [constraints addObject:lowerPriorityConstraint];
        previousItem = item;
    }
    
    [self.rightItemsConstraints addObjectsFromArray:constraints];
    [view addConstraints:constraints];
}

- (void)removeConstraints:(NSMutableArray<NSLayoutConstraint *> *)constraints {
    [NSLayoutConstraint deactivateConstraints:constraints];
    [constraints removeAllObjects];
}

@end
