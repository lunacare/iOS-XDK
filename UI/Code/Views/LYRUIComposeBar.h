//
//  LYRUIComposeBar.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 10.08.2017.
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
#import "LYRUIViewWithLayout.h"
#import "LYRUIConfigurable.h"
@class LYRUIComposeBar;
@class LYRUISendButton;
@class LYRConversation;

NS_ASSUME_NONNULL_BEGIN     // {
@protocol LYRUIComposeBarLayout <LYRUIViewLayout>

- (void)addConstraintsInView:(LYRUIComposeBar *)view;

- (void)removeConstraintsFromView:(LYRUIComposeBar *)view;

- (void)updateConstraintsInView:(LYRUIComposeBar *)view;

@end

@protocol LYRUIComposeBarTheme <NSObject>

/**
 @abstract The color of message input. Default is white.
 */
@property (nonatomic, copy) UIColor *messageInputColor;

/**
 @abstract The color of message input border. Default is gray.
 */
@property (nonatomic, copy) UIColor *messageInputBorderColor;

/**
 @abstract The font of the message text. Default is 14pt system font.
 */
@property (nonatomic, copy) UIFont *textFont;

/**
 @abstract The text color of the message. Default is gray.
 */
@property (nonatomic, copy) UIColor *textColor;

/**
 @abstract The text color of placeholder. Default is light gray.
 */
@property (nonatomic, copy) UIColor *placeholderColor;

@end

IB_DESIGNABLE
/**
 @abstract A view used for getting user inputs in conversation view.
 */
@interface LYRUIComposeBar : LYRUIViewWithLayout <LYRUIComposeBarTheme, LYRUIConfigurable>

/**
 @abstract Array of views added on the left side of the input message input.
 */
@property (nonatomic, copy, nullable) IBOutletCollection(UIView) NSArray<UIView *> *leftItems;

/**
 @abstract Array of views added on the right side of the input message input. Default is an array with `sendButton`.
 */
@property (nonatomic, copy, nullable) IBOutletCollection(UIView) NSArray<UIView *> *rightItems;

/**
 @abstract Conversation in which the compose bar is used, and will send typing indicator updates.
 */
@property (nonatomic, strong) LYRConversation *conversation;

/**
 @abstract Placeholder text to present when input message is empty.
 */
@property (nonatomic, copy, nullable) IBInspectable NSString *placeholder;

/**
 @abstract Message input text.
 */
@property (nonatomic, copy, nullable) IBInspectable NSString *text;

/**
 @abstract Attributed message input text.
 */
@property (nonatomic, copy, nullable) NSAttributedString *attributedText;

/**
 @abstract A text view for editting the message input text.
 */
@property (nonatomic, weak, readonly) UITextView *inputTextView;

/**
 @abstract Default send button, added as a right item to the compose bar during initialization.
 */
@property (nonatomic, strong, readonly) LYRUISendButton *sendButton;

/**
 @abstract Action block called on `sendButton` touch up inside event.
 @param attributedText The `inputTextView` attributed text.
 */
@property (nonatomic, copy) void(^sendPressedBlock)(NSAttributedString *attributedText);

/**
 @abstract Corner radius of the message input. Default value is 8.0 pt.
 */
@property (nonatomic) IBInspectable CGFloat messageInputCornerRadius;

/**
 @abstract LYRUIComposeBarTheme properties overridden to IBInspectable.
 */
@property (nonatomic, copy) IBInspectable UIColor *messageInputColor;
@property (nonatomic, copy) IBInspectable UIColor *messageInputBorderColor;
@property (nonatomic, copy) IBInspectable UIColor *textColor;
@property (nonatomic, copy) IBInspectable UIColor *placeholderColor;

/**
 @abstract A set of fonts and colors to use in compose bar.
 */
@property (nonatomic, strong) id<LYRUIComposeBarTheme> theme UI_APPEARANCE_SELECTOR;

/**
 @abstract Layout of the compose bar subviews.
 */
@property (nonatomic, copy) IBOutlet id<LYRUIComposeBarLayout> layout;

@end
NS_ASSUME_NONNULL_END       // }
