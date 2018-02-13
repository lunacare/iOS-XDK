//
//  LYRUICarouselContentOffsetHandler.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 12.02.2018.
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

#import "LYRUICarouselContentOffsetHandler.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUICarouselMessage.h"
#import "LYRUICarouselMessageListView.h"
#import "LYRUICarouselContentOffsetsCache.h"

@interface LYRUICarouselContentOffsetHandler ()

@property (nonatomic, strong) LYRUICarouselContentOffsetsCache *offsetsCache;

@end

@implementation LYRUICarouselContentOffsetHandler
@synthesize layerConfiguration = _layerConfiguration,
            messageIdentifier = _messageIdentifier;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    self.offsetsCache = [layerConfiguration.injector objectOfType:[LYRUICarouselContentOffsetsCache class]];
}

- (void)storeContentOffsetFromCarousel:(LYRUICarouselMessageListView *)carousel {
    [self.offsetsCache setContentOffset:carousel.collectionView.contentOffset
                   forCarouselMessageId:self.messageIdentifier];
}

- (void)restoreContentOffsetInCarousel:(LYRUICarouselMessageListView *)carousel {
    CGPoint contentOffset = [self.offsetsCache contentOffsetForCarouselMessageId:self.messageIdentifier];
    if (!CGPointEqualToPoint(contentOffset, CGPointZero)) {
        carousel.collectionView.contentOffset = contentOffset;
    }
}

@end
