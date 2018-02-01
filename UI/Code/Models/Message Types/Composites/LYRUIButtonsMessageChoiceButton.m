//
//  LYRUIButtonsMessageChoiceButton.m
//  Layer-UI-iOS
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

#import "LYRUIButtonsMessageChoiceButton.h"

@interface LYRUIButtonsMessageChoiceButton ()

@property (nonatomic, readwrite, nonnull) NSArray<LYRUIChoice *> *choices;
@property (nonatomic, readwrite) BOOL allowReselect;
@property (nonatomic, readwrite) BOOL allowDeselect;
@property (nonatomic, readwrite) BOOL allowMultiselect;
@property (nonatomic, readwrite) NSString *responseName;
@property (nonatomic, readwrite) NSString *preselectedChoice;
@property (nonatomic, readwrite) NSOrderedSet<NSString *> *selectedChoices;
@property (nonatomic, readwrite, nonnull) NSString *responseMessageId;
@property (nonatomic, readwrite, nonnull) NSString *responseNodeId;

@end

@implementation LYRUIButtonsMessageChoiceButton
@synthesize customResponseData = _customResponseData,
            title = _title;

- (instancetype)initWithChoices:(NSArray *)choices
                  allowDeselect:(BOOL)allowDeselect
                  allowReselect:(BOOL)allowReselect
               allowMultiselect:(BOOL)allowMultiselect
                   responseName:(NSString *)responseName
              preselectedChoice:(NSString *)preselectedChoice
                selectedChoices:(NSOrderedSet<NSString *> *)selectedChoices
              responseMessageId:(NSString *)responseMessageId
                 responseNodeId:(NSString *)responseNodeId {
    self = [super init];
    if (self) {
        self.choices = choices;
        self.allowDeselect = allowDeselect;
        self.allowReselect = allowReselect;
        self.allowMultiselect = allowMultiselect;
        self.responseName = responseName;
        self.preselectedChoice = preselectedChoice;
        self.selectedChoices = selectedChoices;
        self.responseMessageId = responseMessageId;
        self.responseNodeId = responseNodeId;
    }
    return self;
}

- (NSString *)type {
    return @"choice";
}

@end
