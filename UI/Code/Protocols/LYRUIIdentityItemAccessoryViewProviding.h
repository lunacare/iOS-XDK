//
//  LYRUIIdentityItemAccessoryViewProviding.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 28.07.2017.
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
@class LYRIdentity;

NS_ASSUME_NONNULL_BEGIN     // {
@protocol LYRUIIdentityItemAccessoryViewProviding <NSObject>

/**
 @abstract Provides an accessory view representing a conversation.
 @param identity The `LYRIdentity` object.
 @return An `UIView` visually representing the conversation.
 @discussion The view will be added to the `LYRUIConversationItemView` as an accessory view.
 */
- (UIView *)accessoryViewForIdentity:(LYRIdentity *)identity;

/**
 @abstract Configures an existing accessory view representing a conversation.
 @param accessoryView The view to update with provided data.
 @param identity The `LYRIdentity` object.
 @discussion This method should be use to update appearance of existing, reused accessory view.
 */
- (void)setupAccessoryView:(UIView *)accessoryView forIdentity:(LYRIdentity *)identity;

@end
NS_ASSUME_NONNULL_END       // }
