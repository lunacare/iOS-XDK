//
//  LYRUIMessageAction.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 04.10.2017.
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

#import "LYRUIMessageAction.h"
#import <CoreLocation/CLLocation.h>

@interface LYRUIMessageAction ()

@property (nonatomic, readwrite) NSString *event;
@property (nonatomic, readwrite) NSDictionary *data;

@end

@implementation LYRUIMessageAction

- (instancetype)initWithEvent:(NSString *)event
                         data:(NSDictionary *)data {
    self = [super init];
    if (self) {
        self.event = event;
        self.data = data;
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)URL {
    NSDictionary *data = @{
            @"url": URL.absoluteString
    };
    self = [self initWithEvent:@"open-url" data:data];
    return self;
}

- (instancetype)initWithFileURL:(NSURL *)URL {
    if (![URL isFileURL]) {
        return nil;
    }
    NSDictionary *data = @{
            @"url": URL.path
    };
    self = [self initWithEvent:@"open-file" data:data];
    return self;
}

- (instancetype)initWithLocation:(CLLocation *)location {
    NSDictionary *data = @{
            @"latitude": @(location.coordinate.latitude),
            @"longitude": @(location.coordinate.longitude),
    };
    self = [self initWithEvent:@"open-map" data:data];
    return self;
}

@end
