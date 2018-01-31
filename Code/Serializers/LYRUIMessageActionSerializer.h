//
//  LYRUIMessageActionSerializer.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 31.01.2018.
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
@class LYRUIMessageAction;

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUIMessageActionSerializer : NSObject

/**
 @abstract Deserializes `LYRUIMessageAction` object from given `properties` of serialized message.
 @param properties Serialized message action properties.
 @return An `LYRUIMessageAction` instance with given properties, or nil if there are no sufficient properties.
 */
- (nullable LYRUIMessageAction *)actionFromProperties:(NSDictionary *)properties;

/**
 @abstract Deserializes `LYRUIMessageAction` object from given `properties` of serialized message, using default event name.
 @param properties Serialized message action properties.
 @param event Default event name, used whenever there is no event name in properties.
 @return An `LYRUIMessageAction` instance with given properties, or nil if there are no sufficient properties.
 */
- (nullable LYRUIMessageAction *)actionFromProperties:(NSDictionary *)properties
                                     withDefaultEvent:(NSString *)event;

/**
 @abstract Deserializes `LYRUIMessageAction` object from given `properties` of serialized message, overriding the base action properties.
 @param properties Serialized message action properties.
 @param baseAction An `LYRUIMessageAction` instance used as default values for new action, when any of properties is missing.
 @return An `LYRUIMessageAction` instance with given properties, or nil if there are no sufficient properties.
 */
- (nullable LYRUIMessageAction *)actionFromProperties:(NSDictionary *)properties
                                     overridingAction:(LYRUIMessageAction *)baseAction;

/**
 @abstract Serializes `LYRUIMessageAction` object to `NSDictionary`.
 @param action An `LYRUIMessageAction` instance to serialize.
 @return An `NSDictionary` containing all properties of `action`.
 */
- (NSDictionary *)propertiesForAction:(LYRUIMessageAction *)action;

@end
NS_ASSUME_NONNULL_END       // }
