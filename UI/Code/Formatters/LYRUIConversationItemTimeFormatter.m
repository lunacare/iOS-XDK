//
//  LYRUIConversationItemTimeFormatter.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 02.04.2018.
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

#import "LYRUIConversationItemTimeFormatter.h"
#import "LYRUIConfiguration+DependencyInjection.h"

@interface LYRUIConversationItemTimeFormatter ()

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation LYRUIConversationItemTimeFormatter
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    self.calendar = [layerConfiguration.injector objectOfType:[NSCalendar class]];
    self.dateFormatter = [layerConfiguration.injector objectOfType:[NSDateFormatter class]];
}

#pragma mark - LYRUIMessageTimeFormatting method

- (NSString *)stringForTime:(NSDate *)messageTime
            withCurrentTime:(NSDate *)currentTime {
    if ([self.calendar isDate:messageTime inSameDayAsDate:currentTime]) {
        [self setupDateFormatterForCurrentDay];
    } else if ([self numberOfUnits:NSCalendarUnitDay sinceTime:messageTime toCurrentTime:currentTime] == 1) {
        [self setupDateFormatterForYesterday];
        return [self.dateFormatter stringFromDate:[self yesterdayDate]];
    } else if ([self numberOfUnits:NSCalendarUnitDay sinceTime:messageTime toCurrentTime:currentTime] < 7) {
        [self setupDateFormatterForCurrentWeek];
    } else if ([self numberOfUnits:NSCalendarUnitYear sinceTime:messageTime toCurrentTime:currentTime] < 1) {
        [self setupDateFormatterForCurrentYear];
    } else {
        [self setupDateFormatterForPreviousYears];
    }
    return [self.dateFormatter stringFromDate:messageTime];
}

#pragma mark - Date formatter setup

- (void)setupDateFormatterForCurrentDay {
    self.dateFormatter.doesRelativeDateFormatting = NO;
    [self.dateFormatter setLocalizedDateFormatFromTemplate:@"jj:mm"];
}

- (void)setupDateFormatterForYesterday {
    self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateFormatter.doesRelativeDateFormatting = YES;
}

- (void)setupDateFormatterForCurrentWeek {
    self.dateFormatter.doesRelativeDateFormatting = NO;
    [self.dateFormatter setLocalizedDateFormatFromTemplate:@"E"];
}

- (void)setupDateFormatterForCurrentYear {
    self.dateFormatter.doesRelativeDateFormatting = NO;
    [self.dateFormatter setLocalizedDateFormatFromTemplate:@"MMMd"];
}

- (void)setupDateFormatterForPreviousYears {
    self.dateFormatter.doesRelativeDateFormatting = NO;
    self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
    self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
}

#pragma mark - Helpers

- (NSDate *)yesterdayDate {
    return [NSDate dateWithTimeIntervalSinceNow:-(60*60*24)];
}

- (NSUInteger)numberOfUnits:(NSCalendarUnit)units sinceTime:(NSDate *)time toCurrentTime:(NSDate *)currentTime {
    NSDateComponents *components = [self.calendar components:units
                                                    fromDate:time
                                                      toDate:currentTime
                                                     options:0];
    return [self numberOfUnits:units fromDateComponents:components];
}

- (NSUInteger)numberOfUnits:(NSCalendarUnit)unit fromDateComponents:(nonnull NSDateComponents *)dateComponents {
    switch (unit) {
        case NSCalendarUnitMinute:
            return [dateComponents minute];
        case NSCalendarUnitHour:
            return [dateComponents hour];
        case NSCalendarUnitDay:
            return [dateComponents day];
        case NSCalendarUnitMonth:
            return [dateComponents month];
        case NSCalendarUnitYear:
            return [dateComponents year];
            
        default:
            return 0;
    }
}

@end
