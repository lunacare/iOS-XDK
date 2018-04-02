//
//  LYRUIProductMessageCompositeView.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 02.01.2018.
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

#import "LYRUIProductMessageCompositeView.h"
#import "LYRUIProductMessage.h"
#import "LYRUIProductOptionView.h"

static CGFloat const LYRUIProductMessageCompositeViewMinWidth = 292.0;

@interface LYRUIProductMessageCompositeView ()

@property (nonatomic, readwrite, weak) UIImageView *imageView;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, readwrite, weak) UILabel *brandLabel;
@property (nonatomic, readwrite, weak) UILabel *nameLabel;
@property (nonatomic, readwrite, weak) UILabel *priceLabel;
@property (nonatomic, readwrite, weak) UIStackView *optionsStackView;
@property (nonatomic, readwrite, weak) UILabel *descriptionLabel;

@end

@implementation LYRUIProductMessageCompositeView

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
    [self addImageView];
    [self addContainerView];
    self.brandLabel = [self addLabel];
    self.brandLabel.font = [UIFont systemFontOfSize:12.0];
    self.brandLabel.textColor = [UIColor colorWithRed:110.0/255.0 green:114.0/255.0 blue:122.0/255.0 alpha:1.0];
    self.nameLabel = [self addLabel];
    self.priceLabel = [self addLabel];
    [self addStackView];
    self.descriptionLabel = [self addLabel];
    self.backgroundColor = UIColor.whiteColor;
    
    [self addConstraints];
}

- (void)addImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    self.imageView = imageView;
}

- (void)addContainerView {
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    container.backgroundColor = UIColor.whiteColor;
    [self addSubview:container];
    self.containerView = container;
}

- (UILabel *)addLabel {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = UIColor.blackColor;
    [self.containerView addSubview:label];
    return label;
}

- (void)addStackView {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.spacing = 5.0;
    [self.containerView addSubview:stackView];
    self.optionsStackView = stackView;
}

- (void)setupWithOptions:(NSArray<LYRUIProductOptionView *> *)options {
    for (UIView *subview in [self.optionsStackView.arrangedSubviews copy]) {
        [subview removeFromSuperview];
    }
    
    LYRUIProductOptionView *previousOption;
    for (LYRUIProductOptionView *option in options) {
        [self.optionsStackView addArrangedSubview:option];
        if (previousOption != nil) {
            [previousOption.titleLabel.widthAnchor constraintEqualToAnchor:option.titleLabel.widthAnchor].active = YES;
        }
        previousOption = option;
    }
}

- (void)addConstraints {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.widthAnchor constraintGreaterThanOrEqualToConstant:LYRUIProductMessageCompositeViewMinWidth].active = YES;
    
    [self.imageView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.imageView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.imageView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.containerView.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor].active = YES;
    [self.containerView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.containerView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    
    [self.containerView.bottomAnchor constraintLessThanOrEqualToAnchor:self.bottomAnchor].active = YES;
    [self.imageView.heightAnchor constraintEqualToConstant:236.0].active = YES;
    
    [self.brandLabel.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:5.0].active = YES;
    [self.brandLabel.leftAnchor constraintEqualToAnchor:self.containerView.leftAnchor constant:12.0].active = YES;
    [self.brandLabel.rightAnchor constraintEqualToAnchor:self.containerView.rightAnchor constant:-12.0].active = YES;
    [self.brandLabel.bottomAnchor constraintEqualToAnchor:self.nameLabel.topAnchor constant:-5.0].active = YES;
    [self.nameLabel.leftAnchor constraintEqualToAnchor:self.containerView.leftAnchor constant:12.0].active = YES;
    [self.nameLabel.rightAnchor constraintEqualToAnchor:self.containerView.rightAnchor constant:-12.0].active = YES;
    [self.nameLabel.bottomAnchor constraintEqualToAnchor:self.priceLabel.topAnchor constant:-5.0].active = YES;
    [self.priceLabel.leftAnchor constraintEqualToAnchor:self.containerView.leftAnchor constant:12.0].active = YES;
    [self.priceLabel.rightAnchor constraintEqualToAnchor:self.containerView.rightAnchor constant:-12.0].active = YES;
    [self.priceLabel.bottomAnchor constraintEqualToAnchor:self.optionsStackView.topAnchor constant:-5.0].active = YES;
    [self.optionsStackView.leftAnchor constraintEqualToAnchor:self.containerView.leftAnchor constant:12.0].active = YES;
    [self.optionsStackView.rightAnchor constraintEqualToAnchor:self.containerView.rightAnchor constant:-12.0].active = YES;
    [self.optionsStackView.bottomAnchor constraintEqualToAnchor:self.descriptionLabel.topAnchor constant:-5.0].active = YES;
    [self.descriptionLabel.leftAnchor constraintEqualToAnchor:self.containerView.leftAnchor constant:12.0].active = YES;
    [self.descriptionLabel.rightAnchor constraintEqualToAnchor:self.containerView.rightAnchor constant:-12.0].active = YES;
    [self.descriptionLabel.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor constant:-8.0].active = YES;
    
    [self.imageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.imageView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.brandLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.brandLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.priceLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.priceLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.descriptionLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.descriptionLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

#pragma mark - LYRUIViewReusing

- (void)lyr_prepareForReuse {
    self.imageView.image = nil;
    self.brandLabel.text = nil;
    self.nameLabel.text = nil;
    self.descriptionLabel.text = nil;
    for (UIView *subview in [self.optionsStackView.arrangedSubviews copy]) {
        [subview removeFromSuperview];
    }
}

@end
