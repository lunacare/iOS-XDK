//
//  LYRUIMessageRecipientStatusFormatter.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 28.08.2017.
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

#import <LayerKit/LayerKit.h>
@class LYRIdentity;

NS_ASSUME_NONNULL_BEGIN     // {
/**
 @abstract The `LYRUIMessageRecipientStatusFormatter` objects will be used for providing a string describing the status of recipients of a message.
 */
@interface LYRUIMessageRecipientStatusFormatter : NSObject

/**
 @abstract A currently logged in user, used to filter out from message recipients.
 */
@property (nonatomic, strong, nullable) LYRIdentity *currentUser;

/**
 @abstract Provides a formatted string to display as the message recipients status.
 @param message  An `LYRMessage` for which the status description should be returned.
 @return The string to be displayed as the recipients status of the `message`.
 */
- (NSString *)stringForMessageRecipientStatus:(LYRMessage *)message;

/**
 @abstract Provides a status of the `message`.
 @param message  An `LYRMessage` for which the status should be returned.
 @return The `LYRRecipientStatus` enum value of most of the recipients of the `message`.
 */
- (LYRRecipientStatus)statusForMessage:(LYRMessage *)message;

@end
NS_ASSUME_NONNULL_END       // }
