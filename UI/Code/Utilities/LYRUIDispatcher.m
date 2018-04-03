//
//  LYRUIDispatcher.m
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

#import "LYRUIDispatcher.h"

@implementation LYRUIDispatcher

- (void)dispatchAsyncOnMainQueue:(void(^)(void))block {
    [self dispatchAsyncOnQueue:dispatch_get_main_queue() block:block];
}

- (void)dispatchAsyncOnGlobalQueue:(dispatch_queue_priority_t)priority block:(void (^)(void))block {
    [self dispatchAsyncOnQueue:dispatch_get_global_queue(priority, 0) block:block];
}

- (void)dispatchAsyncOnQueue:(dispatch_queue_t)queue block:(void (^)(void))block {
    dispatch_async(queue, block);
}

@end
