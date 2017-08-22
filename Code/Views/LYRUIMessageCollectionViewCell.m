//
//  LYRUIMessageCollectionViewCell.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 18.08.2017.
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

#import "LYRUIMessageCollectionViewCell.h"
#import "LYRUIMessageItemView.h"

@interface LYRUIMessageCollectionViewCell ()

@property (nonatomic, readwrite) NSLayoutConstraint *widthConstraint;

@end

@implementation LYRUIMessageCollectionViewCell

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
    LYRUIMessageItemView *messageView = [[LYRUIMessageItemView alloc] init];
    [self.contentView addSubview:messageView];
    messageView.backgroundColor = [UIColor whiteColor];
    messageView.frame = self.contentView.bounds;
    self.messageView = messageView;
    
    messageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView.leftAnchor constraintEqualToAnchor:messageView.leftAnchor].active = YES;
    [self.contentView.topAnchor constraintEqualToAnchor:messageView.topAnchor].active = YES;
    [self.contentView.rightAnchor constraintEqualToAnchor:messageView.rightAnchor].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:messageView.bottomAnchor].active = YES;
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.contentView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.contentView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
}

@end
