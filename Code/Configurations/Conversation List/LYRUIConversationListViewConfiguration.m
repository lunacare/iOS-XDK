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

- (void)setupConversationListView:(LYRUIConversationListView *)conversationListView {
    LYRUIConversationItemViewConfiguration *configuration = [[LYRUIConversationItemViewConfiguration alloc] init];
    
    LYRUIListCellConfiguration<LYRUIConversationCollectionViewCell *, LYRUIConversationItemViewConfiguration *, LYRConversation *> *conversationCellConfiguration =
        [[LYRUIListCellConfiguration alloc] initWithCellClass:[LYRUIConversationCollectionViewCell class]
                                                   modelClass:[LYRConversation class]
                                            viewConfiguration:configuration
                                                   cellHeight:72.0
                                               cellSetupBlock:^(LYRUIConversationCollectionViewCell *cell, LYRConversation *conversation, LYRUIConversationItemViewConfiguration *configuration) {
                                                   [configuration setupConversationItemView:cell.conversationView withConversation:conversation];
                                               }
                                        cellRegistrationBlock:nil];
    [conversationCellConfiguration registerCellInCollectionView:conversationListView.collectionView];
    
    LYRUIListSupplementaryViewConfiguration<LYRUIListHeaderView *> *headerConfiguration = [LYRUIListSupplementaryViewConfiguration headerConfiguration];
    [headerConfiguration registerSupplementaryViewInCollectionView:conversationListView.collectionView];
    
    conversationListView.layout = [[LYRUIListLayout alloc] init];
    conversationListView.dataSource = [self dataSourceWithCellConfiguration:conversationCellConfiguration
                                                        headerConfiguration:headerConfiguration];
    conversationListView.delegate = [self delegateWithCellConfiguration:conversationCellConfiguration
                                                  headerConfiguration:headerConfiguration];
}

- (LYRUIListDataSource *)dataSourceWithCellConfiguration:(LYRUIListCellConfiguration *)cellConfiguration
                                     headerConfiguration:(LYRUIListSupplementaryViewConfiguration *)headerConfiguration {
    LYRUIListDataSource *dataSource = [[LYRUIListDataSource alloc] init];
    [dataSource registerCellConfiguration:cellConfiguration];
    [dataSource registerSupplementaryViewConfiguration:headerConfiguration];
    return dataSource;
}

- (LYRUIListDelegate *)delegateWithCellConfiguration:(LYRUIListCellConfiguration *)cellConfiguration
                                 headerConfiguration:(LYRUIListSupplementaryViewConfiguration *)headerConfiguration {
    LYRUIListDelegate *delegate = [[LYRUIListDelegate alloc] init];
    [delegate registerCellSizeCalculation:cellConfiguration];
    [delegate registerSupplementaryViewSizeCalculation:headerConfiguration];
    return delegate;
}

@end
