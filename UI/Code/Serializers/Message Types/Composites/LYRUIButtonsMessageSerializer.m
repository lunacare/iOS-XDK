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
#import "LYRUIChoiceSelectionsSetFactory.h"

@interface LYRUIButtonsMessageSerializer ()

@property (nonatomic, strong) LYRUIChoiceSelectionsSetFactory *selectionsSetFactory;

@end

@implementation LYRUIButtonsMessageSerializer

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    [super setLayerConfiguration:layerConfiguration];
    self.selectionsSetFactory = [layerConfiguration.injector objectOfType:[LYRUIChoiceSelectionsSetFactory class]];
}

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
                                                                         text:choiceProperties[@"states"][@"default"][@"text"] ?: choiceProperties[@"text"]
                                                                 selectedText:choiceProperties[@"states"][@"selected"][@"text"]
                                                           customResponseData:choiceProperties[@"custom_response_data"]];
                [choices addObject:choice];
            }
            NSDictionary *dataProperties = buttonProperties[@"data"];
            
            NSString *responseName = dataProperties[@"response_name"] ?: @"selection";
            
            LYRUIORSet *initialResponseState;
            if (messagePart.properties[@"initial_response_state"]) {
                initialResponseState = [self.selectionsSetFactory selectionsSetFromInitialResponseState:messagePart.properties[@"initial_response_state"]
                                                                                         dataProperties:dataProperties
                                                                                     customResponseName:responseName];
            }
            
            LYRUIORSet *selectionsSet;
            LYRMessagePart *responseSummaryPart = [messagePart childPartWithRole:@"response_summary"];
            if (responseSummaryPart != nil) {
                selectionsSet = [self.selectionsSetFactory selectionsSetFromResponseSummary:responseSummaryPart.properties
                                                                             dataProperties:dataProperties
                                                                         customResponseName:responseName];
            }
            
            LYRUIButtonsMessageChoiceButton *button = [[LYRUIButtonsMessageChoiceButton alloc] initWithChoices:choices
                                                                                                 allowDeselect:[dataProperties[@"allow_deselect"] boolValue]
                                                                                                 allowReselect:[dataProperties[@"allow_reselect"] boolValue]
                                                                                              allowMultiselect:[dataProperties[@"allow_multiselect"] boolValue]
                                                                                                          name:dataProperties[@"name"]
                                                                                                  responseName:responseName
                                                                                                    enabledFor:[self setWithEnabledFor:dataProperties[@"enabled_for"]]
                                                                                          initialResponseState:initialResponseState
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

- (LYRUIButtonsMessageActionButton *)buttonWithProperties:(NSDictionary *)buttonProperties defaultAction:(LYRUIMessageAction *)action {
    if (buttonProperties[@"event"] != nil && buttonProperties[@"data"] != nil) {
        action = [[LYRUIMessageAction alloc] initWithEvent:buttonProperties[@"event"] data:buttonProperties[@"data"]];
    }
    LYRUIButtonsMessageActionButton *button = [[LYRUIButtonsMessageActionButton alloc] initWithTitle:buttonProperties[@"text"]
                                                                                              action:action];
    return button;
}

- (NSSet<NSString *> *)setWithEnabledFor:(id)enabledFor {
    if ([enabledFor isKindOfClass:[NSString class]]) {
        return [NSSet setWithObject:enabledFor];
    } else if ([enabledFor isKindOfClass:[NSArray class]]) {
        return [NSSet setWithArray:enabledFor];
    }
    return nil;
}

- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUIButtonsMessage *)messageType
                                                    parentNodeId:(NSString *)parentNodeId
                                                            role:(NSString *)role
                                              MIMETypeAttributes:(NSDictionary *)MIMETypeAttributes {
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    NSMutableArray *initialResponseOperations = [[NSMutableArray alloc] init];
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
            LYRUIButtonsMessageChoiceButton *choiceButton = (LYRUIButtonsMessageChoiceButton *)button;
            
            NSArray *operations = [self operationsForInitialResponseState:choiceButton.initialResponseState
                                                               enabledFor:choiceButton.enabledFor];
            [initialResponseOperations addObjectsFromArray:operations];
            
            NSMutableArray *choices = [[NSMutableArray alloc] init];
            for (LYRUIChoice *choice in choiceButton.choices) {
                NSMutableDictionary *choiceJson = [[NSMutableDictionary alloc] init];
                choiceJson[@"id"] = choice.identifier;
                choiceJson[@"text"] = choice.text;
                if (choice.selectedText) {
                    choiceJson[@"states"] = @{ @"selected" : @{ @"text": choice.selectedText } };
                }
                choiceJson[@"custom_response_data"] = choice.customResponseData;
                [choices addObject:choiceJson];
            }
            
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            data[@"allow_reselect"] = @(choiceButton.allowReselect);
            data[@"allow_deselect"] = @(choiceButton.allowDeselect);
            data[@"allow_multiselect"] = @(choiceButton.allowMultiselect);
            data[@"response_name"] = choiceButton.responseName;
            data[@"enabled_for"] = choiceButton.enabledFor.anyObject;
            
            [buttons addObject:@{
                    @"choices": choices,
                    @"data": data,
            }];
        }
    }
    
    NSMutableDictionary *messageJson = [[NSMutableDictionary alloc] init];
    messageJson[@"buttons"] = buttons;
    if (initialResponseOperations.count > 0) {
        messageJson[@"initial_response_state"] = initialResponseOperations;
        NSString *MIMEType = [self MIMETypeForContentType:@"application/vnd.layer.initialresponsestate-v1+json"
                                             parentNodeId:nil
                                                     role:@"initial_response_summary"
                                               attributes:MIMETypeAttributes];
    }
    [messageJson addEntriesFromDictionary:[self.actionSerializer propertiesForAction:messageType.action]];

    NSError *error = nil;
    NSData *messageJsonData = [NSJSONSerialization dataWithJSONObject:messageJson options:0 error:&error];
    if (error) {
        NSLog(@"Failed to serialize button message JSON object: %@", error);
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
    if (messageType.contentMessage != nil) {
        id<LYRUIMessageTypeSerializing> contentSerializer = [self.layerConfiguration.injector serializerForMessagePartMIMEType:messageType.contentMessage.MIMEType];
        contentParts = [contentSerializer layerMessagePartsWithTypedMessage:messageType.contentMessage
                                                               parentNodeId:messagePart.nodeId
                                                                       role:@"content"];
        if (contentParts) {
            [messageParts addObjectsFromArray:contentParts];
        }
    }
    
    NSData *initialResponseData;
    if (initialResponseOperations.count > 0) {
        initialResponseData = [NSJSONSerialization dataWithJSONObject:initialResponseOperations options:0 error:&error];
        if (error) {
            NSLog(@"Failed to serialize initial response JSON object: %@", error);
        }
    }
    if (initialResponseData) {
        NSString *MIMEType = [self MIMETypeForContentType:@"application/vnd.layer.initialresponsestate-v1+json"
                                             parentNodeId:messagePart.nodeId
                                                     role:@"initial_response_summary"
                                               attributes:MIMETypeAttributes];
        LYRMessagePart *initialResponsePart = [LYRMessagePart messagePartWithMIMEType:MIMEType data:initialResponseData];
        [messageParts addObject:initialResponsePart];
    }
    
    return messageParts;
}

- (NSArray *)operationsForInitialResponseState:(LYRUIORSet *)initialResponseState
                                    enabledFor:(NSSet<NSString *> *)enabledFor {
    if (initialResponseState == nil || enabledFor.count == 0) {
        return @[];
    }
    NSMutableArray *initialResponseOperations = [[NSMutableArray alloc] init];
    for (NSString *identityID in enabledFor) {
        for (NSDictionary *operation in initialResponseState.operationsDictionaries) {
            NSMutableDictionary *operationWithID = [operation mutableCopy];
            operationWithID[@"identity_id"] = identityID;
            [initialResponseOperations addObject:operationWithID];
        }
    }
    return initialResponseOperations;
}

- (LYRMessageOptions *)messageOptionsForTypedMessage:(LYRUIMessageType *)messageType {
    LYRMessageOptions *messageOptions = [self defaultMessageOptionsWithPushNotificationText:@"sent you buttons message."];
    return messageOptions;
}

@end
