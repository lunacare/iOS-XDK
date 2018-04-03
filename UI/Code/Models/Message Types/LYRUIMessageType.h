//
//  LYRUIMessageType.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 04.10.2017.
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
#import "LYRUIMessageMetadata.h"
#import "LYRUIMessageAction.h"
#import "LYRUIMessageTypeStatus.h"
#import "LYRUIORSet.h"
@class LYRIdentity;

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUIMessageType : NSObject

@property (nonatomic, readonly, class) NSString *MIMEType;

@property (nonatomic, readonly, nullable) LYRIdentity *sender;

@property (nonatomic, readonly) NSDate *sentAt;

@property (nonatomic, readonly, nullable) LYRUIMessageTypeStatus *status;

@property (nonatomic, readonly) NSString *summary;

@property (nonatomic, readonly) NSString *MIMEType;

@property (nonatomic, weak, readonly, nullable) LYRUIMessageType *parentMessage;

@property (nonatomic, readonly, nullable) LYRUIMessageMetadata *metadata;

@property (nonatomic, readonly, nullable) LYRUIMessageAction *action;

@property (nonatomic, readonly, nullable) LYRUIORSet *initialResponseState;

- (instancetype)initWithAction:(nullable LYRUIMessageAction *)action
                        sender:(nullable LYRIdentity *)sender
                        sentAt:(nullable NSDate *)sentAt
                        status:(nullable LYRUIMessageTypeStatus *)status;

- (instancetype)initWithInitialResponseState:(nullable LYRUIORSet *)initialResponseState
                                      action:(nullable LYRUIMessageAction *)action
                                      sender:(nullable LYRIdentity *)sender
                                      sentAt:(nullable NSDate *)sentAt
                                      status:(nullable LYRUIMessageTypeStatus *)status;

@end
NS_ASSUME_NONNULL_END       // }
