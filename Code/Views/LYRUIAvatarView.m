//
//  LYRUIAvatarView.m
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

#import "LYRUIAvatarView+PrivateProperties.h"
#import "LYRUIImageWithLettersView.h"
#import "LYRUIPresenceView.h"
#import "LYRUIAvatarViewConfiguration.h"
#import "LYRUIPresenceViewDefaultTheme.h"

@interface LYRUIAvatarView ()

@property (nonatomic, weak, readwrite) LYRUIImageWithLettersView *primaryAvatarView;
@property (nonatomic, weak, readwrite) LYRUIImageWithLettersView *secondaryAvatarView;
@property (nonatomic, weak, readwrite) LYRUIPresenceView *presenceView;

@property (nonatomic, strong) LYRUIAvatarViewConfiguration *configuration;

@property (nonatomic) BOOL renderMultiAvatar;

@end

@implementation LYRUIAvatarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (void)lyr_commonInit {
    self.secondaryAvatarView = [self addAvatarView];
    self.primaryAvatarView = [self addAvatarView];
    [self addPresenceView];
    
    self.configuration = [[LYRUIAvatarViewConfiguration alloc] init];
}

- (LYRUIImageWithLettersView *)addAvatarView {
    LYRUIImageWithLettersView *avatarView = [[LYRUIImageWithLettersView alloc] init];
    avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:avatarView];
    return avatarView;
}

- (void)addPresenceView {
    LYRUIPresenceView *presenceView = [[LYRUIPresenceView alloc] init];
    LYRUIPresenceViewDefaultTheme *presenceViewTheme = [[LYRUIPresenceViewDefaultTheme alloc] init];
    presenceViewTheme.presenceIndicatorBackgroundColor = [UIColor whiteColor];
    presenceView.theme = presenceViewTheme;
    presenceView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:presenceView];
    self.presenceView = presenceView;
}

- (void)updateConstraints {
    [self.layout updateConstraintsInView:self];
    [super updateConstraints];
}

- (void)prepareForInterfaceBuilder {
    NSMutableArray<LYRIdentity *> *identities = [[NSMutableArray alloc] init];
    [identities addObject:[[LYRIdentity alloc] init]];
    if (self.renderMultiAvatar) {
        [identities addObject:[[LYRIdentity alloc] init]];
    }
    [self.configuration setupAvatarView:self withIdentities:identities];
}

- (void)setBounds:(CGRect)bounds {
    if (!CGRectEqualToRect(self.bounds, bounds)) {
        [self setNeedsUpdateConstraints];
    }
    [super setBounds:bounds];
}

#pragma mark - Properties

- (void)setIdentities:(NSArray<LYRIdentity *> *)identities {
    _identities = identities;
    [self.configuration setupAvatarView:self withIdentities:identities];
}

- (void)setTheme:(id<LYRUIParticipantsCountViewTheme,LYRUIPresenceIndicatorTheme,LYRUIAvatarViewTheme>)theme {
    _theme = theme;
    self.presenceView.theme = theme;
}

- (void)setLayout:(id<LYRUIAvatarViewLayout>)layout {
    if (self.layout) {
        [self.layout removeConstraintsFromView:self];
    }
    _layout = layout;
    [layout addConstraintsInView:self];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.primaryAvatarView.borderColor = backgroundColor;
    [self setNeedsUpdateConstraints];
}

@end