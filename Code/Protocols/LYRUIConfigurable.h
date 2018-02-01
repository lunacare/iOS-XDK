//
//  LYRUIConfigurable.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 15.12.2017.
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
#import "LYRUIConfiguration.h"

NS_ASSUME_NONNULL_BEGIN     // {
/**
 @abstract Objects conforming to the `LYRUIConfigurable` protocol need to be set up with `LYRUIConfiguration` object.
 */
@protocol LYRUIConfigurable <NSObject>

@required

/**
 @abstract The `presenter` of object. Used to setup and retrieving dependencies.
 @discussion When object is initialized without using `initWithConfiguration:` (e.g. when using storyboards), this property must be set explicitly.
 */
@property (nonatomic, weak) LYRUIConfiguration *layerConfiguration;

/**
 @abstract Initializes a new instance of `LYRUIConfigurable` object with the presenter.
 @param configuration An `LYRUIConfiguration` instance, used to retrieve themes, and setup.
 @return An object conforming to `LYRUIConfigurable` protocol, set up using `presenter`.
 */
- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration;

@end
NS_ASSUME_NONNULL_END       // }
