//
//  LYRUITextMessageContentView.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 31.01.2018.
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

#import "LYRUITextMessageContentView.h"

@interface LYRUITextMessageContentView ()

@property (nonatomic, readwrite) UITextView *textView;

@end

@implementation LYRUITextMessageContentView

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
    self.backgroundColor = UIColor.clearColor;
    
    UITextView *textView = [[UITextView alloc] init];
    textView.backgroundColor = UIColor.clearColor;
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    textView.dataDetectorTypes = UIDataDetectorTypeAll;
    textView.linkTextAttributes = @{ NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.font = [UIFont systemFontOfSize:14.0];
    textView.textContainerInset = UIEdgeInsetsMake(8.0, 7.0, 9.0, 7.0);
    [self addSubview:textView];
    self.textView = textView;
    
    [textView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [textView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [textView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [textView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
}

@end
