//
//  LYRUIChoiceSelectionsSetFactory.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 26.03.2018.
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

#import "LYRUIChoiceSelectionsSetFactory.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIORSet.h"
#import "LYRUIFWWRegister.h"
#import "LYRUILWWRegister.h"
#import "LYRUILWWNRegister.h"

static NSString * const LYRUIChoiceSelectionsSetFactoryMultiselectionKey = @"allow_multiselect";
static NSString * const LYRUIChoiceSelectionsSetFactoryDeselectionKey = @"allow_deselect";
static NSString * const LYRUIChoiceSelectionsSetFactoryReselectionKey = @"allow_reselect";

@implementation LYRUIChoiceSelectionsSetFactory
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (LYRUIORSet *)selectionsSetFromResponseSummary:(NSDictionary *)responseSummary
                                  dataProperties:(NSDictionary *)dataProperties
                              customResponseName:(NSString *)responseName {
    if (responseSummary == nil || ![responseSummary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSString *currentUserID = self.layerConfiguration.client.authenticatedUser.identifier.absoluteString;
    NSDictionary *userData = responseSummary[currentUserID];
    NSDictionary *selectionsSetDictionary = userData[responseName];
    if (selectionsSetDictionary == nil || ![selectionsSetDictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [self selectionsSetWithDictionary:selectionsSetDictionary
                              dataProperties:dataProperties
                          customResponseName:responseName];
}

- (LYRUIORSet *)selectionsSetFromInitialResponseState:(NSArray *)initialResponseState
                                       dataProperties:(NSDictionary *)dataProperties
                                   customResponseName:(NSString *)responseName {
    if (initialResponseState == nil || ![initialResponseState isKindOfClass:[NSArray class]]) {
        return nil;
    }
    NSString *currentUserID = self.layerConfiguration.client.authenticatedUser.identifier.absoluteString;
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"name == %@ && identity_id == %@", responseName, currentUserID];
    NSArray *filteredOperations = [initialResponseState filteredArrayUsingPredicate:namePredicate];
    LYRUIORSet *set = [self selectionsSetWithDictionary:nil
                                         dataProperties:dataProperties
                                     customResponseName:responseName];
    for (NSDictionary *operationDictionary in filteredOperations) {
        NSString *value = operationDictionary[@"value"];
        if (value == nil || value.length == 0) {
            continue;
        }
        NSString *operationID = operationDictionary[@"id"];
        if (operationID == nil || operationID.length == 0) {
            continue;
        }
        LYRUIOROperation *operation = [[LYRUIOROperation alloc] initWithValue:value operationID:operationID];
        [set addOperation:operation];
    }
    return set;
}

- (LYRUIORSet *)selectionsSetWithDictionary:(NSDictionary *)selectionsSetDictionary
                             dataProperties:(NSDictionary *)dataProperties
                         customResponseName:(NSString *)responseName {
    if ([dataProperties[LYRUIChoiceSelectionsSetFactoryMultiselectionKey] boolValue]) {
        return [[LYRUIORSet alloc] initWithPropertyName:responseName dictionary:selectionsSetDictionary];
    } else if ([dataProperties[LYRUIChoiceSelectionsSetFactoryDeselectionKey] boolValue]) {
        return [[LYRUILWWNRegister alloc] initWithPropertyName:responseName dictionary:selectionsSetDictionary];
    } else if ([dataProperties[LYRUIChoiceSelectionsSetFactoryReselectionKey] boolValue]) {
        return [[LYRUILWWRegister alloc] initWithPropertyName:responseName dictionary:selectionsSetDictionary];
    } else {
        return [[LYRUIFWWRegister alloc] initWithPropertyName:responseName dictionary:selectionsSetDictionary];
    }
}

- (LYRUIORSet *)selectionsSetWithResponseName:(NSString *)responseName
                                allowReselect:(BOOL)allowReselect
                                allowDeselect:(BOOL)allowDeselect
                             allowMultiselect:(BOOL)allowMultiselect {
    if (allowMultiselect) {
        return [[LYRUIORSet alloc] initWithPropertyName:responseName];
    } else if (allowDeselect) {
        return [[LYRUILWWNRegister alloc] initWithPropertyName:responseName];
    } else if (allowReselect) {
        return [[LYRUILWWRegister alloc] initWithPropertyName:responseName];
    } else {
        return [[LYRUIFWWRegister alloc] initWithPropertyName:responseName];
    }
}

@end
