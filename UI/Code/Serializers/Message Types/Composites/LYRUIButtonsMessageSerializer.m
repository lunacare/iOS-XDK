//
//  LYRUIButtonsMessageSerializer.m
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

#import "LYRUIButtonsMessageSerializer.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIButtonsMessageActionButton.h"
#import "LYRUIButtonsMessageChoiceButton.h"
#import "LYRMessagePart+LYRUIHelpers.h"
#import "LYRUIChoice.h"
#import "LYRUIMessageActionSerializer.h"
#import "LYRUIORSet.h"
#import "LYRUIFWWRegister.h"
#import "LYRUILWWRegister.h"
#import "LYRUILWWNRegister.h"

@implementation LYRUIButtonsMessageSerializer

- (LYRUIButtonsMessage *)typedMessageWithMessagePart:(LYRMessagePart *)messagePart {
    NSArray *buttons = messagePart.properties[@"buttons"];
    if (buttons == nil || ![buttons isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    LYRMessagePart *contentPart = [messagePart childPartWithRole:@"content"];
    LYRUIMessageType *contentMessage;
    if (contentPart != nil) {
        id<LYRUIMessageTypeSerializing> contentSerializer = [self.layerConfiguration.injector serializerForMessagePartMIMEType:contentPart.contentType];
        contentMessage = [contentSerializer typedMessageWithMessagePart:contentPart];
    }
    
    LYRUIMessageAction *action = [self.actionSerializer actionFromProperties:messagePart.properties overridingAction:contentMessage.action];
    
    NSMutableArray *serializedButtons = [[NSMutableArray alloc] init];
    for (NSDictionary *buttonProperties in buttons) {
        if ([buttonProperties[@"type"] isEqualToString:@"action"]) {
            LYRUIButtonsMessageActionButton *button = [self buttonWithProperties:buttonProperties defaultAction:action];
            [serializedButtons addObject:button];
        } else if ([buttonProperties[@"type"] isEqualToString:@"choice"]) {
            NSMutableArray *choices = [[NSMutableArray alloc] init];
            NSArray *choicesProperties = buttonProperties[@"choices"];
            for (NSDictionary *choiceProperties in choicesProperties) {
                LYRUIChoice *choice = [[LYRUIChoice alloc] initWithIdentifier:choiceProperties[@"id"]
                                                                         text:choiceProperties[@"text"]
                                                                      tooltip:choiceProperties[@"tooltip"]];
                [choices addObject:choice];
            }
            NSDictionary *dataProperties = buttonProperties[@"data"];
            
            NSString *responseName = dataProperties[@"response_name"] ?: @"selection";
            
            LYRUIORSet *selectionsSet;
            LYRMessagePart *responseSummaryPart = [messagePart childPartWithRole:@"response_summary"];
            if (responseSummaryPart != nil) {
                selectionsSet = [self selectionsSetFromResponseSummary:responseSummaryPart.properties
                                                              dataProperties:dataProperties
                                                          customResponseName:responseName];
            }
            
            LYRUIButtonsMessageChoiceButton *button = [[LYRUIButtonsMessageChoiceButton alloc] initWithChoices:choices
                                                                                                 allowDeselect:[dataProperties[@"allow_deselect"] boolValue]
                                                                                                 allowReselect:[dataProperties[@"allow_reselect"] boolValue]
                                                                                              allowMultiselect:[dataProperties[@"allow_multiselect"] boolValue]
                                                                                                          name:dataProperties[@"name"]
                                                                                                  responseName:responseName
                                                                                             preselectedChoice:dataProperties[@"preselected_choice"]
                                                                                                 selectionsSet:selectionsSet
                                                                                             responseMessageId:[messagePart.message.identifier absoluteString]
                                                                                                responseNodeId:messagePart.nodeId];
            [serializedButtons addObject:button];
        }
    }
    
    return [[LYRUIButtonsMessage alloc] initWithButtons:serializedButtons
                                         contentMessage:contentMessage
                                                 action:action
                                                 sender:messagePart.message.sender
                                                 sentAt:messagePart.message.sentAt
                                                 status:[self statusWithMessage:messagePart.message]];
}

- (LYRUIORSet *)selectionsSetFromResponseSummary:(NSDictionary *)responseSummary
                                  dataProperties:(NSDictionary *)dataProperties
                              customResponseName:(NSString *)responseName {
    NSString *currentUserID = self.layerConfiguration.client.authenticatedUser.identifier.lastPathComponent;
    NSDictionary *userData = responseSummary[currentUserID];
    NSDictionary *selectionsSetDictionary = userData[responseName];
    if (selectionsSetDictionary == nil || ![selectionsSetDictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    if ([dataProperties[@"allow_multiselect"] boolValue]) {
        return [[LYRUIORSet alloc] initWithPropertyName:responseName dictionary:selectionsSetDictionary];
    } else if ([dataProperties[@"allow_deselect"] boolValue]) {
        return [[LYRUILWWNRegister alloc] initWithPropertyName:responseName dictionary:selectionsSetDictionary];
    } else if ([dataProperties[@"allow_reselect"] boolValue]) {
        return [[LYRUILWWRegister alloc] initWithPropertyName:responseName dictionary:selectionsSetDictionary];
    } else {
        return [[LYRUIFWWRegister alloc] initWithPropertyName:responseName dictionary:selectionsSetDictionary];
    }
}

- (LYRUIButtonsMessageActionButton *)buttonWithProperties:(NSDictionary *)buttonProperties defaultAction:(LYRUIMessageAction *)action {
    if (buttonProperties[@"event"] != nil && buttonProperties[@"data"] != nil) {
        action = [[LYRUIMessageAction alloc] initWithEvent:buttonProperties[@"event"] data:buttonProperties[@"data"]];
    }
    LYRUIButtonsMessageActionButton *button = [[LYRUIButtonsMessageActionButton alloc] initWithTitle:buttonProperties[@"text"]
                                                                                              action:action];
    return button;
}

- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUIButtonsMessage *)messageType
                                                    parentNodeId:(NSString *)parentNodeId
                                                            role:(NSString *)role {
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    for (id<LYRUIButtonsMessageButton> button in messageType.buttons) {
        if ([button.type isEqualToString:@"action"]) {
            LYRUIButtonsMessageActionButton *actionButton = (LYRUIButtonsMessageActionButton *)button;
            NSMutableDictionary *buttonJson = [[NSMutableDictionary alloc] init];
            buttonJson[@"type"] = actionButton.type;
            buttonJson[@"text"] = actionButton.title;
            buttonJson[@"event"] = actionButton.action.event;
            buttonJson[@"data"] = actionButton.action.data;
            [buttons addObject:buttonJson];
        } else if ([button.type isEqualToString:@"choice"]) {
            // TODO: implement
        }
    }
    
    NSMutableDictionary *messageJson = [[NSMutableDictionary alloc] init];
    messageJson[@"buttons"] = buttons;
    [messageJson addEntriesFromDictionary:[self.actionSerializer propertiesForAction:messageType.action]];

    NSError *error = nil;
    NSData *messageJsonData = [NSJSONSerialization dataWithJSONObject:messageJson options:0 error:&error];
    if (error) {
        NSLog(@"Failed to serialize button message JSON object: %@", error);
        return nil;
    }
    NSMutableArray *messageParts = [[NSMutableArray alloc] init];
    NSString *MIMEType = [self MIMETypeForContentType:messageType.MIMEType parentNodeId:parentNodeId role:role];
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithMIMEType:MIMEType data:messageJsonData];
    [messageParts addObject:messagePart];
    
    NSArray<LYRMessagePart *> *contentParts;
    if (messageType.contentMessage != nil) {
        id<LYRUIMessageTypeSerializing> contentSerializer = [self.layerConfiguration.injector serializerForMessagePartMIMEType:messageType.contentMessage.MIMEType];
        contentParts = [contentSerializer layerMessagePartsWithTypedMessage:messageType.contentMessage
                                                               parentNodeId:messagePart.nodeId
                                                                       role:@"content"];
        if (contentParts) {
            [messageParts addObjectsFromArray:contentParts];
        }
    }
    
    return messageParts;
}

- (LYRMessageOptions *)messageOptionsForTypedMessage:(LYRUIMessageType *)messageType {
    LYRMessageOptions *messageOptions = [self defaultMessageOptionsWithPushNotificationText:@"sent you buttons message."];
    return messageOptions;
}

@end
