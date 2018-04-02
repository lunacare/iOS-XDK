//
//  LYRUIStatusMessageSerializer.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 10.01.2018.
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

#import "LYRUIStatusMessageSerializer.h"
#import "LYRMessage+LYRUIHelpers.h"
#import "LYRMessagePart+LYRUIHelpers.h"
#import "LYRUIMessageActionSerializer.h"

@implementation LYRUIStatusMessageSerializer

- (LYRUIStatusMessage *)typedMessageWithMessagePart:(LYRMessagePart *)messagePart {
    return [[LYRUIStatusMessage alloc] initWithText:messagePart.properties[@"text"]
                                             action:[self.actionSerializer actionFromProperties:messagePart.properties]
                                             sender:nil
                                             sentAt:messagePart.message.sentAt
                                             status:[self statusWithMessage:messagePart.message]];
}

- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUIStatusMessage *)messageType
                                                    parentNodeId:(NSString *)parentNodeId
                                                            role:(NSString *)role
                                              MIMETypeAttributes:(NSDictionary *)MIMETypeAttributes {
    NSMutableDictionary *messageJson = [[NSMutableDictionary alloc] init];
    messageJson[@"text"] = messageType.text;
    
    NSError *error = nil;
    NSData *messageJsonData = [NSJSONSerialization dataWithJSONObject:messageJson options:0 error:&error];
    if (error) {
        NSLog(@"Failed to serialize status message JSON object: %@", error);
        return nil;
    }
    NSString *MIMEType = [self MIMETypeForContentType:messageType.MIMEType
                                         parentNodeId:parentNodeId
                                                 role:role
                                           attributes:MIMETypeAttributes];
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithMIMEType:MIMEType data:messageJsonData];
    return @[messagePart];
}

@end
