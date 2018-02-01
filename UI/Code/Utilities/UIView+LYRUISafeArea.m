//
//  UIView+LYRUISafeArea.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 09.01.2018.
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

#import "UIView+LYRUISafeArea.h"

@implementation UIView (LYRUISafeArea)

- (UIEdgeInsets)lyr_safeAreaInsets {
    SEL selector = NSSelectorFromString(@"safeAreaInsets");
    static BOOL safeAreaInsetsAvailable;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        safeAreaInsetsAvailable = [self respondsToSelector:selector];
    });
    if (!safeAreaInsetsAvailable) {
        return UIEdgeInsetsZero;
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

- (UILayoutGuide *)lyr_safeAreaLayoutGuide {
    SEL selector = NSSelectorFromString(@"safeAreaLayoutGuide");
    static BOOL safeAreaLayoutGuideAvailable;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        safeAreaLayoutGuideAvailable = [self respondsToSelector:selector];
    });
    if (!safeAreaLayoutGuideAvailable) {
        return nil;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                [[self class] instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:self];
    [invocation invoke];
    __unsafe_unretained UILayoutGuide *returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

@end
