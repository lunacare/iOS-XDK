//
//  LYRUIMessageTypeSerializing.h
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

#import <Foundation/Foundation.h>
@class LYRUIMessageType;
@class LYRMessagePart;
@class LYRMessageOptions;
@class LYRUIMessageTypeSerializersRegistry;
@class LYRClient;

NS_ASSUME_NONNULL_BEGIN     // {
@protocol LYRUIMessageTypeSerializing <NSObject>

/**
 @abstract Deserializes a message type (subclass of `LYRUIMessageType`) with provided `LYRMessagePart`
 @param messagePart Instance of `LYRMessagePart` to deserialize.
 @return An instance of `LYRUIMessageType` subclass.
 */
- (LYRUIMessageType *)typedMessageWithMessagePart:(LYRMessagePart *)messagePart;

/**
 @abstract Serializes provided message type into `LYRMessagePart` object.
 @param messageType Instance of `LYRUIMessageType` to serialize.
 @return An instance of `LYRMessagePart`.
 */
- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUIMessageType *)messageType;

/**
 @abstract Serializes provided message type into `LYRMessagePart` object, with `parentNodeId` and `role` attributes.
 @param messageType Instance of `LYRUIMessageType` to serialize.
 @param parentNodeId Identifier of parent `LYRMessagePart` node.
 @paran role The `role` of serialized `LYRMessagePart`.
 @return An instance of `LYRMessagePart`.
 */
- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUIMessageType *)messageType
                                                    parentNodeId:(nullable NSString *)parentNodeId
                                                            role:(nullable NSString *)role;

/**
 @abstract Returns `LYRMessageOptions` with push notification configuration for provided `LYRUIMessageType`.
 @param messageType Instance of `LYRUIMessageType` to configure push notification with.
 @return An instance of `LYRMessageOptions`.
 */
- (LYRMessageOptions *)messageOptionsForTypedMessage:(LYRUIMessageType *)messageType;

@end
NS_ASSUME_NONNULL_END       // }
