//
//  LYRUIMessageItemViewConfiguration.m
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

#import "LYRUIMessageItemViewConfiguration.h"
#import "LYRUIMessageItemView.h"
#import <LayerKit/LayerKit.h>
#import "LYRUIMessageTextDefaultFormatter.h"
#import "LYRUIAvatarViewProvider.h"

@interface LYRUIMessageItemViewConfiguration ()

@property (nonatomic, strong) UITextView *sizingTextView;
@property (nonatomic, strong) id<LYRUIMessageTextFormatting> messageFormatter;

@end

@implementation LYRUIMessageItemViewConfiguration

- (instancetype)init {
    self = [self initWithPrimaryAccessoryViewProvider:nil];
    return self;
}

- (instancetype)initWithPrimaryAccessoryViewProvider:(id<LYRUIMessageItemAccessoryViewProviding>)primaryAccessoryViewProvider {
    self = [super init];
    if (self) {
        self.messageFormatter = [[LYRUIMessageTextDefaultFormatter alloc] init];
        if (primaryAccessoryViewProvider == nil) {
            primaryAccessoryViewProvider = [[LYRUIAvatarViewProvider alloc] init];
        }
        self.primaryAccessoryViewProvider = primaryAccessoryViewProvider;
        self.sizingTextView = [self createContentTextView];
    }
    return self;
}

- (void)setupMessageItemView:(UIView<LYRUIMessageItemView> *)messageItemView withMessage:(LYRMessage *)message {
    if (messageItemView == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Cannot setup Message Item View with nil `messageItemView` argument." userInfo:nil];
    }
    if (message == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Cannot setup Message Item View with nil `message` argument." userInfo:nil];
    }
    
    if (messageItemView.contentView == nil) {
        messageItemView.contentView = [self createContentTextView];
    }
    UITextView *textView = (UITextView *)messageItemView.contentView;
    NSString *messageText = [self.messageFormatter stringForMessage:message];
    textView.text = messageText;
    
    messageItemView.contentView.backgroundColor = [UIColor colorWithWhite:242.0/255.0 alpha:1.0];
    textView.textColor = [UIColor blackColor];
    
    if (messageItemView.primaryAccessoryView == nil) {
        messageItemView.primaryAccessoryView = [self.primaryAccessoryViewProvider accessoryViewForMessage:message];
    } else {
        [self.primaryAccessoryViewProvider setupAccessoryView:messageItemView.primaryAccessoryView forMessage:message];
    }
}

- (UITextView *)createContentTextView {
    // TODO: extract to provider
    UITextView *textView = [[UITextView alloc] init];
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.font = [UIFont systemFontOfSize:14.0];
    textView.textContainerInset = UIEdgeInsetsMake(7.0, 7.0, 7.0, 7.0);
    return textView;
}

- (CGFloat)messageViewHeightForMessage:(LYRMessage *)message maxWidth:(CGFloat)maxWidth {
    // TODO: extract to provider
    CGFloat textWidth = maxWidth - 28.0;
    NSString *messageText = [self.messageFormatter stringForMessage:message];
    self.sizingTextView.text = messageText;
    CGRect stringRect = [self.sizingTextView.text boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                                               options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                            attributes:self.sizingTextView.typingAttributes
                                                               context:nil];
    CGFloat textViewHeight = ceil(stringRect.size.height);
    return textViewHeight + 14.0;
}

@end
