//
//  LYRUICarouselScrolledAnalyticsEvent.h
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 13/8/2018.
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

#import "LYRUICarouselScrolledAnalyticsEvent.h"

NS_ASSUME_NONNULL_BEGIN     // {

@implementation LYRUICarouselScrolledAnalyticsEvent

- (instancetype)initWithMessage:(LYRMessage *)message position:(CGFloat)position {
    self = [super init];
    if (self) {
        if (!message) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Cannot create an instance of LYRUIMessageViewedAnalyticsEvent with message being `nil`." userInfo:nil];
        }
        _message = message;
        _scrollPosition = position;
    }
    return self;
}

+ (instancetype)carouselScrolledAnalyticsEventWithMessage:(LYRMessage *)message position:(CGFloat)position {
    return [[self alloc] initWithMessage:message position:position];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@:%p message=%@ position=%.2f>", self.class, self, self.message.identifier, self.scrollPosition];
}

@end

NS_ASSUME_NONNULL_END       // }
