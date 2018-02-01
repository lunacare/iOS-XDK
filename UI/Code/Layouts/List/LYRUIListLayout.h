//
//  LYRUIListLayout.h
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
#import "LYRUIListView.h"
@protocol LYRUIListDataSource;

@class LYRUIListLayout;

@protocol LYRUIListLayoutDelegate <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(LYRUIListLayout *)collectionViewLayout
        sizeOfViewOfKind:(NSString *)kind
             atIndexPath:(NSIndexPath *)indexPath;

- (void)invalidateAllSupplementaryViewSizes;

@end

/**
 @abstract A layout of the `LYRUIBaseListView` and its `UICollectionView`. Resizes the collection view to fully fill the `LYRUIBaseListView`, and is an vertical flow layout for `UICollectionView`.
 */
@interface LYRUIListLayout : UICollectionViewFlowLayout <LYRUIListViewLayout>

@property (nonatomic, readonly) id<LYRUIListLayoutDelegate> delegate;
@property (nonatomic, readonly) id<LYRUIListDataSource> dataSource;

@end
