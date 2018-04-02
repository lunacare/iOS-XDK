//
//  LYRUITextMessageSerializer.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 06.10.2017.
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

#import "LYRUITextMessageSerializer.h"
#import "LYRUITextMessage.h"
#import <LayerKit/LayerKit.h>
#import "LYRMessage+LYRUIHelpers.h"
#import "LYRMessagePart+LYRUIHelpers.h"
#import "LYRUIMessageActionSerializer.h"

static NSString *const LYRUITextMessageAuthorKey = @"author";
static NSString *const LYRUITextMessageTextKey = @"text";
static NSString *const LYRUITextMessageMIMETypeKey = @"mime_type";
static NSString *const LYRUITextMessageSummaryKey = @"summary";
static NSString *const LYRUITextMessageTitleKey = @"title";
static NSString *const LYRUITextMessageSubtitleKey = @"subtitle";

static NSString *const LYRUITextMessageDefaultActionEvent = @"open-url";

@implementation LYRUITextMessageSerializer

- (NSString *)MIMEType {
    return @"application/vnd.layer.text+json";
}

- (LYRUITextMessage *)typedMessageWithMessagePart:(LYRMessagePart *)messagePart {
    if ([messagePart.MIMEType isEqualToString:@"text/plain"]) {
        NSString *messageText = [[NSString alloc] initWithData:messagePart.data encoding:NSUTF8StringEncoding];
        return [[LYRUITextMessage alloc] initWithText:messageText
                                               sender:messagePart.message.sender
                                               sentAt:messagePart.message.sentAt
                                               status:[self statusWithMessage:messagePart.message]];
    }
    
    if (messagePart.properties[@"text"] == nil) {
        return nil;
    }
    
    LYRUIMessageAction *action = [self.actionSerializer actionFromProperties:messagePart.properties
                                                            withDefaultEvent:LYRUITextMessageDefaultActionEvent];
    return [[LYRUITextMessage alloc] initWithAuthor:messagePart.properties[LYRUITextMessageAuthorKey]
                                               text:messagePart.properties[LYRUITextMessageTextKey]
                                       textMIMEType:messagePart.properties[LYRUITextMessageMIMETypeKey]
                                            summary:messagePart.properties[LYRUITextMessageSummaryKey]
                                              title:messagePart.properties[LYRUITextMessageTitleKey]
                                           subtitle:messagePart.properties[LYRUITextMessageSubtitleKey]
                                             action:action
                                             sender:messagePart.message.sender
                                             sentAt:messagePart.message.sentAt
                                             status:[self statusWithMessage:messagePart.message]];
}

- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUITextMessage *)messageType
                                                    parentNodeId:(NSString *)parentNodeId
                                                            role:(NSString *)role
                                              MIMETypeAttributes:(NSDictionary *)MIMETypeAttributes {
    NSMutableDictionary *messageJson = [[NSMutableDictionary alloc] init];
    messageJson[LYRUITextMessageAuthorKey] = messageType.author;
    messageJson[LYRUITextMessageTextKey] = messageType.text;
    messageJson[LYRUITextMessageMIMETypeKey] = messageType.textMIMEType;
    messageJson[LYRUITextMessageSummaryKey] = messageType.summary;
    messageJson[LYRUITextMessageTitleKey] = messageType.title;
    messageJson[LYRUITextMessageSubtitleKey] = messageType.subtitle;
    [messageJson addEntriesFromDictionary:[self.actionSerializer propertiesForAction:messageType.action]];
    
    NSError *error = nil;
    NSData *messageJsonData = [NSJSONSerialization dataWithJSONObject:messageJson options:0 error:&error];
    if (error) {
        NSLog(@"Failed to serialize text message JSON object: %@", error);
        return nil;
    }
    NSString *MIMEType = [self MIMETypeForContentType:messageType.MIMEType
                                         parentNodeId:parentNodeId
                                                 role:role
                                           attributes:MIMETypeAttributes];
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithMIMEType:MIMEType data:messageJsonData];
    return @[messagePart];
}

- (LYRMessageOptions *)messageOptionsForTypedMessage:(LYRUITextMessage *)messageType {
    NSString *notificationText = messageType.summary ?: messageType.text;
    LYRMessageOptions *messageOptions = [self defaultMessageOptionsWithMessageText:notificationText];
    return messageOptions;
}

@end
