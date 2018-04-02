//
//  LYRUIMessageSender.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 31.08.2017.
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

#import <Foundation/Foundation.h>
#import "LYRUIConfigurable.h"
@class LYRConversation;
@class LYRUIMessageType;
@class CLLocation;

@interface LYRUIMessageSender : NSObject <LYRUIConfigurable>

/**
 @abstract A `LYRConversation` instance used to send messages.
 */
@property (nonatomic, weak) LYRConversation *conversation;

/**
 @abstract Method used to send message with provided `NSAttributedString`.
 @param attributedString A `NSAttributedString` containing text and attachments, used to create new message.
 */
- (void)sendMessageWithAttributedString:(NSAttributedString *)attributedString;

/**
 @abstract Method used to send message with provided `UIImage`.
 @param image A `UIImage` used to create new message.
 */
- (void)sendMessageWithImage:(UIImage *)image;

/**
 @abstract Method used to send message with provided `CLLocation`.
 @param location A `CLLocation` used to create new message.
 */
- (void)sendMessageWithLocation:(CLLocation *)location;

/**
 @abstract Method used to send provided `message`.
 @param message A `LYRUIMessageType` to send.
 */
- (void)sendMessage:(LYRUIMessageType *)message;

@end
