//
//  LYRUIConversationItemView.m
//  Layer-iOS-UI
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

@implementation LYRUIConversationItemView
@synthesize conversationTitleLabel = _conversationTitleLabel,
            lastMessageLabel = _lastMessageLabel,
            dateLabel = _dateLabel,
            accessoryView = _accessoryView;
@dynamic layout;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (instancetype)initWithLayout:(id<LYRUIConversationItemViewLayout>)layout {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.layout = layout;
    }
    return self;
}

- (void)commonInitialization {
    UILabel *conversationTitleLabel = [UILabel new];
    [self addSubview:conversationTitleLabel];
    self.conversationTitleLabel = conversationTitleLabel;
    
    UILabel *lastMessageLabel = [UILabel new];
    [self addSubview:lastMessageLabel];
    self.lastMessageLabel = lastMessageLabel;
    
    UILabel *dateLabel = [UILabel new];
    [self addSubview:dateLabel];
    self.dateLabel = dateLabel;
}

#pragma mark - IBInspectable properties

- (UIFont *)conversationTitleLabelFont {
    return self.conversationTitleLabel.font;
}

- (void)setConversationTitleLabelFont:(UIFont *)conversationTitleLabelFont {
    self.conversationTitleLabel.font = conversationTitleLabelFont;
}

- (UIColor *)conversationTitleLabelColor {
    return self.conversationTitleLabel.textColor;
}

- (void)setConversationTitleLabelColor:(UIColor *)conversationTitleLabelColor {
    self.conversationTitleLabel.textColor = conversationTitleLabelColor;
}

- (UIFont *)lastMessageLabelFont {
    return self.lastMessageLabel.font;
}

- (void)setLastMessageLabelFont:(UIFont *)lastMessageLabelFont {
    self.lastMessageLabel.font = lastMessageLabelFont;
}

- (UIColor *)lastMessageLabelColor {
    return self.lastMessageLabel.textColor;
}

- (void)setLastMessageLabelColor:(UIColor *)lastMessageLabelColor {
    self.lastMessageLabel.textColor = lastMessageLabelColor;
}

- (UIFont *)dateLabelFont {
    return self.dateLabel.font;
}

- (void)setDateLabelFont:(UIFont *)dateLabelFont {
    self.dateLabel.font = dateLabelFont;
}

- (UIColor *)dateLabelColor {
    return self.dateLabel.textColor;
}

- (void)setDateLabelColor:(UIColor *)dateLabelColor {
    self.dateLabel.textColor = dateLabelColor;
}

@end
