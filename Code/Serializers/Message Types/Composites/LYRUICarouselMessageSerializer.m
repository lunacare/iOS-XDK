//
//  LYRUICarouselMessageSeralizer.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 04.12.2017.
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

#import "LYRUICarouselMessageSerializer.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRMessagePart+LYRUIHelpers.h"
#import "LYRUIMessageActionSerializer.h"

@implementation LYRUICarouselMessageSerializer

- (LYRUICarouselMessage *)typedMessageWithMessagePart:(LYRMessagePart *)messagePart {
    NSArray<LYRMessagePart *> *itemsParts = [messagePart childPartsWithRole:@"carousel-item"];
    itemsParts = [itemsParts sortedArrayUsingComparator:^NSComparisonResult(LYRMessagePart *obj1, LYRMessagePart *obj2) {
        return [[obj1 MIMETypeAttributes][@"item-order"] compare:[obj2 MIMETypeAttributes][@"item-order"]];
    }];
    NSMutableArray<LYRUIMessageType *> *itemsMessages = [[NSMutableArray alloc] init];
    for (LYRMessagePart *itemPart in itemsParts) {
        id<LYRUIMessageTypeSerializing> contentSerializer = [self.layerConfiguration.injector serializerForMessagePartMIMEType:itemPart.contentType];
        LYRUIMessageType *itemMessage = [contentSerializer typedMessageWithMessagePart:itemPart];
        if (itemMessage) {
            [itemsMessages addObject:itemMessage];
        }
    }
    
    return [[LYRUICarouselMessage alloc] initWithItemMessages:itemsMessages
                                                       action:[self.actionSerializer actionFromProperties:messagePart.properties]
                                                       sender:messagePart.message.sender
                                                       sentAt:messagePart.message.sentAt
                                                       status:[self statusWithMessage:messagePart.message]];
}

- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUICarouselMessage *)messageType
                                                    parentNodeId:(NSString *)parentNodeId
                                                            role:(NSString *)role {
    //TODO: implement
    
    return @[];
}

- (LYRMessageOptions *)messageOptionsForTypedMessage:(LYRUIMessageType *)messageType {
    LYRMessageOptions *messageOptions = [self defaultMessageOptionsWithPushNotificationText:@"sent you carousel message."];
    return messageOptions;
}

@end
