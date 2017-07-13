//
//  LYRUIConversationItemTitleFormatter.h
//  Layer-UI-iOS
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

#import "LYRUIConversationItemTitleFormatting.h"
#import "LYRUIParticipantsFiltering.h"
#import "LYRUIIdentityNameFormatting.h"

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUIConversationItemTitleFormatter : NSObject <LYRUIConversationItemTitleFormatting>

/**
 @abstract Initializes a new `LYRUIConversationItemTitleFormatter` object with the given participants filter.
 @param participantsFilter An `LYRUIParticipantsFiltering` block which will filter currently logged in user from the conversation title.
 @return An `LYRUIConversationItemTitleFormatter` object.
 */
- (instancetype)initWithParticipantsFilter:(nullable LYRUIParticipantsFiltering)participantsFilter;

/**
 @abstract Initializes new `LYRUIConversationItemTitleFormatter` object with participants filter and name formatter.
 @param participantsFilter An `LYRUIParticipantsFiltering` block which will filter currently logged in user from  the conversation title.
 @param nameFormatter An object conforming to `LYRUIIdentityNameFormatting` protocol, used to format full name of participant in 1 on 1 conversations. Default value is an `LYRUIIdentityNameFormatter` instance.
 */
- (instancetype)initWithParticipantsFilter:(nullable LYRUIParticipantsFiltering)participantsFilter
                                     nameFormatter:(nullable id <LYRUIIdentityNameFormatting>)nameFormatter;

@end
NS_ASSUME_NONNULL_END       // }
