//
//  LYRUIMessageItemIBSetup.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 16.08.2017.
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

#import "LYRUIMessageItemIBSetup.h"
#import "LYRUIMessageItemView.h"
#import "LYRUIAvatarView.h"

@implementation LYRUIMessageItemIBSetup

- (void)prepareMessageItemForInterfaceBuilder:(LYRUIMessageItemView *)messageItem {
    messageItem.primaryAccessoryView = [self avatarView];
    messageItem.secondaryAccessoryView = [self accessoryView];
    [self addContentViewInMessageItem:messageItem];
}

- (LYRUIAvatarView *)avatarView {
    LYRUIAvatarView *avatarView = [[LYRUIAvatarView alloc] init];
    avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    avatarView.backgroundColor = UIColor.whiteColor;
    [avatarView.widthAnchor constraintEqualToConstant:32.0].active = YES;
    [avatarView.heightAnchor constraintEqualToConstant:32.0].active = YES;
    avatarView.identities = @[[LYRIdentity new]];
    return avatarView;
}

- (UIView *)accessoryView {
    UIView *accessoryView = [[UIView alloc] init];
    accessoryView.layer.cornerRadius = 16.0;
    accessoryView.clipsToBounds = YES;
    accessoryView.backgroundColor = UIColor.grayColor;
    [accessoryView.widthAnchor constraintEqualToConstant:32.0].active = YES;
    [accessoryView.heightAnchor constraintEqualToConstant:32.0].active = YES;
    return accessoryView;
}

- (void)addContentViewInMessageItem:(LYRUIMessageItemView *)messageItem {
    UITextView *textView = [[UITextView alloc] init];
    textView.scrollEnabled = NO;
    textView.font = [UIFont systemFontOfSize:14.0];
    textView.text = @"Mistakes are always forgivable, if one has the courage to admit them. I’m not in this world to live up to your expectations and you’re not in this world to live up to mine. If you spend too much time thinking about a thing, you'll never get it done.";
    textView.textContainerInset = UIEdgeInsetsMake(9.0, 10.0, 9.0, 10.0);
    messageItem.contentView = textView;
}

@end
