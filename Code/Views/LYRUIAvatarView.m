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

#import "LYRUIAvatarView.h"
#import "LYRUIImageWithLettersView.h"
#import "LYRUIShapedView.h"
#import "LYRUINumberBadgeView.h"
#import "LYRUIAvatarViewConfigurator.h"

@interface LYRUIAvatarView ()

@property (nonatomic, weak, readwrite) LYRUIImageWithLettersView *primaryAvatarView;
@property (nonatomic, weak, readwrite) LYRUIImageWithLettersView *secondaryAvatarView;
@property (nonatomic, weak, readwrite) LYRUIShapedView *presenceView;
@property (nonatomic, weak, readwrite) LYRUINumberBadgeView *participantsCountView;

@property (nonatomic, strong) LYRUIAvatarViewConfigurator *configurator;

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
    self.configurator = [[LYRUIAvatarViewConfigurator alloc] init];
}

#pragma mark - Properties

- (void)setPresenceViewPosition:(LYRUIAvatarPresenceViewPosition)presenceViewPosition {
    _presenceViewPosition = presenceViewPosition;
    [self setNeedsUpdateConstraints];
}

- (void)setIdentities:(NSArray<LYRIdentity *> *)identities {
    _identities = identities;
    [self.configurator setupAvatarView:self withIdentities:identities];
}

@end
