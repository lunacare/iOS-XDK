//
//  LYRUIButtonsMessage.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 06.10.2017.
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

#import "LYRUIButtonsMessage.h"
#import "LYRUIMessageType+PrivateProperties.h"

@interface LYRUIButtonsMessage ()

@property (nonatomic, strong, readwrite, nullable) LYRUIMessageType *contentMessage;
@property (nonatomic, copy, readwrite) NSArray<LYRUIButtonsMessageActionButton *> *buttons;

@end

@implementation LYRUIButtonsMessage

- (instancetype)initWithButtons:(NSArray<LYRUIButtonsMessageActionButton *> *)buttons
                 contentMessage:(LYRUIMessageType *)contentMessage
                         action:(LYRUIMessageAction *)action
                         sender:(LYRIdentity *)sender
                         sentAt:(NSDate *)sentAt
                         status:(LYRUIMessageTypeStatus *)status {
    self = [super initWithAction:action
                          sender:sender
                          sentAt:sentAt
                          status:status];
    if (self) {
        self.buttons = buttons;
        self.contentMessage = contentMessage;
    }
    return self;
}

- (void)setContentMessage:(LYRUIMessageType *)contentMessage {
    _contentMessage = contentMessage;
    contentMessage.parentMessage = self;
}

+ (NSString *)MIMEType {
    return @"application/vnd.layer.buttons+json";
}

- (NSString *)summary {
    return nil;
}

- (LYRUIMessageAction *)action {
    return super.action ?: self.contentMessage.action;
}

@end
