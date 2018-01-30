//
//  LYRUIMessageListQueryControllerDelegate.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 22.08.2017.
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

#import "LYRUIMessageListQueryControllerDelegate.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIListDataSource.h"
#import "LYRUIListSection.h"
#import <LayerKit/LayerKit.h>
#import "UIScrollView+LYRUIAdjustedContentInset.h"
#import "LYRUIMessageSerializer.h"

@interface LYRUIMessageListQueryControllerDelegate ()

@property (nonatomic, strong) NSMutableArray *insertedIndexPaths;
@property (nonatomic, strong) NSMutableArray *adjacentToInsertedIndexPaths;
@property (nonatomic, strong) NSMutableArray *deletedIndexPaths;
@property (nonatomic, strong) NSMutableArray *updatedIndexPaths;

@property(nonatomic, strong) LYRUIMessageSerializer *messageSerializer;

@end

@implementation LYRUIMessageListQueryControllerDelegate
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.insertedIndexPaths = [[NSMutableArray alloc] init];
        self.adjacentToInsertedIndexPaths = [[NSMutableArray alloc] init];
        self.deletedIndexPaths = [[NSMutableArray alloc] init];
        self.updatedIndexPaths = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [self init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    self.messageSerializer = [layerConfiguration.injector objectOfType:[LYRUIMessageSerializer class]];
}

#pragma mark - LYRQueryControllerDelegate

- (void)queryControllerWillChangeContent:(LYRQueryController *)queryController {}

- (void)queryController:(LYRQueryController *)queryController
        didChangeObject:(id)object
            atIndexPath:(NSIndexPath *)indexPath
          forChangeType:(LYRQueryControllerChangeType)type
           newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case LYRQueryControllerChangeTypeInsert:
            if (newIndexPath.item > 0) {
                NSIndexPath *previousMessageIndexPath = [NSIndexPath indexPathForItem:(newIndexPath.item - 1)
                                                                            inSection:newIndexPath.section];
                [self.adjacentToInsertedIndexPaths addObject:previousMessageIndexPath];
            }
            [self.insertedIndexPaths addObject:newIndexPath];
            if (newIndexPath.item < queryController.count - 1) {
                NSIndexPath *nextMessageIndexPath = [NSIndexPath indexPathForItem:(newIndexPath.item + 1)
                                                                        inSection:newIndexPath.section];
                [self.adjacentToInsertedIndexPaths addObject:nextMessageIndexPath];
            }
            break;
        case LYRQueryControllerChangeTypeUpdate:
        {
            NSIndexPath *currentIndexPath = [queryController indexPathForObject:object];
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
    [self updateIndexPathsToReloadWithQueryController:queryController];
    BOOL shouldScrollToLastMessage = [self newMessagesReceived] && [self lastMessageIsVisible];
    BOOL oldMessagesLoaded = [self oldMessagesLoaded];
    CGFloat oldOffset = self.collectionView.contentOffset.y;
    CGFloat offsetToBottom = self.collectionView.contentSize.height - self.collectionView.contentOffset.y;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self.collectionView performBatchUpdates:^{
        [weakSelf updateCollectionViewItemsWithQueryController:queryController];
    } completion:^(BOOL finished) {
        if (shouldScrollToLastMessage) {
            [weakSelf scrollToLastMessage];
        } else if (oldMessagesLoaded) {
            [weakSelf maintainOffsetToBottom:offsetToBottom];
        } else {
            [weakSelf maintainOldOffset:oldOffset];
        }
        [CATransaction commit];
    }];
}

- (void)updateCollectionViewItemsWithQueryController:(LYRQueryController *)queryController {
    [self updateObjectsWithQueryController:queryController];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self performCollectionViewUpdates];
}

#pragma mark - Data updates;

- (void)updateObjectsWithQueryController:(LYRQueryController *)queryController {
    if (self.listDataSource.sections.count == 0) {
        self.listDataSource.sections = [@[[[LYRUIListSection alloc] init]] mutableCopy];
    }
    LYRUIListSection *section = self.listDataSource.sections[0];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (LYRMessage *message in queryController.paginatedObjects.array) {
        LYRUIMessageType *messageType = [self.messageSerializer typedMessageWithLayerMessage:message];
        [items addObject:messageType];
    }
    section.items = items;
}

- (void)updateIndexPathsToReloadWithQueryController:(LYRQueryController *)queryController {
    [self.adjacentToInsertedIndexPaths removeObjectsInArray:self.insertedIndexPaths];
    for (NSIndexPath *indexPath in self.adjacentToInsertedIndexPaths) {
        id item = [queryController objectAtIndexPath:indexPath];
        NSIndexPath *oldIndexPath = [self.listDataSource indexPathOfItem:item];
        if (oldIndexPath) {
            [self.deletedIndexPaths addObject:oldIndexPath];
            [self.insertedIndexPaths addObject:indexPath];
        }
    }
    [self.adjacentToInsertedIndexPaths removeAllObjects];
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

#pragma mark - Content offset updates

- (void)scrollToLastMessage {
    NSIndexPath *lastItemIndexPath = self.listDataSource.lastItemIndexPath;
    [self.collectionView scrollToItemAtIndexPath:lastItemIndexPath
                                atScrollPosition:UICollectionViewScrollPositionBottom
                                        animated:YES];
}

- (void)maintainOffsetToBottom:(CGFloat)offsetToBottom {
    CGFloat maxOffset = [self maxContentOffxet];
    CGFloat newOffset = self.collectionView.contentSize.height - offsetToBottom;
    CGPoint contentOffset = CGPointMake(0, MIN(newOffset, maxOffset));
    self.collectionView.contentOffset = contentOffset;
}

- (void)maintainOldOffset:(CGFloat)oldOffset {
    CGFloat maxOffset = [self maxContentOffxet];
    CGPoint contentOffset = CGPointMake(0, MIN(oldOffset, maxOffset));
    self.collectionView.contentOffset = contentOffset;
}

#pragma mark - Helpers

- (BOOL)newMessagesReceived {
    NSIndexPath *lastMessageIndexPath = self.listDataSource.lastItemIndexPath;
    for (NSIndexPath *indexPath in self.insertedIndexPaths.reverseObjectEnumerator.allObjects) {
        if (indexPath.item > lastMessageIndexPath.item) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)lastMessageIsVisible {
    return [self.collectionView.indexPathsForVisibleItems containsObject:self.listDataSource.lastItemIndexPath];
}

- (BOOL)oldMessagesLoaded {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    return [self.insertedIndexPaths containsObject:indexPath];
}

- (CGFloat)maxContentOffxet {
    UIEdgeInsets contentInsets = self.collectionView.lyr_adjustedContentInset;
    CGFloat collectionViewHeight = CGRectGetHeight(self.collectionView.bounds);
    CGFloat maxOffset = MAX(self.collectionView.contentSize.height - collectionViewHeight, -contentInsets.top);
    return maxOffset;
}

@end
