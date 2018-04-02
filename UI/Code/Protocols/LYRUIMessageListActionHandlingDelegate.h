//
//  LYRUIMessageListActionHandlingDelegate.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 17.01.2018.
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
@protocol LYRUIActionHandling;
@class LYRUIMessageAction;

NS_ASSUME_NONNULL_BEGIN     // {
@protocol LYRUIMessageListActionHandlingDelegate

/**
 @abstract Method for handling the `LYRUIMessageAction` with given `handler`.
 @param action The `LYRUIMessageAction` to handle.
 @param handler An action handler specific for the message type it was called from. When nil, `action` should be handled by a default handler.
 */
- (void)handleAction:(LYRUIMessageAction *)action withHandler:(nullable id<LYRUIActionHandling>)handler;

- (nullable UIViewController *)previewControllerForAction:(LYRUIMessageAction *)action withHandler:(nullable id<LYRUIActionHandling>)handler;

@end
NS_ASSUME_NONNULL_END       // }
