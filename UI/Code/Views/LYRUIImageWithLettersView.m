//
//  LYRUIImageWithLettersView.m
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

#import "LYRUIImageWithLettersView.h"

@interface LYRUIImageWithLettersView ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *label;

@end

@implementation LYRUIImageWithLettersView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (void)lyr_commonInit {
    [self addImageView];
    [self addLabel];
    
    self.backgroundColor = [UIColor clearColor];
    self.avatarBackgroundColor = [UIColor colorWithRed:219.0/255.0 green:222.0/255.0 blue:228.0/255.0 alpha:1.0];
    self.lettersColor = [UIColor whiteColor];
    
    [self installConstraints];
    [self setNeedsLayout];
}

- (void)addImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];
    self.imageView = imageView;
}

- (void)addLabel {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
}

- (void)installConstraints {
    [self.imageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.imageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.imageView.heightAnchor constraintEqualToAnchor:self.imageView.widthAnchor].active = YES;
    [self.imageView.widthAnchor constraintLessThanOrEqualToAnchor:self.widthAnchor].active = YES;
    [self.imageView.heightAnchor constraintLessThanOrEqualToAnchor:self.heightAnchor].active = YES;
    NSLayoutConstraint *width = [self.imageView.widthAnchor constraintEqualToAnchor:self.widthAnchor];
    NSLayoutConstraint *height = [self.imageView.heightAnchor constraintEqualToAnchor:self.heightAnchor];
    for (NSLayoutConstraint *constraint in @[width, height]) {
        constraint.priority = UILayoutPriorityDefaultHigh;
        constraint.active = YES;
    }
    
    [self.label.centerXAnchor constraintEqualToAnchor:self.imageView.centerXAnchor].active = YES;
    [self.label.centerYAnchor constraintEqualToAnchor:self.imageView.centerYAnchor].active = YES;
}

#pragma mark - Layout updates

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.layer.cornerRadius = round(CGRectGetWidth(self.imageView.frame) / 2.0);
    [self updateFontSize];
}

- (void)updateFontSize {
    CGFloat size = CGRectGetWidth(self.imageView.frame);
    CGFloat fontSize;
    if (size >= 72.0) {
        fontSize = 24.0;
    } else if (size >= 48) {
        fontSize = 18.0;
    } else if (size >= 40) {
        fontSize = 16.0;
    } else {
        fontSize = 14.0;
    }
    NSString *lettersFontName = self.font.fontName;
    UIFont *newLettersFont = [UIFont fontWithName:lettersFontName size:fontSize];
    self.font = newLettersFont;
}

#pragma mark - Properties

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (NSString *)letters {
    return self.label.text;
}

- (void)setLetters:(NSString *)letters {
    self.label.text = letters;
}

- (UIFont *)font {
    return self.label.font;
}

- (void)setFont:(UIFont *)font {
    self.label.font = font;
}

- (UIColor *)lettersColor {
    return self.label.textColor;
}

- (void)setLettersColor:(UIColor *)lettersColor {
    if (lettersColor) {
        self.label.textColor = lettersColor;
    }
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.imageView.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.imageView.layer.borderColor = borderColor.CGColor;
}

- (CGFloat)borderWidth {
    return self.imageView.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.imageView.layer.borderWidth = borderWidth;
}

- (UIColor *)avatarBackgroundColor {
    return self.imageView.backgroundColor;
}

- (void)setAvatarBackgroundColor:(UIColor *)avatarBackgroundColor {
    if (avatarBackgroundColor) {
        self.imageView.backgroundColor = avatarBackgroundColor;
    }
}

@end
