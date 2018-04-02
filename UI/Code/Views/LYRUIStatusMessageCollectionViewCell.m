//
//  LYRUIStatusMessageCollectionViewCell.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 09.01.2018.
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

#import "LYRUIStatusMessageCollectionViewCell.h"
#import "LYRUIStatusMessageCellLayout.h"

@interface LYRUIStatusMessageCollectionViewCell ()

@property (nonatomic, weak, readwrite) UITextView *textView;

@end

@implementation LYRUIStatusMessageCollectionViewCell

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
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UITextView *textView = [[UITextView alloc] init];
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    textView.font = [UIFont systemFontOfSize:13.0];
    textView.textColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
    [self.contentView addSubview:textView];
    self.textView = textView;
    self.layout = [[LYRUIStatusMessageCellLayout alloc] init];
}

#pragma mark - Properties

- (NSString *)text {
    return self.textView.text;
}

- (void)setText:(NSString *)text {
    self.textView.text = text;
}

#pragma mark - Layout

- (void)setLayout:(id<LYRUIStatusMessageViewLayout>)layout {
    if ([self.layout isEqual:layout]) {
        return;
    }
    if (self.layout != nil) {
        [self.layout removeConstraintsFromView:self];
    }
    _layout = [layout copyWithZone:nil];
    [self.layout addConstraintsInView:self];
}

- (void)updateConstraints {
    [self.layout updateConstraintsInView:self];
    [super updateConstraints];
}

@end
