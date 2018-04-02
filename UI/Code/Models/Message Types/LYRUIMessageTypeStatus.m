//
//  LYRUIMessageTypeStatus.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 10.10.2017.
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

#import "LYRUIMessageTypeStatus.h"

@interface LYRUIMessageTypeStatus ()

@property (nonatomic, readwrite) LYRUIMessageStatus status;
@property (nonatomic, readwrite) NSString *statusDescription;

@end

@implementation LYRUIMessageTypeStatus

- (instancetype)initWithRecipientStatus:(LYRRecipientStatus)recipientStatus
                            description:(NSString *)description {
    self = [super init];
    if (self) {
        self.status = [self statusWithRecipientStatus:recipientStatus];
        self.statusDescription = description;
    }
    return self;
}

- (LYRUIMessageStatus)statusWithRecipientStatus:(LYRRecipientStatus)recipientStatus {
    switch (recipientStatus) {
        case LYRRecipientStatusRead:
            return LYRUIMessageStatusRead;
        case LYRRecipientStatusDelivered:
            return LYRUIMessageStatusDelivered;
        case LYRRecipientStatusSent:
            return LYRUIMessageStatusSent;
        case LYRRecipientStatusPending:
            return LYRUIMessageStatusPending;
            
        default:
            return LYRUIMessageStatusNew;
    }
}

@end
