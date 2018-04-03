//
//  LYRUIConversationView.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 31.08.2017.
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

#import <UIKit/UIKit.h>
#import "LYRUIConfigurable.h"
#import "LYRUIViewWithLayout.h"
@class LYRUIConversationView;
@class LYRUIMessageListView;
@class LYRUIComposeBar;
@class LYRConversation;
@class LYRClient;
@class LYRQueryController;
@class LYRUIMessageSender;
@class LYRIdentity;

@protocol LYRUIConversationViewLayout <LYRUIViewLayout>

- (void)addConstraintsInView:(LYRUIConversationView *)view;
- (void)removeConstraintsFromView:(LYRUIConversationView *)view;
- (void)updateConstraintsInView:(LYRUIConversationView *)view;

@end

IB_DESIGNABLE
@interface LYRUIConversationView : LYRUIViewWithLayout <LYRUIConfigurable>

/**
 @abstract A view showing list of `LYRMessage` items.
 */
@property (nonatomic, weak, readonly) LYRUIMessageListView *messageListView;

/**
 @abstract A view containing input field and additional buttons for sending messages. The `sendPressedBlock` of `composeBar` is automatically configured for sending messages using `messageListView` `messageSender`.
 */
@property (nonatomic, weak, readonly) LYRUIComposeBar *composeBar;

/**
 @abstract A `LYRConversation` from which the messages are presented in the `messageListView`.
 @discussion This property is passed to the `messageListView` and sets `messageSender` `conversation` property.
 */
@property (nonatomic, strong) LYRConversation *conversation;

/**
 @abstract An `LYRQueryController` instance managing data displayed in the `messageListView`.
 @discussion This property is passed to the `messageListView`.
 @warning The `LYRQueryController`s delegate will be updated when set to this property.
 */
@property (nonatomic, strong) LYRQueryController *queryController;

/**
 @abstract Layout of the `LYRUIConversationView` subviews.
 */
@property (nonatomic, copy) IBOutlet id<LYRUIConversationViewLayout> layout;

/**
 @abstract An constraint which will be updated with keyboard height to properly move compose bar.
 */
@property (nonatomic, weak) NSLayoutConstraint *keyboardMaintainedConstraint;

@end
