//
//  LYRUIListCellSizeCalculating.h
//  Layer-XDK-UI-iOS
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

#import <Foundation/Foundation.h>

@protocol LYRUIListCellSizeCalculating <NSObject>

/**
 @abstract A set of model types that are handled by the calculation.
 */
@property (nonatomic, readonly) NSSet<Class> *handledItemTypes;

/**
 @abstract Method used to calculate cell size with data of model item at provided index path.
 @param collectionView The `UICollectionView` in which the cell will be presented.
 @param indexPath Index path of the model item from data source, that should be used to set up the cell for size calculation.
 @returns The calculated size of collection view cell, for displaying the model data.
 */
- (CGSize)cellSizeInCollectionView:(UICollectionView *)collectionView forItemAtIndexPath:(NSIndexPath *)indexPath;

@end
