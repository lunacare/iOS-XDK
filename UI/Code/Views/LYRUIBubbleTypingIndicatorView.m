//
//  LYRUIBubbleTypingIndicatorView.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 18.09.2017.
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

#import "LYRUIBubbleTypingIndicatorView.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIDotsBubbleView.h"
#import "LYRUIAvatarView.h"

@interface LYRUIBubbleTypingIndicatorView ()

@property (nonatomic, strong, readwrite) LYRUIAvatarView *avatarView;
@property (nonatomic, strong, readwrite) LYRUIDotsBubbleView *bubbleView;

@end

@implementation LYRUIBubbleTypingIndicatorView
@synthesize layerConfiguration = _layerConfiguration;

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

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        [self lyr_commonInit];
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    self.avatarView.layerConfiguration = layerConfiguration;
}

- (void)lyr_commonInit {
    [self addAvatarView];
    [self addBubbleView];
    [self setupConstraints];
}

- (void)addAvatarView {
    LYRUIAvatarView *avatarView = [[LYRUIAvatarView alloc] init];
    avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:avatarView];
    self.avatarView = avatarView;
}

- (void)addBubbleView {
    LYRUIDotsBubbleView *bubbleView = [[LYRUIDotsBubbleView alloc] init];
    bubbleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bubbleView];
    self.bubbleView = bubbleView;
}

- (void)setupConstraints {
    [self.avatarView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:12.0].active = YES;
    [self.bubbleView.leftAnchor constraintEqualToAnchor:self.avatarView.rightAnchor constant:8.0].active = YES;
    [self.rightAnchor constraintGreaterThanOrEqualToAnchor:self.bubbleView.rightAnchor constant:12.0].active = YES;
    
    [self.avatarView.topAnchor constraintEqualToAnchor:self.topAnchor constant:2.0].active = YES;
    [self.bubbleView.topAnchor constraintEqualToAnchor:self.topAnchor constant:2.0].active = YES;
    
    [self.bottomAnchor constraintEqualToAnchor:self.avatarView.bottomAnchor constant:2.0].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.bubbleView.bottomAnchor constant:2.0].active = YES;
    
    [self.avatarView.widthAnchor constraintEqualToConstant:35.0].active = YES;
    [self.avatarView.heightAnchor constraintEqualToConstant:35.0].active = YES;
}

- (void)updateConstraints {
    [super updateConstraints];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setIdentities:(NSSet<LYRIdentity *> *)identities {
    _identities = [identities copy];
    NSSet<LYRIdentity *> *filteredIdentities = identities;
    if (self.layerConfiguration.participantsFilter) {
        filteredIdentities = self.layerConfiguration.participantsFilter(identities);
    }
    NSArray<LYRIdentity *> *sortedIdentities = self.layerConfiguration.participantsSorter(filteredIdentities);
    self.avatarView.identities = sortedIdentities;
}

@end
