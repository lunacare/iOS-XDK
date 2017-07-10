//
//  LYRUIConversationItemView.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 04.07.2017.
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
@class LYRUIConversationItemView;

NS_ASSUME_NONNULL_BEGIN
@protocol LYRUIConversationItemViewLayout <LYRUIViewLayout>
- (void)addConstraintsInView:(LYRUIConversationItemView *)view;
- (void)removeConstraintsFromView:(LYRUIConversationItemView *)view;
- (void)updateConstraintsInView:(LYRUIConversationItemView *)view;
@end

@protocol LYRUIConversationItemView <NSObject>

@property(nonatomic, weak) UILabel *conversationTitleLabel;
@property(nonatomic, weak) UILabel *lastMessageLabel;
@property(nonatomic, weak) UILabel *dateLabel;
@property(nonatomic, weak, nullable) UIView *accessoryView;

@end

/**
 @abstract The `LYRUIConversationItemView` class provides a lightweight, customizable view for presenting Layer conversation objects.
 */
IB_DESIGNABLE
@interface LYRUIConversationItemView : LYRUIViewWithLayout <LYRUIConversationItemView>

/**
 @abstract The font for the conversation label displayed in the cell. Default is 16pt system font.
 */
@property (nonatomic, copy) UIFont *conversationTitleLabelFont;

/**
 @abstract The text color for the conversation label displayed in the cell. Default is black.
 */
@property (nonatomic, copy) IBInspectable UIColor *conversationTitleLabelColor;

/**
 @abstract The font for the last message label displayed in the cell. Default is 14pt system font.
 */
@property (nonatomic, copy) UIFont *lastMessageLabelFont;

/**
 @abstract The text color for the last message label displayed in the cell. Default is gray.
 */
@property (nonatomic, copy) IBInspectable UIColor *lastMessageLabelColor;

/**
 @abstract The font for the date label displayed in the cell. Default is 12pt system font.
 */
@property (nonatomic, copy) UIFont *dateLabelFont;

/**
 @abstract The text color for the date label displayed in the cell. Default is gray.
 */
@property (nonatomic, copy) IBInspectable UIColor *dateLabelColor;

/**
 @abstract Layout of the conversation item subviews.
 */
@property (nonatomic, copy, nullable) IBOutlet id<LYRUIConversationItemViewLayout> layout;

/**
 @abstract Initialize with a layout.
 */
- (instancetype)initWithLayout:(id<LYRUIConversationItemViewLayout>)layout;

@end
NS_ASSUME_NONNULL_END
