//
//  LYRUIActionHandling.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 21.09.2017.
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
@protocol LYRUIMessageListActionHandlingDelegate;
@protocol LYRUIActionHandling;
@class LYRUIMessageType;

NS_ASSUME_NONNULL_BEGIN     // {
@protocol LYRUIActionHandlingDelegate <NSObject>

- (void)actionHandler:(id<LYRUIActionHandling>)actionHandler presentViewController:(UIViewController *)viewController;
- (void)actionHandler:(id<LYRUIActionHandling>)actionHandler sendMessage:(LYRUIMessageType *)messageType;

@end

@protocol LYRUIActionHandling <NSObject>

- (void)handleActionWithData:(id)data delegate:(id<LYRUIActionHandlingDelegate>)delegate;
- (nullable UIViewController *)viewControllerForActionWithData:(id)data;

@end
NS_ASSUME_NONNULL_END       // }
