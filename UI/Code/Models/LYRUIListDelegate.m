//
//  LYRUIListDelegate.m
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

#import "LYRUIListDelegate.h"
#import "LYRUIListDataSource.h"
#import "LYRUIListCellSizeCalculating.h"
#import "LYRUIListSupplementaryViewSizeCalculating.h"
#import "LYRUIListLayout.h"

@interface LYRUIListDelegate ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, id<LYRUIListCellSizeCalculating>> *cellSizeCalculations;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<LYRUIListSupplementaryViewSizeCalculating>> *supplementaryViewSizeCalculations;

@end

@implementation LYRUIListDelegate
@synthesize indexPathSelected = _indexPathSelected,
            canLoadMoreItems = _canLoadMoreItems,
            loadMoreItems = _loadMoreItems,
            loadingDelegate = _loadingDelegate;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellSizeCalculations = [[NSMutableDictionary alloc] init];
        self.supplementaryViewSizeCalculations = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - UICollectionViewDelegateFlowLayout methods

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<LYRUIListDataSource> dataSource = (id<LYRUIListDataSource>)collectionView.dataSource;
    if (![dataSource conformsToProtocol:@protocol(LYRUIListDataSource)]) {
        return CGSizeZero;
    }
    id item = [dataSource itemAtIndexPath:indexPath];
    
    NSString *itemType = NSStringFromClass([item class]);
    id<LYRUIListCellSizeCalculating> cellSizeCalculation = self.cellSizeCalculations[itemType];
    if (cellSizeCalculation == nil) {
        cellSizeCalculation = self.defaultCellSizeCalculation;
    }
    if (cellSizeCalculation) {
        return [cellSizeCalculation cellSizeInCollectionView:collectionView forItemAtIndexPath:indexPath];
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    return [self collectionView:collectionView
                         layout:(LYRUIListLayout *)collectionViewLayout
               sizeOfViewOfKind:UICollectionElementKindSectionHeader
                    atIndexPath:headerIndexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section {
    NSIndexPath *footerIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    return [self collectionView:collectionView
                         layout:(LYRUIListLayout *)collectionViewLayout
               sizeOfViewOfKind:UICollectionElementKindSectionFooter
                    atIndexPath:footerIndexPath];
}

#pragma mark - LYRUIListLayout methods

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(LYRUIListLayout *)collectionViewLayout
        sizeOfViewOfKind:(NSString *)kind
             atIndexPath:(NSIndexPath *)indexPath {
    id<LYRUIListSupplementaryViewSizeCalculating> supplementaryViewSizeCalculation = self.supplementaryViewSizeCalculations[kind];
    if (supplementaryViewSizeCalculation) {
        return [supplementaryViewSizeCalculation supplementaryViewSizeInCollectionView:collectionView
                                                                    forItemAtIndexPath:indexPath];
    }
    return CGSizeZero;
}

- (void)invalidateAllSupplementaryViewSizes {
    for (id<LYRUIListSupplementaryViewSizeCalculating> supplementaryViewSizeCalculation in self.supplementaryViewSizeCalculations.allValues) {
        [supplementaryViewSizeCalculation invalidateAllSupplementaryViewSizes];
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.indexPathSelected) {
        self.indexPathSelected(indexPath);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self loadMoreItemsIfAvailableWithScrollView:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadMoreItemsIfAvailableWithScrollView:scrollView];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [self loadMoreItemsIfAvailableWithScrollView:scrollView];
}

- (void)loadMoreItemsIfAvailableWithScrollView:(UIScrollView *)scrollView {
    if (self.canLoadMoreItems && self.loadMoreItems && [self.loadingDelegate shouldLoadMoreItemsWithScrollView:scrollView]) {
        self.loadMoreItems();
    }
}

#pragma mark - LYRUIListCellSizeCalculating registration

- (void)registerCellSizeCalculation:(id<LYRUIListCellSizeCalculating>)cellSizeCalculation {
    for (Class itemType in cellSizeCalculation.handledItemTypes) {
        NSString *key = NSStringFromClass(itemType);
        if (key.length == 0) {
            continue;
        }
        self.cellSizeCalculations[key] = cellSizeCalculation;
    }
}

#pragma mark - LYRUIListSupplementaryViewPresenting registration

- (void)registerSupplementaryViewSizeCalculation:(id<LYRUIListSupplementaryViewSizeCalculating>)supplementaryViewSizeCalculation {
    NSString *key = supplementaryViewSizeCalculation.viewKind;
    self.supplementaryViewSizeCalculations[key] = supplementaryViewSizeCalculation;
    supplementaryViewSizeCalculation.listDelegate = self;
}

#pragma mark - Properties

- (void)setCanLoadMoreItems:(BOOL)canLoadMoreItems {
    _canLoadMoreItems = canLoadMoreItems;
    self.loadingDelegate.canLoadMoreItems = canLoadMoreItems;
}

@end
