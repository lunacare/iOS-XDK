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
#import "LYRUIAvatarView+PrivateProperties.h"
#import "LYRUIImageWithLettersView.h"
#import "LYRUIImageWithLettersViewConfigurator.h"
#import "LYRUIPresenceView.h"
#import "LYRUIAvatarViewSingleLayout.h"
#import "LYRUIAvatarViewMultiLayout.h"

@interface LYRUIAvatarViewConfigurator ()

@property (nonatomic, strong) LYRUIImageWithLettersViewConfigurator *avatarViewConfigurator;

@property (nonatomic, strong) LYRUIAvatarViewSingleLayout *singleLayout;
@property (nonatomic, strong) LYRUIAvatarViewMultiLayout *multiLayout;

@end

@implementation LYRUIAvatarViewConfigurator

- (instancetype)init {
    self = [self initWithAvatarViewConfigurator:nil];
    return self;
}

- (instancetype)initWithAvatarViewConfigurator:(LYRUIImageWithLettersViewConfigurator *)avatarViewConfigurator {
    self = [super init];
    if (self) {
        if (avatarViewConfigurator == nil) {
            avatarViewConfigurator = [[LYRUIImageWithLettersViewConfigurator alloc] init];
        }
        self.avatarViewConfigurator = avatarViewConfigurator;
        self.singleLayout = [[LYRUIAvatarViewSingleLayout alloc] init];
        self.multiLayout = [[LYRUIAvatarViewMultiLayout alloc] init];
    }
    return self;
}

#pragma mark - LYRUIAvatarView configuration

- (void)setupAvatarView:(LYRUIAvatarView *)avatarView withIdentities:(NSArray<LYRIdentity *> *)identities {
    if (identities.count == 1) {
        [self setupSingleAvatarView:avatarView withIdentity:identities.firstObject];
    } else {
        [self setupMultipleAvatarView:avatarView withIdentities:identities];
    }
    avatarView.presenceView.identities = identities;
}

- (void)setupSingleAvatarView:(LYRUIAvatarView *)avatarView withIdentity:(LYRIdentity *)identity {
    [self.avatarViewConfigurator setupImageWithLettersView:avatarView.primaryAvatarView withIdentity:identity];
    avatarView.primaryAvatarView.borderWidth = 0.0;
    avatarView.layout = self.singleLayout;
}

- (void)setupMultipleAvatarView:(LYRUIAvatarView *)avatarView withIdentities:(NSArray<LYRIdentity *> *)identities {
    if (identities.count == 2) {
        [self.avatarViewConfigurator setupImageWithLettersView:avatarView.secondaryAvatarView withIdentity:identities.lastObject];
    } else {
        [self.avatarViewConfigurator setupImageWithLettersViewWithMultipleParticipantsIcon:avatarView.secondaryAvatarView];
    }
    [self.avatarViewConfigurator setupImageWithLettersView:avatarView.primaryAvatarView withIdentity:identities.firstObject];
    avatarView.primaryAvatarView.borderWidth = 2.0;
    avatarView.layout = self.multiLayout;
}

@end
