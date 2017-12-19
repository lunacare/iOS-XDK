//
//  LYRUIConversationListViewConfiguration.m
//  Layer-UI-iOS
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

#import "LYRUIConversationListViewConfiguration.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIListSection.h"
#import "LYRUIListDataSource.h"
#import "LYRUIListDelegate.h"
#import "LYRUIListLayout.h"
#import "LYRUIConversationItemViewConfiguration.h"
#import "LYRUIConversationCollectionViewCell.h"
#import "LYRUIListHeaderView.h"
#import <LayerKit/LayerKit.h>
#import "LYRUIListCellConfiguration.h"
#import "LYRUIListSupplementaryViewConfiguration.h"

@implementation LYRUIConversationListViewConfiguration
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)setupListView:(LYRUIConversationListView *)conversationListView {
    LYRUIConversationItemViewConfiguration *itemViewConfiguration = [self.layerConfiguration.injector configurationForViewClass:[LYRUIConversationItemView class]];
    
    LYRUIListCellConfiguration<LYRUIConversationCollectionViewCell *, LYRUIConversationItemViewConfiguration *, LYRConversation *> *conversationCellConfiguration;
    conversationCellConfiguration = [self.layerConfiguration.injector configurationForViewClass:[UICollectionViewCell class]];
    [conversationCellConfiguration setupWithCellClass:[LYRUIConversationCollectionViewCell class]
                                           modelClass:[LYRConversation class]
                                    viewConfiguration:itemViewConfiguration
                                           cellHeight:72.0
                                       cellSetupBlock:^(LYRUIConversationCollectionViewCell *cell, LYRConversation *conversation, LYRUIConversationItemViewConfiguration *configuration) {
                                           [configuration setupConversationItemView:cell.conversationView withConversation:conversation];
                                       }
                                cellRegistrationBlock:nil];
    [conversationCellConfiguration registerCellInCollectionView:conversationListView.collectionView];
    
    LYRUIListSupplementaryViewConfiguration<LYRUIListHeaderView *> *headerConfiguration = [self.layerConfiguration.injector configurationForViewClass:[LYRUIListHeaderView class]];
    [headerConfiguration registerSupplementaryViewInCollectionView:conversationListView.collectionView];
    
    conversationListView.layout = [self.layerConfiguration.injector layoutForViewClass:[LYRUIConversationListView class]];
    
    LYRUIListDataSource *dataSource = [self.layerConfiguration.injector objectOfType:[LYRUIListDataSource class]];
    [dataSource registerCellConfiguration:conversationCellConfiguration];
    [dataSource registerSupplementaryViewConfiguration:headerConfiguration];
    conversationListView.dataSource = dataSource;
    
    LYRUIListDelegate *delegate = [self.layerConfiguration.injector objectOfType:[LYRUIListDelegate class]];
    [delegate registerCellSizeCalculation:conversationCellConfiguration];
    [delegate registerSupplementaryViewSizeCalculation:headerConfiguration];
    conversationListView.delegate = delegate;
}

@end
