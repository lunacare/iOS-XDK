//
//  UIButton+LYRUIBlockAction.m
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

#import "UIButton+LYRUIBlockAction.h"
#import "NSObject+LYRUIObjectAssociation.h"

static void *LYRUIButtonActionKey = &LYRUIButtonActionKey;

@implementation UIButton (LYRUIBlockAction)

- (void)lyr_handleAction:(UIButton *)button {
    if (self.lyr_actionHandler) {
        self.lyr_actionHandler(self);
    }
}

- (void (^)(UIButton *))lyr_actionHandler {
    return [self lyr_getAssociatedPropertyWithKey:LYRUIButtonActionKey];
}

- (void)setLyr_actionHandler:(void (^)(UIButton *))lyr_actionHandler {
    if (lyr_actionHandler == nil && [self lyr_actionAndTargetIsSet]) {
        [self removeTarget:self action:@selector(lyr_handleAction:) forControlEvents:UIControlEventTouchUpInside];
    } else if (lyr_actionHandler != nil && ![self lyr_actionAndTargetIsSet]) {
        [self addTarget:self action:@selector(lyr_handleAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self lyr_setAssociatedPropertyWithKey:LYRUIButtonActionKey object:lyr_actionHandler];
}

- (BOOL)lyr_actionAndTargetIsSet {
    NSString *selectorString = NSStringFromSelector(@selector(lyr_handleAction:));
    return [self.allTargets containsObject:self] &&
        [[self actionsForTarget:self forControlEvent:UIControlEventTouchUpInside] containsObject:selectorString];
}

@end
