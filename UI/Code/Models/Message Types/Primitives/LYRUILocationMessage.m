//
//  LYRUILocationMessage.m
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

#import "LYRUILocationMessage.h"

@interface LYRUILocationMessage ()

@property (nonatomic, readwrite) CLLocation *location;
@property (nonatomic, readwrite) NSUInteger zoom;
@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) NSString *contentDescription;
@property (nonatomic, readwrite) NSDate *createdAt;
@property (nonatomic, readwrite) NSString *street1;
@property (nonatomic, readwrite) NSString *street2;
@property (nonatomic, readwrite) NSString *city;
@property (nonatomic, readwrite) NSString *administrativeArea;
@property (nonatomic, readwrite) NSString *country;
@property (nonatomic, readwrite) NSString *postalCode;

@end

@implementation LYRUILocationMessage

- (instancetype)initWithLocation:(CLLocation *)location
                            zoom:(NSUInteger)zoom
                           title:(NSString *)title
              contentDescription:(NSString *)contentDescription
                         street1:(NSString *)street1
                         street2:(NSString *)street2
                            city:(NSString *)city
              administrativeArea:(NSString *)administrativeArea
                         country:(NSString *)country
                      postalCode:(NSString *)postalCode
                          action:(LYRUIMessageAction *)action
                          sender:(LYRIdentity *)sender
                          sentAt:(NSDate *)sentAt
                          status:(LYRUIMessageTypeStatus *)status {
    if (action == nil) {
        action = [[LYRUIMessageAction alloc] initWithLocation:location];
    }
    self = [super initWithAction:action
                          sender:sender
                          sentAt:sentAt
                          status:status];
    if (self) {
        self.location = location;
        self.zoom = zoom;
        self.title = title;
        self.contentDescription = contentDescription;
        self.street1 = street1;
        self.street2 = street2;
        self.city = city;
        self.administrativeArea = administrativeArea;
        self.country = country;
        self.postalCode = postalCode;
    }
    return self;
}

- (nonnull instancetype)initWithLocation:(nonnull CLLocation *)location
                                  sender:(nullable LYRIdentity *)sender
                                  sentAt:(nullable NSDate *)sentAt
                                  status:(LYRUIMessageTypeStatus *)status {
    self = [self initWithLocation:location
                             zoom:17
                            title:nil
               contentDescription:nil
                          street1:nil
                          street2:nil
                             city:nil
               administrativeArea:nil
                          country:nil
                       postalCode:nil
                           action:nil
                           sender:sender
                           sentAt:sentAt
                           status:status];
    return self;
}

- (nonnull instancetype)initWithLocation:(nonnull CLLocation *)location {
    self = [self initWithLocation:location
                           sender:nil
                           sentAt:nil
                           status:nil];
    return self;
}

- (LYRUIMessageMetadata *)metadata {
    LYRUIMessageMetadata *metadata;
    if (self.title.length > 0 || self.contentDescription.length > 0) {
        metadata = [[LYRUIMessageMetadata alloc] initWithDescription:self.contentDescription
                                                               title:self.title
                                                              footer:nil];
    }
    return metadata;
}

+ (NSString *)MIMEType {
    return @"application/vnd.layer.location+json";
}

- (NSString *)summary {
    return self.title ?: @"Location";
}

@end
