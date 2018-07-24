//
//  LYRUIChoiceMessage.m
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

#import "LYRUIChoiceMessage.h"
#import "LYRUIChoiceSelectionsSetFactory.h"

@interface LYRUIChoiceMessage ()

@property (nonatomic, copy, readwrite, nullable) NSString *title;
@property (nonatomic, copy, readwrite, nullable) NSString *label;
@property (nonatomic, strong, readwrite, nullable) LYRUIMessageType *contentMessage;
@property (nonatomic, copy, readwrite) NSArray<LYRUIChoice *> *choices;
@property (nonatomic, readwrite) LYRUIChoiceMessageType type;
@property (nonatomic, readwrite) LYRUIChoiceMessageType expandedType;
@property (nonatomic, readwrite) BOOL allowReselect;
@property (nonatomic, readwrite) BOOL allowDeselect;
@property (nonatomic, readwrite) BOOL allowMultiselect;
@property (nonatomic, copy, readwrite, nullable) NSString *name;
@property (nonatomic, copy, readwrite, nullable) NSString *responseName;
@property (nonatomic, copy, readwrite, nullable) NSDictionary *customResponseData;
@property (nonatomic, copy, readwrite) NSSet<NSString *> *enabledFor;
@property (nonatomic, readwrite, nullable) LYRUIORSet *selectionsSet;
@property (nonatomic, readwrite, nonnull) NSString *responseMessageId;
@property (nonatomic, readwrite, nonnull) NSString *responseNodeId;

@end

@implementation LYRUIChoiceMessage

- (instancetype)initWithTitle:(NSString *)title
                        label:(NSString *)label
               contentMessage:(LYRUIMessageType *)contentMessage
                      choices:(NSArray<LYRUIChoice *> *)choices
                         type:(LYRUIChoiceMessageType)type
                 expandedType:(LYRUIChoiceMessageType)expandedType
                allowReselect:(BOOL)allowReselect
                allowDeselect:(BOOL)allowDeselect
             allowMultiselect:(BOOL)allowMultiselect
                         name:(NSString *)name
                 responseName:(NSString *)responseName
           customResponseData:(NSDictionary *)customResponseData
                   enabledFor:(NSSet<NSString *> *)enabledFor
         initialResponseState:(LYRUIORSet *)initialResponseState
                selectionsSet:(LYRUIORSet *)selectionsSet
            responseMessageId:(NSString *)responseMessageId
               responseNodeId:(NSString *)responseNodeId
                       action:(LYRUIMessageAction *)action
                       sender:(LYRIdentity *)sender
                       sentAt:(NSDate *)sentAt
                       status:(LYRUIMessageTypeStatus *)status
                  messagePart:(nullable LYRMessagePart *)messagePart {
    self = [super initWithInitialResponseState:initialResponseState
                                        action:action
                                        sender:sender
                                        sentAt:sentAt
                                        status:status
                                   messagePart:messagePart];
    if (self) {
        self.title = title;
        self.label = label;
        self.contentMessage = contentMessage;
        self.choices = choices;
        self.type = type;
        self.expandedType = expandedType;
        self.allowReselect = allowReselect;
        self.allowDeselect = allowDeselect;
        self.allowMultiselect = allowMultiselect;
        self.name = name;
        self.responseName = responseName ?: @"selection";
        self.enabledFor = enabledFor;
        self.customResponseData = customResponseData;
        self.selectionsSet = selectionsSet;
        self.responseMessageId = responseMessageId;
        self.responseNodeId = responseNodeId;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                        label:(NSString *)label
                      choices:(NSArray<LYRUIChoice *> *)choices
                         type:(LYRUIChoiceMessageType)type
                 expandedType:(LYRUIChoiceMessageType)expandedType
                allowReselect:(BOOL)allowReselect
                allowDeselect:(BOOL)allowDeselect
             allowMultiselect:(BOOL)allowMultiselect
                         name:(NSString *)name
                 responseName:(NSString *)responseName
           customResponseData:(NSDictionary *)customResponseData
                   enabledFor:(NSString *)enabledFor
               selectedChoice:(NSString *)selectedChoice
                  messagePart:(nullable LYRMessagePart *)messagePart {
    if (responseName == nil) {
        responseName = @"selection";
    }
    LYRUIORSet *initialResponseState;
    if (selectedChoice) {
        initialResponseState = [[[LYRUIChoiceSelectionsSetFactory alloc] init] selectionsSetWithResponseName:responseName
                                                                                               allowReselect:allowReselect
                                                                                               allowDeselect:allowDeselect
                                                                                            allowMultiselect:allowMultiselect];
        LYRUIOROperation *operation = [[LYRUIOROperation alloc] initWithValue:selectedChoice];
        [initialResponseState addOperation:operation];
    }
    self = [self initWithTitle:title
                         label:label
                contentMessage:nil
                       choices:choices
                          type:type
                  expandedType:expandedType
                 allowReselect:allowReselect
                 allowDeselect:allowDeselect
              allowMultiselect:allowMultiselect
                          name:name
                  responseName:responseName
            customResponseData:customResponseData
                    enabledFor:[NSSet setWithObjects:enabledFor, nil]
          initialResponseState:initialResponseState
                 selectionsSet:nil
             responseMessageId:nil
                responseNodeId:nil
                        action:nil
                        sender:nil
                        sentAt:nil
                        status:nil
                   messagePart:messagePart];
    return self;
}

+ (NSString *)MIMEType {
    return @"application/vnd.layer.choice+json";
}

- (NSString *)summary {
    return self.title ?: @"Choice";
}

@end
