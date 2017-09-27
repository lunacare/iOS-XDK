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
#import "LYRUIBaseItemViewLayout.h"
#import "LYRUIConversationItemViewLayoutMetrics.h"
#import "LYRUIConversationItemIBSetup.h"
#import "LYRUIConversationItemViewUnreadTheme.h"

@interface LYRUIConversationItemView ()

@property(nonatomic, weak, readwrite) UIView *accessoryViewContainer;
@property(nonatomic, weak, readwrite) UILabel *conversationTitleLabel;
@property(nonatomic, weak, readwrite) UILabel *lastMessageLabel;
@property(nonatomic, weak, readwrite) UILabel *dateLabel;

@end

@implementation LYRUIConversationItemView
@dynamic accessoryViewContainer;
@synthesize theme = _theme,
            state = _state;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        LYRUIConversationItemViewLayoutMetrics *metrics = [[LYRUIConversationItemViewLayoutMetrics alloc] init];
        self.layout = [[LYRUIBaseItemViewLayout alloc] initWithMetrics:metrics];
        self.unreadTheme = [[LYRUIConversationItemViewUnreadTheme alloc] init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        LYRUIConversationItemViewLayoutMetrics *metrics = [[LYRUIConversationItemViewLayoutMetrics alloc] init];
        self.layout = [[LYRUIBaseItemViewLayout alloc] initWithMetrics:metrics];
        self.unreadTheme = [[LYRUIConversationItemViewUnreadTheme alloc] init];
    }
    return self;
}

- (instancetype)initWithLayout:(id<LYRUIBaseItemViewLayout>)layout {
    if (layout == nil) {
        LYRUIConversationItemViewLayoutMetrics *metrics = [[LYRUIConversationItemViewLayoutMetrics alloc] init];
        layout = [[LYRUIBaseItemViewLayout alloc] initWithMetrics:metrics];
        self.unreadTheme = [[LYRUIConversationItemViewUnreadTheme alloc] init];
    }
    self = [super initWithLayout:layout];
    return self;
}

- (void)prepareForInterfaceBuilder {
    [LYRUIConversationItemIBSetup prepareConversationItemForInterfaceBuilder:self];
}

#pragma mark - LYRUIConversationItemViewState and LYRUIBaseItemViewTheme changes

- (void)setState:(LYRUIConversationItemViewState)state {
    _state = state;
    switch (state) {
        case LYRUIConversationItemViewStateRead:
            [self updateWithTheme:self.theme];
            break;
        case LYRUIConversationItemViewStateUnread:
            [self updateWithTheme:self.unreadTheme];
            break;
    }
}

- (void)setTheme:(id<LYRUIBaseItemViewTheme>)theme {
    _theme = theme;
    if (self.state == LYRUIConversationItemViewStateRead) {
        [self updateWithTheme:theme];
    }
}

- (void)setUnreadTheme:(id<LYRUIBaseItemViewTheme>)unreadTheme {
    _unreadTheme = unreadTheme;
    if (self.state == LYRUIConversationItemViewStateUnread) {
        [self updateWithTheme:unreadTheme];
    }
}

- (void)updateWithTheme:(id<LYRUIBaseItemViewTheme>)theme {
    if (theme == nil) {
        return;
    }
    if (theme.titleLabelFont) {
        self.titleLabelFont = theme.titleLabelFont;
    }
    if (theme.titleLabelColor) {
        self.titleLabelColor = theme.titleLabelColor;
    }
    if (theme.messageLabelFont) {
        self.messageLabelFont = theme.messageLabelFont;
    }
    if (theme.messageLabelColor) {
        self.messageLabelColor = theme.messageLabelColor;
    }
    if (theme.timeLabelFont) {
        self.timeLabelFont = theme.timeLabelFont;
    }
    if (theme.timeLabelColor) {
        self.timeLabelColor = theme.timeLabelColor;
    }
}

@end
