//
//  LYRUIConversationItemAccessoryViewProvider.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 28.07.2017.
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

#import "LYRUIConversationItemAccessoryViewProvider.h"
#import "LYRUIAvatarView.h"
#import "LYRUIParticipantsFilter.h"
#import <LayerKit/LayerKit.h>

@interface LYRUIConversationItemAccessoryViewProvider ()

@property (nonatomic, strong) LYRUIParticipantsFilter *participantsFilter;

@end

@implementation LYRUIConversationItemAccessoryViewProvider
@synthesize currentUser = _currentUser;

- (instancetype)initWithParticipantsFilter:(LYRUIParticipantsFilter *)participantsFilter {
    self = [super init];
    if (self) {
        if (participantsFilter == nil) {
            participantsFilter = [[LYRUIParticipantsFilter alloc] init];
        }
        self.participantsFilter = participantsFilter;
    }
    return self;
}

#pragma mark - Properties

- (LYRIdentity *)currentUser {
    return self.participantsFilter.currentUser;
}

- (void)setCurrentUser:(LYRIdentity *)currentUser {
    self.participantsFilter.currentUser = currentUser;
}

#pragma mark - LYRUIConversationItemAccessoryViewProviding methods

- (UIView *)accessoryViewForConversation:(LYRConversation *)conversation {
    LYRUIAvatarView *avatarView = [[LYRUIAvatarView alloc] init];
    avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setupAccessoryView:avatarView forConversation:conversation];
    return avatarView;
}

- (void)setupAccessoryView:(LYRUIAvatarView *)avatarView forConversation:(LYRConversation *)conversation {
    NSArray<LYRIdentity *> *identities = [[self.participantsFilter filteredParticipants:conversation.participants] allObjects];
    avatarView.identities = identities;
}

@end
