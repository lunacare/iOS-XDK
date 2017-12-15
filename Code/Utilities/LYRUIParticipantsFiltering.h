//
//  LYRUIParticipantsFiltering.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 04.08.2017.
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

#import "LYRUIParticipantsFiltering.h"
@class LYRIdentity;

NS_ASSUME_NONNULL_BEGIN     // {
typedef NSSet<LYRIdentity *> *_Nonnull (^LYRUIParticipantsFiltering)(NSSet<LYRIdentity *> *);

extern LYRUIParticipantsFiltering _Nullable (^LYRUIParticipantsDefaultFilterWithCurrentUser)(LYRIdentity *);

@protocol LYRUIParticipantsFiltering <NSObject>

/**
 @abstract An `LYRUIParticipantsFiltering` block which will filter currently logged in user from the participants set.
 */
@property (nonatomic, strong, nullable) LYRUIParticipantsFiltering participantsFilter;

@end
NS_ASSUME_NONNULL_END       // }
