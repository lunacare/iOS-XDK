//
//  LYRUISendButton.h
//  Layer-UI-iOS
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

#import <UIKit/UIKit.h>

@protocol LYRUISendButtonTheme <NSObject>

/**
 @abstract The font of the send button title. Default is 14pt system font.
 */
@property (nonatomic, copy) UIFont *titleFont;

/**
 @abstract The color of enabled send button. Default is blue.
 */
@property (nonatomic, copy) UIColor *enabledColor;

/**
 @abstract The color of disabled send button. Default is light gray.
 */
@property (nonatomic, copy) UIColor *disabledColor;

@end

@interface LYRUISendButton : UIButton <LYRUISendButtonTheme>

/**
 @abstract LYRUISendButtonTheme properties overridden to IBInspectable.
 */
@property (nonatomic, copy) IBInspectable UIColor *enabledColor;
@property (nonatomic, copy) IBInspectable UIColor *disabledColor;

/**
 @abstract A set of fonts and colors to use in send button.
 */
@property (nonatomic, strong) id<LYRUISendButtonTheme> theme UI_APPEARANCE_SELECTOR;

@end
