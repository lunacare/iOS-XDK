//
//  LYRUIBaseListViewLayout.m
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

#import "LYRUIBaseItemViewLayout.h"
#import "LYRUIConversationItemViewLayoutMetrics.h"

@interface LYRUIBaseItemViewLayout ()

@property(nonatomic, strong) LYRUIConversationItemViewLayoutMetrics *metrics;

@property(nonatomic) LYRUIBaseItemViewLayoutSize layoutSize;
@property(nonatomic) BOOL layoutWithAccessoryView;

@property(nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *accessoryViewConstraints;
@property(nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *accessoryViewContainerSizeConstraints;
@property(nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *titleLabelHorizontalConstraints;
@property(nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *messageLabelHorizontalConstraints;
@property(nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *verticalMarginConstraints;
@property(nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *verticalConstraints;

@end

@implementation LYRUIBaseItemViewLayout

- (instancetype)init {
    self = [self initWithMetrics:nil];
    return self;
}

- (instancetype)initWithMetrics:(id<LYRUIBaseItemViewLayoutMetricsProviding>)metrics {
    self = [super init];
    if (self) {
        self.metrics = metrics;
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

- (void)addConstraintsInView:(LYRUIBaseItemView *)view {
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

- (void)updateConstraintsInView:(LYRUIBaseItemView *)view {
    if (self.layoutWithAccessoryView != (view.accessoryView != nil)) {
        [self removeConstraintsFromView:view];
        [self addConstraintsInView:view];
        self.layoutWithAccessoryView = (view.accessoryView != nil);
        return;
    }
    
    LYRUIBaseItemViewLayoutSize oldLayoutSize = self.layoutSize;
    LYRUIBaseItemViewLayoutSize newLayoutSize = [self.metrics laytoutSizeForViewHeight:CGRectGetHeight(view.frame)];
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

- (void)removeConstraintsFromView:(LYRUIBaseItemView *)view {
    [self removeConstraints:self.accessoryViewContainerSizeConstraints fromView:view];
    [self removeConstraints:self.accessoryViewConstraints fromView:view.accessoryViewContainer];
    [self removeConstraints:self.messageLabelHorizontalConstraints fromView:view];
    [self removeConstraints:self.titleLabelHorizontalConstraints fromView:view];
    [self removeConstraints:self.verticalMarginConstraints fromView:view];
    [self removeConstraints:self.verticalConstraints fromView:view];
}

#pragma mark - Horizontal layout

- (void)layoutHorizontallyInView:(LYRUIBaseItemView *)view {
    [self layoutTitleLabelHorizontallyInView:view];
    [self layoutMessageLabelHorizontallyInView:view];
}

- (void)layoutTitleLabelHorizontallyInView:(LYRUIBaseItemView *)view {
    UIView *accessoryContainer = view.accessoryViewContainer;
    UIView *titleLabel = view.titleLabel;
    UIView *timeLabel = view.timeLabel;
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
    [constraints addObject:[timeLabel.leftAnchor constraintGreaterThanOrEqualToAnchor:titleLabel.rightAnchor
                                                                             constant:margin]];
    if (self.layoutSize > LYRUIBaseItemViewLayoutSizeTiny) {
        [constraints addObject:[timeLabel.rightAnchor constraintEqualToAnchor:view.rightAnchor constant:-margin]];
    } else {
        [constraints addObject:[titleLabel.rightAnchor constraintEqualToAnchor:view.rightAnchor constant:-margin]];
    }
    
    [view addConstraints:constraints];
    [self.titleLabelHorizontalConstraints addObjectsFromArray:constraints];
}

- (void)updateTitleLabelConstraintsInView:(LYRUIBaseItemView *)view {
    self.layoutSize = [self.metrics laytoutSizeForViewHeight:CGRectGetHeight(view.frame)];
    [self removeConstraints:self.titleLabelHorizontalConstraints fromView:view];
    [self layoutTitleLabelHorizontallyInView:view];
}

- (void)layoutMessageLabelHorizontallyInView:(LYRUIBaseItemView *)view {
    UIView *accessoryContainer = view.accessoryViewContainer;
    UIView *messageLabel = view.messageLabel;
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

- (void)setupContentCompressionResistanceInView:(LYRUIBaseItemView *)view {
    [view.timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                    forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - Vertical layout

- (void)addVerticalMarginsInView:(LYRUIBaseItemView *)view {
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

- (void)layoutVerticallyInView:(LYRUIBaseItemView *)view {
    UIView *accessoryContainer = view.accessoryViewContainer;
    UIView *titleLabel = view.titleLabel;
    UIView *timeLabel = view.timeLabel;
    UIView *messageLabel = view.messageLabel;
    CGFloat topGuideShift = self.metrics.topGuideShift;
    CGFloat margin = self.metrics.labelsVerticalMargin;
    
    NSMutableArray *constraints = [NSMutableArray new];
    
    [constraints addObject:[accessoryContainer.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]];
    if (self.layoutSize < LYRUIBaseItemViewLayoutSizeLarge) {
        [constraints addObject:[titleLabel.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]];
        [constraints addObject:[titleLabel.centerYAnchor constraintEqualToAnchor:timeLabel.centerYAnchor]];
    } else {
        [constraints addObject:[titleLabel.topAnchor constraintEqualToAnchor:accessoryContainer.topAnchor
                                                                    constant:topGuideShift]];
        [constraints addObject:[titleLabel.topAnchor constraintEqualToAnchor:timeLabel.topAnchor]];
    }
    [constraints addObject:[messageLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:margin]];
    
    [view addConstraints:constraints];
    [self.verticalConstraints addObjectsFromArray:constraints];
}

- (void)updateVerticalLayoutInView:(LYRUIBaseItemView *)view {
    self.layoutSize = [self.metrics laytoutSizeForViewHeight:CGRectGetHeight(view.frame)];
    [self removeConstraints:self.verticalConstraints fromView:view];
    [self layoutVerticallyInView:view];
}

#pragma mark - Accessory view layout

- (void)setAccessoryViewContainerSizeInView:(LYRUIBaseItemView *)view {
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

- (void)setAccessoryViewLayoutInView:(LYRUIBaseItemView *)view {
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

- (void)updateAccessoryViewConstraintsInView:(LYRUIBaseItemView *)view {
    [self removeConstraints:self.accessoryViewConstraints
                   fromView:view.accessoryViewContainer];
    [self setAccessoryViewLayoutInView:view];
}

#pragma mark - Detecting size change

- (BOOL)toOrFromLargeLayoutChangeWithOldSize:(LYRUIBaseItemViewLayoutSize)oldLayoutSize
                                     newSize:(LYRUIBaseItemViewLayoutSize)newLayoutSize {
    LYRUIBaseItemViewLayoutSize largeSize = LYRUIBaseItemViewLayoutSizeLarge;
    return oldLayoutSize != newLayoutSize && (oldLayoutSize == largeSize || newLayoutSize == largeSize);
}

- (BOOL)toOrFromTinyLayoutChangeWithOldSize:(LYRUIBaseItemViewLayoutSize)oldLayoutSize
                                    newSize:(LYRUIBaseItemViewLayoutSize)newLayoutSize {
    LYRUIBaseItemViewLayoutSize tinySize = LYRUIBaseItemViewLayoutSizeTiny;
    return oldLayoutSize != newLayoutSize && (oldLayoutSize == tinySize || newLayoutSize == tinySize);
}

#pragma mark - Visibility updates

- (void)setupViewsVisibilityInView:(LYRUIBaseItemView *)view {
    view.messageLabel.hidden = (self.layoutSize != LYRUIBaseItemViewLayoutSizeLarge);
    view.timeLabel.hidden = (self.layoutSize == LYRUIBaseItemViewLayoutSizeTiny);
}

#pragma mark - Font sizes updates

- (void)updateFontSizesInView:(LYRUIBaseItemView *)view {
    NSString *conversationTitleFontName = view.titleLabel.font.fontName;
    UIFont *newConversationTitleFont = [UIFont fontWithName:conversationTitleFontName
                                                       size:self.metrics.conversationTitleFontSize];
    view.titleLabel.font = newConversationTitleFont;
    NSString *dateFontName = view.timeLabel.font.fontName;
    UIFont *newDateFont = [UIFont fontWithName:dateFontName size:self.metrics.dateFontSize];
    view.timeLabel.font = newDateFont;
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

#pragma mark - LYRUIBaseListViewLayoutMetricsDelegate method

- (LYRUIBaseItemViewLayoutSize)baseItemViewLayoutMetricsCurrentLayoutSize {
    return self.layoutSize;
}

@end
