//
//  LYRUIIdentityListViewConfiguration.m
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

#import "LYRUIIdentityListViewConfiguration.h"
#import "LYRUIListSection.h"
#import "LYRUIListDataSource.h"
#import "LYRUIListDelegate.h"
#import "LYRUIListLayout.h"
#import "LYRUIIdentityItemViewConfiguration.h"
#import "LYRUIIdentityCollectionViewCell.h"
#import "LYRUIListHeaderView.h"
#import <LayerKit/LayerKit.h>
#import "LYRUIListCellConfiguration.h"
#import "LYRUIListSupplementaryViewConfiguration.h"

@implementation LYRUIIdentityListViewConfiguration

+ (void)setupIdentityListView:(LYRUIIdentityListView *)identityListView {
    [identityListView.collectionView registerClass:[LYRUIListHeaderView class]
                        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                               withReuseIdentifier:NSStringFromClass([LYRUIListSection class])];
    
    LYRUIIdentityItemViewConfiguration *configuration = [[LYRUIIdentityItemViewConfiguration alloc] init];
    
    LYRUIListCellConfiguration<LYRUIIdentityCollectionViewCell *, LYRUIIdentityItemViewConfiguration *, LYRIdentity *> *identityCellConfiguration =
    [[LYRUIListCellConfiguration alloc] initWithCellClass:[LYRUIIdentityCollectionViewCell class]
                                               modelClass:[LYRIdentity class]
                                        viewConfiguration:configuration
                                               cellHeight:48.0
                                           cellSetupBlock:^(LYRUIIdentityCollectionViewCell *cell, LYRIdentity *identity, LYRUIIdentityItemViewConfiguration *configuration) {
                                               [configuration setupIdentityItemView:cell.identityView withIdentity:identity];
                                           }
                                    cellRegistrationBlock:nil];
    [identityCellConfiguration registerCellInCollectionView:identityListView.collectionView];
    
    LYRUIListSupplementaryViewConfiguration<LYRUIListHeaderView *> *headerConfiguration = [LYRUIListSupplementaryViewConfiguration headerConfiguration];
    [headerConfiguration registerSupplementaryViewInCollectionView:identityListView.collectionView];
    
    identityListView.layout = [[LYRUIListLayout alloc] init];
    
    LYRUIListDataSource *dataSource = [[LYRUIListDataSource alloc] init];
    [dataSource registerCellConfiguration:identityCellConfiguration];
    [dataSource registerSupplementaryViewConfiguration:headerConfiguration];
    identityListView.dataSource = dataSource;
    
    LYRUIListDelegate *delegate = [[LYRUIListDelegate alloc] init];
    [delegate registerCellSizeCalculation:identityCellConfiguration];
    [delegate registerSupplementaryViewSizeCalculation:headerConfiguration];
    identityListView.delegate = delegate;
}

@end
