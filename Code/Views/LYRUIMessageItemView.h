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
@property(nonatomic, strong, nullable) UIView *contentView;
@property(nonatomic, strong, nullable) UIView *secondaryAccessoryView;
@property (nonatomic, copy) UIColor *contentViewColor;

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
/**
 @abstract The `LYRUIMessageItemView` class provides a lightweight, customizable view for presenting Layer message objects.
 */
@interface LYRUIMessageItemView : LYRUIViewWithLayout <LYRUIMessageItemView>

/**
 @abstract An primary accessory view for the item, i.e. an avatar view;
 */
@property(nonatomic, strong, nullable) IBOutlet UIView *primaryAccessoryView;

/**
 @abstract An secondary accessory view for the item, i.e. an disclosure indicator;
 */
@property(nonatomic, strong, nullable) IBOutlet UIView *secondaryAccessoryView;

/**
 @abstract The view in which the primary accessory view will be contained;
 */
@property (nonatomic, weak, readonly) UIView *primaryAccessoryViewContainer;

/**
 @abstract The view in which the content view will be contained;
 */
@property (nonatomic, weak, readonly) UIView *contentViewContainer;

/**
 @abstract The view in which the secondary accessory view will be contained;
 */
@property (nonatomic, weak, readonly) UIView *secondaryAccessoryViewContainer;

/**
 @abstract Layout of the message item subviews.
 */
@property (nonatomic, copy) id<LYRUIMessageItemViewLayout> layout;

/**
 @abstract Direction of conversation item subviews alignment.
 */
@property (nonatomic) LYRUIMessageItemViewLayoutDirection layoutDirection;

/**
 @abstract Initialize with a layout.
 */
- (instancetype)initWithLayout:(id<LYRUIMessageItemViewLayout>)layout;

@end
NS_ASSUME_NONNULL_END       // }
