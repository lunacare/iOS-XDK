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
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUITimeFormatting.h"
#import "LYRUIConversationItemTitleFormatting.h"
#import "LYRUIConversationItemAccessoryViewProviding.h"
#import "LYRUIMessageTextFormatting.h"
#import "LYRUIParticipantsFiltering.h"

@implementation LYRUIConversationItemViewConfiguration
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

#pragma mark - Properties

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    self.accessoryViewProvider = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIConversationItemAccessoryViewProviding) forClass:[self class]];
    self.titleFormatter = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIConversationItemTitleFormatting) forClass:[self class]];
    self.lastMessageFormatter = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIMessageTextFormatting) forClass:[self class]];
    self.messageTimeFormatter = [layerConfiguration.injector protocolImplementation:@protocol(LYRUITimeFormatting) forClass:[self class]];
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
    
    if ([view conformsToProtocol:@protocol(LYRUIConfigurable)]) {
        id<LYRUIConfigurable> configurableView = (id<LYRUIConfigurable>)view;
        configurableView.layerConfiguration = self.layerConfiguration;
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
