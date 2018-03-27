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
#import "LYRUIChoiceSelectionsCache.h"

@interface LYRUIBaseChoiceSelectionHandler ()

@property (nonatomic, strong, readwrite) id<LYRUIChoiceSet> choiceSet;
@property (nonatomic, strong, readwrite) NSMutableOrderedSet<NSString *> *selectedIdentifiers;
@property (nonatomic, strong) LYRUIChoiceSelectionsCache *selectionsCache;

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
    self.selectionsCache = [layerConfiguration.injector objectOfType:[LYRUIChoiceSelectionsCache class]];
}

- (instancetype)initWithChoiceSet:(id<LYRUIChoiceSet>)choiceSet configuration:(LYRUIConfiguration *)configuration {
    self = [self initWithConfiguration:configuration];
    if (self) {
        self.choiceSet = choiceSet;
        NSMutableOrderedSet *cachedSelections = [[self.selectionsCache selectionsForChoiceSet:choiceSet] mutableCopy];
        self.selectedIdentifiers = cachedSelections ?: [choiceSet.selectedChoices mutableCopy] ?: [[NSMutableOrderedSet alloc] init];
    }
    return self;
}

- (void)buttonTapped:(LYRUIChoiceButton *)tappedButton {}

- (void)choiceWithIdentifier:(NSString *)identifier selected:(BOOL)selected {
    if (identifier == nil) {
        return;
    }
    if (selected) {
        [self.selectedIdentifiers addObject:identifier];
    } else {
        [self.selectedIdentifiers removeObject:identifier];
    }
    [self.selectionsCache setSelections:self.selectedIdentifiers forChoiceSet:self.choiceSet];
    
    LYRUIChoice *choice;
    for (LYRUIChoice *aChoice in self.choiceSet.choices) {
        if ([aChoice.identifier isEqualToString:identifier]) {
            choice = aChoice;
        }
    }
    
    [self sendActionForChoice:choice selection:selected];
}

- (void)sendActionForChoice:(LYRUIChoice *)choice selection:(BOOL)selected {
    NSMutableDictionary *participantData = [[NSMutableDictionary alloc] init];
    NSString *responseName = self.choiceSet.responseName;
    [participantData addEntriesFromDictionary:self.choiceSet.customResponseData];
    participantData[responseName] = [self.selectedIdentifiers.array componentsJoinedByString:@","];
    [participantData addEntriesFromDictionary:choice.customResponseData];
    
    NSMutableDictionary *actionData = [[NSMutableDictionary alloc] init];
    actionData[@"response_to"] = self.choiceSet.responseMessageId;
    actionData[@"response_to_node_id"] = self.choiceSet.responseNodeId;
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
