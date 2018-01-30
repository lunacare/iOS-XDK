//
//  LYRUIMessageAttributesManager.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 30.01.2018.
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
@class LYRMessage;
@class LYRMessagePart;

extern NSString *const LYRUIMessagePartRoleRoot;

@interface LYRUIMessageAttributesManager : NSObject

- (LYRMessagePart *)messageRootPart:(LYRMessage *)message;
- (NSDictionary *)messageProperties:(LYRMessage *)message;
- (NSArray<LYRMessagePart *> *)message:(LYRMessage *)message childMessagePartsOfPart:(LYRMessagePart *)messagePart;
- (NSString *)messagePartContentType:(LYRMessagePart *)messagePart;
- (NSDictionary *)messagePartMIMETypeAttributes:(LYRMessagePart *)messagePart;
- (NSString *)messagePartNodeId:(LYRMessagePart *)messagePart;
- (NSString *)messagePartParentNodeId:(LYRMessagePart *)messagePart;
- (NSString *)messagePartRole:(LYRMessagePart *)messagePart;
- (NSArray<LYRMessagePart *> *)messagePartChildParts:(LYRMessagePart *)messagePart;
- (LYRMessagePart *)messagePart:(LYRMessagePart *)messagePart childPartWithMIMEType:(NSString *)MIMEType;
- (LYRMessagePart *)messagePart:(LYRMessagePart *)messagePart childPartWithRole:(NSString *)role;
- (NSArray<LYRMessagePart *> *)messagePart:(LYRMessagePart *)messagePart childPartsWithRole:(NSString *)role;
- (NSDictionary *)messagePartProperties:(LYRMessagePart *)messagePart;

@end
