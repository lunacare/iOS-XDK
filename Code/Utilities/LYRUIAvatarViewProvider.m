//
//  LYRUIAvatarViewProvider.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 02.11.2017.
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

#import "LYRUIAvatarViewProvider.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIAvatarView.h"
#import "LYRUIParticipantsFiltering.h"
#import "LYRUIParticipantsSorting.h"
#import <LayerKit/LayerKit.h>

@implementation LYRUIAvatarViewProvider
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (LYRUIAvatarView *)avatarView {
    LYRUIAvatarView *avatarView = [self.layerConfiguration.injector objectOfType:[LYRUIAvatarView class]];
    avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    return avatarView;
}

- (void)setupAvatarView:(LYRUIAvatarView *)avatarView forIdentity:(LYRIdentity *)identity {
    NSArray<LYRIdentity *> *identities = @[identity];
    avatarView.identities = identities;
}

- (void)setupAvatarView:(LYRUIAvatarView *)avatarView forIdentities:(NSSet<LYRIdentity *> *)identities {
    NSSet<LYRIdentity *> *filteredIdentities = identities;
    if (self.layerConfiguration.participantsFilter) {
        filteredIdentities = self.layerConfiguration.participantsFilter(identities);
    }
    NSArray<LYRIdentity *> *sortedIdentities = self.layerConfiguration.participantsSorter(filteredIdentities);
    avatarView.identities = sortedIdentities;
}

#pragma mark - LYRUIIdentityItemAccessoryViewProviding methods

- (LYRUIAvatarView *)accessoryViewForIdentity:(LYRIdentity *)identity {
    LYRUIAvatarView *avatarView = [self avatarView];
    [self setupAccessoryView:avatarView forIdentity:identity];
    return avatarView;
}

- (void)setupAccessoryView:(LYRUIAvatarView *)avatarView forIdentity:(LYRIdentity *)identity {
    [self setupAvatarView:avatarView forIdentity:identity];
}

#pragma mark - LYRUIConversationItemAccessoryViewProviding methods

- (LYRUIAvatarView *)accessoryViewForConversation:(LYRConversation *)conversation {
    LYRUIAvatarView *avatarView = [self avatarView];
    [self setupAccessoryView:avatarView forConversation:conversation];
    return avatarView;
}

- (void)setupAccessoryView:(LYRUIAvatarView *)avatarView forConversation:(LYRConversation *)conversation {
    [self setupAvatarView:avatarView forIdentities:conversation.participants];
}

#pragma mark - LYRUIMessageItemAccessoryViewProviding methods

- (LYRUIAvatarView *)accessoryViewForMessage:(LYRMessage *)message {
    LYRUIAvatarView *avatarView = [self avatarView];
    [self setupAccessoryView:avatarView forMessage:message];
    return avatarView;
}

- (void)setupAccessoryView:(LYRUIAvatarView *)avatarView forMessage:(LYRMessage *)message {
    [self setupAvatarView:avatarView forIdentity:message.sender];
}

@end
