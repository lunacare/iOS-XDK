//
//  LYRUIConversationItemViewController.m
//  Layer-iOS-UI
//
//  Created by Łukasz Przytuła on 05.07.2017.
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

#import "LYRUIConversationItemViewController.h"

@implementation LYRUIConversationItemViewController

- (instancetype)init {
    self = [self initWithAccessoryViewProvider:nil
                                titleFormatter:nil
                          lastMessageFormatter:nil
                                 dateFormatter:nil];
    return self;
}

- (instancetype)initWithAccessoryViewProvider:(id<LYRUIConversationItemAccessoryViewProviding>)accessoryViewProvider
                               titleFormatter:(id<LYRUIConversationItemTitleFormatting>)titleFormatter
                         lastMessageFormatter:(id<LYRUIConversationItemLastMessageFormatting>)lastMessageFormatter
                                dateFormatter:(id<LYRUIConversationItemDateFormatting>)dateFormatter {
    self = [super init];
    if (self) {
        if (accessoryViewProvider == nil) {
            //TODO: set default provider
        }
        self.accessoryViewProvider = accessoryViewProvider;
        if (titleFormatter == nil) {
            //TODO: set default formatter;
        }
        self.titleFormatter = titleFormatter;
        if (lastMessageFormatter == nil) {
            //TODO: set default formatter;
        }
        self.lastMessageFormatter = lastMessageFormatter;
        if (dateFormatter == nil) {
            //TODO: set default formatter;
        }
        self.dateFormatter = dateFormatter;
    }
    return self;
}

#pragma mark - LYRUIConversationItemView setup

- (void)setupConversationItemView:(UIView<LYRUIConversationItemView> *)view
                 withConversation:(LYRConversation *)conversation {
    view.conversationTitleLabel.text = [self.titleFormatter titleForConversation:conversation];
    LYRMessage *lastMessage = conversation.lastMessage;
    if (lastMessage) {
        view.dateLabel.text = [self.dateFormatter stringForConversationLastMessageTime:lastMessage.sentAt
                                                                       withCurrentTime:[NSDate date]];
        view.lastMessageLabel.text = [self.lastMessageFormatter stringForConversationLastMessage:lastMessage];
    }
    [view.accessoryView removeFromSuperview];
    UIView *accessoryView = [self.accessoryViewProvider accessoryViewForConversation:conversation];
    if (accessoryView) {
        [view addSubview:accessoryView];
        view.accessoryView = accessoryView;
    }
    [view setNeedsUpdateConstraints];
}

@end
