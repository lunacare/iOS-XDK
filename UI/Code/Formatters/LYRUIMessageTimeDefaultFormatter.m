//
//  LYRUIMessageTimeDefaultFormatter.m
//  Layer-XDK-UI-iOS
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

#import "LYRUIMessageTimeDefaultFormatter.h"
#import "LYRUIConfiguration+DependencyInjection.h"

@interface LYRUIMessageTimeDefaultFormatter ()

@property(nonatomic, strong) NSCalendar *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation LYRUIMessageTimeDefaultFormatter
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
    self.dateFormatter = [layerConfiguration.injector objectOfType:[NSDateFormatter class]];
}

#pragma mark - LYRUIMessageTimeFormatting method

- (NSString *)stringForTime:(NSDate *)messageTime
            withCurrentTime:(NSDate *)currentTime {
    if ([self.calendar isDate:messageTime inSameDayAsDate:currentTime]) {
        [self setupDateFormatterForCurrentDay];
    } else {
        [self setupDateFormatterForOtherDay];
    }
    return [self.dateFormatter stringFromDate:messageTime];
}

#pragma mark - Date formatter setup

- (void)setupDateFormatterForCurrentDay {
    self.dateFormatter.dateStyle = NSDateFormatterNoStyle;
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
}

- (void)setupDateFormatterForOtherDay {
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
}

@end
