//
//  LYRUIConversationItemTableViewCell.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 07.07.2017.
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

#import "LYRUIConversationItemTableViewCell.h"

@interface LYRUIConversationItemTableViewCell ()

@property (nonatomic, weak) LYRUIConversationItemView *conversationItemView;

@end

@implementation LYRUIConversationItemTableViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addConversationItemView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addConversationItemView];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addConversationItemView];
    }
    return self;
}

- (void)addConversationItemView {
    LYRUIConversationItemView *conversationItemView = [[LYRUIConversationItemView alloc] init];
    [self.contentView addSubview:conversationItemView];
    self.conversationItemView = conversationItemView;
    conversationItemView.frame = self.bounds;
    conversationItemView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
}

#pragma mark - LYRUIConversationItemView properties

- (UIView *)accessoryView {
    return self.conversationItemView.accessoryView;
}

- (void)setAccessoryView:(UIView *)accessoryView {
    self.conversationItemView.accessoryView = accessoryView;
}

- (UILabel *)titleLabel {
    return self.conversationItemView.titleLabel;
}

- (UILabel *)messageLabel {
    return self.conversationItemView.messageLabel;
}

- (UILabel *)timeLabel {
    return self.conversationItemView.timeLabel;
}

- (LYRUIConversationItemViewState)state {
    return self.conversationItemView.state;
}

- (void)setState:(LYRUIConversationItemViewState)state {
    self.conversationItemView.state = state;
}

@end
