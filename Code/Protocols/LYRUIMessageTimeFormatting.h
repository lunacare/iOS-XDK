//
//  LYRUIMessageTimeFormatting.h
//  Layer-iOS-UI
//
//  Created by Łukasz Przytuła on 06.07.2017.
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

/**
 @abstract The `LYRUIMessageTimeFormatting` protocol must be adopted by objects that will be used for providing a string describing the time of sending a message.
 */
@protocol LYRUIMessageTimeFormatting <NSObject>

/**
 @abstract Provides a formatted date string to display for a given message time in accordance to provided current time.
 @param messageTime  An `NSDate` representing time of message.
 @param currentTime An `NSDate` representing current time.
 @return The string to be displayed as the time of the message.
 */
- (NSString *)stringForMessageTime:(NSDate *)messageTime withCurrentTime:(NSDate *)currentTime;

@end
