//
//  LYRUIPresenceView.m
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

#import "LYRUIPresenceView.h"
#import "LYRUIShapedView.h"
#import "LYRUINumberBadgeView.h"
#import "LYRUIPresenceViewConfiguration.h"
#import "LYRUIPresenceViewDefaultTheme.h"
#import "LYRUIConfiguration+DependencyInjection.h"

@interface LYRUIPresenceView ()

@property (nonatomic, weak, readwrite) LYRUIShapedView *presenceIndicator;
@property (nonatomic, weak, readwrite) LYRUINumberBadgeView *participantsCountView;

@property (nonatomic, strong) LYRUIPresenceViewConfiguration *configuration;

@end

@implementation LYRUIPresenceView

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self lyr_commonInit];
        self.layerConfiguration = configuration;
    }
    return self;
}

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
    [self addPresenceIndicator];
    [self addParticipantsCountView];
    [self installConstraints];  
}

- (void)addPresenceIndicator {
    LYRUIShapedView *presenceIndicator = [[LYRUIShapedView alloc] init];
    presenceIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:presenceIndicator];
    self.presenceIndicator = presenceIndicator;
}

- (void)addParticipantsCountView {
    LYRUINumberBadgeView *participantsCountView = [[LYRUINumberBadgeView alloc] init];
    participantsCountView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:participantsCountView];
    self.participantsCountView = participantsCountView;
}

- (void)installConstraints {
    [self.presenceIndicator.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
    [self.presenceIndicator.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
    [self.presenceIndicator.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.presenceIndicator.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    [self.participantsCountView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
    [self.participantsCountView.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
    [self.participantsCountView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.participantsCountView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
}

#pragma mark - Properties

- (void)setIdentities:(NSArray<LYRIdentity *> *)identities {
    _identities = identities;
    [self.configuration setupPresenceView:self withIdentities:identities usingTheme:self.theme];
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    self.theme = [layerConfiguration.injector themeForViewClass:[self class]];
    self.configuration = [layerConfiguration.injector configurationForViewClass:[self class]];
}

@end
