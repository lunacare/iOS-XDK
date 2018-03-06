//
//  LYRUIComposeBarPresenter.m
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

#import "LYRUIComposeBarPresenter.h"
#import "LYRUIComposeBar.h"
#import "LYRUISendButton.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import <LayerKit/LayerKit.h>

@interface LYRUIComposeBarPresenter ()

@property (nonatomic, strong) NSNotificationCenter *notificationCenter;

@property (nonatomic, weak) LYRUIComposeBar *composeBar;
@property (nonatomic, readonly) UITextView *textView;

@property (nonatomic, strong) id textViewDidBeginEditingObserver;
@property (nonatomic, strong) id textViewTextChangedObserver;
@property (nonatomic, strong) id textViewDidEndEditingObserver;

@property (nonatomic) BOOL placeholderVisible;

@end

@implementation LYRUIComposeBarPresenter
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

#pragma mark - LYRUIComposeBar setup

- (void)configureComposeBar:(LYRUIComposeBar *)composeBar {
    self.composeBar = composeBar;
    
    NSString *inputText = composeBar.inputTextView.text;
    if (inputText == nil || inputText.length == 0) {
        [self showPlaceholder];
        composeBar.sendButton.enabled = NO;
    }
    
    [composeBar.sendButton addTarget:self
                              action:@selector(buttonPressed:)
                    forControlEvents:UIControlEventTouchUpInside];
    
    [self setupTextViewNotifications:composeBar.inputTextView];
    [self setupComposeBarKVO:composeBar];
}

- (void)setupTextViewNotifications:(UITextView *)textView {
    __weak __typeof(self) weakSelf = self;
    id beginEditingObserver =  [self.notificationCenter addObserverForName:UITextViewTextDidBeginEditingNotification
                                                                    object:textView
                                                                     queue:nil
                                                                usingBlock:^(NSNotification * _Nonnull notification) {
                                                                    [weakSelf didBeginEditing];
                                                                }];
    self.textViewDidBeginEditingObserver = beginEditingObserver;
    
    id textChangedObserver =  [self.notificationCenter addObserverForName:UITextViewTextDidChangeNotification
                                                                   object:textView
                                                                    queue:nil
                                                               usingBlock:^(NSNotification * _Nonnull notification) {
                                                                   [weakSelf textChanged];
                                                               }];
    self.textViewTextChangedObserver = textChangedObserver;
    
    id endEditingObserver =  [self.notificationCenter addObserverForName:UITextViewTextDidEndEditingNotification
                                                                  object:textView
                                                                   queue:nil
                                                              usingBlock:^(NSNotification * _Nonnull notification) {
                                                                  [weakSelf didEndEditing];
                                                              }];
    self.textViewDidEndEditingObserver = endEditingObserver;
}

- (void)setupComposeBarKVO:(LYRUIComposeBar *)composeBar {
    [composeBar addObserver:self forKeyPath:@"placeholder" options:NSKeyValueObservingOptionNew context:NULL];
    [composeBar addObserver:self forKeyPath:@"textColor" options:NSKeyValueObservingOptionNew context:NULL];
    [composeBar addObserver:self forKeyPath:@"placeholderColor" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)cleanup {
    [self removeTextViewNotifications];
    [self removeComposeBarKVO:self.composeBar];
}

- (void)removeTextViewNotifications {
    [self.notificationCenter removeObserver:self.textViewDidBeginEditingObserver];
    [self.notificationCenter removeObserver:self.textViewTextChangedObserver];
    [self.notificationCenter removeObserver:self.textViewDidEndEditingObserver];
}

- (void)removeComposeBarKVO:(LYRUIComposeBar *)composeBar {
    [composeBar removeObserver:self forKeyPath:@"placeholder"];
    [composeBar removeObserver:self forKeyPath:@"textColor"];
    [composeBar removeObserver:self forKeyPath:@"placeholderColor"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if (![object isEqual:self.composeBar]) {
        return;
    }
    
    if ([keyPath isEqualToString:@"placeholder"]) {
        [self placeholderUpdated];
    } else if ([keyPath isEqualToString:@"textColor"] || [keyPath isEqualToString:@"placeholderColor"]) {
        [self colorsUpdated];
    }
}

#pragma mark - LYRUIComposeBar logic

- (void)didBeginEditing {
    if (self.placeholderVisible) {
        self.placeholderVisible = NO;
        self.textView.textColor = self.composeBar.textColor;
        self.textView.text = nil;
    }
}

- (void)textChanged {
    [self updateSendButtonState];
    LYRTypingIndicatorAction action = self.textView.text.length > 0 ? LYRTypingIndicatorActionBegin : LYRTypingIndicatorActionFinish;
    [self.composeBar.conversation sendTypingIndicator:action];
}

- (void)didEndEditing {
    if (self.textView.text == nil || self.textView.text.length == 0) {
        [self showPlaceholder];
        self.composeBar.sendButton.enabled = NO;
    }
    [self.composeBar.conversation sendTypingIndicator:LYRTypingIndicatorActionFinish];
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

- (void)updateSendButtonState {
    if (!self.placeholderVisible) {
        self.composeBar.sendButton.enabled = (self.textView.text.length > 0 &&
                                              ![self.composeBar.placeholder isEqualToString:self.textView.text]);
    }
}

- (void)showPlaceholder {
    self.placeholderVisible = YES;
    self.textView.textColor = self.composeBar.placeholderColor;
    self.textView.text = self.composeBar.placeholder;
}

#pragma mark - Button Press Handling

- (void)buttonPressed:(LYRUISendButton *)sendButton {
    if (self.composeBar.text != nil) {
        if (self.composeBar.sendPressedBlock) {
            self.composeBar.sendPressedBlock(self.composeBar.attributedText);
        }
        self.composeBar.text = nil;
    }
}

#pragma mark - Properties

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    self.notificationCenter = [layerConfiguration.injector objectOfType:[NSNotificationCenter class]];
}

- (UITextView *)textView {
    return self.composeBar.inputTextView;
}

- (NSString *)text {
    if (self.placeholderVisible) {
        return nil;
    }
    return self.textView.text;
}

- (void)setText:(NSString *)text {
    if (self.textView.isFirstResponder == NO && (text == nil || text.length == 0)) {
        [self showPlaceholder];
    } else {
        self.placeholderVisible = NO;
        self.textView.textColor = self.composeBar.textColor;
        self.textView.text = text;
        [self updateSendButtonState];
    }
}

- (NSAttributedString *)attributedText {
    if (self.placeholderVisible) {
        return nil;
    }
    return self.textView.attributedText;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    if (self.textView.isFirstResponder == NO && (attributedText == nil || attributedText.length == 0)) {
        [self showPlaceholder];
    } else {
        self.placeholderVisible = NO;
        self.textView.textColor = self.composeBar.textColor;
        self.textView.attributedText = attributedText;
        [self updateSendButtonState];
    }
}

@end
