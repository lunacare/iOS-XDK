//
//  LYRUIMessageItemAccessoryViewProviding.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 02.11.2017.
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
#import "LYRUIParticipantsFiltering.h"
@class LYRMessage;

NS_ASSUME_NONNULL_BEGIN     // {
@protocol LYRUIMessageItemAccessoryViewProviding <NSObject>

/**
 @abstract Provides an accessory view representing a message.
 @param message The `LYRMessage` object.
 @return An `UIView` visually representing the message.
 @discussion The view will be added to the `LYRUIMessageItemView` as an accessory view.
 */
- (UIView *)accessoryViewForMessage:(LYRMessage *)message;

/**
 @abstract Configures an existing accessory view representing a message.
 @param accessoryView The view to update with provided data.
 @param message The `LYRMessage` object.
 @discussion This method should be use to update appearance of existing, reused accessory view.
 */
- (void)setupAccessoryView:(UIView *)accessoryView forMessage:(LYRMessage *)message;

@end
NS_ASSUME_NONNULL_END       // }
