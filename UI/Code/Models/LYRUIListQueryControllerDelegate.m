//
//  LYRUIListQueryControllerDelegate.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 02.08.2017.
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

#import "LYRUIListQueryControllerDelegate.h"
#import "LYRUIListDataSource.h"
#import "LYRUIListSection.h"

@interface LYRUIListQueryControllerDelegate ()

@property (nonatomic, strong) NSArray *itemsSelectedBeforeContentChange;
@property (nonatomic, strong) NSMutableArray *insertedIndexPaths;
@property (nonatomic, strong) NSMutableArray *deletedIndexPaths;
@property (nonatomic, strong) NSMutableArray *updatedIndexPaths;

@end

@implementation LYRUIListQueryControllerDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        self.insertedIndexPaths = [[NSMutableArray alloc] init];
        self.deletedIndexPaths = [[NSMutableArray alloc] init];
        self.updatedIndexPaths = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - LYRQueryControllerDelegate

- (void)queryControllerWillChangeContent:(LYRQueryController *)queryController {
    [self storeSelectedItems];
}

- (void)queryController:(LYRQueryController *)controller
        didChangeObject:(id)object
            atIndexPath:(NSIndexPath *)indexPath
          forChangeType:(LYRQueryControllerChangeType)type
           newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case LYRQueryControllerChangeTypeInsert:
            [self.insertedIndexPaths addObject:newIndexPath];
            break;
        case LYRQueryControllerChangeTypeUpdate:
        {
            NSIndexPath *currentIndexPath = [controller indexPathForObject:object];
            if (currentIndexPath && [currentIndexPath isEqual:indexPath]) {
                [self.updatedIndexPaths addObject:indexPath];
            }
            break;
        }
        case LYRQueryControllerChangeTypeMove:
            [self.deletedIndexPaths addObject:indexPath];
            [self.insertedIndexPaths addObject:newIndexPath];
            break;
        case LYRQueryControllerChangeTypeDelete:
            [self.deletedIndexPaths addObject:indexPath];
            break;
        default:
            break;
    }
}

- (void)queryControllerDidChangeContent:(LYRQueryController *)queryController {
    __weak __typeof(self) weakSelf = self;
    [self.collectionView performBatchUpdates:^{
        [weakSelf updateObjectsWithQueryController:queryController];
        [weakSelf performCollectionViewUpdates];
        [weakSelf restoreSelectedItemsWithQueryController:queryController];
    } completion:nil];
}

#pragma mark - Data updates;

- (void)updateObjectsWithQueryController:(LYRQueryController *)queryController {
    LYRUIListSection *section = self.listDataSource.sections[0];
    section.items = [queryController.paginatedObjects.array mutableCopy];
}

#pragma mark - UICollectionView updates

- (void)performCollectionViewUpdates {
    [self.collectionView deleteItemsAtIndexPaths:self.deletedIndexPaths];
    [self.collectionView insertItemsAtIndexPaths:self.insertedIndexPaths];
    [self.collectionView reloadItemsAtIndexPaths:self.updatedIndexPaths];
    [self.deletedIndexPaths removeAllObjects];
    [self.insertedIndexPaths removeAllObjects];
    [self.updatedIndexPaths removeAllObjects];
}

#pragma mark - Selected items management

- (void)storeSelectedItems {
    NSMutableArray *selectedItems;
    NSArray<NSIndexPath *> *indexPaths = [self.collectionView indexPathsForSelectedItems];
    if (indexPaths && indexPaths.count > 0) {
        selectedItems = [[NSMutableArray alloc] init];
        for (NSIndexPath *indexPath in indexPaths) {
            id object = [self.listDataSource itemAtIndexPath:indexPath];
            if (object) {
                [selectedItems addObject:object];
            }
        }
    }
    self.itemsSelectedBeforeContentChange = selectedItems;
}

- (void)restoreSelectedItemsWithQueryController:(LYRQueryController *)queryController {
    if (self.itemsSelectedBeforeContentChange) {
        for (id item in self.itemsSelectedBeforeContentChange) {
            NSIndexPath *indexPath = [queryController indexPathForObject:item];
            if (indexPath) {
                [self.collectionView selectItemAtIndexPath:indexPath
                                                  animated:NO
                                            scrollPosition:UICollectionViewScrollPositionNone];
            }
        }
        self.itemsSelectedBeforeContentChange = nil;
    }
}

@end
