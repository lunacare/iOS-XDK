//
//  LYRUIORSetsCache.m
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

#import "LYRUIORSetsCache.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIFWWRegister.h"
#import "LYRUILWWRegister.h"
#import "LYRUILWWNRegister.h"
#import "LYRUIORSet.h"
#import "LYRUIORSetValuesStore.h"
#import "LYRUIChoiceSet.h"

@interface LYRUIORSetsCache ()

@property (nonatomic, strong) LYRUIORSetValuesStore *setValuesStore;
@property (nonatomic, strong) NSMutableDictionary *sets;

@end

@implementation LYRUIORSetsCache
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
        self.sets = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    self.setValuesStore = [layerConfiguration.injector objectOfType:[LYRUIORSetValuesStore class]];
}

- (void)storeORSet:(LYRUIORSet *)ORSet forChoiceSet:(id<LYRUIChoiceSet>)choiceSet {
    self.sets[[self keyForChoiceSet:choiceSet]] = ORSet;
    [self.setValuesStore setDictionary:ORSet.dictionary forChoiceSet:choiceSet];
}

- (LYRUIORSet *)ORSetForChoiceSet:(id<LYRUIChoiceSet>)choiceSet {
    NSString *key = [self keyForChoiceSet:choiceSet];
    LYRUIORSet *ORSet = self.sets[key];
    if (ORSet == nil) {
        NSDictionary *dictionary = [self.setValuesStore dictionaryForChoiceSet:choiceSet];
        if (![dictionary isKindOfClass:[NSDictionary class]]) {
            dictionary = nil;
        }
        if (choiceSet.allowMultiselect) {
            ORSet = [[LYRUIORSet alloc] initWithPropertyName:choiceSet.responseName dictionary:dictionary];
        } else if (choiceSet.allowDeselect) {
            ORSet = [[LYRUILWWNRegister alloc] initWithPropertyName:choiceSet.responseName dictionary:dictionary];
        } else if (choiceSet.allowReselect) {
            ORSet = [[LYRUILWWRegister alloc] initWithPropertyName:choiceSet.responseName dictionary:dictionary];
        } else {
            ORSet = [[LYRUIFWWRegister alloc] initWithPropertyName:choiceSet.responseName dictionary:dictionary];
        }
    }
    return ORSet;
}

- (NSString *)keyForChoiceSet:(id<LYRUIChoiceSet>)choiceSet {
    return [NSString stringWithFormat:@"%@;%@;%@", choiceSet.responseMessageId, choiceSet.responseNodeId, choiceSet.responseName];
}

@end
