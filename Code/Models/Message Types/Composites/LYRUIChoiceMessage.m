//
//  LYRUIChoiceMessage.m
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

#import "LYRUIChoiceMessage.h"

@interface LYRUIChoiceMessage ()

@property (nonatomic, strong, readwrite, nullable) NSString *title;
@property (nonatomic, strong, readwrite, nullable) NSString *label;
@property (nonatomic, copy, readwrite) NSArray<LYRUIChoice *> *choices;
@property (nonatomic, readwrite) LYRUIChoiceMessageType type;
@property (nonatomic, readwrite) LYRUIChoiceMessageType expandedType;
@property (nonatomic, readwrite) BOOL allowReselect;
@property (nonatomic, readwrite) BOOL allowDeselect;
@property (nonatomic, readwrite) BOOL allowMultiselect;
@property (nonatomic, strong, readwrite, nullable) NSString *responseName;
@property (nonatomic, strong, readwrite, nullable) NSDictionary *customResponseData;
@property (nonatomic, strong, readwrite, nullable) NSString *preselectedChoice;
@property (nonatomic, strong, readwrite, nullable) NSOrderedSet<NSString *> *selectedChoices;
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
                 responseName:(NSString *)responseName
           customResponseData:(NSDictionary *)customResponseData
            preselectedChoice:(NSString *)preselectedChoice
              selectedChoices:(NSOrderedSet<NSString *> *)selectedChoices
            responseMessageId:(NSString *)responseMessageId
               responseNodeId:(NSString *)responseNodeId
                       action:(LYRUIMessageAction *)action
                       sender:(LYRIdentity *)sender
                       sentAt:(NSDate *)sentAt
                       status:(LYRUIMessageTypeStatus *)status {
    self = [super initWithButtons:choices
                   contentMessage:contentMessage
                           action:action
                           sender:sender
                           sentAt:sentAt
                           status:status];
    if (self) {
        self.title = title;
        self.label = label;
        self.choices = choices;
        self.type = type;
        self.expandedType = expandedType;
        self.allowReselect = allowReselect;
        self.allowDeselect = allowDeselect;
        self.allowMultiselect = allowMultiselect;
        self.responseName = responseName;
        self.customResponseData = customResponseData;
        self.preselectedChoice = preselectedChoice;
        self.selectedChoices = selectedChoices;
        self.responseMessageId = responseMessageId;
        self.responseNodeId = responseNodeId;
    }
    return self;
}

+ (NSString *)MIMEType {
    return @"application/vnd.layer.choice+json";
}

- (NSString *)summary {
    return self.title ?: @"Choice";
}

@end
