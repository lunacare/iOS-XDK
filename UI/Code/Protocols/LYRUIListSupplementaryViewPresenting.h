//
//  LYRUIListSupplementaryViewPresenting.h
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

#import <UIKit/UIKit.h>
@protocol LYRUIListDataSource;

@protocol LYRUIListSupplementaryViewPresenting <NSObject>

/**
 @abstract Data source of the list view.
 */
@property (nonatomic, weak) id<LYRUIListDataSource> listDataSource;

/**
 @abstract Kind of the collection reusable view handled by the presenter.
 */
@property (nonatomic, readonly) NSString *viewKind;

/**
 @abstract Reuse identifier of the collection reusable view used by the presenter to present model data.
 */
@property (nonatomic, readonly) NSString *viewReuseIdentifier;

/**
 @abstract Method used to register reusable view of kind handled by the presenter, for reuse identifier in the collection view.
 @param collectionView A `UICollectionView` instance in which the reusable view will be registered.
 */
- (void)registerSupplementaryViewInCollectionView:(UICollectionView *)collectionView;

/**
 @abstract Method used to setup reusable view with data of model item at provided index path.
 @param view The `UICollectionReusableView` for presenting model data.
 @param indexPath Index path of the model item from data source, that should be used to set up the reusable view with.
 */
- (void)setupSupplementaryView:(UICollectionReusableView *)view forItemAtIndexPath:(NSIndexPath *)indexPath;

@end
