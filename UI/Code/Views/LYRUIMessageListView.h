//
//  LYRUIMessageListView.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 18.08.2017.
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

#import "LYRUIBaseListView.h"
#import "LYRUIMessageListTypingIndicatorsControlling.h"
#import "LYRUIMessageListActionHandlingDelegate.h"
@class LYRConversation;
@class LYRMessage;
@class LYRIdentity;
@class LYRUIMessageSender;

typedef NS_ENUM(NSUInteger, LYRUITypingIndicatorMode) {
    LYRUITypingIndicatorModeInline = 1 << 0,
    LYRUITypingIndicatorModeText = 1 << 1,
    LYRUITypingIndicatorModeBoth = LYRUITypingIndicatorModeInline | LYRUITypingIndicatorModeText,
};

IB_DESIGNABLE
/**
 @abstract A typed `LYRUIBaseListView`, for presenting `LYRMessage` items.
 */
@interface LYRUIMessageListView : LYRUIBaseListView<LYRMessage *> <LYRUIMessageListActionHandlingDelegate>

/**
 @abstract A `LYRConversation` from which the messages are presented in the list.
 @discussion When this property is set, a `LYRQueryController` for `LYRMessage` objects assigned to provided conversation, sorted by `position` property, and using `pageSize` property.
 @warning Setting this property also updates `queryController` property.
 */
@property (nonatomic, strong) LYRConversation *conversation;

/**
 @abstract Object used for sending messages in the `LYRConversation`.
 @discussion This property is set, when view is set up using `LYRUIConfiguration`.
 */
@property (nonatomic, strong, readonly) LYRUIMessageSender *messageSender;

/**
 @abstract Minimal time interval between two messages to show message time in the list.
 */
@property (nonatomic) NSTimeInterval messageGroupingTimeInterval;

/**
 @abstract Page size used with pagination.
 @discussion This property is used only when list is set up using `setupWithConversation:client:` or `setQueryController:`.
 */
@property (nonatomic) NSUInteger pageSize;

/**
 @abstract Way of presenting typing indicator. Default is LYRUITypingIndicatorModeBoth.
 */
@property (nonatomic) LYRUITypingIndicatorMode typingIndicatorMode;

/**
 @abstract Object controlling presence of typing indicators.
 */
@property (nonatomic, strong) id<LYRUIMessageListTypingIndicatorsControlling> typingIndicatorsController;

/**
 @abstract Delegate used for handling message actions.
 */
@property (nonatomic, weak) id<LYRUIMessageListActionHandlingDelegate> messageActionHandlingDelegate;

/**
 @abstract Scroll the messages list to last message.
 @param animated YES to animate the transition at a constant velocity to the new offset, NO to make the transition immediate.
 */
- (void)scrollToLastMessageAnimated:(BOOL)animated;

/**
 @abstract Registers view controller for presenting previews of message content.
 @param viewController View controller used to push view controllers with preview of messages content.
 @discussion The registered view controller will be used by the default action handlering delegate to present previews.
 */
- (void)registerViewControllerForPreviewing:(UIViewController *)viewController;

@end
