//
//  LYRUIConfiguration+DependencyInjection.m
//  Layer-XDK-UI-iOS
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

#import "LYRUIConfiguration+DependencyInjection.h"
#import <objc/runtime.h>

static void *LYRUIConfigurationInjectorKey = &LYRUIConfigurationInjectorKey;

@implementation LYRUIConfiguration (DependencyInjection)

#pragma mark - Properties

- (id<LYRUIDependencyInjection>)injector {
    return objc_getAssociatedObject(self, LYRUIConfigurationInjectorKey);
}

- (void)setInjector:(id<LYRUIDependencyInjection>)injector {
    objc_setAssociatedObject(self, LYRUIConfigurationInjectorKey, injector, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
