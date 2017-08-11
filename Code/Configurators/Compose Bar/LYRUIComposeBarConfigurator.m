//
//  LYRUIComposeBarConfigurator.m
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

#import "LYRUIComposeBarConfigurator.h"
#import "LYRUIComposeBar.h"

@interface LYRUIComposeBarConfigurator ()

@property (nonatomic, strong) NSNotificationCenter *notificationCenter;

@property (nonatomic, weak) LYRUIComposeBar *composeBar;
@property (nonatomic, readonly) UITextView *textView;

@property (nonatomic, strong) id textViewDidBeginEditingObserver;
@property (nonatomic, strong) id textViewTextChangedObserver;
@property (nonatomic, strong) id textViewDidEndEditingObserver;

@property (nonatomic) BOOL placeholderVisible;

@end

@implementation LYRUIComposeBarConfigurator

- (instancetype)init {
    self = [self initWithNotificationCenter:nil];
    return self;
}

- (instancetype)initWithNotificationCenter:(NSNotificationCenter *)notificationCenter {
    self = [super init];
    if (self) {
        self.placeholderVisible = YES;
        if (notificationCenter == nil) {
            notificationCenter = [NSNotificationCenter defaultCenter];
        }
        self.notificationCenter = notificationCenter;
    }
    return self;
}

#pragma mark - LYRUIComposeBar setup

- (void)configureComposeBar:(LYRUIComposeBar *)composeBar {
    self.composeBar = composeBar;
    
    [composeBar.sendButton addTarget:self
                              action:@selector(sendButtonPressed:)
                    forControlEvents:UIControlEventTouchUpInside];
    
    __weak __typeof(self) weakSelf = self;
    id beginEditingObserver =  [self.notificationCenter addObserverForName:UITextViewTextDidBeginEditingNotification
                                                                    object:composeBar.inputTextView
                                                                     queue:nil
                                                                usingBlock:^(NSNotification * _Nonnull notification) {
                                                                    [weakSelf didBeginEditing];
                                                                }];
    self.textViewDidBeginEditingObserver = beginEditingObserver;
    
    id textChangedObserver =  [self.notificationCenter addObserverForName:UITextViewTextDidChangeNotification
                                                                   object:composeBar.inputTextView
                                                                    queue:nil
                                                               usingBlock:^(NSNotification * _Nonnull notification) {
                                                                   [weakSelf textChanged];
                                                               }];
    self.textViewTextChangedObserver = textChangedObserver;
    
    id endEditingObserver =  [self.notificationCenter addObserverForName:UITextViewTextDidEndEditingNotification
                                                                  object:composeBar.inputTextView
                                                                   queue:nil
                                                              usingBlock:^(NSNotification * _Nonnull notification) {
                                                                  [weakSelf didEndEditing];
                                                              }];
    self.textViewDidEndEditingObserver = endEditingObserver;
}

- (void)cleanup {
    [self.composeBar.sendButton removeTarget:self
                                      action:@selector(sendButtonPressed:)
                            forControlEvents:UIControlEventTouchUpInside];
    [self.notificationCenter removeObserver:self.textViewDidBeginEditingObserver];
    [self.notificationCenter removeObserver:self.textViewTextChangedObserver];
    [self.notificationCenter removeObserver:self.textViewDidEndEditingObserver];
}

#pragma mark - LYRUIComposeBar logic

- (void)didBeginEditing {
    if ([self.textView.text isEqualToString:self.composeBar.placeholder]) {
        self.placeholderVisible = NO;
        self.textView.textColor = self.composeBar.textColor;
        self.textView.text = nil;
    }
}

- (void)textChanged {
    if (!self.placeholderVisible) {
        self.composeBar.sendButton.enabled = (self.textView.text.length > 0 &&
                                              ![self.composeBar.placeholder isEqualToString:self.textView.text]);
    }
}

- (void)didEndEditing {
    if (self.textView.text == nil || self.textView.text.length == 0) {
        [self showPlaceholder];
        self.composeBar.sendButton.enabled = NO;
    }
}

- (void)sendButtonPressed:(UIButton *)sendButton {
    if (!self.placeholderVisible) {
        if (self.composeBar.sendButtonPressedCallback) {
            self.composeBar.sendButtonPressedCallback(self.textView.attributedText);
        }
        self.textView.text = nil;
    }
}

- (void)placeholderUpdated {
    if (self.placeholderVisible) {
        [self showPlaceholder];
    }
}

- (void)colorsUpdated {
    if (self.placeholderVisible) {
        self.textView.textColor = self.composeBar.placeholderColor;
    } else {
        self.textView.textColor = self.composeBar.textColor;
    }
}

- (void)showPlaceholder {
    self.placeholderVisible = YES;
    self.textView.textColor = self.composeBar.placeholderColor;
    self.textView.text = self.composeBar.placeholder;
}

#pragma mark - Properties

- (UITextView *)textView {
    return self.composeBar.inputTextView;
}

- (NSString *)messageText {
    if (self.placeholderVisible) {
        return nil;
    }
    return self.textView.text;
}

- (void)setMessageText:(NSString *)messageText {
    if (messageText == nil || messageText.length == 0) {
        [self showPlaceholder];
    } else {
        self.placeholderVisible = NO;
        self.textView.textColor = self.composeBar.textColor;
        self.textView.text = messageText;
    }
}

- (NSAttributedString *)attributedMessageText {
    if (self.placeholderVisible) {
        return nil;
    }
    return self.textView.attributedText;
}

- (void)setAttributedMessageText:(NSAttributedString *)attributedMessageText {
    if (attributedMessageText == nil || attributedMessageText.length == 0) {
        [self showPlaceholder];
    } else {
        self.placeholderVisible = NO;
        self.textView.attributedText = attributedMessageText;
    }
}

@end
