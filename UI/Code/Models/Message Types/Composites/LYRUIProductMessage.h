//
//  LYRUIProductMessage.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 21.12.2017.
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
@class LYRUIChoiceMessage;

@interface LYRUIProductMessage : LYRUIMessageType

@property (nonatomic, readonly, nullable) NSString *brand;
@property (nonatomic, readonly, nullable) NSString *name;
@property (nonatomic, readonly, nullable) NSString *productDescription;
@property (nonatomic, readonly, nullable) NSArray<NSURL *> *imageURLs;
@property (nonatomic, readonly) double price;
@property (nonatomic, readonly) NSUInteger quantity;
@property (nonatomic, readonly, nullable) NSString *currency;
@property (nonatomic, readonly, nullable) NSArray<LYRUIChoiceMessage *> *options;

- (nonnull instancetype)initWithBrand:(nullable NSString *)brand
                                 name:(nullable NSString *)name
                   productDescription:(nullable NSString *)productDescription
                            imageURLs:(nullable NSArray<NSURL *> *)imageURLs
                                price:(double)price
                             quantity:(NSUInteger)quantity
                             currency:(nullable NSString *)currency
                              options:(nullable NSArray<LYRUIChoiceMessage *> *)options
                               action:(nullable LYRUIMessageAction *)action
                               sender:(nullable LYRIdentity *)sender
                               sentAt:(nullable NSDate *)sentAt
                               status:(nullable LYRUIMessageTypeStatus *)status;

@end
