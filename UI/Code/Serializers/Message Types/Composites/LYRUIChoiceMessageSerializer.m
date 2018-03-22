//
//  LYRUIChoiceMessageSerializer.m
//  Layer-UI-iOS
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
#import "LYRUIFWWRegister.h"
#import "LYRUILWWRegister.h"
#import "LYRUILWWNRegister.h"

@implementation LYRUIChoiceMessageSerializer

- (LYRUIChoiceMessage *)typedMessageWithMessagePart:(LYRMessagePart *)messagePart {
    NSArray *choices = messagePart.properties[@"choices"];
    if (choices == nil || ![choices isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *serializedChoices = [[NSMutableArray alloc] init];
    for (NSDictionary *choiceProperties in choices) {
        id<LYRUIChoiceProperties> selectedChoiceProperties;
        id<LYRUIChoiceProperties> defaultChoiceProperties;
        NSDictionary *states = choiceProperties[@"states"];
        if (states != nil && [states isKindOfClass:[NSDictionary class]]) {
            selectedChoiceProperties = [self choicePropertiesWithDictionary:states[@"selected"]];
            defaultChoiceProperties = [self choicePropertiesWithDictionary:states[@"default"]];
        }
        
        LYRUIChoice *choice = [[LYRUIChoice alloc] initWithIdentifier:choiceProperties[@"id"]
                                                                 text:choiceProperties[@"text"]
                                                              tooltip:choiceProperties[@"tooltip"]
                                                   customResponseData:choiceProperties[@"custom_response_data"]
                                               defaultStateProperties:defaultChoiceProperties
                                              selectedStateProperties:selectedChoiceProperties];
        [serializedChoices addObject:choice];
    }
    
    NSString *title = messagePart.properties[@"title"] ?: @"Choose One";
    
    LYRUIMessageType *contentMessage;
    if (messagePart.properties[@"label"] != nil) {
        contentMessage = [[LYRUITextMessage alloc] initWithText:messagePart.properties[@"label"]
                                                          title:title];
    }
    
    NSString *responseName = messagePart.properties[@"response_name"] ?: @"selection";
    
    LYRUIORSet *selectionsSet;
    LYRMessagePart *responseSummaryPart = [messagePart childPartWithRole:@"response_summary"];
    if (responseSummaryPart != nil) {
        selectionsSet = [self selectionsSetFromResponseSummary:responseSummaryPart.properties
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
                                   preselectedChoice:messagePart.properties[@"preselected_choice"]
                                       selectionsSet:selectionsSet
                                   responseMessageId:[messagePart.message.identifier absoluteString]
                                      responseNodeId:messagePart.nodeId
                                              action:[self.actionSerializer actionFromProperties:messagePart.properties]
                                              sender:messagePart.message.sender
                                              sentAt:messagePart.message.sentAt
                                              status:[self statusWithMessage:messagePart.message]];
}

- (id<LYRUIChoiceProperties>)choicePropertiesWithDictionary:(NSDictionary *)dictionary {
    if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[LYRUIChoice alloc] initWithText:dictionary[@"text"]
                                     tooltip:dictionary[@"tooltip"]];
}

- (LYRUIChoiceMessageType)choiceMessageTypeWithString:(NSString *)string {
    if ([string isEqualToString:@"label"]) {
        return LYRUIChoiceMessageTypeLabel;
    }
    return LYRUIChoiceMessageTypeDefault;
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

- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUIChoiceMessage *)messageType
                                                    parentNodeId:(NSString *)parentNodeId
                                                            role:(NSString *)role {
    NSMutableArray *choices = [[NSMutableArray alloc] init];
    for (LYRUIChoice *choice in messageType.choices) {
        NSMutableDictionary *choiceJson = [[NSMutableDictionary alloc] init];
        choiceJson[@"id"] = choice.identifier;
        choiceJson[@"text"] = choice.text;
        choiceJson[@"tooltip"] = choice.tooltip;
        choiceJson[@"custom_response_data"] = choice.customResponseData;
        NSMutableDictionary *states = [[NSMutableDictionary alloc] init];
        states[@"default"] = [self dictionaryForChoiceProperties:choice.defaultStateProperties];
        states[@"selected"] = [self dictionaryForChoiceProperties:choice.selectedStateProperties];
        if (states.allKeys.count > 0) {
            choiceJson[@"states"] = states;
        }
        [choices addObject:choiceJson];
    }
    
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
    messageJson[@"preselected_choice"] = messageType.preselectedChoice;
    [messageJson addEntriesFromDictionary:[self.actionSerializer propertiesForAction:messageType.action]];
    
    NSError *error = nil;
    NSData *messageJsonData = [NSJSONSerialization dataWithJSONObject:messageJson options:0 error:&error];
    if (error) {
        NSLog(@"Failed to serialize choice message JSON object: %@", error);
        return nil;
    }
    NSString *MIMEType = [self MIMETypeForContentType:messageType.MIMEType parentNodeId:parentNodeId role:role];
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithMIMEType:MIMEType data:messageJsonData];
    return @[messagePart];
}

- (NSDictionary *)dictionaryForChoiceProperties:(id<LYRUIChoiceProperties>)choiceProperties {
    if (choiceProperties == nil) {
        return nil;
    }
    
    NSMutableDictionary *choicePropertiesDictionary = [[NSMutableDictionary alloc] init];
    choicePropertiesDictionary[@"text"] = choiceProperties.text;
    choicePropertiesDictionary[@"tooltip"] = choiceProperties.tooltip;
    return choicePropertiesDictionary;
}

- (NSString *)stringForChoiceMessageType:(LYRUIChoiceMessageType)type {
    switch (type) {
        case LYRUIChoiceMessageTypeDefault:
            return @"default";
        case LYRUIChoiceMessageTypeLabel:
            return @"label";
    }
}

- (LYRMessageOptions *)messageOptionsForTypedMessage:(LYRUIMessageType *)messageType {
    LYRMessageOptions *messageOptions = [self defaultMessageOptionsWithPushNotificationText:@"sent you choice message."];
    return messageOptions;
}

@end
