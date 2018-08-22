//
//  LYRUIFeedbackResponseMessageContainerViewPresenter.m
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 8/1/18.
//  Copyright (c) 2018 Layer. All rights reserved.
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

#import "LYRUILargeFeedbackResponseMessageContainerViewPresenter.h"
#import "LYRUIFeedbackMessage.h"
#import "LYRUIFeedbackResponseMessage.h"
#import "LYRUILargeFeedbackResponseMessageView.h"
#import "LYRUIReusableViewsQueue.h"
#import "LYRUIResponseMessage.h"
#import "LYRUIFWWRegister.h"
#import "UIButton+LYRUIBlockAction.h"
#import "LYRUIMessageListTimeFormatter.h"
#import "LYRUIConfiguration+DependencyInjection.h"

@implementation LYRUILargeFeedbackResponseMessageContainerViewPresenter

- (UIView *)viewForMessage:(LYRUIFeedbackResponseMessage *)message {
    LYRUILargeFeedbackResponseMessageView *view = [self.reusableViewsQueue dequeueReusableViewOfType:[LYRUILargeFeedbackResponseMessageView class]];
    if (view == nil) {
        view = [[LYRUILargeFeedbackResponseMessageView alloc] initWithConfiguration:self.layerConfiguration];
    }
    LYRUIFeedbackMessage *feedbackMessage = (LYRUIFeedbackMessage *)message.parentMessage;
    [self setupViewConstraints:view];

    LYRUIMessageListTimeFormatter *timeFormatter = [self.layerConfiguration.injector protocolImplementation:@protocol(LYRUITimeFormatting) forClass:[self class]];
    BOOL ratingEnabledForUser = [[feedbackMessage enabledFor] containsObject:[[[[[self layerConfiguration] client] authenticatedUser] identifier] absoluteString]];

    // Rating
    NSUInteger rating = [[message rating] unsignedIntegerValue];
    view.ratingContainer.rating = rating;

    // Prompt
    if ((nil == [message rating])) {
        if (ratingEnabledForUser) {
            view.enabled = YES;
            view.promptText = feedbackMessage.promptTemplate ?: @"Rate your experience 1-5 stars";
            view.commentPlaceholderText = feedbackMessage.placeholder ?: @"Add a comment";
        } else {
            view.enabled = NO;
            view.promptText = feedbackMessage.promptWaitTemplate ?: @"Waiting for Feedback";
            view.commentPlaceholderText = @"Comment";
        }
    } else {
        view.enabled = NO;
        view.promptText = [timeFormatter stringForTime:message.sentAt withCurrentTime:[NSDate date]];
        view.commentPlaceholderText = feedbackMessage.placeholder ?: @"Comment";
    }

    // Comment
    view.commentTextView.text = message.comment;

    // Submit Button
    __weak __typeof(view) weakView = view;
    view.sendButton.lyr_actionHandler = ^(UIButton *pressedButton) {
        __strong __typeof(weakView) strongView = weakView;
        if (strongView.ratingContainer.rating == LYRUIRatingNotDefined) {
            // Do nothing, in case the user didn't select any stars.
            return;
        }
        NSNumber *rating = @(strongView.ratingContainer.rating);
        NSString *comment = strongView.commentTextView.text;

        // Gather changes from the CRDT registers.
        LYRUIFWWRegister<NSNumber *> *ratingReg = [[LYRUIFWWRegister alloc] initWithPropertyName:@"rating"];
        [ratingReg addOperation:[[LYRUIOROperation alloc] initWithValue:rating]];

        LYRUIFWWRegister<NSString *> *commentReg = [[LYRUIFWWRegister alloc] initWithPropertyName:@"comment"];
        [commentReg addOperation:[[LYRUIOROperation alloc] initWithValue:comment]];

        NSMutableArray<NSDictionary<NSString *, id> *> *changes = [NSMutableArray array];
        [changes addObjectsFromArray:ratingReg.operationsDictionaries];
        if (comment.length) {
            [changes addObjectsFromArray:commentReg.operationsDictionaries];
        }

        NSMutableDictionary *actionData = [[NSMutableDictionary alloc] init];
        actionData[@"response_to"] = feedbackMessage.responseMessageId;
        actionData[@"response_to_node_id"] = feedbackMessage.responseNodeId;
        actionData[@"changes"] = changes;
        actionData[@"text"] = @"Rating submitted";

        LYRUIMessageAction *action = [[LYRUIMessageAction alloc] initWithEvent:@"layer-send-feedback" data:actionData];
        [self.actionHandlingDelegate handleAction:action withHandler:nil];

        // Disable the controls
        strongView.enabled = NO;
    };
    return view;
}

@end
