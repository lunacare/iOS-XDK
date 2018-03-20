//
//  UIScrollView+LYRUIAdjustedContentInset.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 25.01.2018.
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

#import "UIScrollView+LYRUIAdjustedContentInset.h"
#import "NSObject+LYRUIObjectAssociation.h"

static void *LYRUICollectionViewOriginalContentInset = &LYRUICollectionViewOriginalContentInset;

@implementation UIScrollView (LYRUIAdjustedContentInset)

- (UIEdgeInsets)lyr_adjustedContentInset {
    SEL selector = NSSelectorFromString(@"adjustedContentInset");
    static BOOL adjustedContentInsetAvailable;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        adjustedContentInsetAvailable = [self respondsToSelector:selector];
    });
    if (!adjustedContentInsetAvailable) {
        return self.contentInset;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                [[self class] instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:self];
    [invocation invoke];
    UIEdgeInsets returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

- (NSString *)lyr_serializedOriginalContentInset {
    return [self lyr_getAssociatedPropertyWithKey:LYRUICollectionViewOriginalContentInset];
}

- (void)setLyr_serializedOriginalContentInset:(NSString *)lyr_serializedOriginalContentInset {
    [self lyr_setAssociatedPropertyWithKey:LYRUICollectionViewOriginalContentInset object:lyr_serializedOriginalContentInset];
}

@end
