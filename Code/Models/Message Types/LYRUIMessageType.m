//
//  LYRUIMessageType.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 04.10.2017.
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

#import "LYRUIMessageType.h"
#import <LayerKit/layerKit.h>

@interface LYRUIMessageType ()

@property (nonatomic, readwrite) LYRIdentity *sender;
@property (nonatomic, readwrite) NSDate *sentAt;
@property (nonatomic, readwrite) LYRUIMessageTypeStatus *status;
@property (nonatomic, weak, readwrite) LYRUIMessageType *parentMessage;
@property (nonatomic, readwrite) LYRUIMessageAction *action;

@end

@implementation LYRUIMessageType

- (instancetype)initWithAction:(LYRUIMessageAction *)action
                        sender:(LYRIdentity *)sender
                        sentAt:(NSDate *)sentAt
                        status:(LYRUIMessageTypeStatus *)status {
    self = [super init];
    if (self) {
        self.action = action;
        self.sender = sender;
        self.sentAt = sentAt;
        self.status = status;
    }
    return self;
}

- (NSString *)summary {
    return @"Unsupported message type";
}

+ (NSString *)MIMEType {
    return nil;
}

- (NSString *)MIMEType {
    return [[self class] MIMEType];
}

@end
