//
//  LYRUIButtonsMessageChoiceButton.h
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

#import "LYRUIButtonsMessageActionButton.h"
#import "LYRUIButtonsMessageButton.h"
#import "LYRUIChoice.h"
#import "LYRUIChoiceSet.h"
#import "LYRUIORSet.h"

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUIButtonsMessageChoiceButton : NSObject <LYRUIButtonsMessageButton, LYRUIChoiceSet>

- (instancetype)initWithChoices:(NSArray *)choices
                  allowDeselect:(BOOL)allowDeselect
                  allowReselect:(BOOL)allowReselect
               allowMultiselect:(BOOL)allowMultiselect
                           name:(nullable NSString *)name
                   responseName:(nullable NSString *)responseName
                     enabledFor:(NSSet<NSString *> *)enabledFor
           initialResponseState:(nullable LYRUIORSet *)initialResponseState
                  selectionsSet:(nullable LYRUIORSet *)selectionsSet
              responseMessageId:(nullable NSString *)responseMessageId
                 responseNodeId:(nullable NSString *)responseNodeId;

- (instancetype)initWithChoices:(NSArray *)choices
                  allowDeselect:(BOOL)allowDeselect
                  allowReselect:(BOOL)allowReselect
               allowMultiselect:(BOOL)allowMultiselect
                           name:(nullable NSString *)name
                   responseName:(NSString *)responseName
                     enabledFor:(NSString *)enabledFor
                 selectedChoice:(nullable NSString *)selectedChoice;

@end
NS_ASSUME_NONNULL_END       // }
