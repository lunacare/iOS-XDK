//
//  LYRUITitledMessageContainerView.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 27.11.2017.
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

#import "LYRUITitledMessageContainerView.h"
#import "LYRUITitledMessageContainerViewDefaultTheme.h"
#import "LYRUITitledMessageContainerViewLayout.h"

@implementation LYRUITitledMessageContainerView
@dynamic layout;
@synthesize contentView = _contentView,
            titleLabelFont = _titleLabelFont;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame layout:nil];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                       layout:(id<LYRUITitledMessageContainerViewLayout>)layout {
    self = [super initWithFrame:frame];
    if (self) {
        [self lyr_commonInitWithLayout:layout];
    }
    return self;
}

- (instancetype)initWithLayout:(id<LYRUITitledMessageContainerViewLayout>)layout {
    self = [self initWithFrame:CGRectZero layout:layout];
    return self;
}

- (void)lyr_commonInit {
    [self lyr_commonInitWithLayout:nil];
}

- (void)lyr_commonInitWithLayout:(id<LYRUITitledMessageContainerViewLayout>)layout {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.titleContainer = [self addView];
    self.contentViewContainer = [self addView];
    
    self.titleLabel = [self addLabelInView:self.titleContainer];
    
    [self addIcon];
    
    self.theme = [[LYRUITitledMessageContainerViewDefaultTheme alloc] init];
    if (layout == nil) {
        layout = [[LYRUITitledMessageContainerViewLayout alloc] init];
    }
    self.layout = layout;
}

- (UIView *)addView {
    UIView *view = [[UIView alloc] init];
    view.clipsToBounds = YES;
    [self addSubview:view];
    return view;
}

- (UILabel *)addLabelInView:(UIView *)view {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    [view addSubview:label];
    return label;
}

- (void)addIcon {
    UIImageView *icon = [[UIImageView alloc] init];
    icon.hidden = YES;
    icon.backgroundColor = UIColor.clearColor;
    [self.titleContainer addSubview:icon];
    self.icon = icon;
}

#pragma mark - Properties

- (UIFont *)titleLabelFont {
    return self.titleLabel.font;
}

- (void)setTitleLabelFont:(UIFont *)titleLabelFont {
    self.titleLabel.font = titleLabelFont;
}

- (UIColor *)titleLabelTextColor {
    return self.titleLabel.textColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor {
    self.titleLabel.textColor = titleLabelTextColor;
}

- (UIColor *)titleContainerBackgroundColor {
    return self.titleContainer.backgroundColor;
}

- (void)setTitleContainerBackgroundColor:(UIColor *)titleContainerBackgroundColor {
    self.titleContainer.backgroundColor = titleContainerBackgroundColor;
}

- (void)setContentView:(UIView *)contentView {
    if (self.contentView != nil) {
        [self.contentView removeFromSuperview];
    }
    if (contentView != nil) {
        [self.contentViewContainer addSubview:contentView];
        contentView.backgroundColor = self.contentViewContainer.backgroundColor;
    }
    _contentView = contentView;
    [self setNeedsUpdateConstraints];
}

- (void)setTheme:(id<LYRUITitledMessageContainerViewTheme>)theme {
    _theme = theme;
    self.titleLabel.font = theme.titleLabelFont;
    self.titleLabel.textColor = theme.titleLabelTextColor;
    self.titleContainerBackgroundColor = theme.titleContainerBackgroundColor;
}

@end
