//
//  LYRUILWWRegister.m
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

#import "LYRUILWWRegister.h"

@implementation LYRUILWWRegister

#pragma mark - Properties

- (NSString *)type {
    return @"LWW";
}

#pragma mark - Public methods

- (void)addOperation:(LYRUIOROperation *)operation {
    if ([self containsOperationWithID:operation.operationID]) {
        return;
    }
    for (LYRUIOROperation *operation in [self.adds copy]) {
        [self.adds removeObject:operation];
        [self.removes addObject:operation.operationID];
    }
    [self.adds addObject:operation];
}

- (void)removeOperationWithID:(NSString *)operationID {
    if ([self containsOperationWithID:operationID]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Cannot remove added value from LWW Register"
                                     userInfo:nil];
    }
    [self.removes addObject:operationID];
}

@end
