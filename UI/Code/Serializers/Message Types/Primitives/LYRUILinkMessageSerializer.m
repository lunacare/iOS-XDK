//
//  LYRUILinkMessageSerializer.m
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

#import "LYRUILinkMessageSerializer.h"
#import "LYRMessage+LYRUIHelpers.h"
#import "LYRMessagePart+LYRUIHelpers.h"
#import "LYRUIMessageActionSerializer.h"

@implementation LYRUILinkMessageSerializer

- (LYRUILinkMessage *)typedMessageWithMessagePart:(LYRMessagePart *)messagePart {
    CGSize imageSize = CGSizeZero;
    if (messagePart.properties[@"image_width"] != nil && messagePart.properties[@"image_width"] != nil) {
        imageSize = CGSizeMake([messagePart.properties[@"image_width"] doubleValue],
                               [messagePart.properties[@"image_height"] doubleValue]);
    }
    NSURL *imageURL;
    if (messagePart.properties[@"image_url"] != nil) {
        imageURL = [NSURL URLWithString:messagePart.properties[@"image_url"]];
    }
    
    NSURL *URL = [self URLWithString:messagePart.properties[@"url"]];
    LYRUIMessageAction *action = [self.actionSerializer actionFromProperties:messagePart.properties
                                                            withDefaultEvent:@"open-url"];
    return [[LYRUILinkMessage alloc] initWithAuthor:messagePart.properties[@"author"]
                                              title:messagePart.properties[@"title"]
                                 contentDescription:messagePart.properties[@"description"]
                                           imageURL:imageURL
                                          imageSize:imageSize
                                                URL:URL
                                             action:action
                                             sender:messagePart.message.sender
                                             sentAt:messagePart.message.sentAt
                                             status:[self statusWithMessage:messagePart.message]
                                        messagePart:messagePart];
}

- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUILinkMessage *)messageType
                                                    parentNodeId:(NSString *)parentNodeId
                                                            role:(NSString *)role {
    NSMutableDictionary *messageJson = [[NSMutableDictionary alloc] init];
    messageJson[@"author"] = messageType.author;
    messageJson[@"title"] = messageType.title;
    messageJson[@"description"] = messageType.contentDescription;
    messageJson[@"image_url"] = messageType.imageURL.absoluteString;
    if (!CGSizeEqualToSize(messageType.imageSize, CGSizeZero)) {
        messageJson[@"image_width"] = @(messageType.imageSize.width);
        messageJson[@"image_height"] = @(messageType.imageSize.height);
    }
    messageJson[@"url"] = messageType.URL.absoluteString;
    [messageJson addEntriesFromDictionary:[self.actionSerializer propertiesForAction:messageType.action]];
    
    NSError *error = nil;
    NSData *messageJsonData = [NSJSONSerialization dataWithJSONObject:messageJson options:0 error:&error];
    if (error) {
        NSLog(@"Failed to serialize link message JSON object: %@", error);
        return nil;
    }
    NSString *MIMEType = [self MIMETypeForContentType:messageType.MIMEType parentNodeId:parentNodeId role:role attributes:@{}];
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithMIMEType:MIMEType data:messageJsonData];
    return @[messagePart];
}

- (LYRMessageOptions *)messageOptionsForTypedMessage:(LYRUILinkMessage *)messageType {
    LYRMessageOptions *messageOptions = [self defaultMessageOptionsWithPushNotificationText:@"sent you a link."];
    return messageOptions;
}

@end
