//
//  LYRUIReceiptMessageCompositeView.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 04.01.2018.
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

#import "LYRUIReceiptMessageCompositeView.h"

@interface LYRUIReceiptMessageCompositeView ()

@property (nonatomic, readwrite, weak) UIStackView *stackView;
@property (nonatomic, readwrite, weak) UIStackView *titleStackView;
@property (nonatomic, readwrite, weak) UIImageView *iconView;
@property (nonatomic, readwrite, weak) UILabel *titleLabel;
@property (nonatomic, readwrite, weak) UIStackView *productsStackView;
@property (nonatomic, readwrite, weak) UIStackView *paymentStackView;
@property (nonatomic, readwrite, weak) UILabel *paymentTitleLabel;
@property (nonatomic, readwrite, weak) UILabel *paymentLabel;
@property (nonatomic, readwrite, weak) UIView *spacingCover;
@property (nonatomic, readwrite, weak) UIStackView *shippingStackView;
@property (nonatomic, readwrite, weak) UILabel *shippingTitleLabel;
@property (nonatomic, readwrite, weak) UILabel *shippingAddressLabel;
@property (nonatomic, readwrite, weak) UIStackView *summaryStackView;
@property (nonatomic, readwrite, weak) UILabel *summaryTitleLabel;
@property (nonatomic, readwrite, weak) UILabel *totalPriceLabel;

@end

@implementation LYRUIReceiptMessageCompositeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (void)lyr_commonInit {
    [self addStackView];
    
    [self addTitle];
    [self addProducts];
    [self addPayment];
    [self addShipping];
    [self addSummary];

    [self hideSpacing];
    
    [self addConstraints];
}

- (void)addStackView {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.spacing = 1.0;
    [self addSubview:stackView];
    self.stackView = stackView;
}

- (void)addTitle {
    UIStackView *stackView = [[UIStackView alloc] init];
    [self addStackViewBackground:stackView];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 8.0;
    stackView.layoutMargins = UIEdgeInsetsMake(8, 12, 8, 12);
    stackView.layoutMarginsRelativeArrangement = YES;
    [self.stackView addArrangedSubview:stackView];
    self.titleStackView = stackView;
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [stackView addArrangedSubview:iconImageView];
    self.iconView = iconImageView;
    
    UILabel *label = [self newLabel];
    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [stackView addArrangedSubview:label];
    self.titleLabel = label;
}

- (void)addProducts {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.spacing = 1.0;
    [self.stackView addArrangedSubview:stackView];
    self.productsStackView = stackView;
}

- (void)addPayment {
    UIStackView *stackView = [[UIStackView alloc] init];
    [self addStackViewBackground:stackView];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillProportionally;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.spacing = 5.0;
    stackView.layoutMargins = UIEdgeInsetsMake(8, 12, 8, 12);
    stackView.layoutMarginsRelativeArrangement = YES;
    [self.stackView addArrangedSubview:stackView];
    self.paymentStackView = stackView;
    
    UILabel *titleLabel = [self newLabel];
    titleLabel.font = [UIFont systemFontOfSize:12.0];
    titleLabel.textColor = [UIColor colorWithRed:110.0/255.0 green:114.0/255.0 blue:122.0/255.0 alpha:1.0];
    [stackView addArrangedSubview:titleLabel];
    self.paymentTitleLabel = titleLabel;
    
    UILabel *label = [self newLabel];
    [stackView addArrangedSubview:label];
    self.paymentLabel = label;
}

- (void)addShipping {
    UIStackView *stackView = [[UIStackView alloc] init];
    [self addStackViewBackground:stackView];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillProportionally;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.spacing = 5.0;
    stackView.layoutMargins = UIEdgeInsetsMake(8, 12, 8, 12);
    stackView.layoutMarginsRelativeArrangement = YES;
    [self.stackView addArrangedSubview:stackView];
    self.shippingStackView = stackView;
    
    UILabel *titleLabel = [self newLabel];
    titleLabel.font = [UIFont systemFontOfSize:12.0];
    titleLabel.textColor = [UIColor colorWithRed:110.0/255.0 green:114.0/255.0 blue:122.0/255.0 alpha:1.0];
    [stackView addArrangedSubview:titleLabel];
    self.shippingTitleLabel = titleLabel;
    
    UILabel *label = [self newLabel];
    [stackView addArrangedSubview:label];
    self.shippingAddressLabel = label;
}

- (void)addSummary {
    UIStackView *stackView = [[UIStackView alloc] init];
    [self addStackViewBackground:stackView];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.spacing = 5.0;
    stackView.layoutMargins = UIEdgeInsetsMake(8, 12, 8, 12);
    stackView.layoutMarginsRelativeArrangement = YES;
    [self.stackView addArrangedSubview:stackView];
    self.summaryStackView = stackView;
    
    UILabel *titleLabel = [self newLabel];
    titleLabel.textColor = [UIColor colorWithRed:110.0/255.0 green:114.0/255.0 blue:122.0/255.0 alpha:1.0];
    [stackView addArrangedSubview:titleLabel];
    self.summaryTitleLabel = titleLabel;
    
    UILabel *label = [self newLabel];
    label.textAlignment = NSTextAlignmentRight;
    [stackView addArrangedSubview:label];
    self.totalPriceLabel = label;
}

- (UILabel *)newLabel {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = UIColor.blackColor;
    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    return label;
}

- (void)hideSpacing {
    UIView *spacingCover = [[UIView alloc] init];
    spacingCover.translatesAutoresizingMaskIntoConstraints = NO;
    spacingCover.backgroundColor = UIColor.whiteColor;
    [self.stackView addSubview:spacingCover];
    self.spacingCover = spacingCover;
}

- (void)addConstraints {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.widthAnchor constraintGreaterThanOrEqualToConstant:192.0].active = YES;
    
    [self.stackView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.stackView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.stackView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    
    [self.iconView.widthAnchor constraintEqualToAnchor:self.iconView.heightAnchor].active = YES;
    [self.iconView.widthAnchor constraintEqualToConstant:24.0].active = YES;
    [self.iconView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.iconView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.spacingCover.widthAnchor constraintEqualToAnchor:self.stackView.widthAnchor].active = YES;
    [self.spacingCover.leftAnchor constraintEqualToAnchor:self.stackView.leftAnchor].active = YES;
    [self.spacingCover.topAnchor constraintEqualToAnchor:self.paymentStackView.bottomAnchor].active = YES;
    [self.spacingCover.bottomAnchor constraintEqualToAnchor:self.shippingStackView.topAnchor].active = YES;
}

- (void)addStackViewBackground:(UIStackView *)stackView {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    backgroundView.backgroundColor = UIColor.whiteColor;
    [stackView addSubview:backgroundView];
    [stackView sendSubviewToBack:backgroundView];
    [backgroundView.topAnchor constraintEqualToAnchor:stackView.topAnchor].active = YES;
    [backgroundView.rightAnchor constraintEqualToAnchor:stackView.rightAnchor].active = YES;
    [backgroundView.bottomAnchor constraintEqualToAnchor:stackView.bottomAnchor].active = YES;
    [backgroundView.leftAnchor constraintEqualToAnchor:stackView.leftAnchor].active = YES;
}

- (void)lyr_prepareForReuse {
    for (UIView *subview in [self.productsStackView.subviews copy]) {
        [subview removeFromSuperview];
    }
}

@end
