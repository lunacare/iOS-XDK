//
//  LYRUIConversationItemViewConfigurator.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 12.07.2017.
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

#import "LYRUIIdentityViewConfigurator.h"
#import "LYRUITimeAgoDateFormatting.h"
#import "LYRUIIdentityNameFormatting.h"

@implementation LYRUIIdentityViewConfigurator

- (instancetype)init {
    self = [self initWithAccessoryViewProvider:nil
                                 nameFormatter:nil
                       lastSeenAtTimeFormatter:nil];
    return self;
}

- (instancetype)initWithAccessoryViewProvider:(nullable id<LYRUIIdentityAccessoryViewProviding>)accessoryViewProvider
                                nameFormatter:(nullable id<LYRUIIdentityNameFormatting>)nameFormatter
                      lastSeenAtTimeFormatter:(nullable id<LYRUITimeAgoDateFormatting>)lastSeenAtTimeFormatter {
    self = [super init];
    if (self) {
        if (accessoryViewProvider == nil) {
            //TODO: set default provider
        }
        self.accessoryViewProvider = accessoryViewProvider;
        if (nameFormatter == nil) {
            //TODO: set default formatter
        }
        self.nameFormatter = nameFormatter;
        if (lastSeenAtTimeFormatter == nil) {
            //TODO: set default formatter
        }
        self.lastSeenAtTimeFormatter = lastSeenAtTimeFormatter;
    }
    return self;
}

#pragma mark - LYRUIConversationItemView setup

- (void)setupConversationItemView:(UIView<LYRUIConversationItemView> *)view
                     withIdentity:(LYRIdentity *)identity {
    if (view == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Cannot setup Conversation Item View with nil `view` argument." userInfo:nil];
    }
    if (identity == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Cannot setup Conversation Item View with nil `identity` argument." userInfo:nil];
    }
    
    view.titleLabel.text = [self.nameFormatter nameForIdentity:identity];
    view.timeLabel.text = [self.lastSeenAtTimeFormatter timeAgoStringForTime:identity.lastSeenAt
                                                             withCurrentTime:[NSDate date]];
    
    [view.accessoryView removeFromSuperview];
    UIView *accessoryView = [self.accessoryViewProvider accessoryViewForIdentity:identity];
    if (accessoryView) {
        [view addSubview:accessoryView];
        view.accessoryView = accessoryView;
    }
    [view setNeedsUpdateConstraints];
}

@end
