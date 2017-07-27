//
//  LYRUIListDelegate.h
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

#import <UIKit/UIKit.h>
#import "LYRUIListLayout.h"
@protocol LYRUIListCellSizeCalculating;
@protocol LYRUIListSupplementaryViewSizeCalculating;

NS_ASSUME_NONNULL_BEGIN     // {
@protocol LYRUIListLoadingMoreDelegate <NSObject>

/**
 @abstract A method for determining if loading more items should begin according to `scrollView` scroll position.
 */
- (BOOL)shouldLoadMoreItemsWithScrollView:(UIScrollView *)scrollView;

@end

/**
 @abstract `LYRUIListView` delegate.
 */
@protocol LYRUIListDelegate <UICollectionViewDelegate>

/**
 @abstract A callback block called on selection of cell in `LYRUIListView`.
 */
@property (nonatomic, copy) void(^indexPathSelected)(NSIndexPath *);

/**
 @abstract Flag indicating if another page of items can be loaded.
 */
@property (nonatomic) BOOL canLoadMoreItems;

/**
 @abstract A delegate used to determine if loading more items should begin according to `UIScrollView` scroll position.
 */
@property (nonatomic, weak) id<LYRUIListLoadingMoreDelegate> loadingDelegate;

/**
 @abstract A block called when list is scrolled near the end of current page and `canLoadMoreItems` is set to `YES`.
 */
@property (nonatomic, copy) void(^loadMoreItems)();

@end

/**
 @abstract A class conforming to `LYRUIListDelegate` protocol. Sizes cells to full width of `UICollectionView` simillar to `UITableView`.
 */
@interface LYRUIListDelegate : NSObject <LYRUIListLayoutDelegate, LYRUIListDelegate>

/**
 @abstract A method for registering objects conforming to `LYRUIListCellSizeCalculating` protocol that will be used to calculate sizes of cells in the list view.
 */
- (void)registerCellSizeCalculation:(id<LYRUIListCellSizeCalculating>)cellSizeCalculation;

/**
 @abstract A method for registering objects conforming to `LYRUIListSupplementaryViewSizeCalculating` protocol that will be used to calculate sizes of supplementary views in the list view.
 */
- (void)registerSupplementaryViewSizeCalculation:(id<LYRUIListSupplementaryViewSizeCalculating>)supplementaryViewSizeCalculation;

@end
NS_ASSUME_NONNULL_END       // }
