//
//  LYRUIChoiceSingleReSelectionHandler.m
//  Layer-UI-iOS
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

#import "LYRUIChoiceSingleReSelectionHandler.h"
#import "LYRUIChoiceSet.h"
#import "LYRUIChoiceButton.h"
#import "LYRUIChoice.h"

@implementation LYRUIChoiceSingleReSelectionHandler

- (void)buttonTapped:(LYRUIChoiceButton *)tappedButton {
    for (UIButton *button in self.buttons) {
        if ((button == tappedButton) && self.choiceSet.allowDeselect) {
            button.enabled = YES;
            button.selected = !button.selected;
        } else {
            button.enabled = (button != tappedButton);
            button.selected = (button == tappedButton);
        }
    }
    [self choiceWithIdentifier:tappedButton.choiceIdentifier selected:tappedButton.selected];
}

- (void)setButtons:(NSArray<LYRUIChoiceButton *> *)buttons {
    [super setButtons:buttons];
    if (self.selectedIdentifiers.count == 0) {
        return;
    }
    for (LYRUIChoiceButton *button in buttons) {
        button.selected = [self.selectedIdentifiers containsObject:button.choiceIdentifier];
        button.enabled = !self.choiceSet.allowDeselect || !button.selected;
    }
}

- (void)choiceWithIdentifier:(NSString *)identifier selected:(BOOL)selected {
    if (identifier == nil) {
        return;
    }
    if (selected) {
        [self.selectedIdentifiers removeAllObjects];
    }
    [super choiceWithIdentifier:identifier selected:selected];
}

@end
