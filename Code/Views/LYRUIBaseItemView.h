//
//  LYRUIBaseItemView.h
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

#import <UIKit/UIKit.h>
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
@property(nonatomic, weak, readonly) UILabel *messageLabel;
@property(nonatomic, weak, readonly) UILabel *timeLabel;
@property(nonatomic, weak, nullable) UIView *accessoryView;

@end

/**
 @abstract The `LYRUIBaseListView` class provides a lightweight, customizable view for presenting item with title, time, and message.
 */
IB_DESIGNABLE
@interface LYRUIBaseItemView : LYRUIViewWithLayout <LYRUIBaseItemView>

/**
 @abstract The view in which the accessory view will be contained;
 */
@property(nonatomic, weak, readonly) UIView *accessoryViewContainer;

/**
 @abstract The font for the title label displayed in the cell. Default is 16pt system font.
 */
@property (nonatomic, copy) UIFont *titleLabelFont;

/**
 @abstract The text color for the title label displayed in the cell. Default is black.
 */
@property (nonatomic, copy) IBInspectable UIColor *titleLabelColor;

/**
 @abstract The font for the message label displayed in the cell. Default is 14pt system font.
 */
@property (nonatomic, copy) UIFont *messageLabelFont;

/**
 @abstract The text color for the message label displayed in the cell. Default is gray.
 */
@property (nonatomic, copy) IBInspectable UIColor *messageLabelColor;

/**
 @abstract The font for the time label displayed in the cell. Default is 12pt system font.
 */
@property (nonatomic, copy) UIFont *timeLabelFont;

/**
 @abstract The text color for the time label displayed in the cell. Default is gray.
 */
@property (nonatomic, copy) IBInspectable UIColor *timeLabelColor;

/**
 @abstract Layout of the conversation item subviews.
 */
@property (nonatomic, copy, nullable) IBOutlet id<LYRUIBaseItemViewLayout> layout;

/**
 @abstract Initialize with a layout.
 */
- (instancetype)initWithLayout:(id<LYRUIBaseItemViewLayout>)layout;

@end
NS_ASSUME_NONNULL_END
