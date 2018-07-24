//
//  LYRUILinkMessage.h
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

#import "LYRUIMessageType.h"

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUILinkMessage : LYRUIMessageType

@property (nonatomic, readonly, nullable) NSString *author;

@property (nonatomic, readonly, nullable) NSString *title;

@property (nonatomic, readonly, nullable) NSString *contentDescription;

@property (nonatomic, readonly, nullable) NSURL *imageURL;

@property (nonatomic, readonly) CGSize imageSize;

@property (nonatomic, readonly, nonnull) NSURL *URL;

- (instancetype)initWithAuthor:(nullable NSString *)author
                         title:(nullable NSString *)title
            contentDescription:(nullable NSString *)contentDescription
                      imageURL:(nullable NSURL *)imageURL
                     imageSize:(CGSize)imageSize
                           URL:(NSURL *)URL
                        action:(nullable LYRUIMessageAction *)action
                        sender:(nullable LYRIdentity *)sender
                        sentAt:(nullable NSDate *)sentAt
                        status:(nullable LYRUIMessageTypeStatus *)status
                   messagePart:(nullable LYRMessagePart *)messagePart;

- (instancetype)initWithURL:(NSURL *)URL;

@end
NS_ASSUME_NONNULL_END       // }
