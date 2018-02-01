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
#import "LYRUIChoiceSet.h"

@interface LYRUIChoiceSelectionsCache ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSOrderedSet<NSString *> *> *selectionsForChoiceSets;

@end

@implementation LYRUIChoiceSelectionsCache

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectionsForChoiceSets = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (LYRUIChoiceSelectionsCache *)sharedCache {
    static LYRUIChoiceSelectionsCache *sharedCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[LYRUIChoiceSelectionsCache alloc] init];
    });
    return sharedCache;
}

- (void)setSelections:(NSOrderedSet<NSString *> *)choiceSelections forChoiceSet:(id<LYRUIChoiceSet>)choiceSet {
    self.selectionsForChoiceSets[[self keyForChoiceSet:choiceSet]] = choiceSelections;
}

- (NSOrderedSet<NSString *> *)selectionsForChoiceSet:(id<LYRUIChoiceSet>)choiceSet {
    return self.selectionsForChoiceSets[[self keyForChoiceSet:choiceSet]];
}

- (NSString *)keyForChoiceSet:(id<LYRUIChoiceSet>)choiceSet {
    return [NSString stringWithFormat:@"%@;%@;%@", choiceSet.responseMessageId, choiceSet.responseNodeId, choiceSet.responseName];
}

@end
