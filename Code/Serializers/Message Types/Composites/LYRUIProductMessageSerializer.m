//
//  LYRUIProductMessageSerializer.m
//  Layer-UI-iOS
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

#import "LYRUIProductMessageSerializer.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRMessagePart+LYRUIHelpers.h"
#import "LYRUIMessageActionSerializer.h"

@implementation LYRUIProductMessageSerializer

- (LYRUIProductMessage *)typedMessageWithMessagePart:(LYRMessagePart *)messagePart {
    NSMutableArray *options = [[NSMutableArray alloc] init];
    NSArray *optionParts = [messagePart childPartsWithRole:@"options"];
    for (LYRMessagePart *optionMessagePart in optionParts) {
        id<LYRUIMessageTypeSerializing> optionSerializer = [self.layerConfiguration.injector serializerForMessagePartMIMEType:optionMessagePart.contentType];
        LYRUIMessageType *optionMessage = [optionSerializer typedMessageWithMessagePart:optionMessagePart];
        if (optionMessage != nil) {
            [options addObject:optionMessage];
        }
    }
    
    return [[LYRUIProductMessage alloc] initWithBrand:messagePart.properties[@"brand"]
                                                 name:messagePart.properties[@"name"]
                                   productDescription:messagePart.properties[@"description"]
                                            imageURLs:[self imageURLsFromStrings:messagePart.properties[@"image_urls"]]
                                                price:[messagePart.properties[@"price"] doubleValue]
                                             quantity:[messagePart.properties[@"quantity"] unsignedIntegerValue]
                                             currency:messagePart.properties[@"currency"]
                                              options:options
                                               action:[self.actionSerializer actionFromProperties:messagePart.properties]
                                               sender:messagePart.message.sender
                                               sentAt:messagePart.message.sentAt
                                               status:[self statusWithMessage:messagePart.message]];
}

- (NSArray<NSURL *> *)imageURLsFromStrings:(NSArray<NSString *> *)imageURLStrings {
    if (imageURLStrings == nil || ![imageURLStrings isKindOfClass:[NSArray class]]) {
        return nil;
    }
    NSMutableArray *imageURLs = [[NSMutableArray alloc] init];
    for (NSString *imageURLString in imageURLStrings) {
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        if (imageURL != nil) {
            [imageURLs addObject:imageURL];
        }
    }
    return imageURLs;
}

- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUIProductMessage *)messageType
                                                    parentNodeId:(NSString *)parentNodeId
                                                            role:(NSString *)role {
    // TODO: implement
    return @[];
}

- (LYRMessageOptions *)messageOptionsForTypedMessage:(LYRUIMessageType *)messageType {
    LYRMessageOptions *messageOptions = [self defaultMessageOptionsWithPushNotificationText:@"sent you product message."];
    return messageOptions;
}

@end
