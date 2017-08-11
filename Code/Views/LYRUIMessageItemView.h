//
//  LYRUIMessageItemView.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 11.08.2017.
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
@class LYRUIMessageItemView;

NS_ASSUME_NONNULL_BEGIN     // {
@protocol LYRUIMessageItemView <NSObject>

@property(nonatomic, strong, nullable) UIView *primaryAccessoryView;
@property(nonatomic, strong, nullable) UIView *contentHeader;
@property(nonatomic, strong, nullable) UIView *contentView;
@property(nonatomic, strong, nullable) UIView *contentFooter;
@property(nonatomic, strong, nullable) UIView *secondaryAccessoryView;

@end

typedef NS_ENUM(NSUInteger, LYRUIMessageItemViewLayoutDirection) {
    LYRUIMessageItemViewLayoutDirectionLeft = 1,
    LYRUIMessageItemViewLayoutDirectionRight = -1,
};

@protocol LYRUIMessageItemViewLayout <LYRUIViewLayout>

@property (nonatomic) LYRUIMessageItemViewLayoutDirection layoutDirection;

- (void)addConstraintsInView:(LYRUIMessageItemView *)view;

- (void)updateConstraintsInView:(LYRUIMessageItemView *)view;

- (void)removeConstraintsFromView:(LYRUIMessageItemView *)view;

@end

IB_DESIGNABLE
@interface LYRUIMessageItemView : LYRUIViewWithLayout <LYRUIMessageItemView>

@property (nonatomic, weak, readonly) UIView *primaryAccessoryViewContainer;
@property (nonatomic, weak, readonly) UIView *contentContainer;
@property (nonatomic, weak, readonly) UIView *contentHeaderContainer;
@property (nonatomic, weak, readonly) UIView *contentViewContainer;
@property (nonatomic, weak, readonly) UIView *contentFooterContainer;
@property (nonatomic, weak, readonly) UIView *secondaryAccessoryViewContainer;

@property (nonatomic, copy) id<LYRUIMessageItemViewLayout> layout;
@property (nonatomic) LYRUIMessageItemViewLayoutDirection layoutDirection;

@end
NS_ASSUME_NONNULL_END       // }
