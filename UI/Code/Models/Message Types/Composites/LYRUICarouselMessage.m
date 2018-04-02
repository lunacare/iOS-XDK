//
//  LYRUICarouselMessage.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 04.12.2017.
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

#import "LYRUICarouselMessage.h"
#import "LYRUIMessageType+PrivateProperties.h"

@interface LYRUICarouselMessage ()

@property (nonatomic, strong, readwrite) NSArray<LYRUIMessageType *> *carouselItemMessages;
@property (nonatomic, copy, readwrite) NSString *identifier;

@end

@implementation LYRUICarouselMessage

- (instancetype)initWithItemMessages:(NSArray<LYRUIMessageType *> *)itemMessages
                          identifier:(nullable NSString *)identifier
                              action:(nullable LYRUIMessageAction *)action
                              sender:(nullable LYRIdentity *)sender
                              sentAt:(nullable NSDate *)sentAt
                              status:(nullable LYRUIMessageTypeStatus *)status {
    self = [super initWithAction:action
                          sender:sender
                          sentAt:sentAt
                          status:status];
    if (self) {
        self.carouselItemMessages = itemMessages;
        self.identifier = identifier;
    }
    return self;
}

- (void)setCarouselItemMessages:(NSArray<LYRUIMessageType *> *)carouselItemMessages {
    _carouselItemMessages = carouselItemMessages;
    for (LYRUIMessageType *message in carouselItemMessages) {
        message.parentMessage = self;
    }
}

+ (NSString *)MIMEType {
    return @"application/vnd.layer.carousel+json";
}

- (NSString *)summary {
    return @"carousel";
}

@end
