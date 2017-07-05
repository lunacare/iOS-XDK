//
//  LYRUIViewLayout.h
//  Layer-iOS-UI
//
//  Created by Łukasz Przytuła on 04.07.2017.
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

NS_ASSUME_NONNULL_BEGIN
/**
 @abstract Objects conforming to the `LYRUIViewLayout` protocol will be used to add, remove, or update AutoLayout constraints in the view passed to them.
 */
@protocol LYRUIViewLayout <NSObject, NSCopying>

/**
 @abstract Adds constraints to the view and its subviews.
 @param view The view to add constraints in.
 */
- (void)addConstraintsInView:(__kindof UIView *)view;

/**
 @abstract Removes constraints added prviously in `addConstraintsInView:` method.
 @param view The view to remove constraints from.
 */
- (void)removeConstraintsFromView:(__kindof UIView *)view;

/**
 @abstract Updates constraints added prviously in `addConstraintsInView:` method.
 @param view The view to update constraints in.
 */
- (void)updateConstraintsInView:(__kindof UIView *)view;
@end
NS_ASSUME_NONNULL_END
