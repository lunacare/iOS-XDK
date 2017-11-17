//
//  LYRUIListCellConfiguring.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 16.10.2017.
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
@protocol LYRUIListDataSource;

@protocol LYRUIListCellConfiguring <NSObject>

/**
 @abstract Data source of the list view.
 */
@property (nonatomic, weak) id<LYRUIListDataSource> listDataSource;

/**
 @abstract A set of model types that are handled by the configuration.
 */
@property (nonatomic, readonly) NSSet<Class> *handledItemTypes;

/**
 @abstract Reuse identifier of the collection view cell used by the configuration to present model data.
 */
@property (nonatomic, readonly) NSString *cellReuseIdentifier;

/**
 @abstract Method used to register cell for reuse identifier in the collection view.
 @param collectionView A `UICollectionView` instance in which the cell will be registered.
 */
- (void)registerCellInCollectionView:(UICollectionView *)collectionView;

/**
 @abstract Method used to setup cell with data of model item at provided index path.
 @param cell The `UICollectionViewCell` for presenting model data.
 @param indexPath Index path of the model item from data source, that should be used to set up the cell with.
 */
- (void)setupCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;

@end
