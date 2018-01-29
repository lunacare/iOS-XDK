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
@class LYRConversation;
@class LYRMessage;
@class LYRIdentity;

IB_DESIGNABLE
/**
 @abstract A typed `LYRUIBaseListView`, for presenting `LYRConversation` items.
 */
@interface LYRUIMessageListView : LYRUIBaseListView<LYRMessage *>

/**
 @abstract A `LYRConversation` from which the messages are presented in the list.
 @discussion This property is set when list is set up using `setupWithConversation:client:` or `setQueryController:`.
 */
@property (nonatomic, weak, readonly) LYRConversation *conversation;

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
 @abstract Method used to configure messages list with a `LYRConversation`.
 @discussion This methods creates a `LYRQueryController` for `LYRMessage` objects assigned to provided conversation, sorted by `position` property, and using `pageSize` property.
 @param conversation A `LYRConversation` to present messages from.
 */
- (void)setupWithConversation:(LYRConversation *)conversation;

/**
 @abstract Scroll the messages list to last message.
 @param animated YES to animate the transition at a constant velocity to the new offset, NO to make the transition immediate.
 */
- (void)scrollToLastMessageAnimated:(BOOL)animated;

@end
