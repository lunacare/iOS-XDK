//
//  LYRUIListCellConfiguration.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 18.10.2017.
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

#import "LYRUIListCellConfiguration.h"
#import "LYRUIListDataSource.h"

@implementation LYRUIListCellConfiguration
@synthesize listDataSource = _listDataSource;

- (instancetype)initWithCellClass:(Class)cellClass
                       modelClass:(Class)modelClass
                viewConfiguration:(id)viewConfiguration
                       cellHeight:(CGFloat)cellHeight
                   cellSetupBlock:(void(^)(id, id, id))cellSetupBlock
            cellRegistrationBlock:(nullable void(^)(UICollectionView *))cellRegistrationBlock {
    self = [super init];
    if (self) {
        [self setupWithCellClass:cellClass
                      modelClass:modelClass
               viewConfiguration:viewConfiguration
                      cellHeight:cellHeight
                  cellSetupBlock:cellSetupBlock
           cellRegistrationBlock:cellRegistrationBlock];
    }
    return self;
}

- (void)setupWithCellClass:(Class)cellClass
                modelClass:(Class)modelClass
         viewConfiguration:(id)viewConfiguration
                cellHeight:(CGFloat)cellHeight
            cellSetupBlock:(void(^)(id, id, id))cellSetupBlock
     cellRegistrationBlock:(nullable void(^)(UICollectionView *))cellRegistrationBlock {
    self.handledItemTypes = [NSSet setWithObject:modelClass];
    NSString *reuseIdentifier = NSStringFromClass(cellClass);
    self.cellReuseIdentifier = reuseIdentifier;
    self.viewConfiguration = viewConfiguration;
    self.cellHeight = cellHeight;
    self.cellSetupBlock = cellSetupBlock;
    if (cellRegistrationBlock == nil) {
        cellRegistrationBlock = ^(UICollectionView *collectionView) {
            [collectionView registerClass:cellClass forCellWithReuseIdentifier:reuseIdentifier];
        };
    }
    self.cellRegistrationBlock = cellRegistrationBlock;
}

- (void)setupCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    id modelItem = [self.listDataSource itemAtIndexPath:indexPath];
    if (self.cellSetupBlock) {
        self.cellSetupBlock(cell, modelItem, self.viewConfiguration);
    }
}

- (void)registerCellInCollectionView:(UICollectionView *)collectionView {
    if (self.cellRegistrationBlock) {
        self.cellRegistrationBlock(collectionView);
    }
}

- (CGSize)cellSizeInCollectionView:(UICollectionView *)collectionView forItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = CGRectGetWidth(collectionView.bounds);
    return CGSizeMake(width, self.cellHeight);
}

@end
