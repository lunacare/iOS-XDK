//
//  LYRUIButtonsMessage.h
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

#import "LYRUIMessageType.h"
#import "LYRUIButtonsMessageActionButton.h"

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUIButtonsMessage : LYRUIMessageType

@property (nonatomic, strong, readonly, nullable) LYRUIMessageType *contentMessage;
@property (nonatomic, copy, readonly) NSArray<LYRUIButtonsMessageActionButton *> *buttons;

- (instancetype)initWithButtons:(NSArray<LYRUIButtonsMessageActionButton *> *)buttons
                 contentMessage:(nullable LYRUIMessageType *)contentMessage
                         action:(nullable LYRUIMessageAction *)action
                         sender:(nullable LYRIdentity *)sender
                         sentAt:(nullable NSDate *)sentAt
                         status:(nullable LYRUIMessageTypeStatus *)status;

@end
NS_ASSUME_NONNULL_END       // }
