//
//  LYRUIBubbleTypingIndicatorCollectionViewCell.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 18.09.2017.
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

#import "LYRUIBubbleTypingIndicatorCollectionViewCell.h"
#import "LYRUIBubbleTypingIndicatorView.h"
#import "LYRUIDotsBubbleView.h"

@implementation LYRUIBubbleTypingIndicatorCollectionViewCell

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
    LYRUIBubbleTypingIndicatorView *typingIndicatorView = [[LYRUIBubbleTypingIndicatorView alloc] init];
    typingIndicatorView.backgroundColor = [UIColor clearColor];
    typingIndicatorView.frame = self.contentView.bounds;
    typingIndicatorView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.contentView addSubview:typingIndicatorView];
    self.typingIndicatorView = typingIndicatorView;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.typingIndicatorView.bubbleView.animating = NO;
}

@end
