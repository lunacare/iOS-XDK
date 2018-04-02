//
//  LYRUINumberBadgeView.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 20.07.2017.
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

#import "LYRUINumberBadgeView.h"

@interface LYRUINumberBadgeView ()

@property (nonatomic, weak) UILabel *label;

@end

@implementation LYRUINumberBadgeView

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
    [self addLabel];
    [self setupColors];
    [self installConstraints];
}

- (void)addLabel {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 4.0;
    label.layer.borderWidth = 1.0;
    label.font = [UIFont systemFontOfSize:9.0];
    [self addSubview:label];
    self.label = label;
}

- (void)setupColors {
    UIColor *defaultColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
    self.textColor = defaultColor;
    self.borderColor = defaultColor;
    self.backgroundColor = [UIColor clearColor];
}

- (void)installConstraints {
    [self.label.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
    [self.label.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
    [self.label.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.label.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
}

#pragma mark - Properties

- (UIColor *)textColor {
    return self.label.textColor;
}

- (void)setTextColor:(UIColor *)textColor {
    if (textColor == nil) {
        textColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
    }
    self.label.textColor = textColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.label.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor {
    if (borderColor == nil) {
        borderColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
    }
    self.label.layer.borderColor = borderColor.CGColor;
}

- (CGFloat)borderWidth {
    return self.label.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.label.layer.borderWidth = borderWidth;
}

- (CGFloat)cornerRadius {
    return self.label.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.label.layer.cornerRadius = cornerRadius;
}

- (UIFont *)font {
    return self.label.font;
}

- (void)setFont:(UIFont *)font {
    self.label.font = font;
}

- (void)setNumber:(NSUInteger)number {
    _number = number;
    self.label.text = @(number).stringValue;
}

@end
