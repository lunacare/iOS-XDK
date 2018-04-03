//
//  LYRUIComposeBar.m
//  Layer-XDK-UI-iOS
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
#import "LYRUIComposeBarPresenter.h"
#import "LYRUIComposeBarIBSetup.h"
#import "LYRUIAutoresizingTextView.h"
#import "LYRUISendButton.h"
#import "LYRUIConfiguration+DependencyInjection.h"

@interface LYRUIComposeBar ()

@property (nonatomic, weak, readwrite) UITextView *inputTextView;
@property (nonatomic, strong, readwrite) LYRUISendButton *sendButton;

@property (nonatomic, strong) LYRUIComposeBarPresenter *presenter;

@end

@implementation LYRUIComposeBar
@synthesize layerConfiguration = _layerConfiguration,
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

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [self init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)lyr_commonInit {
    [self addInputTextView];
    [self addDefaultSendButton];
    [self setupDefaultFonts];
    [self setupDefaultColors];
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
    LYRUISendButton *button = [LYRUISendButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button.widthAnchor constraintEqualToConstant:55.0].active = YES;
    [button.heightAnchor constraintEqualToConstant:32.0].active = YES;
    self.rightItems = @[button];
    self.sendButton = button;
}

- (void)setupDefaultColors {
    self.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    self.messageInputColor = [UIColor whiteColor];
    self.messageInputBorderColor = [UIColor colorWithRed:219.0/255.0 green:222.0/255.0 blue:228.0/255.0 alpha:1.0];
    self.placeholderColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
    self.textColor = [UIColor colorWithRed:27.0/255.0 green:28.0/255.0 blue:29.0/255.0 alpha:1.0];
}

- (void)setupDefaultFonts {
    self.textFont = [UIFont systemFontOfSize:14.0];
}

- (void)prepareForInterfaceBuilder {
    [[[LYRUIComposeBarIBSetup alloc] init] prepareComposeBarForInterfaceBuilder:self];
}

- (void)dealloc {
    [self.presenter cleanupComposeBar:self];
}

#pragma mark - Properties

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    if (self.layout == nil) {
        self.layout = [layerConfiguration.injector layoutForViewClass:[self class]];
    }
    self.presenter = [layerConfiguration.injector presenterForViewClass:[self class]];
    [self.presenter configureComposeBar:self];
}

- (void)setLeftItems:(NSArray<UIView *> *)leftItems {
    NSMutableArray *subviewsToRemove = [NSMutableArray arrayWithArray:self.leftItems];
    [subviewsToRemove removeObjectsInArray:leftItems];
    [self removeSubviews:subviewsToRemove];
    _leftItems = leftItems;
    [self addSubviews:leftItems];
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}

- (void)setRightItems:(NSArray<UIView *> *)rightItems {
    NSMutableArray *subviewsToRemove = [NSMutableArray arrayWithArray:self.rightItems];
    [subviewsToRemove removeObjectsInArray:rightItems];
    [self removeSubviews:subviewsToRemove];
    _rightItems = rightItems;
    [self addSubviews:rightItems];
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}

- (NSString *)text {
    if (self.presenter) {
        return self.presenter.text;
    }
    return self.inputTextView.text;
}

- (void)setText:(NSString *)text {
    if (self.presenter) {
        self.presenter.text = text;
    } else {
        self.inputTextView.text = text;
    }
}

- (NSAttributedString *)attributedText {
    return self.presenter.attributedText;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    self.presenter.attributedText = attributedText;
}

- (CGFloat)messageInputCornerRadius {
    return self.inputTextView.layer.cornerRadius;
}

- (void)setMessageInputCornerRadius:(CGFloat)messageInputCornerRadius {
    self.inputTextView.layer.cornerRadius = messageInputCornerRadius;
}

#pragma mark - Theme

- (UIColor *)messageInputColor {
    return self.inputTextView.backgroundColor;
}

- (void)setMessageInputColor:(UIColor *)messageInputColor {
    self.inputTextView.backgroundColor = messageInputColor;
}

- (UIColor *)messageInputBorderColor {
    return [UIColor colorWithCGColor:self.inputTextView.layer.borderColor];
}

- (void)setMessageInputBorderColor:(UIColor *)messageInputBorderColor {
    self.inputTextView.layer.borderColor = messageInputBorderColor.CGColor;
}

- (UIFont *)textFont {
    return self.inputTextView.font;
}

- (void)setTextFont:(UIFont *)textFont {
    self.inputTextView.font = textFont;
}

- (void)setTheme:(id<LYRUIComposeBarTheme>)theme {
    _theme = theme;
    self.messageInputColor = theme.messageInputColor;
    self.messageInputBorderColor = theme.messageInputBorderColor;
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
