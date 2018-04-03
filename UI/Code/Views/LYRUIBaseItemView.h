//
//  LYRUIBaseItemView.h
//  Layer-XDK-UI-iOS
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

#import <UIKit/UIKit.h>
#import "LYRUIConfigurable.h"
#import "LYRUIViewLayout.h"
#import "LYRUIViewWithLayout.h"
@class LYRUIBaseItemView;

NS_ASSUME_NONNULL_BEGIN
@protocol LYRUIBaseItemViewLayout <LYRUIViewLayout>
- (void)addConstraintsInView:(LYRUIBaseItemView *)view;
- (void)removeConstraintsFromView:(LYRUIBaseItemView *)view;
- (void)updateConstraintsInView:(LYRUIBaseItemView *)view;
@end

@protocol LYRUIBaseItemView <NSObject>

@property(nonatomic, weak, readonly) UILabel *titleLabel;
@property(nonatomic, weak, readonly) UILabel *subtitleLabel;
@property(nonatomic, weak, readonly) UILabel *detailLabel;
@property(nonatomic, weak, nullable) UIView *accessoryView;

@end

@protocol LYRUIBaseItemViewTheme <NSObject, NSCopying>

/**
 @abstract The font for the title label displayed in the cell. Default is 16pt system font.
 */
@property (nonatomic, strong) UIFont *titleLabelFont;

/**
 @abstract The text color for the title label displayed in the cell. Default is black.
 */
@property (nonatomic, strong) IBInspectable UIColor *titleLabelColor;

/**
 @abstract The font for the subtitle label displayed in the cell. Default is 14pt system font.
 */
@property (nonatomic, strong) UIFont *subtitleLabelFont;

/**
 @abstract The text color for the subtitle label displayed in the cell. Default is gray.
 */
@property (nonatomic, strong) IBInspectable UIColor *subtitleLabelColor;

/**
 @abstract The font for the detail label displayed in the cell. Default is 12pt system font.
 */
@property (nonatomic, strong) UIFont *detailLabelFont;

/**
 @abstract The text color for the detail label displayed in the cell. Default is gray.
 */
@property (nonatomic, strong) IBInspectable UIColor *detailLabelColor;

@end

/**
 @abstract The `LYRUIBaseListView` class provides a lightweight, customizable view for presenting item with title, time, and message.
 */
IB_DESIGNABLE
@interface LYRUIBaseItemView : LYRUIViewWithLayout <LYRUIBaseItemView, LYRUIBaseItemViewTheme, LYRUIConfigurable>

/**
 @abstract The view in which the accessory view will be contained;
 */
@property(nonatomic, weak, readonly) UIView *accessoryViewContainer;

/**
 @abstract LYRUIBaseItemViewTheme properties overridden to IBInspectable.
 */
@property (nonatomic, strong) IBInspectable UIColor *titleLabelColor;
@property (nonatomic, strong) IBInspectable UIColor *subtitleLabelColor;
@property (nonatomic, strong) IBInspectable UIColor *detailLabelColor;

/**
 @abstract A set of fonts and colors to use in item view. Default is LYRUIBaseItemViewDefaultTheme.
 */
@property (nonatomic, copy) id<LYRUIBaseItemViewTheme> theme UI_APPEARANCE_SELECTOR;

/**
 @abstract Layout of the conversation item subviews.
 */
@property (nonatomic, copy, nullable) IBOutlet id<LYRUIBaseItemViewLayout> layout;

@end
NS_ASSUME_NONNULL_END
