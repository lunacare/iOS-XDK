//
//  LYRUILocationMessage.h
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
@class CLLocation;

@interface LYRUILocationMessage : LYRUIMessageType

@property (nonatomic, readonly, nonnull) CLLocation *location;

@property (nonatomic, readonly) NSUInteger zoom;

@property (nonatomic, readonly, nullable) NSString *title;

@property (nonatomic, readonly, nullable) NSString *contentDescription;

@property (nonatomic, readonly, nullable) NSString *street1;

@property (nonatomic, readonly, nullable) NSString *street2;

@property (nonatomic, readonly, nullable) NSString *city;

@property (nonatomic, readonly, nullable) NSString *administrativeArea;

@property (nonatomic, readonly, nullable) NSString *country;

@property (nonatomic, readonly, nullable) NSString *postalCode;

- (nonnull instancetype)initWithLocation:(nonnull CLLocation *)location
                                    zoom:(NSUInteger)zoom
                                   title:(nullable NSString *)title
                      contentDescription:(nullable NSString *)contentDescription
                                 street1:(nullable NSString *)street1
                                 street2:(nullable NSString *)street2
                                    city:(nullable NSString *)city
                      administrativeArea:(nullable NSString *)administrativeArea
                                 country:(nullable NSString *)country
                              postalCode:(nullable NSString *)postalCode
                                  action:(nullable LYRUIMessageAction *)action
                                  sender:(nullable LYRIdentity *)sender
                                  sentAt:(nullable NSDate *)sentAt
                                  status:(nullable LYRUIMessageTypeStatus *)status;

- (nonnull instancetype)initWithLocation:(nonnull CLLocation *)location
                                  sender:(nullable LYRIdentity *)sender
                                  sentAt:(nullable NSDate *)sentAt
                                  status:(nullable LYRUIMessageTypeStatus *)status;

- (nonnull instancetype)initWithLocation:(nonnull CLLocation *)location;

@end
