//
//  LYRUIConversationListViewPresenter.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 31.07.2017.
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

#import "LYRUIConversationListViewPresenter.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIListSection.h"
#import "LYRUIListDataSource.h"
#import "LYRUIListDelegate.h"
#import "LYRUIListLayout.h"
#import "LYRUIConversationItemViewPresenter.h"
#import "LYRUIConversationCollectionViewCell.h"
#import "LYRUIListHeaderView.h"
#import <LayerKit/LayerKit.h>
#import "LYRUIListCellPresenter.h"
#import "LYRUIListSupplementaryViewPresenter.h"

@implementation LYRUIConversationListViewPresenter
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)setupListView:(LYRUIConversationListView *)conversationListView {
    LYRUIConversationItemViewPresenter *itemViewPresenter = [self.layerConfiguration.injector presenterForViewClass:[LYRUIConversationItemView class]];
    
    LYRUIListCellPresenter<LYRUIConversationCollectionViewCell *, LYRUIConversationItemViewPresenter *, LYRConversation *> *conversationCellPresenter;
    conversationCellPresenter = [self.layerConfiguration.injector presenterForViewClass:[UICollectionViewCell class]];
    [conversationCellPresenter setupWithCellClass:[LYRUIConversationCollectionViewCell class]
                                           modelClass:[LYRConversation class]
                                    viewPresenter:itemViewPresenter
                                           cellHeight:72.0
                                       cellSetupBlock:^(LYRUIConversationCollectionViewCell *cell, LYRConversation *conversation, LYRUIConversationItemViewPresenter *presenter) {
                                           [presenter setupConversationItemView:cell.conversationView withConversation:conversation];
                                       }
                                cellRegistrationBlock:nil];
    [conversationCellPresenter registerCellInCollectionView:conversationListView.collectionView];
    
    LYRUIListSupplementaryViewPresenter<LYRUIListHeaderView *> *headerPresenter = [self.layerConfiguration.injector presenterForViewClass:[LYRUIListHeaderView class]];
    [headerPresenter registerSupplementaryViewInCollectionView:conversationListView.collectionView];
    
    if (conversationListView.layout == nil) {
        conversationListView.layout = [self.layerConfiguration.injector layoutForViewClass:[LYRUIConversationListView class]];
    }
    
    LYRUIListDataSource *dataSource = [self.layerConfiguration.injector objectOfType:[LYRUIListDataSource class]];
    [dataSource registerCellPresenter:conversationCellPresenter];
    [dataSource registerSupplementaryViewPresenter:headerPresenter];
    conversationListView.dataSource = dataSource;
    
    LYRUIListDelegate *delegate = [self.layerConfiguration.injector objectOfType:[LYRUIListDelegate class]];
    [delegate registerCellSizeCalculation:conversationCellPresenter];
    [delegate registerSupplementaryViewSizeCalculation:headerPresenter];
    conversationListView.delegate = delegate;
}

@end
