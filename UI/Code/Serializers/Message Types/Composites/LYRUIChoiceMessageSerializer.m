//
//  LYRUIChoiceMessageSerializer.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 23.11.2017.
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

#import "LYRUIChoiceMessageSerializer.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIChoice.h"
#import "LYRMessagePart+LYRUIHelpers.h"
#import "LYRUITextMessage.h"
#import "LYRUIMessageActionSerializer.h"
#import "LYRUIORSet.h"
#import "LYRUIChoiceSelectionsSetFactory.h"

@interface LYRUIChoiceMessageSerializer ()

@property (nonatomic, strong) LYRUIChoiceSelectionsSetFactory *selectionsSetFactory;

@end

@implementation LYRUIChoiceMessageSerializer

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    [super setLayerConfiguration:layerConfiguration];
    self.selectionsSetFactory = [layerConfiguration.injector objectOfType:[LYRUIChoiceSelectionsSetFactory class]];
}

- (LYRUIChoiceMessage *)typedMessageWithMessagePart:(LYRMessagePart *)messagePart {
    NSArray *choices = messagePart.properties[@"choices"];
    if (choices == nil || ![choices isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *serializedChoices = [[NSMutableArray alloc] init];
    for (NSDictionary *choiceProperties in choices) {
        LYRUIChoice *choice = [[LYRUIChoice alloc] initWithIdentifier:choiceProperties[@"id"]
                                                                 text:choiceProperties[@"states"][@"default"][@"text"] ?: choiceProperties[@"text"]
                                                         selectedText:choiceProperties[@"states"][@"selected"][@"text"]
                                                   customResponseData:choiceProperties[@"custom_response_data"]];
        
        [serializedChoices addObject:choice];
    }
    
    NSString *title = messagePart.properties[@"title"] ?: @"Choose One";
    
    LYRUIMessageType *contentMessage;
    if (messagePart.properties[@"label"] != nil) {
        contentMessage = [[LYRUITextMessage alloc] initWithText:messagePart.properties[@"label"]
                                                          title:title];
    }
    
    NSString *responseName = messagePart.properties[@"response_name"] ?: @"selection";
    
    LYRUIORSet *initialResponseState;
    if (messagePart.properties[@"initial_response_state"]) {
        initialResponseState = [self.selectionsSetFactory selectionsSetFromInitialResponseState:messagePart.properties[@"initial_response_state"]
                                                                                 dataProperties:messagePart.properties
                                                                             customResponseName:responseName];
    }
    
    LYRUIORSet *selectionsSet;
    LYRMessagePart *responseSummaryPart = [messagePart childPartWithRole:@"response_summary"];
    if (responseSummaryPart != nil) {
        selectionsSet = [self.selectionsSetFactory selectionsSetFromResponseSummary:responseSummaryPart.properties
                                                                     dataProperties:messagePart.properties
                                                                 customResponseName:responseName];
    }
    
    return [[LYRUIChoiceMessage alloc] initWithTitle:title
                                               label:messagePart.properties[@"label"]
                                      contentMessage:contentMessage
                                             choices:serializedChoices
                                                type:[self choiceMessageTypeWithString:messagePart.properties[@"type"]]
                                        expandedType:[self choiceMessageTypeWithString:messagePart.properties[@"expanded_type"]]
                                       allowReselect:[messagePart.properties[@"allow_reselect"] boolValue]
                                       allowDeselect:[messagePart.properties[@"allow_deselect"] boolValue]
                                    allowMultiselect:[messagePart.properties[@"allow_multiselect"] boolValue]
                                                name:messagePart.properties[@"name"]
                                        responseName:responseName
                                  customResponseData:messagePart.properties[@"custom_data_response"]
                                          enabledFor:[self setWithEnabledFor:messagePart.properties[@"enabled_for"]]
                                initialResponseState:initialResponseState
                                       selectionsSet:selectionsSet
                                   responseMessageId:[messagePart.message.identifier absoluteString]
                                      responseNodeId:messagePart.nodeId
                                              action:[self.actionSerializer actionFromProperties:messagePart.properties]
                                              sender:messagePart.message.sender
                                              sentAt:messagePart.message.sentAt
                                              status:[self statusWithMessage:messagePart.message]];
}

- (LYRUIChoiceMessageType)choiceMessageTypeWithString:(NSString *)string {
    if ([string isEqualToString:@"label"]) {
        return LYRUIChoiceMessageTypeLabel;
    }
    return LYRUIChoiceMessageTypeDefault;
}

- (NSSet<NSString *> *)setWithEnabledFor:(id)enabledFor {
    if ([enabledFor isKindOfClass:[NSString class]]) {
        return [NSSet setWithObject:enabledFor];
    } else if ([enabledFor isKindOfClass:[NSArray class]]) {
        return [NSSet setWithArray:enabledFor];
    }
    return nil;
}

- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUIChoiceMessage *)messageType
                                                    parentNodeId:(NSString *)parentNodeId
                                                            role:(NSString *)role
                                              MIMETypeAttributes:(NSDictionary *)MIMETypeAttributes {
    NSMutableArray *choices = [[NSMutableArray alloc] init];
    for (LYRUIChoice *choice in messageType.choices) {
        NSMutableDictionary *choiceJson = [[NSMutableDictionary alloc] init];
        choiceJson[@"id"] = choice.identifier;
        choiceJson[@"text"] = choice.text;
        if (choice.selectedText) {
            choiceJson[@"states"] = @{ @"selected" : @{ @"text": choice.selectedText } };
        }
        choiceJson[@"custom_response_data"] = choice.customResponseData;
        [choices addObject:choiceJson];
    }
    
    NSArray *initialResponseOperations = [self operationsForInitialResponseState:messageType.initialResponseState
                                                                      enabledFor:messageType.enabledFor];
    
    NSMutableDictionary *messageJson = [[NSMutableDictionary alloc] init];
    messageJson[@"title"] = messageType.title;
    messageJson[@"label"] = messageType.label;
    messageJson[@"choices"] = choices;
    messageJson[@"type"] = [self stringForChoiceMessageType:messageType.type];
    messageJson[@"expanded_type"] = [self stringForChoiceMessageType:messageType.expandedType];
    messageJson[@"allow_reselect"] = @(messageType.allowReselect);
    messageJson[@"allow_deselect"] = @(messageType.allowDeselect);
    messageJson[@"allow_multiselect"] = @(messageType.allowMultiselect);
    messageJson[@"name"] = messageType.name;
    messageJson[@"response_name"] = messageType.responseName;
    messageJson[@"custom_data_response"] = messageType.customResponseData;
    messageJson[@"enabled_for"] = messageType.enabledFor.anyObject;
    messageJson[@"initial_response_state"] = initialResponseOperations;
    [messageJson addEntriesFromDictionary:[self.actionSerializer propertiesForAction:messageType.action]];
    
    NSError *error = nil;
    NSData *messageJsonData = [NSJSONSerialization dataWithJSONObject:messageJson options:0 error:&error];
    if (error) {
        NSLog(@"Failed to serialize choice message JSON object: %@", error);
        return nil;
    }
    NSMutableArray *messageParts = [[NSMutableArray alloc] init];
    NSString *MIMEType = [self MIMETypeForContentType:messageType.MIMEType
                                         parentNodeId:parentNodeId
                                                 role:role
                                           attributes:MIMETypeAttributes];
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithMIMEType:MIMEType data:messageJsonData];
    [messageParts addObject:messagePart];
    
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

- (NSString *)stringForChoiceMessageType:(LYRUIChoiceMessageType)type {
    switch (type) {
        case LYRUIChoiceMessageTypeDefault:
            return @"standard";
        case LYRUIChoiceMessageTypeLabel:
            return @"label";
    }
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
    LYRMessageOptions *messageOptions = [self defaultMessageOptionsWithPushNotificationText:@"sent you choice message."];
    return messageOptions;
}

@end
