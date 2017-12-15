//
//  LYRUIDependencyInjection.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 14.12.2017.
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
@protocol LYRUIDependencyInjection;
@protocol LYRUIBaseItemViewTheme;

typedef id(^LYRUIDependencyProviding)(id<LYRUIDependencyInjection>);

@protocol LYRUIDependencyInjection <NSObject>

/**
 @abstract Returns a theme object for given view class.
 @param viewClass Class of the view for which the theme should be returned.
 @return An theme for given view class.
 */
- (id)themeForViewClass:(Class)viewClass;

/**
 @abstract Returns a theme object for given view class alternative state.
 @param viewClass Class of the view for which the alternative theme should be returned.
 @return An alternative theme for given view class.
 */
- (id)alternativeThemeForViewClass:(Class)viewClass;

/**
 @abstract Returns a configuration object for given view class.
 @param viewClass Class of the view for which the configuration should be returned.
 @return An configuration for given view class.
 */
- (id)configurationForViewClass:(Class)viewClass;

/**
 @abstract Returns a layout object for given view class.
 @param viewClass Class of the view for which the layout should be returned.
 @return An layout for given view class.
 */
- (id)layoutForViewClass:(Class)viewClass;

@end
