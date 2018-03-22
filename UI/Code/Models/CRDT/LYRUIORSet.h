//
//  LYRUIORSet.h
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

#import <Foundation/Foundation.h>
#import "LYRUIOROperation.h"

@interface LYRUIORSet : NSObject

@property (nonatomic, strong, readonly) NSString *type;

@property (nonatomic, readonly) NSString *propertyName;

@property (nonatomic, strong, readonly) NSMutableOrderedSet<LYRUIOROperation *> *adds;

@property (nonatomic, strong, readonly) NSMutableOrderedSet<NSString *> *removes;

@property (nonatomic, readonly) NSDictionary *dictionary;

@property (nonatomic, readonly) NSOrderedSet *selectedValues;

- (instancetype)initWithPropertyName:(NSString *)propertyName;
- (instancetype)initWithPropertyName:(NSString *)propertyName dictionary:(NSDictionary *)dictionary;

- (void)addOperation:(LYRUIOROperation *)operation;
- (void)removeOperationWithID:(NSString *)operationID;
- (void)synchronizeWithSet:(LYRUIORSet *)remoteSet;

- (BOOL)containsOperationWithID:(NSString *)operationID;
- (LYRUIOROperation *)operationWithID:(NSString *)operationID;

@end
