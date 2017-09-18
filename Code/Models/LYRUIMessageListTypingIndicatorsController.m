//
//  LYRUIMessageListTypingIndicatorsController.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 15.09.2017.
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

#import "LYRUIMessageListTypingIndicatorsController.h"
#import <LayerKit/LayerKit.h>
#import "LYRUIPanelTypingIndicatorView.h"

@interface LYRUIMessageListTypingIndicatorsController ()
@property (nonatomic, strong) NSMutableSet<LYRIdentity *> *typingParticipants;
@property (nonatomic, strong) LYRConversation *conversation;
@end

@implementation LYRUIMessageListTypingIndicatorsController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.notificationCenter = [NSNotificationCenter defaultCenter];
        self.typingParticipants = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)registerForNotificationsInConversation:(LYRConversation *)conversation {
    self.conversation = conversation;
    [self.notificationCenter addObserver:self
                                selector:@selector(didReceiveTypingIndicator:)
                                    name:LYRConversationDidReceiveTypingIndicatorNotification
                                  object:nil];
}

- (void)removeNotificationsObserver {
    [self.notificationCenter removeObserver:self];
}

#pragma mark - Notification handler

- (void)didReceiveTypingIndicator:(NSNotification *)notification {
    if (!notification.object || ![notification.object isEqual:self.conversation]) {
        return;
    }
    
    LYRTypingIndicator *typingIndicator = notification.userInfo[LYRTypingIndicatorObjectUserInfoKey];
    if (typingIndicator.action == LYRTypingIndicatorActionBegin) {
        [self.typingParticipants addObject:typingIndicator.sender];
    } else {
        [self.typingParticipants removeObject:typingIndicator.sender];
    }
    
    NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    if (numberOfItems > 0) {
        NSIndexPath *lastItemIndexPath = [NSIndexPath indexPathForItem:(numberOfItems - 1) inSection:0];
        [self.collectionView reloadItemsAtIndexPaths:@[lastItemIndexPath]];
    }
}

@end
