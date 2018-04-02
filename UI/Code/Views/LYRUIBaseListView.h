//
//  LYRUIBaseListView.h
//  Layer-XDK-UI-iOS
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
#import "LYRUIConfigurable.h"
#import "LYRUIListView.h"
#import "LYRUIViewWithLayout.h"
@class LYRQueryController;
@class LYRUIListSection<ModelType>;
@protocol LYRUIListDelegate;
@protocol LYRUIListDataSource;

NS_ASSUME_NONNULL_BEGIN     // {
IB_DESIGNABLE
/**
 @abstract A generic list view for presenting model objects of given `ModelType` in a `UICollectionView`.
 */
@interface LYRUIBaseListView<ModelType> : LYRUIViewWithLayout <LYRUIListView, LYRUIConfigurable>

/**
 @abstract An `LYRQueryController` instance managing data displayed in the list.
 @warning When an query controller is set on the list, it takes control of the collection view and it's data source, and maintains all the updates of its content. Any manual changes in items will result in unexpected behavior.
 @warning The `LYRQueryController`s delegate will be updated when set to this property.
 */
@property (nonatomic, strong) LYRQueryController *queryController;

/**
 @abstract Proxy for sections of items of given `ModelType` to present in the list view, stored in the data source.
 @warning When items are maintained manually (and not by the `LYRQueryController`), it is required to manually update the collection view with any changes made in the model.
 */
@property (nonatomic, strong) NSMutableArray<LYRUIListSection<ModelType> *> *items;

/**
 @abstract Layout of the list view and contained `UICollectionView`.
 */
@property (nonatomic, copy) IBOutlet UICollectionViewLayout<LYRUIListViewLayout> *layout;

/**
 @abstract A delegate of the contained `UICollectionView`.
 @warning When an delegate object is set to this property, the `indexPathSelected` block of the delegate will be updated with a block that retirieves an object for the corresponding index path from the data source, and passes it to the `itemSelected` block of this list view.
 */
@property (nonatomic, strong) id<LYRUIListDelegate> delegate;

/**
 @abstract A data source of the contained `UICollectionView`.
 */
@property (nonatomic, strong) id<LYRUIListDataSource> dataSource;

/**
 @abstract An callback block, called on selection of an item in the collection view.
 @warning If the `indexPathSelected` of the `delegate` is manually changed, this block will not be called.
 */
@property (nonatomic, copy) void(^itemSelected)(ModelType);

/**
 @abstract Returns an array of `ModelType` objects selected in the collection view.
 */
@property (nonatomic, readonly) NSArray<ModelType> *selectedItems;

/**
 @abstract Flag indicating if another page of items can be loaded.
 @warning When items are maintained manually (and not by the `LYRQueryController`), it is required to manually update the `canLoadMoreItems` value.
 */
@property (nonatomic) BOOL canLoadMoreItems;

/**
 @abstract A block called when list is scrolled near the end of current page and `canLoadMoreItems` is set to `YES`.
 @warning When items are maintained manually (and not by the `LYRQueryController`), it is required to manually set the `loadMoreItems` block handle loading inside of it.
 */
@property (nonatomic, copy) void(^loadMoreItems)(void);

@end
NS_ASSUME_NONNULL_END       // }
