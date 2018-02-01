//
//  LYRUIChoiceMessageCompositeView.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 16.01.2018.
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

#import "LYRUIViewWithLayout.h"
#import "LYRUIMessageViewContainer.h"
#import "LYRUIViewReusing.h"
@class LYRUIChoiceMessage;
@class LYRUIChoiceMessageCompositeView;
@class LYRUIChoiceView;
@class LYRUIMessageAction;

NS_ASSUME_NONNULL_BEGIN     // {
@protocol LYRUIChoiceMessageCompositeViewLayout <LYRUIViewLayout>

- (void)addConstraintsInView:(LYRUIChoiceMessageCompositeView *)view;
- (void)removeConstraintsFromView:(LYRUIChoiceMessageCompositeView *)view;
- (void)updateConstraintsInView:(LYRUIChoiceMessageCompositeView *)view;

@end

@interface LYRUIChoiceMessageCompositeView : LYRUIViewWithLayout <LYRUIViewReusing, LYRUIMessageViewContainer>

@property (nonatomic, weak, readonly) UIView *contentViewContainer;
@property (nonatomic, weak, readonly) LYRUIChoiceView *choiceView;

@property (nonatomic, copy, nullable) void(^actionHandler)(LYRUIMessageAction *);

/**
 @abstract Layout of the standard message container subviews. Default is an `LYRUIChoiceMessageCompositeViewLayout` instance.
 */
@property (nonatomic, copy) id<LYRUIChoiceMessageCompositeViewLayout> layout;

@end
NS_ASSUME_NONNULL_END       // }
