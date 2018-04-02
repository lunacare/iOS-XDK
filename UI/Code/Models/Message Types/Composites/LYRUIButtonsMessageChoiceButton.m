//
//  LYRUIButtonsMessageChoiceButton.m
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

#import "LYRUIButtonsMessageChoiceButton.h"
#import "LYRUIChoiceSelectionsSetFactory.h"

@interface LYRUIButtonsMessageChoiceButton ()

@property (nonatomic, readwrite, nonnull) NSArray<LYRUIChoice *> *choices;
@property (nonatomic, readwrite) BOOL allowReselect;
@property (nonatomic, readwrite) BOOL allowDeselect;
@property (nonatomic, readwrite) BOOL allowMultiselect;
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSString *responseName;
@property (nonatomic, copy, readwrite) NSSet<NSString *> *enabledFor;
@property (nonatomic, readwrite) LYRUIORSet *initialResponseState;
@property (nonatomic, readwrite) LYRUIORSet *selectionsSet;
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
                           name:(NSString *)name
                   responseName:(NSString *)responseName
                     enabledFor:(NSSet<NSString *> *)enabledFor
           initialResponseState:(LYRUIORSet *)initialResponseState
                  selectionsSet:(LYRUIORSet *)selectionsSet
              responseMessageId:(NSString *)responseMessageId
                 responseNodeId:(NSString *)responseNodeId {
    self = [super init];
    if (self) {
        self.choices = choices;
        self.allowDeselect = allowDeselect;
        self.allowReselect = allowReselect;
        self.allowMultiselect = allowMultiselect;
        self.name = name;
        self.responseName = responseName ?: @"selected";
        self.enabledFor = enabledFor;
        self.initialResponseState = initialResponseState;
        self.selectionsSet = selectionsSet;
        self.responseMessageId = responseMessageId;
        self.responseNodeId = responseNodeId;
    }
    return self;
}

- (instancetype)initWithChoices:(NSArray *)choices
                  allowDeselect:(BOOL)allowDeselect
                  allowReselect:(BOOL)allowReselect
               allowMultiselect:(BOOL)allowMultiselect
                           name:(NSString *)name
                   responseName:(NSString *)responseName
                     enabledFor:(NSString *)enabledFor
                 selectedChoice:(NSString *)selectedChoice {
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
    self = [self initWithChoices:choices
                   allowDeselect:allowDeselect
                   allowReselect:allowReselect
                allowMultiselect:allowMultiselect
                            name:name
                    responseName:responseName
                      enabledFor:[NSSet setWithObjects:enabledFor, nil]
            initialResponseState:initialResponseState
                   selectionsSet:nil
               responseMessageId:nil
                  responseNodeId:nil];
    return self;
}

- (NSString *)type {
    return @"choice";
}

@end
