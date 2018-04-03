//
//  LYRUIIdentityCollectionViewCell.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 27.07.2017.
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

#import "LYRUIIdentityCollectionViewCell.h"
#import "LYRUIIdentityItemView.h"
#import "UIView+LYRUISafeArea.h"
#import "UIView+LYRUILayoutGuide.h"
#import "UILayoutGuide+LYRUILayoutGuide.h"

@implementation LYRUIIdentityCollectionViewCell

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
    LYRUIIdentityItemView *identityView = [[LYRUIIdentityItemView alloc] init];
    identityView.frame = self.contentView.bounds;
    [self.contentView addSubview:identityView];
    identityView.translatesAutoresizingMaskIntoConstraints = NO;
    id<LYRUILayoutGuide> layoutGuide = self.contentView.lyr_safeAreaLayoutGuide ?: self.contentView;
    [layoutGuide.leftAnchor constraintEqualToAnchor:identityView.leftAnchor].active = YES;
    [layoutGuide.topAnchor constraintEqualToAnchor:identityView.topAnchor].active = YES;
    [layoutGuide.rightAnchor constraintEqualToAnchor:identityView.rightAnchor].active = YES;
    [layoutGuide.bottomAnchor constraintEqualToAnchor:identityView.bottomAnchor].active = YES;
    self.identityView = identityView;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected == YES) {
        self.identityView.backgroundColor = [UIColor colorWithWhite:242.0/255.0 alpha:1.0];
    } else {
        self.identityView.backgroundColor = UIColor.whiteColor;
    }
}

@end
