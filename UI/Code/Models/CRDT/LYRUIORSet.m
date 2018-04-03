//
//  LYRUIORSet.m
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

#import "LYRUIORSet.h"

@interface LYRUIORSet ()

@property (nonatomic, readwrite) NSString *propertyName;

@property (nonatomic, strong, readwrite) NSMutableOrderedSet<LYRUIOROperation *> *adds;

@property (nonatomic, strong, readwrite) NSMutableOrderedSet<NSString *> *removes;

@end

@implementation LYRUIORSet

- (instancetype)initWithPropertyName:(NSString *)propertyName {
    self = [super init];
    if (self) {
        self.propertyName = propertyName;
        self.adds = [[NSMutableOrderedSet alloc] init];
        self.removes = [[NSMutableOrderedSet alloc] init];
    }
    return self;
}

- (instancetype)initWithPropertyName:(NSString *)propertyName dictionary:(NSDictionary *)dictionary {
    self = [self initWithPropertyName:propertyName];
    if (self) {
        for (NSDictionary *operationDictionary in dictionary[@"adds"]) {
            NSString *value = operationDictionary[@"value"];
            if (value == nil || value.length == 0) {
                continue;
            }
            for (NSString *operationID in operationDictionary[@"ids"]) {
                if (operationID.length == 0) {
                    continue;
                }
                LYRUIOROperation *operation = [[LYRUIOROperation alloc] initWithValue:value
                                                                          operationID:operationID];
                [self.adds addObject:operation];
            }
        }
        NSArray *removes = dictionary[@"removes"];
        if (removes != nil) {
            [self.removes addObjectsFromArray:removes];
        }
    }
    return self;
}

#pragma mark - Properties

- (NSString *)type {
    return @"Set";
}

- (NSDictionary *)dictionary {
    NSMutableDictionary<NSString *, NSMutableArray *> *valueOperationIDs = [[NSMutableDictionary alloc] init];
    for (LYRUIOROperation *operation in self.adds) {
        if (valueOperationIDs[operation.value] == nil) {
            valueOperationIDs[operation.value] = [[NSMutableArray alloc] init];
        }
        [valueOperationIDs[operation.value] addObject:operation.operationID];
    }
    NSMutableArray *adds = [[NSMutableArray alloc] init];
    for (NSString *key in valueOperationIDs.allKeys) {
        [adds addObject:@{
                @"ids": valueOperationIDs[key],
                @"value": key,
        }];
    }
    return @{
            @"adds": adds,
            @"removes": [self.removes array]
    };
}

- (NSArray *)operationsDictionaries {
    NSMutableArray *operations = [[NSMutableArray alloc] initWithCapacity:self.adds.count + self.removes.count];
    for (LYRUIOROperation *operation in self.adds) {
        [operations addObject:[self dictionaryForOperation:@"add" value:operation.value identifier:operation.operationID]];
    }
    for (NSString *operationID in self.removes) {
        [operations addObject:[self dictionaryForOperation:@"remove" value:nil identifier:operationID]];
    }
    return [operations copy];
}

- (NSOrderedSet *)selectedValues {
    NSMutableOrderedSet *values = [[NSMutableOrderedSet alloc] init];
    for (LYRUIOROperation *operation in self.adds) {
        [values addObject:operation.value];
    }
    return [values copy];
}

#pragma mark - Public methods

- (NSArray<NSDictionary *> *)addOperation:(LYRUIOROperation *)operation {
    if ([self containsOperationWithID:operation.operationID]) {
        return nil;
    }
    [self.adds addObject:operation];
    return @[[self dictionaryForOperation:@"add" value:operation.value identifier:operation.operationID]];
}

- (NSArray<NSDictionary *> *)removeOperationWithID:(NSString *)operationID {
    NSString *value = nil;
    if ([self containsOperationWithID:operationID]) {
        LYRUIOROperation *operation = [self operationWithID:operationID];
        [self.adds removeObject:operation];
        value = operation.value;
    }
    [self.removes addObject:operationID];
    return @[[self dictionaryForOperation:@"remove" value:value identifier:operationID]];
}

- (void)synchronizeWithSet:(LYRUIORSet *)remoteSet {
    if (remoteSet == nil) {
        return;
    }
    NSMutableOrderedSet<LYRUIOROperation *> *oldAdds = self.adds;
    NSMutableOrderedSet<NSString *> *oldRemoves = self.removes;
    self.adds = [remoteSet.adds mutableCopy];
    self.removes = [remoteSet.removes mutableCopy];
    
    for (NSString *operationID in oldRemoves) {
        if ([self containsOperationWithID:operationID]) {
            [self.adds removeObject:[self operationWithID:operationID]];
        }
        [self.removes addObject:operationID];
    }
    
    for (LYRUIOROperation *operation in oldAdds) {
        if (![self.removes containsObject:operation.operationID]) {
            [self addOperation:operation];
        }
    }
}

#pragma mark - Helpers

- (BOOL)containsOperationWithID:(NSString *)operationID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"operationID == %@", operationID];
    return [self.adds filteredOrderedSetUsingPredicate:predicate].count > 0;
}

- (LYRUIOROperation *)operationWithID:(NSString *)operationID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"operationID == %@", operationID];
    NSOrderedSet *operationsWithID = [self.adds filteredOrderedSetUsingPredicate:predicate];
    if (operationsWithID.count > 1) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"The OR-Set contains multiple operations with same ID"
                                     userInfo:nil];
    }
    return operationsWithID.firstObject;
}

- (NSDictionary *)dictionaryForOperation:(NSString *)operation
                                   value:(nullable NSString *)value
                              identifier:(NSString *)identifier {
    NSMutableDictionary *operationDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{
            @"operation": operation,
            @"type": self.type,
            @"name": self.propertyName,
            @"id": identifier,
    }];
    operationDictionary[@"value"] = value;
    return [operationDictionary copy];
}

@end
