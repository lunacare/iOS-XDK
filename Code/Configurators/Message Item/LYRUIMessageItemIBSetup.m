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
#import "LYRUISampleAccessoryView.h"

@implementation LYRUIMessageItemIBSetup

- (void)prepareMessageItemForInterfaceBuilder:(LYRUIMessageItemView *)messageItem {
    messageItem.primaryAccessoryView = [self accessoryView];
    messageItem.secondaryAccessoryView = [self accessoryView];
    [self addContentViewInMessageItem:messageItem];
    messageItem.layoutDirection = LYRUIMessageItemViewLayoutDirectionRight;
}

- (LYRUISampleAccessoryView *)accessoryView {
    LYRUISampleAccessoryView *accessoryView = [[LYRUISampleAccessoryView alloc] init];
    [accessoryView.widthAnchor constraintEqualToConstant:32.0].active = YES;
    [accessoryView.heightAnchor constraintEqualToConstant:32.0].active = YES;
    return accessoryView;
}

- (void)addContentViewInMessageItem:(LYRUIMessageItemView *)messageItem {
    UITextView *textView = [[UITextView alloc] init];
    textView.scrollEnabled = NO;
    textView.font = [UIFont systemFontOfSize:14.0];
    textView.text = @"Mistakes are always forgivable, if one has the courage to admit them. I’m not in this world to live up to your expectations and you’re not in this world to live up to mine. If you spend too much time thinking about a thing, you'll never get it done.";
    textView.textContainerInset = UIEdgeInsetsMake(7.0, 12.0, 7.0, 12.0);
    messageItem.contentView = textView;
}

@end
