//
//  LYRUICarouselMessageCompositeViewPresenter.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 04.12.2017.
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

#import "LYRUICarouselMessageCompositeViewPresenter.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUICarouselMessageListView.h"
#import "LYRUICarouselMessage.h"
#import "LYRUIMessageItemContentPresentersProvider.h"
#import "LYRUIListSection.h"
#import "LYRUIReusableViewsQueue.h"
#import "LYRUICarouselContentOffsetHandling.h"

@implementation LYRUICarouselMessageCompositeViewPresenter

- (id)copyWithZone:(NSZone *)zone {
    __typeof(self) copy = [[[self class] allocWithZone:zone] init];
    copy.presentersProvider = self.presentersProvider;
    return copy;
}

- (UIView *)viewForMessage:(LYRUICarouselMessage *)message {
    LYRUICarouselMessageListView *carouselCompositeView = [self.reusableViewsQueue dequeueReusableViewOfType:[LYRUICarouselMessageListView class]];
    if (carouselCompositeView == nil) {
        carouselCompositeView = [[LYRUICarouselMessageListView alloc] init];
        carouselCompositeView.layerConfiguration = self.layerConfiguration;
    }
    carouselCompositeView.contentOffsetHandler = [self.layerConfiguration.injector protocolImplementation:@protocol(LYRUICarouselContentOffsetHandling)
                                                                                                 forClass:[self class]];
    carouselCompositeView.contentOffsetHandler.messageIdentifier = message.identifier;
    carouselCompositeView.messageActionHandlingDelegate = self.actionHandlingDelegate;
    LYRUIListSection *section = [[LYRUIListSection alloc] init];
    section.items = [message.carouselItemMessages mutableCopy];
    carouselCompositeView.items = [@[section] mutableCopy];
    [carouselCompositeView.collectionView reloadData];
    [carouselCompositeView.contentOffsetHandler restoreContentOffsetInCarousel:carouselCompositeView];
    [self setupViewConstraints:carouselCompositeView];
    return carouselCompositeView;
}

- (CGFloat)viewHeightForMessage:(LYRUICarouselMessage *)message minWidth:(CGFloat)minWidth maxWidth:(CGFloat)maxWidth {
    CGFloat height = 0.0;
    CGFloat carouselItemsWidth = (0.8 * maxWidth);
    if (maxWidth > 600.0) {
        carouselItemsWidth = (0.6 * maxWidth);
    } else if (maxWidth > 460.0) {
        carouselItemsWidth = (0.75 * maxWidth);
    }
    carouselItemsWidth = MIN(carouselItemsWidth, 260.0);
    for (LYRUIMessageType *carouselItem in message.carouselItemMessages) {
        id<LYRUIMessageItemContentPresenting> configuration =
                [self.presentersProvider presenterForMessageClass:[carouselItem class]];
        CGFloat itemHeight = [configuration viewHeightForMessage:carouselItem minWidth:carouselItemsWidth maxWidth:carouselItemsWidth];
        height = MAX(height, itemHeight);
    }
    return height;
}

- (void)setupViewConstraints:(UIView *)view {
    [NSLayoutConstraint deactivateConstraints:view.constraints];
    [view.widthAnchor constraintGreaterThanOrEqualToConstant:192.0].active = YES;
    NSLayoutConstraint *widthConstraint = [view.widthAnchor constraintEqualToConstant:1000.0];
    widthConstraint.priority = UILayoutPriorityDefaultLow;
    widthConstraint.active = YES;
    [view setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [view setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

@end
