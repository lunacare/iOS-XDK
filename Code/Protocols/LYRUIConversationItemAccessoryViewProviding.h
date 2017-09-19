//
//  LYRUIConversationItemAccessoryViewProviding.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 28.07.2017.
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
#import "LYRUIParticipantsFiltering.h"
@class LYRConversation;
@class LYRIdentity;

NS_ASSUME_NONNULL_BEGIN     // {
@protocol LYRUIConversationItemAccessoryViewProviding <NSObject>

/**
 @abstract An `LYRUIParticipantsFiltering` block which will filter currently logged in user from the accessory view.
 */
@property (nonatomic, strong, nullable) LYRUIParticipantsFiltering participantsFilter;

/**
 @abstract Provides an accessory view representing a conversation.
 @param conversation The `LYRConversation` object.
 @return An `UIView` visually representing the conversation.
 @discussion The view will be added to the `LYRUIConversationItemView` as an accessory view.
 */
- (UIView *)accessoryViewForConversation:(LYRConversation *)conversation;

/**
 @abstract Configures an existing accessory view representing a conversation.
 @param accessoryView The view to update with provided data.
 @param conversation The `LYRConversation` object.
 @discussion This method should be use to update appearance of existing, reused accessory view.
 */
- (void)setupAccessoryView:(UIView *)accessoryView forConversation:(LYRConversation *)conversation;

@end
NS_ASSUME_NONNULL_END       // }
