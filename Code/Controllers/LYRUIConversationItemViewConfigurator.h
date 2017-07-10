//
//  LYRUIConversationItemViewConfigurator.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 05.07.2017.
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

#import <Foundation/Foundation.h>
#import "LYRUIConversationItemView.h"
#import <LayerKit/LayerKit.h>
@protocol LYRUIConversationItemTitleFormatting;
@protocol LYRUIMessageTimeFormatting;

NS_ASSUME_NONNULL_BEGIN
@protocol LYRUIConversationItemAccessoryViewProviding <NSObject>

/**
 @abstract Provides an accessory view representing a conversation.
 @param conversation The `LYRConversation` object.
 @return An `UIView` visually representing the conversation.
 @discussion The view will be added to the `LYRUIConversationItemView` as an accessory view.
 */
- (UIView *)accessoryViewForConversation:(LYRConversation *)conversation;

@end

@protocol LYRUIConversationItemLastMessageFormatting <NSObject>

/**
 @abstract Provides a description string to display for a given message.
 @param message The `LYRMessage` object.
 @return The string to be displayed as the summary for a given message in the conversation list.
 */
- (NSString *)stringForConversationLastMessage:(LYRMessage *)message;

@end

@interface LYRUIConversationItemViewConfigurator : NSObject

/**
 @abstract The object provides an accessory view for conversation item.
 */
@property(nonatomic, strong) id<LYRUIConversationItemAccessoryViewProviding> accessoryViewProvider;

/**
 @abstract The object provides a title for the conversation item.
 */
@property(nonatomic, strong) id<LYRUIConversationItemTitleFormatting> titleFormatter;

/**
 @abstract The object provides summary of last message for the conversation item.
 */
@property(nonatomic, strong) id<LYRUIConversationItemLastMessageFormatting> lastMessageFormatter;

/**
 @abstract The object provides formatted date of last message for the conversation item.
 */
@property(nonatomic, strong) id<LYRUIMessageTimeFormatting> messageTimeFormatter;

/**
 @abstract Initializes a new `LYRUIConversationItemViewConfigurator` object with the given accessory view provider and formatters.
 @param accessoryViewProvider The object conforming to `LYRUIConversationItemAccessoryViewProviding` protocol from which to retrieve the accessory view for display.
 @param titleFormatter The object conforming to `LYRUIConversationItemTitleFormatting` protocol from which to retrieve the conversation title for display.
 @param lastMessageFormatter The object conforming to `LYRUIConversationItemLastMessageFormatting` protocol from which to retrieve the conversation's last message summary for display.
 @param messageTimeFormatter The object conforming to `LYRUIMessageTimeFormatting` protocol from which to retrieve the conversation's last message time for display.
 @return An `LYRUIConversationItemViewConfigurator` object.
 */
- (instancetype)initWithAccessoryViewProvider:(nullable id<LYRUIConversationItemAccessoryViewProviding>)accessoryViewProvider
                               titleFormatter:(nullable id<LYRUIConversationItemTitleFormatting>)titleFormatter
                         lastMessageFormatter:(nullable id<LYRUIConversationItemLastMessageFormatting>)lastMessageFormatter
                         messageTimeFormatter:(nullable id<LYRUIMessageTimeFormatting>)messageTimeFormatter NS_DESIGNATED_INITIALIZER;

/**
 @abstract Updates the view conforming to `LYRUIConversationItemView` protocol with data from given Conversation.
 @param view The UIView conforming to `LYRUIConversationItemView` protocol to be set up.
 @param conversation The `LYRConversation` object to be presented on conversations list.
 */
- (void)setupConversationItemView:(UIView<LYRUIConversationItemView> *)view
                 withConversation:(LYRConversation *)conversation;

@end
NS_ASSUME_NONNULL_END
