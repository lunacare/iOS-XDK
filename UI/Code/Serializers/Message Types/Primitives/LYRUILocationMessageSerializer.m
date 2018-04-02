//
//  LYRUILocationMessageSerializer.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 10.10.2017.
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

#import "LYRUILocationMessageSerializer.h"
#import <CoreLocation/CoreLocation.h>
#import <LayerKit/LayerKit.h>
#import "LYRMessage+LYRUIHelpers.h"
#import "LYRMessagePart+LYRUIHelpers.h"
#import "LYRUIMessageActionSerializer.h"

@interface LYRUILocationMessageSerializer ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation LYRUILocationMessageSerializer

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        self.dateFormatter = dateFormatter;
    }
    return self;
}

- (LYRUILocationMessage *)typedMessageWithMessagePart:(LYRMessagePart *)messagePart {
    if ([messagePart.MIMEType isEqualToString:@"location/coordinate"]) {
        NSError *error = nil;
        NSDictionary *locationDict = [NSJSONSerialization JSONObjectWithData:messagePart.data
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:&error];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[locationDict[@"lat"] doubleValue]
                                                          longitude:[locationDict[@"lon"] doubleValue]];
        return [[LYRUILocationMessage alloc] initWithLocation:location
                                                       sender:messagePart.message.sender
                                                       sentAt:messagePart.message.sentAt
                                                       status:[self statusWithMessage:messagePart.message]];
    }
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([messagePart.properties[@"latitude"] doubleValue],
                                                                   [messagePart.properties[@"longitude"] doubleValue]);
    NSDate *timestamp;
    if (messagePart.properties[@"created_at"] != nil) {
        timestamp = [self.dateFormatter dateFromString:messagePart.properties[@"created_at"]];
    }
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:coordinate
                                                         altitude:[messagePart.properties[@"altitude"] doubleValue]
                                               horizontalAccuracy:[messagePart.properties[@"accuracy"] doubleValue]
                                                 verticalAccuracy:[messagePart.properties[@"accuracy"] doubleValue]
                                                        timestamp:timestamp];
    NSUInteger zoom = (messagePart.properties[@"zoom"] != nil) ? [messagePart.properties[@"zoom"] unsignedIntegerValue] : 17;
    LYRUIMessageAction *action = [self.actionSerializer actionFromProperties:messagePart.properties
                                                            withDefaultEvent:@"open-map"];
    return [[LYRUILocationMessage alloc] initWithLocation:location
                                                     zoom:zoom
                                                    title:messagePart.properties[@"title"]
                                       contentDescription:messagePart.properties[@"description"]
                                                  street1:messagePart.properties[@"street1"]
                                                  street2:messagePart.properties[@"street2"]
                                                     city:messagePart.properties[@"city"]
                                       administrativeArea:messagePart.properties[@"administrative_area"]
                                                  country:messagePart.properties[@"country"]
                                               postalCode:messagePart.properties[@"postal_code"]
                                                   action:action
                                                   sender:messagePart.message.sender
                                                   sentAt:messagePart.message.sentAt
                                                   status:[self statusWithMessage:messagePart.message]];
}

- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUILocationMessage *)messageType
                                                    parentNodeId:(NSString *)parentNodeId
                                                            role:(NSString *)role
                                              MIMETypeAttributes:(NSDictionary *)MIMETypeAttributes {
    NSMutableDictionary *messageJson = [[NSMutableDictionary alloc] init];
    messageJson[@"latitude"] = @(messageType.location.coordinate.latitude);
    messageJson[@"longitude"] = @(messageType.location.coordinate.longitude);
    messageJson[@"altitude"] = @(messageType.location.altitude);
    messageJson[@"accuracy"] = @((messageType.location.verticalAccuracy + messageType.location.horizontalAccuracy) / 2.0);
    messageJson[@"title"] = messageType.title;
    messageJson[@"description"] = messageType.contentDescription;
    if (messageType.location.timestamp) {
        messageJson[@"created_at"] = [self.dateFormatter stringFromDate:messageType.location.timestamp];
    }
    [messageJson addEntriesFromDictionary:[self.actionSerializer propertiesForAction:messageType.action]];
    
    NSError *error = nil;
    NSData *messageJsonData = [NSJSONSerialization dataWithJSONObject:messageJson options:0 error:&error];
    if (error) {
        NSLog(@"Failed to serialize location message JSON object: %@", error);
        return nil;
    }
    NSString *MIMEType = [self MIMETypeForContentType:messageType.MIMEType
                                         parentNodeId:parentNodeId
                                                 role:role
                                           attributes:MIMETypeAttributes];
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithMIMEType:MIMEType data:messageJsonData];
    return @[messagePart];
}

- (LYRMessageOptions *)messageOptionsForTypedMessage:(LYRUILocationMessage *)messageType {
    LYRMessageOptions *messageOptions = [self defaultMessageOptionsWithPushNotificationText:@"sent you a location."];
    return messageOptions;
}

@end
