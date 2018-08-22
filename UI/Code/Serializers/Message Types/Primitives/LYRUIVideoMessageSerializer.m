//
//  LYRUIVideoMessageSerializer.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 11.10.2017.
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

#import "LYRUIVideoMessageSerializer.h"
#import "LYRMessage+LYRUIHelpers.h"
#import "LYRMessagePart+LYRUIHelpers.h"
#import "LYRUIMessageActionSerializer.h"

static NSString * const LYRUIVideoMessageSerializerDefaultAction = @"layer-open-expanded-view";

@interface LYRUIVideoMessageSerializer ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation LYRUIVideoMessageSerializer

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

- (LYRUIVideoMessage *)typedMessageWithMessagePart:(LYRMessagePart *)messagePart {
    CGSize previewSize = CGSizeZero;
    if (messagePart.properties[@"preview_width"] != nil && messagePart.properties[@"preview_height"] != nil) {
        previewSize = CGSizeMake([messagePart.properties[@"preview_width"] doubleValue],
                                 [messagePart.properties[@"preview_height"] doubleValue]);
    }
    LYRSize size = messagePart.properties[@"size"] ? [messagePart.properties[@"size"] integerValue] : LYRSizeNotDefined;
    NSTimeInterval duration = messagePart.properties[@"duration"] ? [messagePart.properties[@"duration"] doubleValue] : 0;
    NSString *mimeType = messagePart.properties[@"mime_type"] ?: @"application/octet-stream";
    NSURL *sourceLocalURL;
    LYRMessagePart *sourcePart = [messagePart childPartWithRole:@"source"];
    if (sourcePart) {
        if (sourcePart.transferStatus == LYRContentTransferReadyForDownload) {
            [sourcePart downloadContent:NULL];
        }
        sourceLocalURL = [self localFileURLForFileMessagePart:sourcePart withMIMEType:mimeType];
    }
    NSURL *previewLocalURL;
    LYRMessagePart *previewPart = [messagePart childPartWithRole:@"preview"];
    if (previewPart) {
        if (previewPart.transferStatus == LYRContentTransferReadyForDownload) {
            [previewPart downloadContent:NULL];
        }
        previewLocalURL = [self localFileURLForFileMessagePart:previewPart withMIMEType:mimeType];
    }
    NSDate *createdAt;
    if (messagePart.properties[@"created_at"] != nil) {
        createdAt = [self.dateFormatter dateFromString:messagePart.properties[@"created_at"]];
    }
    NSURL *sourceURL = messagePart.properties[@"source_url"] ? [NSURL URLWithString:messagePart.properties[@"source_url"]] : nil;
    NSURL *previewURL = messagePart.properties[@"preview_url"] ? [NSURL URLWithString:messagePart.properties[@"preview_url"]] : nil;
    NSMutableDictionary *properties = messagePart.properties.mutableCopy;
    properties[@"message_part_id"] = messagePart.identifier;
    LYRUIMessageAction *action = [[LYRUIMessageAction alloc] initWithEvent:LYRUIVideoMessageSerializerDefaultAction data:properties];
    return [[LYRUIVideoMessage alloc] initWithArtist:messagePart.properties[@"artist"]
                                               title:messagePart.properties[@"title"]
                                           createdAt:createdAt
                                            subtitle:messagePart.properties[@"subtitle"]
                                         aspectRatio:[messagePart.properties[@"aspect_ratio"] doubleValue]
                                                size:size
                                            duration:duration
                                       mediaMIMEType:mimeType
                                           sourceURL:sourceURL
                                          previewURL:previewURL
                                 localSourceProgress:sourcePart.progress
                                   localSourceStatus:sourcePart.transferStatus
                                      sourceLocalURL:sourceLocalURL
                                     previewLocalURL:previewLocalURL
                                         previewSize:previewSize
                                              action:action
                                              sender:messagePart.message.sender
                                              sentAt:messagePart.message.sentAt
                                              status:[self statusWithMessage:messagePart.message]
                                         messagePart:messagePart];
}

- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUIVideoMessage *)messageType
                                                    parentNodeId:(NSString *)parentNodeId
                                                            role:(NSString *)role {
    // Sending media messages not supported.
    return @[ ];
}

- (LYRMessageOptions *)messageOptionsForTypedMessage:(LYRUIVideoMessage *)messageType {
    LYRMessageOptions *messageOptions = [self defaultMessageOptionsWithPushNotificationText:[NSString stringWithFormat:@"sent you %@", messageType.title ?: @"a Video Message"]];
    return messageOptions;
}

@end
