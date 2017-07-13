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

@interface LYRUIConversationItemView ()

@property(nonatomic, weak, readwrite) UIView *accessoryViewContainer;
@property(nonatomic, weak, readwrite) UILabel *conversationTitleLabel;
@property(nonatomic, weak, readwrite) UILabel *lastMessageLabel;
@property(nonatomic, weak, readwrite) UILabel *dateLabel;

@end

@implementation LYRUIConversationItemView
@dynamic accessoryViewContainer;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        LYRUIConversationItemViewLayoutMetrics *metrics = [[LYRUIConversationItemViewLayoutMetrics alloc] init];
        self.layout = [[LYRUIBaseItemViewLayout alloc] initWithMetrics:metrics];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        LYRUIConversationItemViewLayoutMetrics *metrics = [[LYRUIConversationItemViewLayoutMetrics alloc] init];
        self.layout = [[LYRUIBaseItemViewLayout alloc] initWithMetrics:metrics];
    }
    return self;
}

- (instancetype)initWithLayout:(id<LYRUIBaseItemViewLayout>)layout {
    if (layout == nil) {
        LYRUIConversationItemViewLayoutMetrics *metrics = [[LYRUIConversationItemViewLayoutMetrics alloc] init];
        layout = [[LYRUIBaseItemViewLayout alloc] initWithMetrics:metrics];
    }
    self = [super initWithLayout:layout];
    return self;
}

- (void)prepareForInterfaceBuilder {
    [[[LYRUIConversationItemIBSetup alloc] init] prepareConversationItemForInterfaceBuilder:self];
}

@end
