//
//  LYRUIConversationItemTitleFormatting.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 06.07.2017.
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
@protocol LYRUIConversationItemTitleFormatting <NSObject>

/**
 @abstract Provides a title string to display for a given conversation.
 @param conversation The `LYRConversation` object.
 @return The string to be displayed as the title for a given conversation in the conversation list.
 */
- (NSString *)titleForConversation:(LYRConversation *)conversation;

@end
NS_ASSUME_NONNULL_END       // }
