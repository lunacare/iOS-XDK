//
//  LYRUISendButton.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 13.11.2017.
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

#import "LYRUISendButton.h"

@implementation LYRUISendButton
@synthesize titleFont;

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
    self.titleFont = [UIFont boldSystemFontOfSize:14.0];
    self.enabledColor = [UIColor colorWithRed:16.0/255.0 green:148.0/255.0 blue:208.0/255.0 alpha:1.0];
    self.disabledColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
    [self setTitle:@"Send" forState:UIControlStateNormal];
}

#pragma mark - Theme

- (UIFont *)titleFont {
    return self.titleLabel.font;
}

- (void)setTitleFont:(UIFont *)titleFont {
    self.titleLabel.font = titleFont;
}

- (UIColor *)enabledColor {
    return [self titleColorForState:UIControlStateNormal];
}

- (void)setEnabledColor:(UIColor *)enabledColor {
    [self setTitleColor:enabledColor forState:UIControlStateNormal];
}

- (UIColor *)disabledColor {
    return [self titleColorForState:UIControlStateDisabled];
}

- (void)setDisabledColor:(UIColor *)disabledColor {
    [self setTitleColor:disabledColor forState:UIControlStateDisabled];
}

- (void)setTheme:(id<LYRUISendButtonTheme>)theme {
    _theme = theme;
    self.titleFont = theme.titleFont;
    self.enabledColor = theme.enabledColor;
    self.disabledColor = theme.disabledColor;
}

@end
