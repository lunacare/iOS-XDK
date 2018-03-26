//
//  LYRUIFWWRegister.m
//  Layer-UI-iOS
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

#import "LYRUIFWWRegister.h"

@implementation LYRUIFWWRegister

#pragma mark - Properties

- (NSString *)type {
    return @"FWW";
}

#pragma mark - Public methods

- (NSArray<NSDictionary *> *)addOperation:(LYRUIOROperation *)operation {
    if ([self containsOperationWithID:operation.operationID]) {
        return nil;
    }
    if (self.adds.count > 1) {
        [self removeOperationWithID:operation.operationID];
        return nil;
    }
    return [super addOperation:operation];
}

- (NSArray<NSDictionary *> *)removeOperationWithID:(NSString *)operationID {
    if ([self containsOperationWithID:operationID]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Cannot remove added value from FWW Register"
                                     userInfo:nil];
    }
    return [super removeOperationWithID:operationID];
}

@end
