//
//  LYRUITitledMessageContainerView.h
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

#import "LYRUIViewWithLayout.h"
#import "LYRUIMessageViewContainer.h"
@class LYRUITitledMessageContainerView;

@protocol LYRUITitledMessageContainerViewLayout <LYRUIViewLayout>

- (void)addConstraintsInView:(LYRUITitledMessageContainerView *)view;
- (void)removeConstraintsFromView:(LYRUITitledMessageContainerView *)view;
- (void)updateConstraintsInView:(LYRUITitledMessageContainerView *)view;

@end

@protocol LYRUITitledMessageContainerViewTheme <NSObject>

/**
 @abstract The font of the title label. Default is 12pt system font.
 */
@property (nonatomic, copy) UIFont *titleLabelFont;

/**
 @abstract The color of title label text. Default is dark gray.
 */
@property (nonatomic, copy) UIColor *titleLabelTextColor;

@property (nonatomic, copy) UIColor *titleContainerBackgroundColor;

@end

@interface LYRUITitledMessageContainerView : LYRUIViewWithLayout <LYRUIMessageViewContainer, LYRUITitledMessageContainerViewTheme>

@property (nonatomic, weak) UIView *contentViewContainer;

@property (nonatomic, weak) UIView *titleContainer;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIImageView *icon;

/**
 @abstract LYRUITitledMessageContainerViewTheme properties overridden to IBInspectable.
 */
@property (nonatomic, copy) IBInspectable UIColor *titleLabelTextColor;
@property (nonatomic, copy) IBInspectable UIColor *titleContainerBackgroundColor;

/**
 @abstract A set of fonts and colors to use in standard message container. Default is an `LYRUITitledMessageContainerViewDefaultTheme` instance.
 */
@property (nonatomic, strong) id<LYRUITitledMessageContainerViewTheme> theme UI_APPEARANCE_SELECTOR;

/**
 @abstract Layout of the standard message container subviews. Default is an `LYRUITitledMessageContainerViewLayout` instance.
 */
@property (nonatomic, copy) id<LYRUITitledMessageContainerViewLayout> layout;

/**
 @abstract Initialize with a layout.
 */
- (instancetype)initWithLayout:(id<LYRUITitledMessageContainerViewLayout>)layout;

@end
