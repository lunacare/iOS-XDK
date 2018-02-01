//
//  LYRUIComposeBarPresenter.h
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

#import <Foundation/Foundation.h>
#import "LYRUIConfigurable.h"
@class LYRUIComposeBar;

/**
 @abstract The `LYRUIComposeBarPresenter` will be used for presenting a `LYRUIComposeBar`, and handling placeholder, and send button state.
 */
@interface LYRUIComposeBarPresenter : NSObject <LYRUIConfigurable>

/**
 @abstract Compose bar's message input text.
 */
@property (nonatomic, copy) NSString *text;

/**
 @abstract Compose bar's attributed message input text.
 */
@property (nonatomic, copy) NSAttributedString *attributedText;

/**
 @abstract Configures the `LYRUIComposeBar` for proper handling of input text with placeholder, and managing send button state.
 @param composeBar An `LYRUIComposeBar` to be set up.
 */
- (void)configureComposeBar:(LYRUIComposeBar *)composeBar;

/**
 @abstract Cleans all observers from the `LYRUIComposeBar` configured using `configureComposeBar:` method.
 */
- (void)cleanup;

@end
