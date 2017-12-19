//
//  LYRUITimeAgoFormatter.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 14.07.2017.
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

#import "LYRUITimeAgoFormatter.h"
#import "LYRUIConfiguration+DependencyInjection.h"

@interface LYRUITimeAgoFormatter ()

@property(nonatomic, strong) NSCalendar *calendar;

@end

@implementation LYRUITimeAgoFormatter
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [self init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

#pragma mark - Properties

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    self.calendar = [layerConfiguration.injector objectOfType:[NSCalendar class]];
}

#pragma mark - LYRUITimeAgoDateFormatting method

- (NSString *)stringForTime:(NSDate *)time withCurrentTime:(NSDate *)currentTime {
    if ([self numberOfUnits:NSCalendarUnitYear sinceTime:time toCurrentTime:currentTime] > 0) {
        return [self timeAgoStringSinceTime:time toCurrentTime:currentTime inUnits:NSCalendarUnitYear];
    } else if ([self numberOfUnits:NSCalendarUnitMonth sinceTime:time toCurrentTime:currentTime] > 1) {
        return [self timeAgoStringSinceTime:time toCurrentTime:currentTime inUnits:NSCalendarUnitMonth];
    } else if ([self numberOfUnits:NSCalendarUnitDay sinceTime:time toCurrentTime:currentTime] > 1) {
        return [self timeAgoStringSinceTime:time toCurrentTime:currentTime inUnits:NSCalendarUnitDay];
    } else if ([self numberOfUnits:NSCalendarUnitHour sinceTime:time toCurrentTime:currentTime] > 1) {
        return [self timeAgoStringSinceTime:time toCurrentTime:currentTime inUnits:NSCalendarUnitHour];
    } else {
        return [self timeAgoStringSinceTime:time toCurrentTime:currentTime inUnits:NSCalendarUnitMinute];
    }
}

#pragma mark - Helpers

- (NSString *)timeAgoStringSinceTime:(NSDate *)time toCurrentTime:(NSDate *)currentTime inUnits:(NSCalendarUnit)units {
    NSUInteger timeUnits = [self numberOfUnits:units sinceTime:time toCurrentTime:currentTime];
    if (units == NSCalendarUnitMinute && timeUnits == 0) {
        timeUnits = 1;
    }
    return [self stringForTimeAgo:timeUnits inUnit:units];
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

- (nonnull NSString *)stringForTimeAgo:(NSUInteger)timeAgo inUnit:(NSCalendarUnit)unit {
    NSString *timeUnitString = [self timeUnitStringForUnit:unit];
    BOOL plural = (timeAgo > 1);
    return [NSString stringWithFormat:@"%lu %@%@ ago", (unsigned long)timeAgo, timeUnitString, (plural ? @"s" : @"")];
}

- (nullable NSString *)timeUnitStringForUnit:(NSCalendarUnit)unit {
    switch (unit) {
        case NSCalendarUnitMinute:
            return @"min";
        case NSCalendarUnitHour:
            return @"hour";
        case NSCalendarUnitDay:
            return @"day";
        case NSCalendarUnitMonth:
            return @"month";
        case NSCalendarUnitYear:
            return @"year";
        
        default:
            return nil;
    }
}

@end
