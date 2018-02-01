//
//  LYRUIMessageListViewPresenter.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 18.08.2017.
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

#import "LYRUIMessageListViewPresenter.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIListSection.h"
#import "LYRUIListDataSource.h"
#import "LYRUIMessageListDelegate.h"
#import "LYRUIMessageListLayout.h"
#import "LYRUIMessageCollectionViewCell.h"
#import "LYRUIMessageListView.h"
#import "LYRUIMessageItemView.h"
#import "LYRUIMessageCellPresenter.h"
#import "LYRUIListHeaderView.h"
#import <LayerKit/LayerKit.h>
#import "LYRUIListCellPresenting.h"
#import "LYRUIListSupplementaryViewPresenting.h"
#import "LYRUIMessageListTimeSupplementaryViewPresenter.h"
#import "LYRUIMessageListMessageTimeView.h"
#import "LYRUIMessageListStatusSupplementaryViewPresenter.h"
#import "LYRUIMessageListMessageStatusView.h"
#import "LYRUIListLoadingIndicatorPresenter.h"
#import "LYRUIListLoadingIndicatorView.h"
#import "LYRUIMessageCollectionViewCell.h"
#import "LYRUIMessageListTypingIndicatorsController.h"
#import "LYRUIPanelTypingIndicatorView.h"
#import "LYRUITypingIndicatorFooterPresenter.h"
#import "LYRUIBubbleTypingIndicatorCollectionViewCell.h"
#import "LYRUITypingIndicatorCellPresenter.h"
#import "LYRUIStatusMessageCollectionViewCell.h"
#import "LYRUIStatusCellPresenter.h"
#import "LYRUICarouselMessageCellPresenter.h"

static NSTimeInterval const LYRUIMessageListViewDefaultGroupintTimeInterval = 60.0 * 30.0;
static NSInteger const LYRUIMessageListViewDefaultPageSize = 30;

@implementation LYRUIMessageListViewPresenter
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)setupListView:(LYRUIMessageListView *)messageListView {
    id<LYRUIDependencyInjection> injector = self.layerConfiguration.injector;
    
    messageListView.messageGroupingTimeInterval = LYRUIMessageListViewDefaultGroupintTimeInterval;
    messageListView.pageSize = LYRUIMessageListViewDefaultPageSize;
    
    LYRUIMessageListLayout *layout = [injector objectOfType:[self layoutClass]];
    
    LYRUIMessageCellPresenter *cellPresenter = [injector objectOfType:[self cellPresenterClass]];
    cellPresenter.actionHandlingDelegate = messageListView;
    
    LYRUICarouselMessageCellPresenter *carouselCellPresenter = [injector objectOfType:[LYRUICarouselMessageCellPresenter class]];
    carouselCellPresenter.actionHandlingDelegate = messageListView;
    
    LYRUIMessageListTimeSupplementaryViewPresenter *messageTimeViewPresenter =
        [injector presenterForViewClass:[LYRUIMessageListMessageTimeView class]];
    messageTimeViewPresenter.messageListView = messageListView;
    
    LYRUIMessageListStatusSupplementaryViewPresenter *messageStatusViewPresenter =
        [injector presenterForViewClass:[LYRUIMessageListMessageStatusView class]];
    
    LYRUIListLoadingIndicatorPresenter *loadingIndicatorPresenter =
        [injector presenterForViewClass:[LYRUIListLoadingIndicatorView class]];
    
    LYRUIMessageListTypingIndicatorsController *typingIndicatorsController =
        [injector objectOfType:[LYRUIMessageListTypingIndicatorsController class]];
    typingIndicatorsController.collectionView = messageListView.collectionView;
    messageListView.typingIndicatorsController = typingIndicatorsController;
    
    LYRUITypingIndicatorCellPresenter *typingIndicatorCellPresenter =
        [injector presenterForViewClass:[LYRUIBubbleTypingIndicatorCollectionViewCell class]];
    
    LYRUITypingIndicatorFooterPresenter *typingIndicatorFooterPresenter =
        [injector presenterForViewClass:[LYRUIPanelTypingIndicatorView class]];
    
    LYRUIStatusCellPresenter *statusMessageCellPresenter =
        [injector presenterForViewClass:[LYRUIStatusMessageCollectionViewCell class]];
    
    [self registerCellsWithPresenters:@[cellPresenter,
                                        carouselCellPresenter,
                                        typingIndicatorCellPresenter,
                                        statusMessageCellPresenter]
                     inCollectionView:messageListView.collectionView];
    [self registerSupplementaryViewsWithPresenters:@[messageTimeViewPresenter,
                                                     messageStatusViewPresenter,
                                                     loadingIndicatorPresenter,
                                                     typingIndicatorFooterPresenter]
                                  inCollectionView:messageListView.collectionView];
    
    messageListView.layout = layout;
    
    LYRUIListDataSource *dataSource = [[LYRUIListDataSource alloc] init];
    cellPresenter.listDataSource = dataSource;
    [dataSource registerCellPresenter:cellPresenter];
    [dataSource registerCellPresenter:carouselCellPresenter];
    [dataSource registerCellPresenter:typingIndicatorCellPresenter];
    [dataSource registerCellPresenter:statusMessageCellPresenter];
    [dataSource registerSupplementaryViewPresenter:messageTimeViewPresenter];
    [dataSource registerSupplementaryViewPresenter:messageStatusViewPresenter];
    [dataSource registerSupplementaryViewPresenter:loadingIndicatorPresenter];
    [dataSource registerSupplementaryViewPresenter:typingIndicatorFooterPresenter];
    messageListView.dataSource = dataSource;
    
    LYRUIMessageListDelegate *delegate = [injector objectOfType:[self delegateClass]];
    [delegate registerCellSizeCalculation:cellPresenter];
    [delegate registerCellSizeCalculation:carouselCellPresenter];
    [delegate registerCellSizeCalculation:typingIndicatorCellPresenter];
    [delegate registerCellSizeCalculation:statusMessageCellPresenter];
    [delegate registerSupplementaryViewSizeCalculation:messageTimeViewPresenter];
    [delegate registerSupplementaryViewSizeCalculation:messageStatusViewPresenter];
    [delegate registerSupplementaryViewSizeCalculation:loadingIndicatorPresenter];
    [delegate registerSupplementaryViewSizeCalculation:typingIndicatorFooterPresenter];
    delegate.loadingDelegate = loadingIndicatorPresenter;
    messageListView.delegate = delegate;
}

- (Class)layoutClass {
    return [LYRUIMessageListLayout class];
}

- (Class)delegateClass {
    return [LYRUIMessageListDelegate class];
}

- (Class)cellPresenterClass {
    return [LYRUIMessageCellPresenter class];
}

#pragma mark - Cells and Supplementary Views setup

- (void)registerCellsWithPresenters:(NSArray<id<LYRUIListCellPresenting>> *)cellPresenters
                       inCollectionView:(UICollectionView *)collectionView {
    for (id<LYRUIListCellPresenting> presenter in cellPresenters) {
        [presenter registerCellInCollectionView:collectionView];
    }
}

- (void)registerSupplementaryViewsWithPresenters:(NSArray<id<LYRUIListSupplementaryViewPresenting>> *)supplementaryViewPresenters
                                    inCollectionView:(UICollectionView *)collectionView {
    for (id<LYRUIListSupplementaryViewPresenting> presenter in supplementaryViewPresenters) {
        [presenter registerSupplementaryViewInCollectionView:collectionView];
    }
}

@end
