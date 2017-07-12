//
//  LYRUIConversationItemViewLayout.m
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

#import "LYRUIConversationItemViewLayout.h"
#import "LYRUIConversationItemViewLayoutMetrics.h"

@interface LYRUIConversationItemViewLayout () <LYRUIConversationItemViewLayoutMetricsDelegate>

@property(nonatomic, strong) LYRUIConversationItemViewLayoutMetrics *metrics;

@property(nonatomic) LYRUIConversationItemViewLayoutSize layoutSize;
@property(nonatomic) BOOL layoutWithAccessoryView;

@property(nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *accessoryViewConstraints;
@property(nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *accessoryViewContainerSizeConstraints;
@property(nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *titleLabelHorizontalConstraints;
@property(nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *messageLabelHorizontalConstraints;
@property(nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *verticalMarginConstraints;
@property(nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *verticalConstraints;

@end

@implementation LYRUIConversationItemViewLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.metrics = [[LYRUIConversationItemViewLayoutMetrics alloc] init];
        self.metrics.delegate = self;
        
        self.accessoryViewConstraints = [NSMutableArray new];
        self.accessoryViewContainerSizeConstraints = [NSMutableArray new];
        self.titleLabelHorizontalConstraints = [NSMutableArray new];
        self.messageLabelHorizontalConstraints = [NSMutableArray new];
        self.verticalMarginConstraints = [NSMutableArray new];
        self.verticalConstraints = [NSMutableArray new];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] init];
}

#pragma mark - LYRUIViewLayout methods

- (void)addConstraintsInView:(LYRUIConversationItemView *)view {
    self.layoutSize = [self.metrics laytoutSizeForViewHeight:CGRectGetHeight(view.frame)];
    self.layoutWithAccessoryView = (view.accessoryView != nil);
    [self setAccessoryViewContainerSizeInView:view];
    [self setAccessoryViewLayoutInView:view];
    [self layoutHorizontallyInView:view];
    [self addVerticalMarginsInView:view];
    [self layoutVerticallyInView:view];
    [self setupViewsVisibilityInView:view];
    [self updateFontSizesInView:view];
    [self setupContentCompressionResistanceInView:view];
}

- (void)updateConstraintsInView:(LYRUIConversationItemView *)view {
    if (self.layoutWithAccessoryView != (view.accessoryView != nil)) {
        [self removeConstraintsFromView:view];
        [self addConstraintsInView:view];
        self.layoutWithAccessoryView = (view.accessoryView != nil);
        return;
    }
    
    LYRUIConversationItemViewLayoutSize oldLayoutSize = self.layoutSize;
    LYRUIConversationItemViewLayoutSize newLayoutSize = [self.metrics laytoutSizeForViewHeight:CGRectGetHeight(view.frame)];
    if (oldLayoutSize != newLayoutSize) {
        if ([self toOrFromLargeLayoutChangeWithOldSize:oldLayoutSize newSize:newLayoutSize]) {
            [self updateVerticalLayoutInView:view];
        }
        if ([self toOrFromTinyLayoutChangeWithOldSize:oldLayoutSize newSize:newLayoutSize]) {
            [self updateTitleLabelConstraintsInView:view];
        }
        [self updateVerticalMarginsSize];
        [self updateAccessoryViewContainerSize];
        [self setupViewsVisibilityInView:view];
        [self updateFontSizesInView:view];
    }
    [self updateAccessoryViewConstraintsInView:view];
}

- (void)removeConstraintsFromView:(LYRUIConversationItemView *)view {
    [self removeConstraints:self.accessoryViewContainerSizeConstraints fromView:view];
    [self removeConstraints:self.accessoryViewConstraints fromView:view.accessoryViewContainer];
    [self removeConstraints:self.messageLabelHorizontalConstraints fromView:view];
    [self removeConstraints:self.titleLabelHorizontalConstraints fromView:view];
    [self removeConstraints:self.verticalMarginConstraints fromView:view];
    [self removeConstraints:self.verticalConstraints fromView:view];
}

#pragma mark - Horizontal layout

- (void)layoutHorizontallyInView:(LYRUIConversationItemView *)view {
    [self layoutTitleLabelHorizontallyInView:view];
    [self layoutMessageLabelHorizontallyInView:view];
}

- (void)layoutTitleLabelHorizontallyInView:(LYRUIConversationItemView *)view {
    UIView *accessoryContainer = view.accessoryViewContainer;
    UIView *titleLabel = view.conversationTitleLabel;
    UIView *dateLabel = view.dateLabel;
    CGFloat margin = self.metrics.horizontalMarginSize;
    CGFloat variableMargin = self.metrics.horizontalVariableMarginSize;
    
    NSMutableArray *constraints = [NSMutableArray new];
    
    [constraints addObject:[accessoryContainer.leftAnchor constraintEqualToAnchor:view.leftAnchor constant:margin]];
    if (view.accessoryView != nil) {
        [constraints addObject:[titleLabel.leftAnchor constraintEqualToAnchor:accessoryContainer.rightAnchor
                                                                     constant:variableMargin]];
    } else {
        [constraints addObject:[titleLabel.leftAnchor constraintEqualToAnchor:view.leftAnchor constant:margin]];
    }
    [constraints addObject:[dateLabel.leftAnchor constraintGreaterThanOrEqualToAnchor:titleLabel.rightAnchor
                                                                             constant:margin]];
    if (self.layoutSize > LYRUIConversationItemViewLayoutSizeTiny) {
        [constraints addObject:[dateLabel.rightAnchor constraintEqualToAnchor:view.rightAnchor constant:-margin]];
    } else {
        [constraints addObject:[titleLabel.rightAnchor constraintEqualToAnchor:view.rightAnchor constant:-margin]];
    }
    
    [view addConstraints:constraints];
    [self.titleLabelHorizontalConstraints addObjectsFromArray:constraints];
}

- (void)updateTitleLabelConstraintsInView:(LYRUIConversationItemView *)view {
    self.layoutSize = [self.metrics laytoutSizeForViewHeight:CGRectGetHeight(view.frame)];
    [self removeConstraints:self.titleLabelHorizontalConstraints fromView:view];
    [self layoutTitleLabelHorizontallyInView:view];
}

- (void)layoutMessageLabelHorizontallyInView:(LYRUIConversationItemView *)view {
    UIView *accessoryContainer = view.accessoryViewContainer;
    UIView *messageLabel = view.lastMessageLabel;
    CGFloat margin = self.metrics.horizontalMarginSize;
    
    NSMutableArray *constraints = [NSMutableArray new];
    if (view.accessoryView != nil) {
        [constraints addObject:[messageLabel.leftAnchor constraintEqualToAnchor:accessoryContainer.rightAnchor
                                                                       constant:margin]];
    } else {
        [constraints addObject:[messageLabel.leftAnchor constraintEqualToAnchor:view.leftAnchor constant:margin]];
    }
    [constraints addObject:[messageLabel.rightAnchor constraintEqualToAnchor:view.rightAnchor constant:-margin]];
    [view addConstraints:constraints];
    [self.messageLabelHorizontalConstraints addObjectsFromArray:constraints];
}

- (void)setupContentCompressionResistanceInView:(LYRUIConversationItemView *)view {
    [view.dateLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                    forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - Vertical layout

- (void)addVerticalMarginsInView:(LYRUIConversationItemView *)view {
    UIView *accessoryContainer = view.accessoryViewContainer;
    CGFloat margin = self.metrics.verticalMarginSize;
    
    NSMutableArray *constraints = [NSMutableArray new];
    
    [constraints addObject:[accessoryContainer.topAnchor constraintGreaterThanOrEqualToAnchor:view.topAnchor
                                                                                     constant:margin]];
    [constraints addObject:[accessoryContainer.bottomAnchor constraintLessThanOrEqualToAnchor:view.bottomAnchor
                                                                                        constant:-margin]];
    
    [view addConstraints:constraints];
    [self.verticalMarginConstraints addObjectsFromArray:constraints];
}

- (void)updateVerticalMarginsSize {
    for (NSLayoutConstraint *constraint in self.verticalMarginConstraints) {
        constraint.constant = self.metrics.verticalMarginSize;
    }
}

- (void)layoutVerticallyInView:(LYRUIConversationItemView *)view {
    UIView *accessoryContainer = view.accessoryViewContainer;
    UIView *titleLabel = view.conversationTitleLabel;
    UIView *dateLabel = view.dateLabel;
    UIView *messageLabel = view.lastMessageLabel;
    CGFloat topGuideShift = self.metrics.topGuideShift;
    CGFloat margin = self.metrics.labelsVerticalMargin;
    
    NSMutableArray *constraints = [NSMutableArray new];
    
    [constraints addObject:[accessoryContainer.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]];
    if (self.layoutSize < LYRUIConversationItemViewLayoutSizeLarge) {
        [constraints addObject:[titleLabel.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]];
        [constraints addObject:[titleLabel.centerYAnchor constraintEqualToAnchor:dateLabel.centerYAnchor]];
    } else {
        [constraints addObject:[titleLabel.topAnchor constraintEqualToAnchor:accessoryContainer.topAnchor
                                                                    constant:topGuideShift]];
        [constraints addObject:[titleLabel.topAnchor constraintEqualToAnchor:dateLabel.topAnchor]];
    }
    [constraints addObject:[messageLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:margin]];
    
    [view addConstraints:constraints];
    [self.verticalConstraints addObjectsFromArray:constraints];
}

- (void)updateVerticalLayoutInView:(LYRUIConversationItemView *)view {
    self.layoutSize = [self.metrics laytoutSizeForViewHeight:CGRectGetHeight(view.frame)];
    [self removeConstraints:self.verticalConstraints fromView:view];
    [self layoutVerticallyInView:view];
}

#pragma mark - Accessory view layout

- (void)setAccessoryViewContainerSizeInView:(LYRUIConversationItemView *)view {
    UIView *accessoryContainer = view.accessoryViewContainer;
    CGFloat maxSize = self.metrics.accessoryViewContainerMaxSize;
    
    NSMutableArray *constraints = [NSMutableArray new];
    
    [constraints addObject:[accessoryContainer.heightAnchor constraintEqualToConstant:maxSize]];
    [constraints addObject:[accessoryContainer.widthAnchor constraintEqualToConstant:maxSize]];
    
    [view addConstraints:constraints];
    [self.accessoryViewContainerSizeConstraints addObjectsFromArray:constraints];
}

- (void)updateAccessoryViewContainerSize {
    for (NSLayoutConstraint *constraint in self.accessoryViewContainerSizeConstraints) {
        constraint.constant = self.metrics.accessoryViewContainerMaxSize;
    }
}

- (void)setAccessoryViewLayoutInView:(LYRUIConversationItemView *)view {
    UIView *accessoryContainer = view.accessoryViewContainer;
    UIView *accessoryView = view.accessoryView;
    
    if (view.accessoryView != nil) {
        NSMutableArray *constraints = [NSMutableArray new];
        
        [constraints addObject:[accessoryView.leadingAnchor constraintEqualToAnchor:accessoryContainer.leadingAnchor]];
        [constraints addObject:[accessoryView.trailingAnchor constraintEqualToAnchor:accessoryContainer.trailingAnchor]];
        [constraints addObject:[accessoryView.topAnchor constraintEqualToAnchor:accessoryContainer.topAnchor]];
        [constraints addObject:[accessoryView.bottomAnchor constraintEqualToAnchor:accessoryContainer.bottomAnchor]];
        
        [self.accessoryViewConstraints addObjectsFromArray:constraints];
        [view.accessoryViewContainer addConstraints:self.accessoryViewConstraints];
    }
}

- (void)updateAccessoryViewConstraintsInView:(LYRUIConversationItemView *)view {
    [self removeConstraints:self.accessoryViewConstraints
                   fromView:view.accessoryViewContainer];
    [self setAccessoryViewLayoutInView:view];
}

#pragma mark - Detecting size change

- (BOOL)toOrFromLargeLayoutChangeWithOldSize:(LYRUIConversationItemViewLayoutSize)oldLayoutSize
                                     newSize:(LYRUIConversationItemViewLayoutSize)newLayoutSize {
    LYRUIConversationItemViewLayoutSize largeSize = LYRUIConversationItemViewLayoutSizeLarge;
    return oldLayoutSize != newLayoutSize && (oldLayoutSize == largeSize || newLayoutSize == largeSize);
}

- (BOOL)toOrFromTinyLayoutChangeWithOldSize:(LYRUIConversationItemViewLayoutSize)oldLayoutSize
                                    newSize:(LYRUIConversationItemViewLayoutSize)newLayoutSize {
    LYRUIConversationItemViewLayoutSize tinySize = LYRUIConversationItemViewLayoutSizeTiny;
    return oldLayoutSize != newLayoutSize && (oldLayoutSize == tinySize || newLayoutSize == tinySize);
}

#pragma mark - Visibility updates

- (void)setupViewsVisibilityInView:(LYRUIConversationItemView *)view {
    view.lastMessageLabel.hidden = (self.layoutSize != LYRUIConversationItemViewLayoutSizeLarge);
    view.dateLabel.hidden = (self.layoutSize == LYRUIConversationItemViewLayoutSizeTiny);
}

#pragma mark - Font sizes updates

- (void)updateFontSizesInView:(LYRUIConversationItemView *)view {
    NSString *conversationTitleFontName = view.conversationTitleLabel.font.fontName;
    UIFont *newConversationTitleFont = [UIFont fontWithName:conversationTitleFontName
                                                       size:self.metrics.conversationTitleFontSize];
    view.conversationTitleLabel.font = newConversationTitleFont;
    NSString *dateFontName = view.dateLabel.font.fontName;
    UIFont *newDateFont = [UIFont fontWithName:dateFontName size:self.metrics.dateFontSize];
    view.dateLabel.font = newDateFont;
}

#pragma mark - Helpers

- (void)removeConstraints:(NSMutableArray<NSLayoutConstraint *> *)constraints fromView:(UIView *)view {
    for (NSLayoutConstraint *constraint in constraints) {
        if ([view.constraints containsObject:constraint]) {
            [view removeConstraint:constraint];
        }
    }
    [constraints removeAllObjects];
}

#pragma mark - LYRUIConversationItemViewLayoutMetricsDelegate method

- (LYRUIConversationItemViewLayoutSize)conversationItemViewLayoutMetricsCurrentLayoutSize {
    return self.layoutSize;
}

@end
