//
//  LYRUIConversationItemAccessoryViewProvider.h
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

#import "LYRUIConversationItemAccessoryViewProviding.h"
#import "LYRUIParticipantsFiltering.h"

@interface LYRUIConversationItemAccessoryViewProvider : NSObject <LYRUIConversationItemAccessoryViewProviding>

/**
 @abstract Initializes a new `LYRUIConversationItemAccessoryViewProvider` object with the given participants filter.
 @param participantsFilter An `LYRUIParticipantsFiltering` block which will filter currently logged in user from the accessory view for display. When `nil` is passed, an `LYRUIParticipantsDefaultFilter` will be used. 
 @return An `LYRUIConversationItemAccessoryViewProvider` object.
 */
- (instancetype)initWithParticipantsFilter:(LYRUIParticipantsFiltering)participantsFilter;

@end
