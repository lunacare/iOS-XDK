//
//  LYRUIReceiptProductView.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 08.01.2018.
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

#import "LYRUIReceiptProductView.h"

@interface LYRUIReceiptProductView ()

@property (nonatomic, readwrite, weak) UIStackView *stackView;
@property (nonatomic, readwrite, weak) UIStackView *labelsStackView;
@property (nonatomic, readwrite, weak) UIImageView *imageView;
@property (nonatomic, readwrite, weak) UILabel *nameLabel;
@property (nonatomic, readwrite, weak) UILabel *optionsLabel;
@property (nonatomic, readwrite, weak) UILabel *quantityLabel;

@end

@implementation LYRUIReceiptProductView

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
    self.backgroundColor = UIColor.whiteColor;
    
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFillProportionally;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 12.0;
    stackView.layoutMargins = UIEdgeInsetsMake(12, 12, 12, 12);
    stackView.layoutMarginsRelativeArrangement = YES;
    [self addSubview:stackView];
    self.stackView = stackView;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [stackView addArrangedSubview:imageView];
    [imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    self.imageView = imageView;
    
    UIStackView *labelsStackView = [[UIStackView alloc] init];
    labelsStackView.translatesAutoresizingMaskIntoConstraints = NO;
    labelsStackView.axis = UILayoutConstraintAxisVertical;
    labelsStackView.distribution = UIStackViewDistributionFillProportionally;
    labelsStackView.alignment = UIStackViewAlignmentFill;
    labelsStackView.spacing = 2.0;
    [stackView addArrangedSubview:labelsStackView];
    self.labelsStackView = labelsStackView;
    
    UILabel *nameLabel = [self newLabel];
    nameLabel.font = [UIFont systemFontOfSize:14.0];
    nameLabel.textColor = UIColor.blackColor;
    [labelsStackView addArrangedSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *optionsLabel = [self newLabel];
    optionsLabel.font = [UIFont systemFontOfSize:12.0];
    optionsLabel.textColor = [UIColor colorWithRed:110.0/255.0 green:114.0/255.0 blue:122.0/255.0 alpha:1.0];
    [labelsStackView addArrangedSubview:optionsLabel];
    self.optionsLabel = optionsLabel;
    
    UILabel *quantityLabel = [self newLabel];
    quantityLabel.font = [UIFont systemFontOfSize:11.0];
    quantityLabel.textColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
    [labelsStackView addArrangedSubview:quantityLabel];
    self.quantityLabel = quantityLabel;
    
    [self addConstraints];
}

- (UILabel *)newLabel {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 1;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    return label;
}

- (void)addConstraints {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.heightAnchor constraintEqualToConstant:74.0].active = YES;
    [self.imageView.widthAnchor constraintEqualToConstant:50.0].active = YES;
    [self.imageView.heightAnchor constraintEqualToConstant:50.0].active = YES;
    [self.stackView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.stackView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.stackView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
}

@end
