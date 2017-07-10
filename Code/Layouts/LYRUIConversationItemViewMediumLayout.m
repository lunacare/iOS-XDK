//
//  LYRUIConversationItemViewMediumLayout.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 06.07.2017.
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

#import "LYRUIConversationItemViewMediumLayout.h"

@interface LYRUIConversationItemViewMediumLayout ()

@property(nonatomic, weak) NSLayoutConstraint *heightConstraint;
@property(nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *horizontalConstraints;
@property(nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *verticalConstraints;
@property(nonatomic, weak) NSLayoutConstraint *centerVerticallyConstraint;

@end

@implementation LYRUIConversationItemViewMediumLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.horizontalConstraints = [NSMutableArray new];
        self.verticalConstraints = [NSMutableArray new];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] init];
}

- (void)addConstraintsInView:(LYRUIConversationItemView *)view {
    view.lastMessageLabel.hidden = YES;
    [self addHeightConstraintInView:view];
    [self layoutHorizontallyInView:view];
    [self layoutVerticallyInView:view];
}

- (void)updateConstraintsInView:(LYRUIConversationItemView *)view {
    [self removeConstraints:self.horizontalConstraints
                   fromView:view];
    [self layoutHorizontallyInView:view];
    [self removeConstraints:self.verticalConstraints
                   fromView:view];
    [self layoutVerticallyInView:view];
}

- (void)removeConstraintsFromView:(LYRUIConversationItemView *)view {
    [view removeConstraint:self.heightConstraint];
    [self removeConstraints:self.horizontalConstraints
                   fromView:view];
    [self removeConstraints:self.verticalConstraints
                   fromView:view];
    [view removeConstraint:self.centerVerticallyConstraint];
}

#pragma mark - Helpers

- (void)addHeightConstraintInView:(LYRUIConversationItemView *)view {
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f
                                                                         constant:60];
    [view addConstraint:heightConstraint];
    self.heightConstraint = heightConstraint;
}

- (void)layoutHorizontallyInView:(LYRUIConversationItemView *)view {
    NSMutableDictionary *views = [@{
            @"conversationTitleLabel" : view.conversationTitleLabel,
            @"dateLabel" : view.dateLabel,
    } mutableCopy];
    NSString *layout;
    if (view.accessoryView) {
        views[@"accessoryView"] = view.accessoryView;
        layout = @"H:|-margin-[accessoryView]-margin-[conversationTitleLabel]->=margin-[dateLabel]-margin-|";
    } else {
        layout = @"H:|-margin-[conversationTitleLabel]->=margin-[dateLabel]-margin-|";
    }
    NSArray<__kindof NSLayoutConstraint *> *constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:layout
                                                options:NSLayoutFormatAlignAllCenterY
                                                metrics:@{ @"margin" : @12 }
                                                  views:views];
    [view addConstraints:constraints];
    [self.horizontalConstraints addObjectsFromArray:constraints];
}

- (void)layoutVerticallyInView:(LYRUIConversationItemView *)view {
    NSString *layout = @"V:|->=margin-[view]->=margin-|";
    NSDictionary *views;
    if (view.accessoryView) {
        views = @{ @"view" : view.accessoryView };
    } else {
        views = @{ @"view" : view.conversationTitleLabel };
    }
    NSArray<__kindof NSLayoutConstraint *> *constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:layout
                                                options:NSLayoutFormatAlignAllCenterY
                                                metrics:@{ @"margin" : @10 }
                                                  views:views];
    [view addConstraints:constraints];
    [self.verticalConstraints addObjectsFromArray:constraints];
}

- (void)centerVerticallyInView:(LYRUIConversationItemView *)view {
    NSLayoutConstraint *centerVerticallyConstraint = [NSLayoutConstraint constraintWithItem:view.conversationTitleLabel
                                                                                  attribute:NSLayoutAttributeCenterY
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:view
                                                                                  attribute:NSLayoutAttributeCenterY
                                                                                 multiplier:1.0f
                                                                                   constant:0.0f];
    [view addConstraint:centerVerticallyConstraint];
    self.centerVerticallyConstraint = centerVerticallyConstraint;
}

- (void)removeConstraints:(NSMutableArray<NSLayoutConstraint *> *)constraints
                 fromView:(LYRUIConversationItemView *)view {
    for (NSLayoutConstraint *constraint in constraints) {
        if ([view.constraints containsObject:constraint]) {
            [view removeConstraint:constraint];
        }
    }
    [constraints removeAllObjects];
}

@end
