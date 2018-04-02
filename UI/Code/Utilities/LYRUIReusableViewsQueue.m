//
//  LYRUIReusableViewsQueue.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 03.11.2017.
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

#import "LYRUIReusableViewsQueue.h"

@interface LYRUIReusableViewsQueue ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray *> *queues;

@end

@implementation LYRUIReusableViewsQueue

- (instancetype)init {
    self = [super init];
    if (self) {
        self.queues = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSMutableArray *)queueForViewType:(Class)viewType {
    NSMutableArray *queue = self.queues[NSStringFromClass(viewType)];
    if (queue == nil) {
        queue = [[NSMutableArray alloc] init];
        self.queues[NSStringFromClass(viewType)] = queue;
    }
    return queue;
}

#pragma mark - Public methods

- (__kindof UIView *)dequeueReusableViewOfType:(Class)viewType {
    NSMutableArray *queue = [self queueForViewType:viewType];
    UIView *view;
    if (queue.count > 0) {
        view = queue.lastObject;
        [queue removeLastObject];
    }
    return view;
}

- (void)enqueueReusableView:(__kindof UIView *)view {
    if (view == nil) {
        return;
    }
    NSMutableArray *queue = [self queueForViewType:[view class]];
    [queue addObject:view];
}

@end
