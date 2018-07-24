//
//  LYRUIMessageItemContentPresenting.h
//  Layer-XDK-UI-iOS
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

#import <UIKit/UIKit.h>
#import "LYRUIMessageListActionHandlingDelegate.h"
@protocol LYRUIMessageItemView;
@protocol LYRUIActionHandling;
@class LYRUIMessageType;
@class LYRUIReusableViewsQueue;
@class LYRUIMessageItemContentPresentersProvider;
@class LYRUIMessageType;
@class LYRUIMessageAction;

@protocol LYRUIMessageItemContentPresenting <NSObject>

/**
 @abstract A delegate used for handling message actions.
 */
@property (nonatomic, weak) id <LYRUIMessageListActionHandlingDelegate> actionHandlingDelegate;

/**
 @abstract A queue for reusing message item content views.
 */
@property (nonatomic, strong) LYRUIReusableViewsQueue *reusableViewsQueue;

/**
 @abstract A delegate used for handling message actions.
 */
@property (nonatomic, weak) __kindof LYRUIMessageItemContentPresentersProvider *presentersProvider;

/**
 @abstract Method for creating and configuring content view for given `message`.
 @param message Instance of `LYRUIMessageType` to present.
 @return Content view representing the `message`.
 */
- (UIView *)viewForMessage:(LYRUIMessageType *)message;

/**
 @abstract Returns a background color to use wiht content view for given `message`.
 @param message Instance of `LYRUIMessageType` to present.
 @return Background color of the message content view.
 */
- (UIColor *)backgroundColorForMessage:(LYRUIMessageType *)message;

/**
 @abstract Method for calculating height of content view for `message`, with given width boundaries.
 @param message Instance of `LYRUIMessageType` to present.
 @param minWidth Minimum width of the message content view.
 @param maxWidth Maximum width of the message content view.
 @return Height of the view representing the `message`.
 */
- (CGFloat)viewHeightForMessage:(LYRUIMessageType *)message minWidth:(CGFloat)minWidth maxWidth:(CGFloat)maxWidth;

@end
