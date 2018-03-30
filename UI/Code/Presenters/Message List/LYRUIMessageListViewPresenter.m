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
#import "LYRUIMessageCellPresenter.h"
#import "LYRUIListHeaderView.h"
#import <LayerKit/LayerKit.h>
#import "LYRUIListCellPresenting.h"
#import "LYRUIListSupplementaryViewPresenting.h"
#import "LYRUIMessageListTimeSupplementaryViewPresenter.h"
#import "LYRUIMessageListStatusSupplementaryViewPresenter.h"
#import "LYRUIListLoadingIndicatorPresenter.h"
#import "LYRUIMessageCollectionViewCell.h"
#import "LYRUIMessageListTypingIndicatorsController.h"
#import "LYRUITypingIndicatorFooterPresenter.h"
#import "LYRUITypingIndicatorCellPresenter.h"
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
    
    LYRUIMessageListLayout *layout = [injector layoutForViewClass:[messageListView class]];
    
    LYRUIMessageCellPresenter *cellPresenter = [injector objectOfType:[self cellPresenterClass]];
    cellPresenter.actionHandlingDelegate = messageListView;
    
    LYRUICarouselMessageCellPresenter *carouselCellPresenter = [injector objectOfType:[LYRUICarouselMessageCellPresenter class]];
    carouselCellPresenter.actionHandlingDelegate = messageListView;
    
    LYRUIMessageListTimeSupplementaryViewPresenter *messageTimeViewPresenter =
        [injector objectOfType:[LYRUIMessageListTimeSupplementaryViewPresenter class]];
    messageTimeViewPresenter.messageListView = messageListView;
    
    LYRUIMessageListStatusSupplementaryViewPresenter *messageStatusViewPresenter =
        [injector objectOfType:[LYRUIMessageListStatusSupplementaryViewPresenter class]];
    
    LYRUIListLoadingIndicatorPresenter *loadingIndicatorPresenter =
        [injector objectOfType:[LYRUIListLoadingIndicatorPresenter class]];
    
    LYRUIMessageListTypingIndicatorsController *typingIndicatorsController =
        [injector objectOfType:[LYRUIMessageListTypingIndicatorsController class]];
    typingIndicatorsController.messageListView = messageListView;
    messageListView.typingIndicatorsController = typingIndicatorsController;
    
    LYRUITypingIndicatorCellPresenter *typingIndicatorCellPresenter =
        [injector objectOfType:[LYRUITypingIndicatorCellPresenter class]];
    
    LYRUITypingIndicatorFooterPresenter *typingIndicatorFooterPresenter =
        [injector objectOfType:[LYRUITypingIndicatorFooterPresenter class]];
    typingIndicatorFooterPresenter.typingIndicatorsController = typingIndicatorsController;
    typingIndicatorFooterPresenter.messageListView = messageListView;
    
    LYRUIStatusCellPresenter *statusMessageCellPresenter =
        [injector objectOfType:[LYRUIStatusCellPresenter class]];
    
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
    
    LYRUIListDataSource *dataSource = [injector objectOfType:[LYRUIListDataSource class]];
    cellPresenter.listDataSource = dataSource;
    dataSource.defaultCellPresenter = cellPresenter;
    [dataSource registerCellPresenter:carouselCellPresenter];
    [dataSource registerCellPresenter:typingIndicatorCellPresenter];
    [dataSource registerCellPresenter:statusMessageCellPresenter];
    [dataSource registerSupplementaryViewPresenter:messageTimeViewPresenter];
    [dataSource registerSupplementaryViewPresenter:messageStatusViewPresenter];
    [dataSource registerSupplementaryViewPresenter:loadingIndicatorPresenter];
    [dataSource registerSupplementaryViewPresenter:typingIndicatorFooterPresenter];
    messageListView.dataSource = dataSource;
    
    LYRUIMessageListDelegate *delegate = [injector objectOfType:[self delegateClass]];
    delegate.defaultCellSizeCalculation = cellPresenter;
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
