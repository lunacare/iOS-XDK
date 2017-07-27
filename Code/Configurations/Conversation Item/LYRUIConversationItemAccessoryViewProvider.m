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
#import <LayerKit/LayerKit.h>

@implementation LYRUIConversationItemAccessoryViewProvider
@synthesize participantsFilter = _participantsFilter;

- (instancetype)init {
    self = [self initWithParticipantsFilter:nil];
    return self;
}

- (instancetype)initWithParticipantsFilter:(LYRUIParticipantsFiltering)participantsFilter {
    self = [super init];
    if (self) {
        self.participantsFilter = participantsFilter;
    }
    return self;
}

#pragma mark - LYRUIConversationItemAccessoryViewProviding methods

- (UIView *)accessoryViewForConversation:(LYRConversation *)conversation {
    LYRUIAvatarView *avatarView = [[LYRUIAvatarView alloc] init];
    avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setupAccessoryView:avatarView forConversation:conversation];
    return avatarView;
}

- (void)setupAccessoryView:(LYRUIAvatarView *)avatarView forConversation:(LYRConversation *)conversation {
    NSSet<LYRIdentity *> *filteredIdentities = conversation.participants;
    if (self.participantsFilter) {
        filteredIdentities = self.participantsFilter(conversation.participants);
    }
    NSArray<LYRIdentity *> *identities = [filteredIdentities allObjects];
    avatarView.identities = identities;
}

@end
