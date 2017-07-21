//
//  LYRUIShapedViewConfigurator.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 19.07.2017.
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
#import <LayerKit/LayerKit.h>
@class LYRUIShapedView;

NS_ASSUME_NONNULL_BEGIN     // {
@protocol LYRUIShapedViewTheming <NSObject, NSCopying>

- (UIColor *)fillColorForPresenceStatus:(LYRIdentityPresenceStatus)status;
- (UIColor *)strokeColorForPresenceStatus:(LYRIdentityPresenceStatus)status;

@end

/**
 @abstract The `LYRUIShapedViewConfigurator` class is responsible for configuring `LYRUIShapedView` colors according to the `LYRIdentityPresenceStatus`.
 */
@interface LYRUIShapedViewConfigurator : NSObject

/**
 @abstract The outside stroke color to set on `LYRUIShapedView`. Default is clear color.
 */
@property (nonatomic, copy) UIColor *outsideStrokeColor;

/**
 @abstract An object returning a set of colors for each `LYRIdentityPresenceStatus`. Default is an `LYRUIShapedViewDefaultTheme` instance.
 */
@property (nonatomic, copy, readonly) id<LYRUIShapedViewTheming> theme;

/**
 @abstract Initializes a new `LYRUIShapedViewConfigurator` object with the given theme conforming to `LYRUIShapedViewTheming` protocol.
 @param theme An object conforming to `LYRUIShapedViewTheming` protocol with a set of colors for each `LYRIdentityPresenceStatus`.
 @return An `LYRUIShapedViewConfigurator` object initialized with the given `theme`.
 */
- (instancetype)initWithTheme:(nullable id<LYRUIShapedViewTheming>)theme NS_DESIGNATED_INITIALIZER;

/**
 @abstract Configures the `LYRUIShapedView` instance colors according to the provided `LYRIdentityPresenceStatus`.
 @param shapedView An `LYRUIShapedView` which should be configured.
 @param status An `LYRIdentityPresenceStatus` for which the `shapedView` should be configured. 
 */
- (void)setupShapedView:(LYRUIShapedView *)shapedView forPresenceStatus:(LYRIdentityPresenceStatus)status;

@end
NS_ASSUME_NONNULL_END     // }
