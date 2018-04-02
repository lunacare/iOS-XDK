//
//  LYRUIDispatching.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 26.07.2017.
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
/**
 @abstract Objects conforming to the `LYRUIDispatching` protocol will be used to dispatch tasks on specified queue.
 */
@protocol LYRUIDispatching <NSObject>

/**
 @abstract Dispatches the task asynchronously on main queue.
 @param block The block of code with the task to perform on main queue.
 */
- (void)dispatchAsyncOnMainQueue:(void(^)(void))block;

/**
 @abstract Dispatches the task asynchronously on queue queue with provided priority.
 @param priority Priority of the global queue on which block should be performed.
 @param block The block of code with the task to perform on global queue.
 */
- (void)dispatchAsyncOnGlobalQueue:(dispatch_queue_priority_t)priority block:(void (^)(void))block;

/**
 @abstract Dispatches the task asynchronously on provided queue.
 @param queue The queue on which block should be performed.
 @param block The block of code with the task to perform on provided queue.
 */
- (void)dispatchAsyncOnQueue:(dispatch_queue_t)queue block:(void (^)(void))block;

@end
