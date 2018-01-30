//
//  LYRUIMessageItemContentPresenting.h
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
@property (nonatomic, weak) LYRUIMessageItemContentPresentersProvider *presentersProvider;

/**
 @abstract Method for creating and configuring content view for given `messageType`.
 @param messageType Instance of `LYRUIMessageType` to present.
 @return Content view representing the `messageType`.
 */
- (UIView *)viewForMessageType:(LYRUIMessageType *)messageType;

/**
 @abstract Returns a background color to use wiht content view for given `messageType`.
 @param messageType Instance of `LYRUIMessageType` to present.
 @return Background color of the message content view.
 */
- (UIColor *)backgroundColorForMessage:(LYRUIMessageType *)messageType;

/**
 @abstract Method for calculating height of content view for `messageType`, with given width boundaries.
 @param messageType Instance of `LYRUIMessageType` to present.
 @param minWidth Minimum width of the message content view.
 @param maxWidth Maximum width of the message content view.
 @return Height of the view representing the `messageType`.
 */
- (CGFloat)viewHeightForMessageType:(LYRUIMessageType *)messageType minWidth:(CGFloat)minWidth maxWidth:(CGFloat)maxWidth;

@end
