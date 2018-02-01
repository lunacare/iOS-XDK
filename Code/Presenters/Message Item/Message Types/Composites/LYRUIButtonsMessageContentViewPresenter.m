//
//  LYRUIButtonsMessageContentViewPresenter.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 13.10.2017.
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

#import "LYRUIButtonsMessageContentViewPresenter.h"
#import "LYRUIButtonsMessageCompositeView.h"
#import "LYRUIButtonsMessage.h"
#import "LYRUIMessageItemContentPresentersProvider.h"
#import "LYRUIReusableViewsQueue.h"
#import "UIImage+LYRUIColorImage.h"
#import "UIButton+LYRUIBlockAction.h"
#import "LYRUIButtonsMessageActionButton.h"
#import "LYRUIButtonsMessageChoiceButton.h"
#import "LYRUIChoiceView.h"

#import "LYRUIChoiceSingleSelectionHandler.h"
#import "LYRUIChoiceSingleReSelectionHandler.h"
#import "LYRUIChoiceMultiSelectionHandler.h"

@implementation LYRUIButtonsMessageContentViewPresenter

- (UIView *)viewForMessage:(LYRUIButtonsMessage *)message {
    LYRUIButtonsMessageCompositeView *buttonsCompositeView = [self.reusableViewsQueue dequeueReusableViewOfType:[LYRUIButtonsMessageCompositeView class]];
    if (buttonsCompositeView == nil) {
        buttonsCompositeView = [[LYRUIButtonsMessageCompositeView alloc] init];
    }
    
    buttonsCompositeView.actionHandlingDelegate = self.actionHandlingDelegate;
    [self setupButtonsMessageView:buttonsCompositeView withMessage:message];
    [self setContentViewInContainer:buttonsCompositeView forMessage:message];
    
    return buttonsCompositeView;
}

- (void)setContentViewInContainer:(id<LYRUIMessageViewContainer>)container forMessage:(LYRUIButtonsMessage *)message {
    if (message.contentMessage != nil && container != nil) {
        id<LYRUIMessageItemContentPresenting> presenter = [self contentViewConfigurationForMessage:message.contentMessage];
        container.contentView = [presenter viewForMessage:message.contentMessage];
    }
}

- (void)setupButtonsMessageView:(LYRUIButtonsMessageCompositeView *)buttonsMessageView withMessage:(LYRUIButtonsMessage *)message {
    for (UIControl *button in [buttonsMessageView.buttonsStackView.subviews copy]) {
        [button removeFromSuperview];
    }
    for (id<LYRUIButtonsMessageButton> button in message.buttons) {
        if ([button.type isEqualToString:@"action"]) {
            [self addActionButton:button inButtonsMessageView:buttonsMessageView];
        } else if ([button.type isEqualToString:@"choice"]) {
            [self addChoiceButton:button inButtonsMessageView:buttonsMessageView];
        }
    }
}

- (void)addActionButton:(LYRUIButtonsMessageActionButton *)actionButton inButtonsMessageView:(LYRUIButtonsMessageCompositeView *)buttonsMessageView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];
    [button setTitleColor:[UIColor colorWithRed:16.0/255.0 green:148.0/255.0 blue:208.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:25.0/255.0 green:165.0/255.0 blue:228.0/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    [button setTitle:actionButton.title forState:UIControlStateNormal];
    __weak __typeof(self) weakSelf = self;
    LYRUIMessageAction *action = actionButton.action;
    button.lyr_actionHandler = ^(UIButton *pressedButton) {
        [weakSelf.actionHandlingDelegate handleAction:action withHandler:nil];
    };
    
    [self addButton:button inButtonsMessageView:buttonsMessageView];
}

- (void)addChoiceButton:(LYRUIButtonsMessageChoiceButton *)choiceButton inButtonsMessageView:(LYRUIButtonsMessageCompositeView *)buttonsMessageView {
    LYRUIChoiceView *choiceView = [[LYRUIChoiceView alloc] init];
    choiceView.axis = LYRUIChoiceViewAxisHorizontal;
    choiceView.numberOfButtons = choiceButton.choices.count;
    
    for (NSUInteger i = 0; i < choiceView.numberOfButtons; i += 1) {
        LYRUIChoiceButton *button = choiceView.buttons[i];
        LYRUIChoice *choice = choiceButton.choices[i];
        [button setTitle:choice.title forState:UIControlStateNormal];
        button.choiceIdentifier = choice.identifier;
    }
    
    Class<LYRUIChoiceSelectionHandling> handlerClass;
    if (choiceButton.allowMultiselect) {
        handlerClass = [LYRUIChoiceMultiSelectionHandler class];
    } else if (choiceButton.allowReselect) {
        handlerClass = [LYRUIChoiceSingleReSelectionHandler class];
    } else {
        handlerClass = [LYRUIChoiceSingleSelectionHandler class];
    }
    choiceView.selectionHandler = [[[handlerClass class] alloc] initWithChoiceSet:choiceButton configuration:self.layerConfiguration];
    choiceView.selectionHandler.actionHandlingDelegate = self.actionHandlingDelegate;
    
    [self addButton:choiceView inButtonsMessageView:buttonsMessageView];
}

- (void)addButton:(UIView *)button inButtonsMessageView:(LYRUIButtonsMessageCompositeView *)buttonsMessageView {
    [button.heightAnchor constraintEqualToConstant:48.0].active = YES;
    [buttonsMessageView.buttonsStackView addArrangedSubview:button];
}

- (CGFloat)viewHeightForMessage:(LYRUIButtonsMessage *)message minWidth:(CGFloat)minWidth maxWidth:(CGFloat)maxWidth {
    CGFloat contentViewHeight = [self contentViewHeightForMessageType:message minWidth:minWidth maxWidth:maxWidth];
    CGFloat buttonsHeight = MAX((message.buttons.count * 49.0) - 1.0, 0.0);
    return buttonsHeight + contentViewHeight;
}

- (CGFloat)contentViewHeightForMessageType:(LYRUIButtonsMessage *)messageType minWidth:(CGFloat)minWidth maxWidth:(CGFloat)maxWidth {
    CGFloat contentViewHeight = 0.0;
    if (messageType.contentMessage != nil) {
        id<LYRUIMessageItemContentPresenting> presenter = [self contentViewConfigurationForMessage:messageType.contentMessage];
        contentViewHeight = [presenter viewHeightForMessage:messageType.contentMessage minWidth:minWidth maxWidth:maxWidth] + 1.0;
    }
    return contentViewHeight;
}

#pragma mark - Properties

- (id<LYRUIMessageItemContentPresenting>)contentViewConfigurationForMessage:(LYRUIMessageType *)message {
    if (self.contentViewConfiguration) {
        return self.contentViewConfiguration;
    }
    return [self.presentersProvider presenterForMessageClass:[message class]];
}

- (void)setPresentersProvider:(LYRUIMessageItemContentPresentersProvider *)presentersProvider {
    [super setPresentersProvider:presentersProvider];
    self.contentViewConfiguration.presentersProvider = presentersProvider;
}

@end
