//
//  LYRUIResponseMessage.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 05.12.2017.
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

#import "LYRUIMessageType.h"

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUIResponseMessage : LYRUIMessageType

@property (nonatomic, copy, readonly, nullable) NSString *responseTo;
@property (nonatomic, copy, readonly, nullable) NSString *responseToNodeId;
@property (nonatomic, copy, readonly, nullable) NSDictionary *participantData;
@property (nonatomic, copy, readonly) NSArray *changes;
@property (nonatomic, copy, readonly) NSString *text;

- (instancetype)initWithResponseTo:(nullable NSString *)responseTo
                  responseToNodeId:(nullable NSString *)responseToNodeId
                   participantData:(nullable NSDictionary *)participantData
                           changes:(NSArray *)changes
                              text:(NSString *)text
                            action:(nullable LYRUIMessageAction *)action
                            sender:(nullable LYRIdentity *)sender
                            sentAt:(nullable NSDate *)sentAt
                            status:(nullable LYRUIMessageTypeStatus *)status;

- (instancetype)initWithResponseTo:(nullable NSString *)responseTo
                  responseToNodeId:(nullable NSString *)responseToNodeId
                   participantData:(nullable NSDictionary *)participantData
                           changes:(NSArray *)changes
                              text:(NSString *)text;

@end
NS_ASSUME_NONNULL_END       // }
