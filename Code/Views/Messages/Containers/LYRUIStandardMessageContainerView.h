//
//  LYRUIStandardMessageContainerView.h
//  Layer-UI-iOS
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

#import "LYRUIViewWithLayout.h"
#import "LYRUIConfigurable.h"
#import "LYRUIMessageViewContainer.h"
@class LYRUIStandardMessageContainerView;

@protocol LYRUIStandardMessageContainerViewLayout <LYRUIViewLayout>

- (void)addConstraintsInView:(LYRUIStandardMessageContainerView *)view;
- (void)removeConstraintsFromView:(LYRUIStandardMessageContainerView *)view;
- (void)updateConstraintsInView:(LYRUIStandardMessageContainerView *)view;

@end

@protocol LYRUIStandardMessageContainerViewTheme <NSObject>

/**
 @abstract The font of the description label. Default is 14pt system font.
 */
@property (nonatomic, copy) UIFont *descriptionLabelFont;

/**
 @abstract The color of description label text. Default is black.
 */
@property (nonatomic, copy) UIColor *descriptionLabelTextColor;

/**
 @abstract The font of the title label. Default is 12pt system font.
 */
@property (nonatomic, copy) UIFont *titleLabelFont;

/**
 @abstract The color of title label text. Default is dark gray.
 */
@property (nonatomic, copy) UIColor *titleLabelTextColor;

/**
 @abstract The font of the footer label. Default is 11pt system font.
 */
@property (nonatomic, copy) UIFont *footerLabelFont;

/**
 @abstract The color of footer label text. Default is light gray.
 */
@property (nonatomic, copy) UIColor *footerLabelTextColor;

@property (nonatomic, copy) UIColor *metadataContainerBackgroundColor;

@end

@interface LYRUIStandardMessageContainerView : LYRUIViewWithLayout <LYRUIMessageViewContainer, LYRUIStandardMessageContainerViewTheme, LYRUIConfigurable>

@property (nonatomic, weak) UIView *contentViewContainer;

@property (nonatomic, weak) UIView *metadataContainer;

@property (nonatomic, weak) UILabel *descriptionLabel;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *footerLabel;

@property (nonatomic, weak) UIImageView *disclosureIndicator;

@property (nonatomic) BOOL disclosureIndicatorHidden;

/**
 @abstract LYRUIStandardMessageContainerViewTheme properties overridden to IBInspectable.
 */
@property (nonatomic, copy) IBInspectable UIColor *descriptionLabelTextColor;
@property (nonatomic, copy) IBInspectable UIColor *titleLabelTextColor;
@property (nonatomic, copy) IBInspectable UIColor *footerLabelTextColor;
@property (nonatomic, copy) IBInspectable UIColor *metadataContainerBackgroundColor;

/**
 @abstract A set of fonts and colors to use in standard message container. Default is an `LYRUIStandardMessageContainerViewDefaultTheme` instance.
 */
@property (nonatomic, strong) id<LYRUIStandardMessageContainerViewTheme> theme UI_APPEARANCE_SELECTOR;

/**
 @abstract Layout of the standard message container subviews. Default is an `LYRUIStandardMessageContainerViewLayout` instance.
 */
@property (nonatomic, copy) id<LYRUIStandardMessageContainerViewLayout> layout;

@end
