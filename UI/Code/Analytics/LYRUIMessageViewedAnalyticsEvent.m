//
//  LYRUIMessageViewedAnalyticsEvent.m
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 8/13/18.
//  Copyright (c) 2018 Layer. All rights reserved.
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

#import "LYRUIMessageViewedAnalyticsEvent.h"

NS_ASSUME_NONNULL_BEGIN     // {

@implementation LYRUIMessageViewedAnalyticsEvent

- (instancetype)initWithMessage:(LYRMessage *)message {
    self = [super init];
    if (self) {
        if (!message) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Cannot create an instance of LYRUIMessageViewedAnalyticsEvent with message being `nil`." userInfo:nil];
        }
        _message = message;
    }
    return self;
}

+ (instancetype)messageViewedAnalyticsEventWithMessage:(LYRMessage *)message {
    return [[self alloc] initWithMessage:message];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@:%p message=%@>", self.class, self, self.message.identifier];
}

@end

NS_ASSUME_NONNULL_END       // }
