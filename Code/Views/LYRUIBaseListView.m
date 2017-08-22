//
//  LYRUIBaseListView.h
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

#import "LYRUIBaseListView.h"
#import "LYRUIListDataSource.h"
#import "LYRUIListQueryControllerDelegate.h"
#import "LYRUIListSection.h"
#import "LYRUIListDelegate.h"

@interface LYRUIBaseListView ()

@property (nonatomic, weak, readwrite) UICollectionView *collectionView;
@property (nonatomic, strong) LYRUIListQueryControllerDelegate *queryControllerDelegate;

@end

@implementation LYRUIBaseListView
@dynamic layout;
@synthesize collectionView = _collectionView,
            participantsFilter = _participantsFilter;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (void)lyr_commonInit {
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                                          collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.allowsSelection = YES;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
}

#pragma mark - Properties

- (void)setParticipantsFilter:(LYRUIParticipantsFiltering)participantsFilter {
    _participantsFilter = participantsFilter;

    if (![self.dataSource isKindOfClass:[LYRUIListDataSource class]]) {
        return;
    }
    LYRUIListDataSource *dataSource = (LYRUIListDataSource *)self.dataSource;
    
    for (id configuration in dataSource.allConfigurations) {
        if ([configuration conformsToProtocol:@protocol(LYRUIParticipantsFiltering)]) {
            id<LYRUIParticipantsFiltering> participantsFilteringConfiguration = (id<LYRUIParticipantsFiltering>)configuration;
            participantsFilteringConfiguration.participantsFilter = participantsFilter;
        }
    }
}

- (void)setQueryController:(LYRQueryController *)queryController {
    _queryController = queryController;
    self.queryControllerDelegate = [[LYRUIListQueryControllerDelegate alloc] init];
    self.queryControllerDelegate.listDataSource = self.dataSource;
    self.queryControllerDelegate.collectionView = self.collectionView;
    self.queryController.delegate = self.queryControllerDelegate;
    LYRUIListSection *section = [[LYRUIListSection alloc] init];
    for (id item in queryController.paginatedObjects) {
        [section.items addObject:item];
    }
    [self.dataSource.sections addObject:section];
    [self.collectionView reloadData];
}

- (NSMutableArray<LYRUIListSection *> *)items {
    return self.dataSource.sections;
}

- (void)setItems:(NSMutableArray<LYRUIListSection *> *)items {
    self.dataSource.sections = items;
}

- (void)setLayout:(UICollectionViewLayout<LYRUIListViewLayout> *)layout {
    [super setLayout:layout];
    self.collectionView.collectionViewLayout = layout;
}

- (void)setDelegate:(id<LYRUIListDelegate>)delegate {
    _delegate = delegate;
    self.collectionView.delegate = delegate;
    __weak __typeof(self) weakSelf = self;
    delegate.indexPathSelected = ^(NSIndexPath *indexPath) {
        [weakSelf indexPathSelected:indexPath];
    };
    delegate.loadMoreItems = ^{
        if (weakSelf.loadMoreItems) {
            weakSelf.loadMoreItems();
        }
    };
}

- (void)setDataSource:(id<LYRUIListDataSource>)dataSource {
    _dataSource = dataSource;
    self.collectionView.dataSource = dataSource;
    self.queryControllerDelegate.listDataSource = dataSource;
}

#pragma mark - Selection

- (void)indexPathSelected:(NSIndexPath *)indexPath {
    if (self.itemSelected) {
        id item = [self.dataSource itemAtIndexPath:indexPath];
        self.itemSelected(item);
    }
}

- (NSArray *)selectedItems {
    return [self.dataSource selectedItemsInCollectionView:self.collectionView];
}

@end
