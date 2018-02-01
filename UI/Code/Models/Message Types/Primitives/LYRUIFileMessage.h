//
//  LYRUIFileMessage.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 05.10.2017.
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
@interface LYRUIFileMessage : LYRUIMessageType

@property (nonatomic, readonly, nullable) NSString *author;

@property (nonatomic, readonly, nullable) NSString *title;

@property (nonatomic, readonly, nullable) NSString *comment;

@property (nonatomic, readonly, nullable) NSString *fileMIMEType;

@property (nonatomic, readonly) NSUInteger size;

@property (nonatomic, readonly, nullable) NSDate *createdAt;

@property (nonatomic, readonly, nullable) NSDate *updatedAt;

@property (nonatomic, readonly, nullable) NSURL *sourceURL;

@property (nonatomic, readonly, nullable) NSURL *sourceLocalURL;

@property (nonatomic, readonly, nullable) NSData *sourceData;

- (nonnull instancetype)initWithAuthor:(nullable NSString *)author
                                 title:(nullable NSString *)title
                               comment:(nullable NSString *)comment
                          fileMIMEType:(nullable NSString *)fileMIMEType
                                  size:(NSUInteger)size
                             createdAt:(nullable NSDate *)createdAt
                             updatedAt:(nullable NSDate *)updatedAt
                             sourceURL:(nullable NSURL *)sourceURL
                        sourceLocalURL:(nullable NSURL *)sourceLocalURL
                            sourceData:(nullable NSData *)sourceData
                                action:(nullable LYRUIMessageAction *)action
                                sender:(nullable LYRIdentity *)sender
                                sentAt:(nullable NSDate *)sentAt
                                status:(nullable LYRUIMessageTypeStatus *)status;

- (nonnull instancetype)initWithFileMIMEType:(nullable NSString *)fileMIMEType
                              sourceLocalURL:(nullable NSURL *)sourceLocalURL
                                      sender:(nullable LYRIdentity *)sender
                                      sentAt:(nullable NSDate *)sentAt
                                      status:(nullable LYRUIMessageTypeStatus *)status;

@end
NS_ASSUME_NONNULL_END       // }
