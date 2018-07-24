//
//  LYRUIFileMessageSerializer.m
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

#import "LYRUIFileMessageSerializer.h"
#import "LYRMessage+LYRUIHelpers.h"
#import "LYRMessagePart+LYRUIHelpers.h"
#import "LYRUIMessageActionSerializer.h"

@interface LYRUIFileMessageSerializer ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation LYRUIFileMessageSerializer

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

- (LYRUIFileMessage *)typedMessageWithMessagePart:(LYRMessagePart *)messagePart {
    if (![messagePart.contentType isEqualToString:@"application/vnd.layer.file+json"]) {
        if (messagePart.transferStatus == LYRContentTransferReadyForDownload) {
            [messagePart downloadContent:NULL];
        }
        NSURL *localFileURL = [self localFileURLForFileMessagePart:messagePart
                                                      withMIMEType:messagePart.MIMEType];
        
        return [[LYRUIFileMessage alloc] initWithFileMIMEType:messagePart.MIMEType
                                               sourceLocalURL:localFileURL
                                                       sender:messagePart.message.sender
                                                       sentAt:messagePart.message.sentAt
                                                       status:[self statusWithMessage:messagePart.message]];
    }
    
    NSDate *createdAt;
    if (messagePart.properties[@"created_at"] != nil) {
        createdAt = [self.dateFormatter dateFromString:messagePart.properties[@"created_at"]];
    }
    NSDate *updatedAt;
    if (messagePart.properties[@"updated_at"] != nil) {
        updatedAt = [self.dateFormatter dateFromString:messagePart.properties[@"updated_at"]];
    }
    LYRMessagePart *sourcePart = [messagePart childPartWithRole:@"source"];
    if (sourcePart.transferStatus == LYRContentTransferReadyForDownload) {
        [sourcePart downloadContent:NULL];
    }
    NSURL *URL = [self URLWithString:messagePart.properties[@"source_url"]];
    NSURL *localFileURL = [self localFileURLForFileMessagePart:sourcePart
                                                  withMIMEType:messagePart.properties[@"mime_type"]];
    LYRUIMessageAction *action = [self.actionSerializer actionFromProperties:messagePart.properties
                                                            withDefaultEvent:@"open-file"];
    return [[LYRUIFileMessage alloc] initWithAuthor:messagePart.properties[@"author"]
                                              title:messagePart.properties[@"title"]
                                            comment:messagePart.properties[@"comment"]
                                       fileMIMEType:messagePart.properties[@"mime_type"]
                                               size:[messagePart.properties[@"size"] unsignedIntegerValue]
                                          createdAt:createdAt
                                          updatedAt:updatedAt
                                          sourceURL:URL
                                     sourceLocalURL:localFileURL
                                         sourceData:nil
                                             action:action
                                             sender:messagePart.message.sender
                                             sentAt:messagePart.message.sentAt
                                             status:[self statusWithMessage:messagePart.message]
                                        messagePart:messagePart];
}

- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUIFileMessage *)messageType
                                                    parentNodeId:(NSString *)parentNodeId
                                                            role:(NSString *)role
                                              MIMETypeAttributes:(NSDictionary *)MIMETypeAttributes {
    // TODO: implement
    return @[];
}

- (LYRMessageOptions *)messageOptionsForTypedMessage:(LYRUIFileMessage *)messageType {
    LYRMessageOptions *messageOptions = [self defaultMessageOptionsWithPushNotificationText:@"sent you a file."];
    return messageOptions;
}

@end
