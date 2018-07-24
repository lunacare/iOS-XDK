//
//  LYRUIStandardMessageContainerView.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 12.10.2017.
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

#import "LYRUIStandardMessageContainerView.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIStandardMessageContainerViewDefaultTheme.h"
#import "LYRUIStandardMessageContainerViewLayout.h"

@implementation LYRUIStandardMessageContainerView
@dynamic layout;
@synthesize contentView = _contentView,
            descriptionLabelFont = _descriptionLabelFont,
            titleLabelFont = _titleLabelFont,
            footerLabelFont = _footerLabelFont,
            disclosureIndicatorHidden = _disclosureIndicatorHidden,
            layerConfiguration = _layerConfiguration;

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

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [self init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    
    if (self.theme == nil) {
        self.theme = [layerConfiguration.injector themeForViewClass:[self class]];
    }
    if (self.layout == nil) {
        self.layout = [layerConfiguration.injector layoutForViewClass:[self class]];
    }
}

- (void)lyr_commonInit {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.updateConstraintsOnWidthChange = YES;
    self.updateConstraintsOnHeightChange = YES;
    
    self.metadataContainer = [self addView];
    self.contentViewContainer = [self addView];
    
    self.descriptionLabel = [self addLabelInView:self.metadataContainer];
    self.titleLabel = [self addLabelInView:self.metadataContainer];
    self.footerLabel = [self addLabelInView:self.metadataContainer];
    
    [self addDisclosureIndicator];
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

- (void)addDisclosureIndicator {
    UIImageView *disclosureIndicator = [[UIImageView alloc] init];
    disclosureIndicator.hidden = YES;
    disclosureIndicator.backgroundColor = UIColor.clearColor;
    [self.metadataContainer addSubview:disclosureIndicator];
    self.disclosureIndicator = disclosureIndicator;
    _disclosureIndicatorHidden = YES;
}

#pragma mark - Properties

- (BOOL)disclosureIndicatorHidden {
    return self.disclosureIndicator.hidden;
}

- (void)setDisclosureIndicatorHidden:(BOOL)disclosureIndicatorHidden {
    if (self.disclosureIndicatorHidden == disclosureIndicatorHidden) {
        return;
    }
    self.disclosureIndicator.hidden = disclosureIndicatorHidden;
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (UIFont *)descriptionLabelFont {
    return self.descriptionLabel.font;
}

- (void)setDescriptionLabelFont:(UIFont *)descriptionLabelFont {
    self.descriptionLabel.font = descriptionLabelFont;
}

- (UIColor *)descriptionLabelTextColor {
    return self.descriptionLabel.textColor;
}

- (void)setDescriptionLabelTextColor:(UIColor *)descriptionLabelTextColor {
    self.descriptionLabel.textColor = descriptionLabelTextColor;
}

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

- (UIFont *)footerLabelFont {
    return self.footerLabel.font;
}

- (void)setFooterLabelFont:(UIFont *)footerLabelFont {
    self.footerLabel.font = footerLabelFont;
}

- (UIColor *)footerLabelTextColor {
    return self.footerLabel.textColor;
}

- (void)setFooterLabelTextColor:(UIColor *)footerLabelTextColor {
    self.footerLabel.textColor = footerLabelTextColor;
}

- (UIColor *)metadataContainerBackgroundColor {
    return self.metadataContainer.backgroundColor;
}

- (void)setMetadataContainerBackgroundColor:(UIColor *)metadataContainerBackgroundColor {
    self.metadataContainer.backgroundColor = metadataContainerBackgroundColor;
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

- (void)setTheme:(id<LYRUIStandardMessageContainerViewTheme>)theme {
    _theme = theme;
    self.descriptionLabel.font = theme.descriptionLabelFont;
    self.descriptionLabel.textColor = theme.descriptionLabelTextColor;
    self.titleLabel.font = theme.titleLabelFont;
    self.titleLabel.textColor = theme.titleLabelTextColor;
    self.footerLabel.font = theme.footerLabelFont;
    self.footerLabel.textColor = theme.footerLabelTextColor;
    self.metadataContainerBackgroundColor = theme.metadataContainerBackgroundColor;
}

@end
