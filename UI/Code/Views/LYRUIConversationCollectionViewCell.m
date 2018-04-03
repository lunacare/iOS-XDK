//
//  LYRUIConversationCollectionViewCell.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 31.07.2017.
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

#import "LYRUIConversationCollectionViewCell.h"
#import "LYRUIConversationItemView.h"
#import "UIView+LYRUISafeArea.h"
#import "UIView+LYRUILayoutGuide.h"
#import "UILayoutGuide+LYRUILayoutGuide.h"

@implementation LYRUIConversationCollectionViewCell

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
    LYRUIConversationItemView *conversationView = [[LYRUIConversationItemView alloc] init];
    conversationView.backgroundColor = [UIColor whiteColor];
    conversationView.frame = self.contentView.bounds;
    [self.contentView addSubview:conversationView];
    conversationView.translatesAutoresizingMaskIntoConstraints = NO;
    id<LYRUILayoutGuide> layoutGuide = self.contentView.lyr_safeAreaLayoutGuide ?: self.contentView;
    [layoutGuide.leftAnchor constraintEqualToAnchor:conversationView.leftAnchor].active = YES;
    [layoutGuide.topAnchor constraintEqualToAnchor:conversationView.topAnchor].active = YES;
    [layoutGuide.rightAnchor constraintEqualToAnchor:conversationView.rightAnchor].active = YES;
    [layoutGuide.bottomAnchor constraintEqualToAnchor:conversationView.bottomAnchor].active = YES;
    self.conversationView = conversationView;
}

@end
