//
//  LYRUIBaseChoiceSelectionHandler.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 18.01.2018.
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

#import "LYRUIBaseChoiceSelectionHandler.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIChoiceSet.h"
#import "LYRUIChoiceButton.h"
#import "LYRUIChoice.h"
#import "LYRUIMessageListActionHandlingDelegate.h"
#import "LYRUIORSetsCache.h"

@interface LYRUIBaseChoiceSelectionHandler ()

@property (nonatomic, strong, readwrite) id<LYRUIChoiceSet> choiceSet;
@property (nonatomic, strong, readwrite) LYRUIORSet *selectionsSet;
@property (nonatomic, strong) LYRUIORSetsCache *setsCache;

@end

@implementation LYRUIBaseChoiceSelectionHandler
@synthesize buttons = _buttons,
            actionHandlingDelegate = _actionHandlingDelegate,
            layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    self.setsCache = [layerConfiguration.injector objectOfType:[LYRUIORSetsCache class]];
}

- (instancetype)initWithChoiceSet:(id<LYRUIChoiceSet>)choiceSet configuration:(LYRUIConfiguration *)configuration {
    self = [self initWithConfiguration:configuration];
    if (self) {
        self.choiceSet = choiceSet;
        self.selectionsSet = [self.setsCache ORSetForChoiceSet:choiceSet];
        [self.selectionsSet synchronizeWithSet:choiceSet.selectionsSet ?: choiceSet.initialResponseState];
    }
    return self;
}

#pragma mark - Properties

- (NSOrderedSet<NSString *> *)selectedIdentifiers {
    return self.selectionsSet.selectedValues;
}

- (void)setButtons:(NSArray<LYRUIChoiceButton *> *)buttons {
    _buttons = buttons;
    NSString *userID = self.layerConfiguration.client.authenticatedUser.identifier.absoluteString;
    if (![self.choiceSet.enabledFor containsObject:userID]) {
        for (LYRUIChoiceButton *button in buttons) {
            button.selected = NO;
            button.enabled = NO;
        }
    }
}

#pragma mark - Public methods

- (void)buttonTapped:(LYRUIChoiceButton *)tappedButton {}

- (void)choiceWithIdentifier:(NSString *)identifier selected:(BOOL)selected {
    if (identifier == nil) {
        return;
    }
    NSMutableArray<NSDictionary *> *changes = [[NSMutableArray alloc] init];
    if (selected) {
        LYRUIOROperation *operation = [[LYRUIOROperation alloc] initWithValue:identifier];
        NSArray *operationDicts = [self.selectionsSet addOperation:operation];
        if (operationDicts != nil) {
            [changes addObjectsFromArray:operationDicts];
        }
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"value == %@", identifier];
        NSOrderedSet<LYRUIOROperation *> *operationsWithValue = [self.selectionsSet.adds filteredOrderedSetUsingPredicate:predicate];
        for (LYRUIOROperation *operation in operationsWithValue) {
            NSArray *operationDicts = [self.selectionsSet removeOperationWithID:operation.operationID];
            if (operationDicts != nil) {
                [changes addObjectsFromArray:operationDicts];
            }
        }
    }
    [self.setsCache storeORSet:self.selectionsSet forChoiceSet:self.choiceSet];
    
    LYRUIChoice *choice;
    for (LYRUIChoice *aChoice in self.choiceSet.choices) {
        if ([aChoice.identifier isEqualToString:identifier]) {
            choice = aChoice;
        }
    }
    
    [self sendActionForChoice:choice changes:changes selection:selected];
}

- (void)sendActionForChoice:(LYRUIChoice *)choice changes:(NSArray *)changes selection:(BOOL)selected {
    NSMutableDictionary *participantData = [[NSMutableDictionary alloc] init];
    [participantData addEntriesFromDictionary:self.choiceSet.customResponseData];
    [participantData addEntriesFromDictionary:choice.customResponseData];
    
    NSMutableDictionary *actionData = [[NSMutableDictionary alloc] init];
    actionData[@"response_to"] = self.choiceSet.responseMessageId;
    actionData[@"response_to_node_id"] = self.choiceSet.responseNodeId;
    actionData[@"changes"] = changes;
    actionData[@"participant_data"] = participantData;
    actionData[@"text"] = [self responseMessageTextForSelecting:selected choice:choice];
    
    LYRUIMessageAction *action = [[LYRUIMessageAction alloc] initWithEvent:@"layer-choice-select" data:actionData];
    [self.actionHandlingDelegate handleAction:action withHandler:nil];
}

- (NSString *)responseMessageTextForSelecting:(BOOL)selected choice:(LYRUIChoice *)choice {
    NSString *senderName = self.layerConfiguration.client.authenticatedUser.displayName;
    NSString *selectionString = selected ? @"selected" : @"deselected";
    NSString *responseMessageText = [NSString stringWithFormat:@"%@ has %@ \"%@\"", senderName, selectionString, choice.text];
    if (self.choiceSet.name.length > 0) {
        responseMessageText = [responseMessageText stringByAppendingFormat:@" from \"%@\"", self.choiceSet.name];
    }
    return responseMessageText;
}

@end
