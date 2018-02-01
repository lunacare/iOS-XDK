//
//  LYRMessage+LYRUIHelpers.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 03.10.2017.
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

#import "LYRMessage+LYRUIHelpers.h"
#import "LYRUIMessageAttributesManager.h"
#import <objc/runtime.h>

static void *LYRUIMessageAttributesManagerKey = &LYRUIMessageAttributesManagerKey;

@interface LYRMessage ()

@property (nonatomic, readonly) LYRUIMessageAttributesManager *attributesManager;

@end

@implementation LYRMessage (LYRUIHelpers)

- (LYRUIMessageAttributesManager *)attributesManager {
    LYRUIMessageAttributesManager *attributesManager = objc_getAssociatedObject([self class], LYRUIMessageAttributesManagerKey);
    if (attributesManager == nil) {
        attributesManager = [[LYRUIMessageAttributesManager alloc] init];
        objc_setAssociatedObject([self class], LYRUIMessageAttributesManagerKey, attributesManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return attributesManager;
}

- (LYRMessagePart *)rootPart {
    return [self.attributesManager messageRootPart:self];
}

- (NSDictionary *)properties {
    return [self.attributesManager messageProperties:self];
}

@end
