//
//  LYRUIStatusMessage.m
//  Layer-XDK-UI-iOS
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

#import "LYRUIStatusMessage.h"

@interface LYRUIStatusMessage ()

@property (nonatomic, readwrite) NSString *text;

@end

@implementation LYRUIStatusMessage

- (instancetype)initWithText:(NSString *)text {
    self = [self initWithText:text action:nil sender:nil sentAt:nil status:nil messagePart:nil];
    return self;
}

- (instancetype)initWithText:(NSString *)text
                      action:(LYRUIMessageAction *)action
                      sender:(LYRIdentity *)sender
                      sentAt:(NSDate *)sentAt
                      status:(LYRUIMessageTypeStatus *)status
                 messagePart:(nullable LYRMessagePart *)messagePart {
    self = [super initWithAction:action sender:sender sentAt:sentAt status:status messagePart:messagePart];
    if (self) {
        self.text = text;
    }
    return self;
}

+ (NSString *)MIMEType {
    return @"application/vnd.layer.status+json";
}

- (NSString *)summary {
    return self.text ?: @"Status";
}

@end
