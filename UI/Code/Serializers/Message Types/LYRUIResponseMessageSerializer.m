//
//  LYRUIResponseMessageSerializer.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 05.12.2017.
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

#import "LYRUIResponseMessageSerializer.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRMessage+LYRUIHelpers.h"
#import "LYRMessagePart+LYRUIHelpers.h"
#import "LYRUIStatusMessage.h"

@implementation LYRUIResponseMessageSerializer

- (LYRUIStatusMessage *)typedMessageWithMessagePart:(LYRMessagePart *)messagePart {
    LYRMessagePart *statusPart = [messagePart childPartWithRole:@"status"];
    if (statusPart != nil) {
        id<LYRUIMessageTypeSerializing> contentSerializer = [self.layerConfiguration.injector serializerForMessagePartMIMEType:statusPart.contentType];
        LYRUIStatusMessage *statusMessage = (LYRUIStatusMessage *)[contentSerializer typedMessageWithMessagePart:statusPart];
        return statusMessage;
    }
    return nil;
}

- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUIResponseMessage *)messageType
                                                    parentNodeId:(NSString *)parentNodeId
                                                            role:(NSString *)role
                                              MIMETypeAttributes:(NSDictionary *)MIMETypeAttributes {
    NSMutableDictionary *messageJson = [[NSMutableDictionary alloc] init];
    messageJson[@"response_to"] = messageType.responseTo;
    messageJson[@"response_to_node_id"] = messageType.responseToNodeId;
    messageJson[@"changes"] = messageType.changes;
    if (messageType.participantData.count > 0) {
        messageJson[@"participant_data"] = messageType.participantData;
    }
    
    NSError *error = nil;
    NSData *messageJsonData = [NSJSONSerialization dataWithJSONObject:messageJson options:0 error:&error];
    if (error) {
        NSLog(@"Failed to serialize response message JSON object: %@", error);
        return nil;
    }
    NSMutableArray *messageParts = [[NSMutableArray alloc] init];
    
    NSString *MIMEType = [self MIMETypeForContentType:messageType.MIMEType
                                         parentNodeId:parentNodeId
                                                 role:role
                                           attributes:MIMETypeAttributes];
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithMIMEType:MIMEType data:messageJsonData];
    [messageParts addObject:messagePart];
    
    NSArray<LYRMessagePart *> *contentParts;
    if (messageType.text != nil) {
        LYRUIStatusMessage *statusMessage = [[LYRUIStatusMessage alloc] initWithText:messageType.text];
        id<LYRUIMessageTypeSerializing> contentSerializer = [self.layerConfiguration.injector serializerForMessagePartMIMEType:statusMessage.MIMEType];
        contentParts = [contentSerializer layerMessagePartsWithTypedMessage:statusMessage
                                                               parentNodeId:messagePart.nodeId
                                                                       role:@"status"];
        if (contentParts) {
            [messageParts addObjectsFromArray:contentParts];
        }
    }
    
    return messageParts;
}

@end
