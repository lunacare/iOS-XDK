//
//  LYRUIButtonsMessageCompositeView.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 12.10.2017.
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
#import "LYRUIViewWithLayout.h"
#import "LYRUIMessageViewContainer.h"
#import "LYRUIViewReusing.h"
@class LYRUIButtonsMessage;
@class LYRUIButtonsMessageCompositeView;
@class LYRUIMessageAction;
@protocol LYRUIMessageListActionHandlingDelegate;

NS_ASSUME_NONNULL_BEGIN     // {
@protocol LYRUIButtonsMessageCompositeViewLayout <LYRUIViewLayout>

- (void)addConstraintsInView:(LYRUIButtonsMessageCompositeView *)view;
- (void)removeConstraintsFromView:(LYRUIButtonsMessageCompositeView *)view;
- (void)updateConstraintsInView:(LYRUIButtonsMessageCompositeView *)view;

@end

@interface LYRUIButtonsMessageCompositeView : LYRUIViewWithLayout <LYRUIViewReusing, LYRUIMessageViewContainer>

@property (nonatomic, weak, readonly) UIView *contentViewContainer;
@property (nonatomic, weak, readonly) UIStackView *buttonsStackView;

@property (nonatomic, weak, nullable) id<LYRUIMessageListActionHandlingDelegate> actionHandlingDelegate;

/**
 @abstract Layout of the standard message container subviews. Default is an `LYRUIButtonsMessageCompositeViewLayout` instance.
 */
@property (nonatomic, copy) id<LYRUIButtonsMessageCompositeViewLayout> layout;

@end
NS_ASSUME_NONNULL_END       // }
