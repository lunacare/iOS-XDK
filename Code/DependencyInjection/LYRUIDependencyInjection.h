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
@class LYRUIConfiguration;
@protocol LYRUIDependencyInjection;
@protocol LYRUIBaseItemViewTheme;
@protocol LYRUIImageCaching;

typedef id(^LYRUIDependencyProviding)(LYRUIConfiguration *);

@protocol LYRUIDependencyInjection <NSObject>

@property (nonatomic, weak) LYRUIConfiguration *layerConfiguration;

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
 @abstract Returns a presenter object for given view class.
 @param viewClass Class of the view for which the presenter should be returned.
 @return An presenter for given view class.
 */
- (id)presenterForViewClass:(Class)viewClass;

/**
 @abstract Returns a layout object for given view class.
 @param viewClass Class of the view for which the layout should be returned.
 @return An layout for given view class.
 */
- (id)layoutForViewClass:(Class)viewClass;

/**
 @abstract Returns an object conforming to `protocol` for use in given `class`.
 @param protocol A protocol for which an implementation should be returned.
 @param class Class of object in which the implementation object will be used.
 @return An object conforming to `protocol` for use in given `class`.
 */
- (id)protocolImplementation:(Protocol *)protocol forClass:(Class)class;

/**
 @abstract Returns an instance object of provided `type`.
 @param type Class of returned object.
 @return An instance of provided `type`.
 */
- (id)objectOfType:(Class)type;

@end
