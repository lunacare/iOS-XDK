//
//  LYRUIAvatarViewConfigurator.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 21.07.2017.
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

#import "LYRUIAvatarViewConfigurator.h"
#import "LYRUIAvatarView.h"
#import "LYRUIImageWithLettersView.h"
#import "LYRUIPresenceView.h"
#import "LYRUIParticipantsCountView.h"
#import "LYRUIImageWithLettersViewConfigurator.h"
#import "LYRUIPresenceViewConfigurator.h"
#import "LYRUIParticipantsCountViewConfigurator.h"

@interface LYRUIAvatarViewConfigurator ()

@property (nonatomic, strong) LYRUIImageWithLettersViewConfigurator *avatarViewConfigurator;
@property (nonatomic, strong) LYRUIPresenceViewConfigurator *presenceViewConfigurator;
@property (nonatomic, strong) LYRUIParticipantsCountViewConfigurator *participantsCounViewConfigurator;

@end

@implementation LYRUIAvatarViewConfigurator

- (void)setupAvatarView:(LYRUIAvatarView *)avatarView withIdentity:(LYRIdentity *)identity {
    [self.avatarViewConfigurator setupImageWithLettersView:avatarView.primaryAvatarView withIdentity:identity];
    [self.presenceViewConfigurator setupPresenceView:avatarView.presenceView forPresenceStatus:identity.presenceStatus];
    // TODO: update to identity layout
}

- (void)setupAvatarView:(LYRUIAvatarView *)avatarView withIdentities:(NSArray<LYRIdentity *> *)identities {
    NSArray<LYRIdentity *> *participants; // TODO: filter currently logged in user from conversation and sort other participants
    if (participants.count == 1) {
        [self setupAvatarView:avatarView withIdentity:participants.firstObject];
        return;
    }
    
    if (participants.count == 2) {
        [self.avatarViewConfigurator setupImageWithLettersView:avatarView.secondaryAvatarView withIdentity:participants.lastObject];
    } else {
        [self.avatarViewConfigurator setupImageWithLettersViewWithMultipleParticipantsIcon:avatarView.secondaryAvatarView];
    }
    [self.avatarViewConfigurator setupImageWithLettersView:avatarView.primaryAvatarView withIdentity:participants.firstObject];
    avatarView.participantsCountView.numberOfParticipants = identities.count;
    // TODO: update to conversation layout
}

@end
