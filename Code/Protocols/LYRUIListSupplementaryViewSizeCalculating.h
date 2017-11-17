//
//  LYRUIListSupplementaryViewSizeCalculating.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 17.10.2017.
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
@protocol LYRUIListDelegate;

@protocol LYRUIListSupplementaryViewSizeCalculating <NSObject>

/**
 @abstract Delegate of the list view.
 */
@property (nonatomic, weak) id<LYRUIListDelegate> listDelegate;

/**
 @abstract Kind of the collection reusable view handled by the calculation.
 */
@property (nonatomic, readonly) NSString *viewKind;

/**
 @abstract Method used to calculate reusable view size with data of model item at provided index path.
 @param collectionView The `UICollectionView` in which the reusable view will be presented.
 @param indexPath Index path of the model item from data source, that should be used to set up the reusable view for size calculation.
 @returns The calculated size of collection reusable view, for displaying the model data.
 */
- (CGSize)supplementaryViewSizeInCollectionView:(UICollectionView *)collectionView forItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 @abstract Method called when calculated sizes cached for index paths should be invalidated.
 */
- (void)invalidateAllSupplementaryViewSizes;

@end
