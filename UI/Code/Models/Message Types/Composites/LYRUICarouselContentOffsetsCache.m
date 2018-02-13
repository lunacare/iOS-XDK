//
//  LYRUICarouselContentOffsetsCache.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 13.02.2018.
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

#import "LYRUICarouselContentOffsetsCache.h"

@interface LYRUICarouselContentOffsetsCache ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *contentOffsetsForMessageIds;

@end

@implementation LYRUICarouselContentOffsetsCache

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentOffsetsForMessageIds = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Public methods

- (void)setContentOffset:(CGPoint)contentOffset forCarouselMessageId:(NSString *)messageId {
    NSString *value = NSStringFromCGPoint(contentOffset);
    self.contentOffsetsForMessageIds[messageId] = value;
}

- (CGPoint)contentOffsetForCarouselMessageId:(NSString *)messageId {
    NSString *storedContentOffset = self.contentOffsetsForMessageIds[messageId];
    if (storedContentOffset == nil) {
        return CGPointZero;
    }
    return CGPointFromString(storedContentOffset);
}

@end
