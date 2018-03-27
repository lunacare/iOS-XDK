//
//  LYRUILinkMessageView.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 15.11.2017.
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

#import "LYRUILinkMessageView.h"

@implementation LYRUILinkMessageView

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
    [self addTextView];
    [self addImageView];
}

- (void)addTextView {
    UITextView *textView = [[UITextView alloc] init];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    textView.dataDetectorTypes = UIDataDetectorTypeAll;
    textView.linkTextAttributes = @{ NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.font = [UIFont systemFontOfSize:14.0];
    textView.textContainerInset = UIEdgeInsetsMake(8.0, 7.0, 9.0, 7.0);
    [self addSubview:textView];
    self.textView = textView;
}

- (void)addImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    self.imageView = imageView;
}

#pragma mark - LYRUIViewReusing

- (void)lyr_prepareForReuse {
    self.textView.text = nil;
    self.imageView.image = nil;
}

#pragma mark - Properties

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.textView.backgroundColor = backgroundColor;
    self.imageView.backgroundColor = backgroundColor;
}

@end
