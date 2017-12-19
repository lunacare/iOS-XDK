//
//  LYRUIConversationItemView.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 04.07.2017.
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

#import "LYRUIConversationItemView.h"
#import "LYRUIConversationItemIBSetup.h"
#import "LYRUIConfiguration+DependencyInjection.h"

@interface LYRUIConversationItemView ()

@property(nonatomic, weak, readwrite) UIView *accessoryViewContainer;
@property(nonatomic, weak, readwrite) UILabel *conversationTitleLabel;
@property(nonatomic, weak, readwrite) UILabel *lastMessageLabel;
@property(nonatomic, weak, readwrite) UILabel *dateLabel;

@end

@implementation LYRUIConversationItemView
@dynamic accessoryViewContainer;
@synthesize theme = _readTheme,
            state = _state;

- (void)prepareForInterfaceBuilder {
    [LYRUIConversationItemIBSetup prepareConversationItemForInterfaceBuilder:self];
}

#pragma mark - Properties

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    [super setLayerConfiguration:layerConfiguration];
    self.unreadTheme = [layerConfiguration.injector alternativeThemeForViewClass:[self class]];
}

#pragma mark - LYRUIConversationItemViewState and LYRUIBaseItemViewTheme changes

- (void)setState:(LYRUIConversationItemViewState)state {
    _state = state;
    switch (state) {
        case LYRUIConversationItemViewStateRead:
            super.theme = self.theme;
            break;
        case LYRUIConversationItemViewStateUnread:
            super.theme = self.unreadTheme;
            break;
    }
}

- (void)setTheme:(id<LYRUIBaseItemViewTheme>)theme {
    _readTheme = theme;
    if (self.state == LYRUIConversationItemViewStateRead) {
        super.theme = theme;
    }
}

- (void)setUnreadTheme:(id<LYRUIBaseItemViewTheme>)unreadTheme {
    _unreadTheme = unreadTheme;
    if (self.state == LYRUIConversationItemViewStateUnread) {
        super.theme = unreadTheme;
    }
}

@end
