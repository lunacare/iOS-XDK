//
//  LYRUIComposeBar.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 10.08.2017.
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

#import "LYRUIComposeBar.h"
#import "LYRUIComposeBarLayout.h"
#import "LYRUIComposeBarConfiguration.h"
#import "LYRUIComposeBarIBSetup.h"
#import "LYRUIAutoresizingTextView.h"

@interface LYRUIComposeBar ()

@property (nonatomic, weak, readwrite) UITextView *inputTextView;
@property (nonatomic, weak, readwrite) UIButton *sendButton;

@property (nonatomic, strong) LYRUIComposeBarConfiguration *configuration;

@end

@implementation LYRUIComposeBar
@synthesize sendButtonTitleFont = _sendButtonTitleFont,
            textFont = _textFont;
@dynamic layout;

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

- (instancetype)initWithConfiguration:(LYRUIComposeBarConfiguration *)configuration {
    self = [super init];
    if (self) {
        [self lyr_commonInitWithConfiguration:configuration];
    }
    return self;
}

- (void)lyr_commonInit {
    [self lyr_commonInitWithConfiguration:nil];
}

- (void)lyr_commonInitWithConfiguration:(LYRUIComposeBarConfiguration *)configuration {
    [self addInputTextView];
    [self addDefaultSendButton];
    [self setupConfiguration:configuration];
    [self setupDefaultFonts];
    [self setupDefaultColors];
    self.layout = [[LYRUIComposeBarLayout alloc] init];
}

- (void)addInputTextView {
    UITextView *textView = [[LYRUIAutoresizingTextView alloc] init];
    textView.layer.cornerRadius = 8.0;
    textView.layer.borderWidth = 1.0;
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableDictionary *attributes = [textView.typingAttributes mutableCopy];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineHeightMultiple:1.13];
    attributes[NSParagraphStyleAttributeName] = style;
    textView.typingAttributes = attributes;
    
    textView.textContainerInset = UIEdgeInsetsMake(6.0, 4.0, 6.0, 4.0);
    [self addSubview:textView];
    
    self.inputTextView = textView;
}

- (void)addDefaultSendButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:@"Send" forState:UIControlStateNormal];
    [button.widthAnchor constraintEqualToConstant:55.0].active = YES;
    [button.heightAnchor constraintEqualToConstant:32.0].active = YES;
    button.enabled = NO;
    self.rightItems = @[button];
    self.sendButton = button;
}

- (void)setupConfiguration:(LYRUIComposeBarConfiguration *)configuration {
    if (configuration == nil) {
        configuration = [[LYRUIComposeBarConfiguration alloc] init];
    }
    self.configuration = configuration;
    [configuration configureComposeBar:self];
}

- (void)setupDefaultColors {
    self.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    self.messageBubbleColor = [UIColor whiteColor];
    self.messageBubbleBorderColor = [UIColor colorWithRed:219.0/255.0 green:222.0/255.0 blue:228.0/255.0 alpha:1.0];
    self.sendButtonEnabledColor = [UIColor colorWithRed:16.0/255.0 green:148.0/255.0 blue:208.0/255.0 alpha:1.0];
    UIColor *lightGrayColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
    self.sendButtonDisabledColor = lightGrayColor;
    self.placeholderColor = lightGrayColor;
    self.textColor = [UIColor colorWithRed:27.0/255.0 green:28.0/255.0 blue:29.0/255.0 alpha:1.0];
}

- (void)setupDefaultFonts {
    self.textFont = [UIFont systemFontOfSize:14.0];
    self.sendButtonTitleFont = [UIFont boldSystemFontOfSize:14.0];
}

- (void)prepareForInterfaceBuilder {
    [[[LYRUIComposeBarIBSetup alloc] init] prepareComposeBarForInterfaceBuilder:self];
}

- (void)dealloc {
    [self.configuration cleanup];
}

#pragma mark - Properties

- (void)setLeftItems:(NSArray<UIView *> *)leftItems {
    [self removeSubviews:self.leftItems];
    _leftItems = leftItems;
    [self addSubviews:leftItems];
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}

- (void)setRightItems:(NSArray<UIView *> *)rightItems {
    [self removeSubviews:self.rightItems];
    _rightItems = rightItems;
    [self addSubviews:rightItems];
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    [self.configuration placeholderUpdated];
}

- (NSString *)messageText {
    return self.configuration.messageText;
}

- (void)setMessageText:(NSString *)messageText {
    self.configuration.messageText = messageText;
}

- (NSAttributedString *)attributedMessageText {
    return self.configuration.attributedMessageText;
}

- (void)setAttributedMessageText:(NSAttributedString *)attributedMessageText {
    self.configuration.attributedMessageText = attributedMessageText;
}

- (CGFloat)messageBubbleCornerRadius {
    return self.inputTextView.layer.cornerRadius;
}

- (void)setMessageBubbleCornerRadius:(CGFloat)messageBubbleCornerRadius {
    self.inputTextView.layer.cornerRadius = messageBubbleCornerRadius;
}

#pragma mark - Theme

- (UIColor *)messageBubbleColor {
    return self.inputTextView.backgroundColor;
}

- (void)setMessageBubbleColor:(UIColor *)messageBubbleColor {
    self.inputTextView.backgroundColor = messageBubbleColor;
}

- (UIColor *)messageBubbleBorderColor {
    return [UIColor colorWithCGColor:self.inputTextView.layer.borderColor];
}

- (void)setMessageBubbleBorderColor:(UIColor *)messageBubbleBorderColor {
    self.inputTextView.layer.borderColor = messageBubbleBorderColor.CGColor;
}

- (UIColor *)sendButtonEnabledColor {
    return [self.sendButton titleColorForState:UIControlStateNormal];
}

- (void)setSendButtonEnabledColor:(UIColor *)sendButtonEnabledColor {
    [self.sendButton setTitleColor:sendButtonEnabledColor forState:UIControlStateNormal];
}

- (UIColor *)sendButtonDisabledColor {
    return [self.sendButton titleColorForState:UIControlStateDisabled];
}

- (void)setSendButtonDisabledColor:(UIColor *)sendButtonDisabledColor {
    [self.sendButton setTitleColor:sendButtonDisabledColor forState:UIControlStateDisabled];
}

- (UIFont *)sendButtonTitleFont {
    return self.sendButton.titleLabel.font;
}

- (void)setSendButtonTitleFont:(UIFont *)sendButtonTitleFont {
    self.sendButton.titleLabel.font = sendButtonTitleFont;
}

- (UIFont *)textFont {
    return self.inputTextView.font;
}

- (void)setTextFont:(UIFont *)textFont {
    self.inputTextView.font = textFont;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self.configuration colorsUpdated];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self.configuration colorsUpdated];
}

- (void)updateTheme:(id<LYRUIComposeBarTheme>)theme {
    self.messageBubbleColor = theme.messageBubbleColor;
    self.messageBubbleBorderColor = theme.messageBubbleBorderColor;
    self.sendButtonTitleFont = theme.sendButtonTitleFont;
    self.sendButtonEnabledColor = theme.sendButtonEnabledColor;
    self.sendButtonDisabledColor = theme.sendButtonDisabledColor;
    self.textFont = theme.textFont;
    self.textColor = theme.textColor;
    self.placeholderColor = theme.placeholderColor;
}

#pragma mark - Helpers

- (void)removeSubviews:(NSArray<UIView *> *)subviews {
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
}

- (void)addSubviews:(NSArray<UIView *> *)subviews {
    for (UIView *view in subviews) {
        [self addSubview:view];
    }
}

@end
