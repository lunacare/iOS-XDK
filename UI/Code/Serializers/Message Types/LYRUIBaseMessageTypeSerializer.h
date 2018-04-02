//
//  LYRUIBaseMessageTypeSerializer.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 06.10.2017.
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

#import "LYRUIMessageTypeSerializing.h"
#import "LYRUIConfigurable.h"
#import "LYRUIIdentityNameFormatting.h"
#import "LYRUIMessageAction.h"
#import "LYRUIMessageTypeStatus.h"
@class LYRClient;
@class LYRMessageOptions;
@class LYRUIMessageActionSerializer;

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUIBaseMessageTypeSerializer<MessageType: LYRUIMessageType *> : NSObject <LYRUIMessageTypeSerializing, LYRUIConfigurable>

@property (nonatomic, strong, readonly) LYRUIMessageActionSerializer *actionSerializer;

- (MessageType)typedMessageWithMessagePart:(LYRMessagePart *)messagePart;
- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(MessageType)message;
- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(MessageType)messageType
                                                    parentNodeId:(nullable NSString *)parentNodeId
                                                            role:(nullable NSString *)role;
- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(MessageType)messageType
                                                    parentNodeId:(nullable NSString *)parentNodeId
                                                            role:(nullable NSString *)role
                                              MIMETypeAttributes:(nullable NSDictionary *)MIMETypeAttributes;
- (LYRMessageOptions *)messageOptionsForTypedMessage:(MessageType)message;

- (LYRUIMessageTypeStatus *)statusWithMessage:(LYRMessage *)message;

- (NSURL *)URLWithString:(NSString *)URLString;

- (NSURL *)localFileURLForFileMessagePart:(LYRMessagePart *)messagePart withMIMEType:(NSString *)MIMEType;

- (NSString *)MIMETypeForContentType:(NSString *)contentType
                        parentNodeId:(NSString *)parentNodeId
                                role:(NSString *)role
                          attributes:(NSDictionary *)attributes;

- (LYRMessageOptions *)defaultMessageOptionsWithMessageText:(NSString *)messageText;
- (LYRMessageOptions *)defaultMessageOptionsWithPushNotificationText:(NSString *)notificationText;

@end
NS_ASSUME_NONNULL_END       // }
