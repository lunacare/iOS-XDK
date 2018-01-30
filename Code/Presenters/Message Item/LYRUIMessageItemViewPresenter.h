//
//  LYRUIMessageItemViewPresenter.h
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

#import "LYRUIMessageItemView.h"
#import "LYRUIConfigurable.h"
@protocol LYRUIMessageItemAccessoryViewProviding;
@class LYRIdentity;
@class LYRMessage;

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUIMessageItemViewPresenter : NSObject <LYRUIConfigurable>

/**
 @abstract The object provides an primary accessory view for message item.
 */
@property (nonatomic, strong) id<LYRUIMessageItemAccessoryViewProviding> primaryAccessoryViewProvider;

/**
 @abstract Updates the view conforming to `LYRUIMessageItemView` protocol with data from given `LYRMessage`.
 @param messageItemView The UIView conforming to `LYRUIMessageItemView` protocol to be set up.
 @param message The `LYRMessage` object to be presented on messages list.
 */
- (void)setupMessageItemView:(UIView<LYRUIMessageItemView> *)messageItemView
                 withMessage:(LYRMessage *)message;

/**
 @abstract Calculates height for displaying an UIView conforming to `LYRUIMessageItemView` protocol with data from given `LYRMessage`.
 @param message The `LYRMessage` object which height should be calculated.
 @param maxWidth Maximum width for presenting the `message`.
 */
- (CGFloat)messageViewHeightForMessage:(LYRMessage *)message maxWidth:(CGFloat)maxWidth;

@end
NS_ASSUME_NONNULL_END       // }
