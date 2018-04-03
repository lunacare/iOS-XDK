//
//  LYRUIOROperation.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 22.03.2018.
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

static NSUInteger const LYRUIOROperationIDLength = 6;

#import "LYRUIOROperation.h"
#include <stdlib.h>

@interface LYRUIOROperation ()

@property (nonatomic, readwrite) NSString *value;

@property (nonatomic, readwrite) NSString *operationID;

@end

@implementation LYRUIOROperation

- (instancetype)initWithValue:(NSString *)value {
    self = [self initWithValue:value operationID:nil];
    return self;
}

- (instancetype)initWithValue:(NSString *)value operationID:(NSString *)operationID {
    self = [super init];
    if (self) {
        self.value = value;
        if (operationID == nil) {
            operationID = [self generateOperationID];
        }
        self.operationID = operationID;
    }
    return self;
}

- (NSString *)generateOperationID {
    NSMutableString *operationID = [[NSMutableString alloc] initWithCapacity:LYRUIOROperationIDLength];
    for (NSUInteger i = 0; i < LYRUIOROperationIDLength; i += 1) {
        [operationID appendFormat:@"%c", (arc4random_uniform(91) + 35)];
    }
    return operationID;
}

@end
