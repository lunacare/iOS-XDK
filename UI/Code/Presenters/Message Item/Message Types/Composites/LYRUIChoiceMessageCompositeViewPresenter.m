//
//  LYRUIChoiceMessageCompositeViewPresenter.m
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

#import "LYRUIChoiceMessageCompositeViewPresenter.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUITitledMessageContainerViewPresenter.h"
#import "LYRUIChoiceMessageCompositeView.h"
#import "LYRUIChoiceMessage.h"
#import "LYRUIReusableViewsQueue.h"
#import "LYRUIChoiceView.h"
#import "LYRUIChoiceSingleSelectionHandler.h"
#import "LYRUIChoiceSingleReSelectionHandler.h"
#import "LYRUIChoiceMultiSelectionHandler.h"
#import "LYRUIChoiceSet.h"
#import "LYRUIImageCreating.h"

@implementation LYRUIChoiceMessageCompositeViewPresenter

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    [super setLayerConfiguration:layerConfiguration];
    
    id<LYRUIImageCreating> imageFactory = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIImageCreating)
                                                                                     forClass:[self class]];
    UIImage *choiceIcon = [imageFactory imageNamed:@"Choice"];
    
    LYRUITitledMessageContainerViewPresenter *titledContainerPresenter =
        [layerConfiguration.injector objectOfType:[LYRUITitledMessageContainerViewPresenter class]];
    titledContainerPresenter.iconImage = choiceIcon;
    self.contentViewConfiguration = titledContainerPresenter;
}

- (UIView *)viewForMessage:(LYRUIChoiceMessage *)message {
    LYRUIChoiceMessageCompositeView *choiceCompositeView = [self.reusableViewsQueue dequeueReusableViewOfType:[LYRUIChoiceMessageCompositeView class]];
    if (choiceCompositeView == nil) {
        choiceCompositeView = [[LYRUIChoiceMessageCompositeView alloc] init];
    }
    
    [self setupChoiceView:choiceCompositeView.choiceView withMessage:message];
    [self setContentViewInContainer:choiceCompositeView forMessage:message];
    
    __weak __typeof(self) weakSelf = self;
    choiceCompositeView.actionHandler = ^(LYRUIMessageAction *action) {
        [weakSelf.actionHandlingDelegate handleAction:action withHandler:nil];
    };
    return choiceCompositeView;
}

- (void)setupChoiceView:(LYRUIChoiceView *)choiceView withMessage:(id<LYRUIChoiceSet>)choiceSet {
    choiceView.numberOfButtons = choiceSet.choices.count;
    
    for (NSUInteger i = 0; i < choiceView.numberOfButtons; i += 1) {
        LYRUIChoiceButton *button = choiceView.buttons[i];
        LYRUIChoice *choice = choiceSet.choices[i];
        [button setTitle:choice.title forState:UIControlStateNormal];
        button.choiceIdentifier = choice.identifier;
    }
    
    Class<LYRUIChoiceSelectionHandling> handlerClass;
    if (choiceSet.allowMultiselect) {
        handlerClass = [LYRUIChoiceMultiSelectionHandler class];
    } else if (choiceSet.allowReselect || choiceSet.allowDeselect) {
        handlerClass = [LYRUIChoiceSingleReSelectionHandler class];
    } else {
        handlerClass = [LYRUIChoiceSingleSelectionHandler class];
    }
    choiceView.selectionHandler = [[[handlerClass class] alloc] initWithChoiceSet:choiceSet configuration:self.layerConfiguration];
    
    choiceView.selectionHandler.actionHandlingDelegate = self.actionHandlingDelegate;
}

- (CGFloat)viewHeightForMessage:(LYRUIChoiceMessage *)message minWidth:(CGFloat)minWidth maxWidth:(CGFloat)maxWidth {
    CGFloat contentViewHeight = [self contentViewHeightForMessageType:message minWidth:minWidth maxWidth:maxWidth];
    CGFloat buttonsHeight = MAX((message.choices.count * 49.0) - 1.0, 0.0);
    return buttonsHeight + contentViewHeight;
}

@end
