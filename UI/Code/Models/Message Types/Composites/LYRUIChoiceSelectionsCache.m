//
//  LYRUIChoiceSelectionsCache.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 23.01.2018.
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

#import "LYRUIChoiceSelectionsCache.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIChoiceSet.h"
#import <LayerKit/LayerKit.h>

@implementation LYRUIChoiceSelectionsCache
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)setSelections:(NSOrderedSet<NSString *> *)choiceSelections forChoiceSet:(id<LYRUIChoiceSet>)choiceSet {
    LYRMessage *message = [self messageWithIdentifier:choiceSet.responseMessageId];
    
    NSMutableDictionary *selections;
    if (message.localData != nil) {
        NSError *error = nil;
        selections = [NSJSONSerialization JSONObjectWithData:message.localData
                                                     options:(NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers)
                                                       error:&error];
    }
    if (selections == nil) {
        selections = [[NSMutableDictionary alloc] init];
    }
    
    NSMutableDictionary *nodeSelections = selections[choiceSet.responseNodeId];
    if (nodeSelections == nil) {
        nodeSelections = [[NSMutableDictionary alloc] init];
    }
    nodeSelections[choiceSet.responseName] = [choiceSelections array];
    selections[choiceSet.responseNodeId] = nodeSelections;
    
    NSError *error = nil;
    NSData *selectionsData = [NSJSONSerialization dataWithJSONObject:selections
                                                             options:0
                                                               error:&error];
    if (error == nil && selectionsData) {
        [message setLocalData:selectionsData error:&error];
    }
}

- (NSOrderedSet<NSString *> *)selectionsForChoiceSet:(id<LYRUIChoiceSet>)choiceSet {
    LYRMessage *message = [self messageWithIdentifier:choiceSet.responseMessageId];
    if (message.localData == nil) {
        return nil;
    }
    
    NSError *error = nil;
    NSDictionary *selections = [NSJSONSerialization JSONObjectWithData:message.localData
                                                               options:0
                                                                 error:&error];
    if (error) {
        return nil;
    }
    NSArray<NSString *> *selectionsArray = selections[choiceSet.responseNodeId][choiceSet.responseName];
    if (selectionsArray == nil) {
        return nil;
    }
    return [NSOrderedSet orderedSetWithArray:selectionsArray];
}

- (LYRMessage *)messageWithIdentifier:(NSString *)identifier {
    LYRClient *client = self.layerConfiguration.client;
    
    NSURL *urlIdentifier = [NSURL URLWithString:identifier];
    
    LYRQuery *query = [LYRQuery queryWithQueryableClass:[LYRMessage class]];
    query.predicate = [LYRPredicate predicateWithProperty:@"identifier"
                                        predicateOperator:LYRPredicateOperatorIsEqualTo
                                                    value:urlIdentifier];
    query.limit = 1;
    return [client executeQuery:query error:nil].firstObject;
}

@end
