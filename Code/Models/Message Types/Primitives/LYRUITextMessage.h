//
//  LYRUITextMessage.h
//  Layer-UI-iOS
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

@interface LYRUITextMessage : LYRUIMessageType

@property (nonatomic, readonly, nullable) NSString *author;

@property (nonatomic, readonly, nonnull) NSString *text;

@property (nonatomic, readonly, nullable) NSString *textMIMEType;

@property (nonatomic, readonly, nullable) NSString *summary;

@property (nonatomic, readonly, nullable) NSString *title;

@property (nonatomic, readonly, nullable) NSString *subtitle;

- (nonnull instancetype)initWithText:(nonnull NSString *)text;

- (nonnull instancetype)initWithText:(nonnull NSString *)text
                               title:(nonnull NSString *)title;

- (nonnull instancetype)initWithText:(nonnull NSString *)text
                              sender:(nullable LYRIdentity *)sender
                              sentAt:(nullable NSDate *)sentAt
                              status:(nullable LYRUIMessageTypeStatus *)status;

- (nonnull instancetype)initWithAuthor:(nullable NSString *)author
                                  text:(nonnull NSString *)text
                          textMIMEType:(nullable NSString *)textMIMEType
                               summary:(nullable NSString *)summary
                                 title:(nullable NSString *)title
                              subtitle:(nullable NSString *)subtitle
                                action:(nullable LYRUIMessageAction *)action
                                sender:(nullable LYRIdentity *)sender
                                sentAt:(nullable NSDate *)sentAt
                                status:(nullable LYRUIMessageTypeStatus *)status;

@end
