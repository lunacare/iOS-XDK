//
//  LYRUIAvatar.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 20.07.2017.
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

#import "LYRUIAvatar.h"
#import "LYRUIImageWithLettersView.h"
#import "LYRUIImageWithLettersViewConfigurator.h"
#import "LYRUIPresenceView.h"
#import "LYRUIPresenceViewConfigurator.h"
#import "LYRUIParticipantsCountView.h"
#import "LYRUIParticipantsCountViewConfigurator.h"

@interface LYRUIAvatar ()

@property (nonatomic, weak) LYRUIImageWithLettersView *primaryAvatarView;
@property (nonatomic, weak) LYRUIImageWithLettersView *secondaryAvatarView;
@property (nonatomic, weak) LYRUIPresenceView *presenceView;
@property (nonatomic, weak) LYRUIParticipantsCountView *participantsCountView;

@property (nonatomic, strong) LYRUIImageWithLettersViewConfigurator *avatarViewConfigurator;
@property (nonatomic, strong) LYRUIPresenceViewConfigurator *presenceViewConfigurator;
@property (nonatomic, strong) LYRUIParticipantsCountViewConfigurator *participantsCounViewConfigurator;

@end

@implementation LYRUIAvatar

- (void)setupWithIdentity:(LYRIdentity *)identity {
    [self.avatarViewConfigurator setupImageWithLettersView:self.primaryAvatarView withIdentity:identity];
    [self.presenceViewConfigurator setupPresenceView:self.presenceView forPresenceStatus:identity.presenceStatus];
    // TODO: update to identity layout
}

- (void)setupWithConversation:(LYRConversation *)conversation {
    NSArray<LYRIdentity *> *participants; // TODO: filter currently logged in user from conversation and sort other participants
    if (participants.count == 1) {
        [self setupWithIdentity:participants.firstObject];
        return;
    }
    
    if (participants.count == 2) {
        [self.avatarViewConfigurator setupImageWithLettersView:self.secondaryAvatarView withIdentity:participants.lastObject];
    } else {
        [self.avatarViewConfigurator setupImageWithLettersViewWithMultipleParticipantsIcon:self.secondaryAvatarView];
    }
    [self.avatarViewConfigurator setupImageWithLettersView:self.secondaryAvatarView withIdentity:participants.firstObject];
    [self.participantsCounViewConfigurator setupParticipantsCountView:self.participantsCountView withConversation:conversation];
    // TODO: update to conversation layout
}

#pragma mark - Properties

- (void)setPresenceViewPosition:(LYRUIAvatarPresenceViewPosition)presenceViewPosition {
    _presenceViewPosition = presenceViewPosition;
    [self setNeedsUpdateConstraints];
}

@end
