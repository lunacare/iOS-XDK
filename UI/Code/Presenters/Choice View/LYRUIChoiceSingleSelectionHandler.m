//
//  LYRUIChoiceSingleSelectionHandler.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 16.01.2018.
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

#import "LYRUIChoiceSingleSelectionHandler.h"
#import "LYRUIChoiceSet.h"
#import "LYRUIChoiceButton.h"
#import "LYRUIChoice.h"

@implementation LYRUIChoiceSingleSelectionHandler

- (void)buttonTapped:(LYRUIChoiceButton *)tappedButton {
    if (self.choiceSet.allowDeselect) {
        BOOL choiceSelected = !tappedButton.selected;
        for (UIButton *button in self.buttons) {
            button.enabled = ((button == tappedButton) || !choiceSelected);
            button.selected = (button == tappedButton) && choiceSelected;
        }
    } else {
        for (LYRUIChoiceButton *button in self.buttons) {
            button.enabled = NO;
            button.selected = (button == tappedButton);
        }
    }
    [self choiceWithIdentifier:tappedButton.choiceIdentifier selected:tappedButton.selected];
}

- (void)setButtons:(NSArray<LYRUIChoiceButton *> *)buttons {
    [super setButtons:buttons];
    NSString *userID = self.layerConfiguration.client.authenticatedUser.identifier.absoluteString;
    if (self.selectedIdentifiers.count == 0 || ![self.choiceSet.enabledFor containsObject:userID]) {
        return;
    }
    for (LYRUIChoiceButton *button in buttons) {
        button.selected = [self.selectedIdentifiers containsObject:button.choiceIdentifier];
        button.enabled = self.choiceSet.allowDeselect && button.selected;
    }
}

@end
