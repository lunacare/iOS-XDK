//
//  LYRUIIdentityListViewPresenter.m
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

#import "LYRUIIdentityListViewPresenter.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIListSection.h"
#import "LYRUIListDataSource.h"
#import "LYRUIListDelegate.h"
#import "LYRUIListLayout.h"
#import "LYRUIIdentityItemViewPresenter.h"
#import "LYRUIIdentityCollectionViewCell.h"
#import "LYRUIListHeaderView.h"
#import <LayerKit/LayerKit.h>
#import "LYRUIListCellPresenter.h"
#import "LYRUIListSupplementaryViewPresenter.h"

@implementation LYRUIIdentityListViewPresenter
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)setupListView:(LYRUIIdentityListView *)identityListView {
    LYRUIIdentityItemViewPresenter *presenter = [self.layerConfiguration.injector presenterForViewClass:[LYRUIIdentityItemView class]];
    
    LYRUIListCellPresenter<LYRUIIdentityCollectionViewCell *, LYRUIIdentityItemViewPresenter *, LYRIdentity *> *identityCellPresenter;
    identityCellPresenter = [self.layerConfiguration.injector presenterForViewClass:[UICollectionViewCell class]];
    [identityCellPresenter setupWithCellClass:[LYRUIIdentityCollectionViewCell class]
                                       modelClass:[LYRIdentity class]
                                viewPresenter:presenter
                                       cellHeight:48.0
                                   cellSetupBlock:^(LYRUIIdentityCollectionViewCell *cell, LYRIdentity *identity, LYRUIIdentityItemViewPresenter *presenter) {
                                       [presenter setupIdentityItemView:cell.identityView withIdentity:identity];
                                   }
                            cellRegistrationBlock:nil];
    [identityCellPresenter registerCellInCollectionView:identityListView.collectionView];
    
    LYRUIListSupplementaryViewPresenter<LYRUIListHeaderView *> *headerPresenter = [self.layerConfiguration.injector presenterForViewClass:[LYRUIListHeaderView class]];
    [headerPresenter registerSupplementaryViewInCollectionView:identityListView.collectionView];
    
    if (identityListView.layout == nil) {
        identityListView.layout = [self.layerConfiguration.injector layoutForViewClass:[LYRUIIdentityListView class]];
    }
    
    LYRUIListDataSource *dataSource = [self.layerConfiguration.injector objectOfType:[LYRUIListDataSource class]];
    [dataSource registerCellPresenter:identityCellPresenter];
    [dataSource registerSupplementaryViewPresenter:headerPresenter];
    identityListView.dataSource = dataSource;
    
    LYRUIListDelegate *delegate = [self.layerConfiguration.injector objectOfType:[LYRUIListDelegate class]];
    [delegate registerCellSizeCalculation:identityCellPresenter];
    [delegate registerSupplementaryViewSizeCalculation:headerPresenter];
    identityListView.delegate = delegate;
}

@end
