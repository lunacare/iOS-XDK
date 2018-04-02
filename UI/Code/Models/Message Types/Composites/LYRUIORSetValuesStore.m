//
//  LYRUIORSetValuesStore.m
//  Layer-XDK-UI-iOS
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

#import "LYRUIORSetValuesStore.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIChoiceSet.h"
#import <LayerKit/LayerKit.h>

@implementation LYRUIORSetValuesStore
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)setDictionary:(NSDictionary *)dictionary forChoiceSet:(id<LYRUIChoiceSet>)choiceSet {
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
    nodeSelections[choiceSet.responseName] = dictionary;
    selections[choiceSet.responseNodeId] = nodeSelections;
    
    NSError *error = nil;
    NSData *selectionsData = [NSJSONSerialization dataWithJSONObject:selections
                                                             options:0
                                                               error:&error];
    if (error == nil && selectionsData) {
        [message setLocalData:selectionsData error:&error];
    }
}

- (NSDictionary *)dictionaryForChoiceSet:(id<LYRUIChoiceSet>)choiceSet {
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
    NSDictionary *dictionary = selections[choiceSet.responseNodeId][choiceSet.responseName];
    return dictionary;
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
