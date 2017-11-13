//
//  LYRUIBaseItemView.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 13.07.2017.
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

#import "LYRUIBaseItemView.h"
#import "LYRUIBaseItemViewDefaultTheme.h"

@interface LYRUIBaseItemView ()

@property(nonatomic, weak, readwrite) UIView *accessoryViewContainer;
@property(nonatomic, weak, readwrite) UILabel *titleLabel;
@property(nonatomic, weak, readwrite) UILabel *subtitleLabel;
@property(nonatomic, weak, readwrite) UILabel *detailLabel;

@end

@implementation LYRUIBaseItemView
@synthesize accessoryView = _accessoryView;
@dynamic layout;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (instancetype)initWithLayout:(id<LYRUIBaseItemViewLayout>)layout {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        [self lyr_commonInit];
        self.layout = layout;
    }
    return self;
}

- (void)lyr_commonInit {
    // TODO: update with colors from color palette
    UIColor *blackColor = [UIColor colorWithRed:27.0/255.0 green:28.0/255.0 blue:29.0/255.0 alpha:1.0];
    UIColor *grayColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
    
    self.titleLabel = [self addLabelWithFont:[UIFont systemFontOfSize:16]
                                               textColor:blackColor];
    self.subtitleLabel = [self addLabelWithFont:[UIFont systemFontOfSize:14]
                                         textColor:grayColor];
    self.detailLabel = [self addLabelWithFont:[UIFont systemFontOfSize:12]
                                  textColor:grayColor];
    self.theme = [[LYRUIBaseItemViewDefaultTheme alloc] init];
    
    UIView *accessoryViewContainer = [[UIView alloc] init];
    accessoryViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:accessoryViewContainer];
    self.accessoryViewContainer = accessoryViewContainer;
}

- (UILabel *)addLabelWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [UILabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:label];
    label.font = font;
    label.textColor = textColor;
    return label;
}

#pragma mark - Properties

- (void)setAccessoryView:(UIView *)accessoryView {
    if (self.accessoryView) {
        [self.accessoryView removeFromSuperview];
    }
    if (accessoryView) {
        [self.accessoryViewContainer addSubview:accessoryView];
    }
    _accessoryView = accessoryView;
}

#pragma mark - LYRUIBaseItemViewTheme properties

- (UIFont *)titleLabelFont {
    return self.titleLabel.font;
}

- (void)setTitleLabelFont:(UIFont *)titleLabelFont {
    self.titleLabel.font = titleLabelFont;
}

- (UIColor *)titleLabelColor {
    return self.titleLabel.textColor;
}

- (void)setTitleLabelColor:(UIColor *)titleLabelColor {
    self.titleLabel.textColor = titleLabelColor;
}

- (UIFont *)subtitleLabelFont {
    return self.subtitleLabel.font;
}

- (void)setSubtitleLabelFont:(UIFont *)messageLabelFont {
    self.subtitleLabel.font = messageLabelFont;
}

- (UIColor *)subtitleLabelColor {
    return self.subtitleLabel.textColor;
}

- (void)setSubtitleLabelColor:(UIColor *)messageLabelColor {
    self.subtitleLabel.textColor = messageLabelColor;
}

- (UIFont *)detailLabelFont {
    return self.detailLabel.font;
}

- (void)setDetailLabelFont:(UIFont *)timeLabelFont {
    self.detailLabel.font = timeLabelFont;
}

- (UIColor *)detailLabelColor {
    return self.detailLabel.textColor;
}

- (void)setDetailLabelColor:(UIColor *)timeLabelColor {
    self.detailLabel.textColor = timeLabelColor;
}

- (void)setTheme:(id<LYRUIBaseItemViewTheme>)theme {
    _theme = theme;
    if (theme.titleLabelFont) {
        self.titleLabelFont = theme.titleLabelFont;
    }
    if (theme.titleLabelColor) {
        self.titleLabelColor = theme.titleLabelColor;
    }
    if (theme.subtitleLabelFont) {
        self.subtitleLabelFont = theme.subtitleLabelFont;
    }
    if (theme.subtitleLabelColor) {
        self.subtitleLabelColor = theme.subtitleLabelColor;
    }
    if (theme.detailLabelFont) {
        self.detailLabelFont = theme.detailLabelFont;
    }
    if (theme.detailLabelColor) {
        self.detailLabelColor = theme.detailLabelColor;
    }
}

@end
