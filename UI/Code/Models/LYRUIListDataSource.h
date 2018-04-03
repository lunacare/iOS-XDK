//
//  LYRUIListDataSource.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 27.07.2017.
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

#import <UIKit/UIKit.h>
#import "LYRUIListSectionHeader.h"
#import "LYRUIListHeaderView.h"
@class LYRUIListSection<ModelType>;
@protocol LYRUIListCellPresenting;
@protocol LYRUIListSupplementaryViewPresenting;

NS_ASSUME_NONNULL_BEGIN     // {
/**
 @abstract `LYRUIListView` data source.
 */
@protocol LYRUIListDataSource <UICollectionViewDataSource>

/**
 @abstract Array of sections of items to populate the list view with.
 */
@property (nonatomic, strong) NSMutableArray<LYRUIListSection *> *sections;

/**
 @abstract Provides the index path of the last item in list.
 */
@property (nonatomic, readonly, nullable) NSIndexPath *lastItemIndexPath;

/**
 @abstract Provides objects selected in the list view.
 @param collectionView The list view's `UICollectionView` in which the items were selected.
 @returns An array of model objects from the list view data source, at corresponding index paths for selected items in `UICollectionView`.
 */
- (NSArray *)selectedItemsInCollectionView:(UICollectionView *)collectionView;

/**
 @abstract Provides an object at the given `indexPath`.
 @param indexPath The index path of an object to retrieve.
 @returns An model object at the corresponding `indexPath`.
 */
- (nullable id)itemAtIndexPath:(NSIndexPath *)indexPath;

/**
 @abstract Provides the index path of given `item`.
 @param item The item for which an index path should be returned.
 @returns An `NSIndexPath` for provided object.
 */
- (nullable NSIndexPath *)indexPathOfItem:(id)item;


@end

/**
 @abstract A class conforming to `LYRUIListDataSource` protocol.
 */
@interface LYRUIListDataSource : NSObject <LYRUIListDataSource>

@property (nonatomic, strong) id<LYRUIListCellPresenting> defaultCellPresenter;

/**
 @abstract A method for registering objects conforming to `LYRUIListCellPresenting` protocol that will be used to setup cells in the list view.
 */
- (void)registerCellPresenter:(id<LYRUIListCellPresenting>)cellPresenter;

/**
 @abstract A method for registering objects conforming to `LYRUIListSupplementaryViewPresenting` protocol that will be used to setup supplementary views in the list view.
 */
- (void)registerSupplementaryViewPresenter:(id<LYRUIListSupplementaryViewPresenting>)supplementaryViewPresenter;

@end
NS_ASSUME_NONNULL_END       // }
