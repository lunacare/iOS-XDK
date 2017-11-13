//
//  LYRUIConversationItemViewConfiguration.m
//  Layer-UI-iOS
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

#import "LYRUIConversationItemViewConfiguration.h"
#import "LYRUIMessageTimeDefaultFormatter.h"
#import "LYRUIConversationItemTitleFormatter.h"
#import "LYRUIConversationItemAccessoryViewProvider.h"
#import "LYRUIMessageTextDefaultFormatter.h"
#import "LYRUIParticipantsFiltering.h"

@implementation LYRUIConversationItemViewConfiguration

- (instancetype)init {
    self = [self initWithAccessoryViewProvider:nil
                                titleFormatter:nil
                          lastMessageFormatter:nil
                          messageTimeFormatter:nil];
    return self;
}

- (instancetype)initWithCurrentUser:(LYRIdentity *)currentUser {
    self = [self init];
    if (self) {
        self.currentUser = currentUser;
    }
    return self;
}

- (instancetype)initWithAccessoryViewProvider:(id<LYRUIConversationItemAccessoryViewProviding>)accessoryViewProvider
                               titleFormatter:(id<LYRUIConversationItemTitleFormatting>)titleFormatter
                         lastMessageFormatter:(id<LYRUIMessageTextFormatting>)lastMessageFormatter
                         messageTimeFormatter:(id<LYRUITimeFormatting>)messageTimeFormatter {
    self = [super init];
    if (self) {
        if (accessoryViewProvider == nil) {
            accessoryViewProvider = [[LYRUIConversationItemAccessoryViewProvider alloc] init];
        }
        self.accessoryViewProvider = accessoryViewProvider;
        if (titleFormatter == nil) {
            titleFormatter = [[LYRUIConversationItemTitleFormatter alloc] init];
        }
        self.titleFormatter = titleFormatter;
        if (lastMessageFormatter == nil) {
            lastMessageFormatter = [[LYRUIMessageTextDefaultFormatter alloc] init];
        }
        self.lastMessageFormatter = lastMessageFormatter;
        if (messageTimeFormatter == nil) {
            messageTimeFormatter = [[LYRUIMessageTimeDefaultFormatter alloc] init];
        }
        self.messageTimeFormatter = messageTimeFormatter;
    }
    return self;
}

#pragma mark - Properties

- (void)setCurrentUser:(LYRIdentity *)currentUser {
    _currentUser = currentUser;
    self.accessoryViewProvider.participantsFilter = LYRUIParticipantsDefaultFilterWithCurrentUser(currentUser);
    self.titleFormatter.participantsFilter = LYRUIParticipantsDefaultFilterWithCurrentUser(currentUser);
}

#pragma mark - LYRUIConversationItemView setup

- (void)setupConversationItemView:(UIView<LYRUIConversationItemView> *)view
                 withConversation:(LYRConversation *)conversation {
    if (view == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Cannot setup Conversation Item View with nil `view` argument." userInfo:nil];
    }
    if (conversation == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Cannot setup Conversation Item View with nil `conversation` argument." userInfo:nil];
    }
    
    NSString *conversationTitle = [self.titleFormatter titleForConversation:conversation];
    view.titleLabel.text = conversationTitle;
    view.accessibilityLabel = conversationTitle;
    
    LYRMessage *lastMessage = conversation.lastMessage;
    if (lastMessage) {
        view.detailLabel.text = [self.messageTimeFormatter stringForTime:lastMessage.sentAt
                                                       withCurrentTime:[NSDate date]];
        view.subtitleLabel.text = [self.lastMessageFormatter stringForMessage:lastMessage];
    }
    if (view.accessoryView == nil) {
        view.accessoryView = [self.accessoryViewProvider accessoryViewForConversation:conversation];
    } else {
        [self.accessoryViewProvider setupAccessoryView:view.accessoryView forConversation:conversation];
    }
    view.state = conversation.hasUnreadMessages ? LYRUIConversationItemViewStateUnread : LYRUIConversationItemViewStateRead;
    view.accessoryView.backgroundColor = view.backgroundColor;
    [view setNeedsUpdateConstraints];
}

@end
