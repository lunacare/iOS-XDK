//
//  LYRUIChoiceMessage.h
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

#import "LYRUIButtonsMessage.h"
#import "LYRUIChoice.h"
#import "LYRUIChoiceSet.h"

typedef NS_ENUM(NSUInteger, LYRUIChoiceMessageType) {
    LYRUIChoiceMessageTypeDefault,
    LYRUIChoiceMessageTypeLabel,
};

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUIChoiceMessage : LYRUIButtonsMessage <LYRUIChoiceSet>

@property (nonatomic, strong, readonly, nullable) NSString *title;
@property (nonatomic, strong, readonly, nullable) NSString *label;
@property (nonatomic, readonly) LYRUIChoiceMessageType type;
@property (nonatomic, readonly) LYRUIChoiceMessageType expandedType;

- (instancetype)initWithTitle:(nullable NSString *)title
                        label:(nullable NSString *)label
               contentMessage:(nullable LYRUIMessageType *)contentMessage
                      choices:(NSArray<LYRUIChoice *> *)choices
                         type:(LYRUIChoiceMessageType)type
                 expandedType:(LYRUIChoiceMessageType)expandedType
                allowReselect:(BOOL)allowReselect
                allowDeselect:(BOOL)allowDeselect
             allowMultiselect:(BOOL)allowMultiselect
                         name:(nullable NSString *)name
                 responseName:(nullable NSString *)responseName
           customResponseData:(nullable NSDictionary *)customResponseData
            preselectedChoice:(nullable NSString *)preselectedChoice
              selectedChoices:(nullable NSOrderedSet<NSString *> *)selectedChoices
            responseMessageId:(NSString *)responseMessageId
               responseNodeId:(NSString *)responseNodeId
                       action:(nullable LYRUIMessageAction *)action
                       sender:(nullable LYRIdentity *)sender
                       sentAt:(nullable NSDate *)sentAt
                       status:(nullable LYRUIMessageTypeStatus *)status;

@end
NS_ASSUME_NONNULL_END       // }
