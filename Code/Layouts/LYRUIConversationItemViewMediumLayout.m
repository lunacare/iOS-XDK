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

typedef enum : NSUInteger {
    LYRUIConversationItemViewLayoutSizeTiny,
    LYRUIConversationItemViewLayoutSizeSmall,
    LYRUIConversationItemViewLayoutSizeMedium,
    LYRUIConversationItemViewLayoutSizeLarge,
} LYRUIConversationItemViewLayoutSize;

@interface LYRUIConversationItemViewMediumLayout ()

@property(nonatomic) LYRUIConversationItemViewLayoutSize layoutSize;
@property(nonatomic) BOOL layoutWithAccessoryView;

@property(nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *accessoryViewConstraints;
@property(nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *accessoryViewContainerSizeConstraints;
@property(nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *titleLabelHorizontalConstraints;
@property(nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *messageLabelHorizontalConstraints;
@property(nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *verticalConstraints;
@property(nonatomic, weak) NSLayoutConstraint *centerVerticallyConstraint;

@end

@implementation LYRUIConversationItemViewMediumLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.accessoryViewConstraints = [NSMutableArray new];
        self.accessoryViewContainerSizeConstraints = [NSMutableArray new];
        self.titleLabelHorizontalConstraints = [NSMutableArray new];
        self.messageLabelHorizontalConstraints = [NSMutableArray new];
        self.verticalConstraints = [NSMutableArray new];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] init];
}

#pragma mark - LYRUIViewLayout methods

- (void)addConstraintsInView:(LYRUIConversationItemView *)view {
    self.layoutSize = [self laytoutSizeForViewHeight:CGRectGetHeight(view.frame)];
    self.layoutWithAccessoryView = (view.accessoryView != nil);
    [self setAccessoryViewContainerSizeInView:view];
    [self setupViewsVisibilityInView:view];
    [self layoutHorizontallyInView:view];
    [self layoutVerticallyInView:view];
}

- (void)updateConstraintsInView:(LYRUIConversationItemView *)view {
    if (self.layoutWithAccessoryView != (view.accessoryView != nil)) {
        [self updateConstraintsForAccessibilityViewVisibilityChangeInView:view];
    } else {
        LYRUIConversationItemViewLayoutSize newLayoutSize = [self laytoutSizeForViewHeight:CGRectGetHeight(view.frame)];
        if ([self layoutChangeBetweenTinyAndLargeWithNewLayoutSize:newLayoutSize]) {
            [self updateVerticalConstraintsInView:view];
            [self updateTitleLabelConstraintsInView:view];
        } else if ([self toOrFromLargeLayoutChangeToNewLayoutSize:newLayoutSize]) {
            [self updateVerticalConstraintsInView:view];
        } else if ([self toOrFromTinyLayoutChangeToNewLayoutSize:newLayoutSize]) {
            [self updateTitleLabelConstraintsInView:view];
        } else if (self.layoutSize != newLayoutSize) {
            [self updateVerticalConstraintsConstants];
        }
        [self updateAccessoryViewContainerSize];
        [self updateAccessoryViewConstraintsInView:view];
    }
    [self setupViewsVisibilityInView:view];
    [self setupFontSizesInView:view];
    self.layoutWithAccessoryView = (view.accessoryView != nil);
}

- (void)removeConstraintsFromView:(LYRUIConversationItemView *)view {
    [self removeConstraints:self.accessoryViewContainerSizeConstraints
                   fromView:view];
    [self removeConstraints:self.accessoryViewConstraints
                   fromView:view.accessoryViewContainer];
    [self removeConstraints:self.messageLabelHorizontalConstraints
                   fromView:view];
    [self removeConstraints:self.titleLabelHorizontalConstraints
                   fromView:view];
    [self removeConstraints:self.verticalConstraints
                   fromView:view];
    [view removeConstraint:self.centerVerticallyConstraint];
}
    
#pragma mark - Layout updates;

- (void)updateConstraintsForAccessibilityViewVisibilityChangeInView:(LYRUIConversationItemView *)view {
    self.layoutSize = [self laytoutSizeForViewHeight:CGRectGetHeight(view.frame)];
    [self removeConstraints:self.accessoryViewConstraints
                   fromView:view];
    [self setAccessoryViewLayoutInView:view];
    [self removeConstraints:self.accessoryViewContainerSizeConstraints
                   fromView:view];
    [self setAccessoryViewContainerSizeInView:view];
    [self updateTitleLabelConstraintsInView:view];
    [self removeConstraints:self.messageLabelHorizontalConstraints
                   fromView:view];
    [self layoutMessageLabelHorizontallyInView:view];
    [self updateVerticalConstraintsInView:view];
    [view removeConstraint:self.centerVerticallyConstraint];
    [self centerVerticallyInView:view];
}

#pragma mark - Horizontal layout

- (void)layoutHorizontallyInView:(LYRUIConversationItemView *)view {
    [self layoutTitleLabelHorizontallyInView:view];
    [self layoutMessageLabelHorizontallyInView:view];
}

- (void)layoutTitleLabelHorizontallyInView:(LYRUIConversationItemView *)view {
    NSMutableDictionary *views = [@{
            @"conversationTitleLabel" : view.conversationTitleLabel,
            @"dateLabel" : view.dateLabel,
    } mutableCopy];
    if (view.accessoryView) {
        views[@"accessoryViewContainer"] = view.accessoryViewContainer;
    }
    NSString *layout = [NSString stringWithFormat:@"H:|-margin-%@[conversationTitleLabel]%@-margin-|",
                        view.accessoryView ? @"[accessoryViewContainer]-variableMargin-" : @"",
                        (self.layoutSize > LYRUIConversationItemViewLayoutSizeTiny) ? @"->=margin-[dateLabel]" : @""];
    NSDictionary *metrics = @{
            @"margin" : @12,
            @"variableMargin": @([self horizontalConstraintsConstant]),
    };
    NSLayoutFormatOptions options = (self.layoutSize == LYRUIConversationItemViewLayoutSizeLarge) ?
        NSLayoutFormatAlignAllTop : NSLayoutFormatAlignAllCenterY;
    NSArray<__kindof NSLayoutConstraint *> *constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:layout
                                                options:options
                                                metrics:metrics
                                                  views:views];
    [view addConstraints:constraints];
    [self.titleLabelHorizontalConstraints addObjectsFromArray:constraints];
}

- (void)updateTitleLabelConstraintsInView:(LYRUIConversationItemView *)view {
    self.layoutSize = [self laytoutSizeForViewHeight:CGRectGetHeight(view.frame)];
    [self removeConstraints:self.titleLabelHorizontalConstraints
                   fromView:view];
    [self layoutTitleLabelHorizontallyInView:view];
}

- (void)layoutMessageLabelHorizontallyInView:(LYRUIConversationItemView *)view {
    NSMutableDictionary *views = [@{
            @"lastMessageLabel" : view.lastMessageLabel,
    } mutableCopy];
    if (view.accessoryView) {
        views[@"accessoryViewContainer"] = view.accessoryViewContainer;
    }
    NSString *layout = [NSString stringWithFormat:@"H:|-margin-%@[lastMessageLabel]-margin-|",
                        view.accessoryView ? @"[accessoryViewContainer]-margin-" : @""];
    NSArray<__kindof NSLayoutConstraint *> *constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:layout
                                                options:NSLayoutFormatAlignAllBottom
                                                metrics:@{ @"margin" : @12 }
                                                  views:views];
    [view addConstraints:constraints];
    [self.messageLabelHorizontalConstraints addObjectsFromArray:constraints];
}

- (CGFloat)horizontalConstraintsConstant {
    switch (self.layoutSize) {
        case LYRUIConversationItemViewLayoutSizeTiny:
            return 8.0f;
        case LYRUIConversationItemViewLayoutSizeSmall:
        case LYRUIConversationItemViewLayoutSizeMedium:
        case LYRUIConversationItemViewLayoutSizeLarge:
            return 12.0f;
    }
}

#pragma mark - Vertical layout

- (void)layoutVerticallyInView:(LYRUIConversationItemView *)view {
    NSString *layout = @"V:|->=margin-[view]->=margin-|";
    NSDictionary *views;
    if (view.accessoryView) {
        views = @{ @"view" : view.accessoryViewContainer };
    } else {
        views = @{ @"view" : view.conversationTitleLabel };
    }
    NSArray<__kindof NSLayoutConstraint *> *constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:layout
                                                options:0
                                                metrics:@{ @"margin" : @([self verticalConstraintsConstant]) }
                                                  views:views];
    [view addConstraints:constraints];
    [self.verticalConstraints addObjectsFromArray:constraints];
}

- (void)updateVerticalConstraintsInView:(LYRUIConversationItemView *)view {
    self.layoutSize = [self laytoutSizeForViewHeight:CGRectGetHeight(view.frame)];
    [self removeConstraints:self.verticalConstraints
                   fromView:view];
    [self layoutVerticallyInView:view];
}

- (void)updateVerticalConstraintsConstants {
    for (NSLayoutConstraint *constraint in self.verticalConstraints) {
        constraint.constant = [self verticalConstraintsConstant];
    }
}

- (CGFloat)verticalConstraintsConstant {
    switch (self.layoutSize) {
        case LYRUIConversationItemViewLayoutSizeTiny:
        case LYRUIConversationItemViewLayoutSizeSmall:
            return 8.0f;
        case LYRUIConversationItemViewLayoutSizeMedium:
            return 10.0f;
        case LYRUIConversationItemViewLayoutSizeLarge:
            return 12.0f;
    }
}

- (void)centerVerticallyInView:(LYRUIConversationItemView *)view {
    UIView *viewToCenter = (view.accessoryView != nil) ? view.accessoryViewContainer : view.conversationTitleLabel;
    NSLayoutConstraint *centerVerticallyConstraint = [NSLayoutConstraint constraintWithItem:viewToCenter
                                                                                  attribute:NSLayoutAttributeCenterY
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:view
                                                                                  attribute:NSLayoutAttributeCenterY
                                                                                 multiplier:1.0f
                                                                                   constant:0.0f];
    [view addConstraint:centerVerticallyConstraint];
    self.centerVerticallyConstraint = centerVerticallyConstraint;
}

#pragma mark - Accessory view size

- (void)setAccessoryViewContainerSizeInView:(LYRUIConversationItemView *)view {
    if (view.accessoryView) {
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view.accessoryViewContainer
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0f
                                                                            constant:[self accessoryViewContainerMaxSize]];
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view.accessoryViewContainer
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0f
                                                                             constant:[self accessoryViewContainerMaxSize]];
        [self.accessoryViewContainerSizeConstraints addObjectsFromArray:@[widthConstraint, heightConstraint]];
        [view addConstraints:self.accessoryViewContainerSizeConstraints];
    }
}

- (void)updateAccessoryViewContainerSize {
    for (NSLayoutConstraint *constraint in self.accessoryViewContainerSizeConstraints) {
        constraint.constant = [self accessoryViewContainerMaxSize];
    }
}

- (CGFloat)accessoryViewContainerMaxSize {
    switch (self.layoutSize) {
        case LYRUIConversationItemViewLayoutSizeTiny:
            return 12.0f;
        case LYRUIConversationItemViewLayoutSizeSmall:
            return 32.0f;
        case LYRUIConversationItemViewLayoutSizeMedium:
            return 40.0f;
        case LYRUIConversationItemViewLayoutSizeLarge:
            return 48.0f;
    }
}

- (void)setAccessoryViewLayoutInView:(LYRUIConversationItemView *)view {
    if (view.accessoryView) {
        NSString *format = @"|-0-[accessoryView]-0-|";
        NSArray<__kindof NSLayoutConstraint *> *horizontalConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:%@", format]
                                                options:0
                                                metrics:nil
                                                  views:@{ @"accessoryView": view.accessoryView }];
        NSArray<__kindof NSLayoutConstraint *> *verticalConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:%@", format]
                                                options:0
                                                metrics:nil
                                                  views:@{ @"accessoryView": view.accessoryView }];
        [self.accessoryViewConstraints addObjectsFromArray:horizontalConstraints];
        [self.accessoryViewConstraints addObjectsFromArray:verticalConstraints];
        [view.accessoryViewContainer addConstraints:self.accessoryViewConstraints];
    }
}

- (void)updateAccessoryViewConstraintsInView:(LYRUIConversationItemView *)view {
    [self removeConstraints:self.accessoryViewConstraints
                   fromView:view.accessoryViewContainer];
    [self setAccessoryViewLayoutInView:view];
}

#pragma mark - Detecting size change

- (BOOL)layoutChangeBetweenTinyAndLargeWithNewLayoutSize:(LYRUIConversationItemViewLayoutSize)newLayoutSize {
    return ((self.layoutSize == LYRUIConversationItemViewLayoutSizeTiny &&
             newLayoutSize == LYRUIConversationItemViewLayoutSizeLarge) ||
            (self.layoutSize == LYRUIConversationItemViewLayoutSizeLarge &&
             newLayoutSize == LYRUIConversationItemViewLayoutSizeTiny));
}

- (BOOL)toOrFromLargeLayoutChangeToNewLayoutSize:(LYRUIConversationItemViewLayoutSize)newLayoutSize {
    return [self layoutChangedToOrFrom:LYRUIConversationItemViewLayoutSizeLarge
                       toNewLayoutSize:newLayoutSize];
}

- (BOOL)toOrFromTinyLayoutChangeToNewLayoutSize:(LYRUIConversationItemViewLayoutSize)newLayoutSize {
    return [self layoutChangedToOrFrom:LYRUIConversationItemViewLayoutSizeTiny
                       toNewLayoutSize:newLayoutSize];
}

- (BOOL)layoutChangedToOrFrom:(LYRUIConversationItemViewLayoutSize)theLayout
              toNewLayoutSize:(LYRUIConversationItemViewLayoutSize)newLayoutSize {
    return ((self.layoutSize == theLayout &&
             newLayoutSize != theLayout) ||
            (self.layoutSize != theLayout &&
             newLayoutSize == theLayout));
}

#pragma mark - Visibility updates

- (void)setupViewsVisibilityInView:(LYRUIConversationItemView *)view {
    view.lastMessageLabel.hidden = (self.layoutSize != LYRUIConversationItemViewLayoutSizeLarge);
    view.dateLabel.hidden = (self.layoutSize == LYRUIConversationItemViewLayoutSizeTiny);
}

#pragma mark - Font sizes updates

- (void)setupFontSizesInView:(LYRUIConversationItemView *)view {
    NSString *conversationTitleFontName = view.conversationTitleLabel.font.fontName;
    UIFont *newConversationTitleFont = [UIFont fontWithName:conversationTitleFontName size:[self conversationTitleFontSize]];
    view.conversationTitleLabel.font = newConversationTitleFont;
    NSString *dateFontName = view.dateLabel.font.fontName;
    UIFont *newDateFont = [UIFont fontWithName:dateFontName size:[self dateFontSize]];
    view.dateLabel.font = newDateFont;
}

- (CGFloat)conversationTitleFontSize {
    switch (self.layoutSize) {
        case LYRUIConversationItemViewLayoutSizeTiny:
        case LYRUIConversationItemViewLayoutSizeSmall:
            return 14.0;
        case LYRUIConversationItemViewLayoutSizeMedium:
        case LYRUIConversationItemViewLayoutSizeLarge:
            return 16.0;
    }
}

- (CGFloat)dateFontSize {
    switch (self.layoutSize) {
        case LYRUIConversationItemViewLayoutSizeTiny:
        case LYRUIConversationItemViewLayoutSizeSmall:
            return 10.0;
        case LYRUIConversationItemViewLayoutSizeMedium:
        case LYRUIConversationItemViewLayoutSizeLarge:
            return 12.0;
    }
}

#pragma mark - Helpers

- (void)removeConstraints:(NSMutableArray<NSLayoutConstraint *> *)constraints
                 fromView:(UIView *)view {
    for (NSLayoutConstraint *constraint in constraints) {
        if ([view.constraints containsObject:constraint]) {
            [view removeConstraint:constraint];
        }
    }
    [constraints removeAllObjects];
}

- (LYRUIConversationItemViewLayoutSize)laytoutSizeForViewHeight:(CGFloat)viewHeight {
    if (viewHeight < 48.0f) {
        return LYRUIConversationItemViewLayoutSizeTiny;
    } else if (viewHeight < 60.0f) {
        return LYRUIConversationItemViewLayoutSizeSmall;
    } else if (viewHeight < 72.0f) {
        return LYRUIConversationItemViewLayoutSizeMedium;
    } else {
        return LYRUIConversationItemViewLayoutSizeLarge;
    }
}

@end
