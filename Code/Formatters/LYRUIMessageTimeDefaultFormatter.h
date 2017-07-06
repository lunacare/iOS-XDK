//
//  LYRUIMessageTimeDefaultFormatter.h
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

#import "LYRUIMessageTimeFormatting.h"

/**
 @abstract The `LYRUIMessageTimeFormatting` protocol must be adopted by objects that will be used for providing a string describing the time of sending a message.
 */
@interface LYRUIMessageTimeDefaultFormatter : NSObject <LYRUIMessageTimeFormatting>

/**
 @abstract Initialize with a calendar and date formatter.
 @param calendar A calendar used to determine if the message time is in the same day as current time. Default is `currentCalendar`.
 @param dateFormatter A date formatter used to format the message time. Default is a calendar with `currentLocale` and `systemTimeZone`.
 */
- (nonnull instancetype)initWithCalendar:(nullable NSCalendar *)calendar
                           dateFormatter:(nullable NSDateFormatter *)dateFormatter NS_DESIGNATED_INITIALIZER;

@end
