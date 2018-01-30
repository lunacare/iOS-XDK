//
//  LYRUIConversationItemViewPresenter.h
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
#import "LYRUIConfigurable.h"
#import "LYRUIConversationItemView.h"
#import <LayerKit/LayerKit.h>
@protocol LYRUIConversationItemTitleFormatting;
@protocol LYRUIMessageTextFormatting;
@protocol LYRUITimeFormatting;
@protocol LYRUIConversationItemAccessoryViewProviding;

NS_ASSUME_NONNULL_BEGIN     // {

@interface LYRUIConversationItemViewPresenter : NSObject <LYRUIConfigurable>

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
@property(nonatomic, strong) id<LYRUIMessageTextFormatting> lastMessageFormatter;

/**
 @abstract The object provides formatted date of last message for the conversation item.
 */
@property(nonatomic, strong) id<LYRUITimeFormatting> messageTimeFormatter;

/**
 @abstract Updates the view conforming to `LYRUIConversationItemView` protocol with data from given Conversation.
 @param view The UIView conforming to `LYRUIConversationItemView` protocol to be set up.
 @param conversation The `LYRConversation` object to be presented on conversations list.
 */
- (void)setupConversationItemView:(UIView<LYRUIConversationItemView> *)view
                 withConversation:(LYRConversation *)conversation;

@end
NS_ASSUME_NONNULL_END       // }
