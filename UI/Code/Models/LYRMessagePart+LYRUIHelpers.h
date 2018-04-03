//
//  LYRMessagePart+LYRUIHelpers.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 03.10.2017.
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

#import <LayerKit/LayerKit.h>

NS_ASSUME_NONNULL_BEGIN     // {

@interface LYRMessagePart (LYRUIHelpers)

/**
 @abstract The content type of the content represented by the receiver.
 */
@property (nonatomic, readonly) NSString *contentType;

/**
 @abstract The attributes of the content represented by the receiver.
 */
@property (nonatomic, readonly) NSDictionary *MIMETypeAttributes;

/**
 @abstract The properties of the message part containing json dictionary.
 */
@property (nonatomic, readonly) NSDictionary *properties;

/**
 @abstract The identifier of message part.
 */
@property (nonatomic, readonly, nullable) NSString *nodeId;

/**
 @abstract The identifier of parent message part.
 */
@property (nonatomic, readonly, nullable) NSString *parentNodeId;

/**
 @abstract The role of message part.
 */
@property (nonatomic, readonly) NSString *role;

/**
 @abstract The messages parts which are child nodes of this part.
 */
@property (nonatomic, readonly) NSArray<LYRMessagePart *> *childParts;

/**
 @abstract The child message part with provided MIME Type.
 @param MIMEType The MIME Type of the child part.
 @returns A child `LYRMessagePart` which has provided `MIMEType`, or nil.
 */
- (LYRMessagePart *)childPartWithMIMEType:(NSString *)MIMEType;

/**
 @abstract The child message part with provided MIME Type.
 @param role The role of the child part.
 @returns A first found child `LYRMessagePart` which has provided `role`, or nil.
 */
- (LYRMessagePart *)childPartWithRole:(NSString *)role;

/**
 @abstract The child message parts with provided MIME Type.
 @param role The role of the child parts.
 @returns All child `LYRMessagePart` objects which have provided `role`, or empty array.
 */
- (NSArray<LYRMessagePart *> *)childPartsWithRole:(NSString *)role;

@end
NS_ASSUME_NONNULL_END       // }
