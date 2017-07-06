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
#import "LYRUIConversationItemViewMediumLayout.h"
#import "LYRUISampleAccessoryView.h"

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
    // TODO: update with colors from color palette
    UIColor *blackColor = [UIColor colorWithRed:27.0/255.0 green:28.0/255.0 blue:29.0/255.0 alpha:1.0];
    UIColor *grayColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
    
    self.conversationTitleLabel = [self addLabelWithFont:[UIFont systemFontOfSize:16]
                                               textColor:blackColor];
    self.lastMessageLabel = [self addLabelWithFont:[UIFont systemFontOfSize:14]
                                         textColor:grayColor];
    self.dateLabel = [self addLabelWithFont:[UIFont systemFontOfSize:12]
                                  textColor:grayColor];

    self.layout = [[LYRUIConversationItemViewMediumLayout alloc] init];
}

- (UILabel *)addLabelWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [UILabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:label];
    label.font = font;
    label.textColor = textColor;
    return label;
}

- (void)prepareForInterfaceBuilder {
    self.conversationTitleLabel.text = @"Name(s) / Title";
    self.dateLabel.text = @"8:30am";
    
    UIView *accessoryView = [[LYRUISampleAccessoryView alloc] init];
    [self addSubview:accessoryView];
    self.accessoryView = accessoryView;
    
    [self setNeedsUpdateConstraints];
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
