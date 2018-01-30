//
//  LYRUIListSupplementaryViewPresenter.h
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

#import <Foundation/Foundation.h>
#import "LYRUIListSupplementaryViewPresenting.h"
#import "LYRUIListSupplementaryViewSizeCalculating.h"
@protocol LYRUIListDataSource;
@class LYRUIListHeaderView;

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUIListSupplementaryViewPresenter<SupplementaryViewType> : NSObject <LYRUIListSupplementaryViewPresenting,
                                                                                      LYRUIListSupplementaryViewSizeCalculating>

/**
 @abstract Supplementary view visibility block, used in `supplementaryViewSizeInCollectionView:forItemAtIndexPath:` to determine if supplementary view of handled kind should be presented for provided index path.
 */
@property (nonatomic, copy) BOOL(^supplementaryViewVisibilityBlock)(id<LYRUIListDataSource>, NSIndexPath *);

/**
 @abstract Supplementary view setup block, called inside `setupSupplementaryView:forItemAtIndexPath:`. The view, list data source, and index path are passed to the block, to setup the reusable view (or it's subview) with the data from model object, using view presenter.
 */
@property (nonatomic, copy) void(^supplementaryViewSetupBlock)(SupplementaryViewType, id<LYRUIListDataSource>, NSIndexPath *);

/**
 @abstract Supplementary view registration block, used to register collection reusable view class for reuse identifier in the collection view.
 */
@property (nonatomic, copy) void(^supplementaryViewRegistrationBlock)(UICollectionView *);

/**
 @abstract Height of reusable view returned in `supplementaryViewSizeInCollectionView:forItemAtIndexPath:`.
 */
@property (nonatomic) CGFloat supplementaryViewHeight;

+ (LYRUIListSupplementaryViewPresenter<LYRUIListHeaderView *> *)headerPresenter;

/**
 @abstract Initializes supplementary view presenter with all necessary properties.
 @param kind Kind of supplementary view handled by the presenter. Will be added to `handledItemTypes`.
 @param reuseIdentifier Reuse identifier of the supplementary view used by the presenter to present model data.
 @param supplementaryViewHeight Height of supplementary view returned in `supplementaryViewSizeInCollectionView:forItemAtIndexPath:`.
 @param supplementaryViewVisibilityBlock Supplementary view visibility block, used in `supplementaryViewSizeInCollectionView:forItemAtIndexPath:` to determine if supplementary view of handled kind should be presented for provided index path.
 @param supplementaryViewSetupBlock Supplementary view setup block, called inside `setupSupplementaryView:forItemAtIndexPath:`. The view, list data source, and index path are passed to the block, to setup the reusable view (or it's subview) with the data from model object, using view presenter.
 @param supplementaryViewRegistrationBlock Supplementary view registration block, used to register collection reusable view class for reuse identifier in the collection view.
 @returns An instance of `LYRUIListSupplementaryViewPresenter` ready for use in `LYRUIListDelagate` and `LYRUIListDataSource`.
 */
- (instancetype)initWithSupplementaryViewClass:(Class)supplementaryViewClass
                                          kind:(NSString *)kind
                               reuseIdentifier:(NSString *)reuseIdentifier
                       supplementaryViewHeight:(CGFloat)supplementaryViewHeight
              supplementaryViewVisibilityBlock:(nullable BOOL(^)(id<LYRUIListDataSource>, NSIndexPath *))supplementaryViewVisibilityBlock
                   supplementaryViewSetupBlock:(void(^)(SupplementaryViewType, id<LYRUIListDataSource>, NSIndexPath *))supplementaryViewSetupBlock
            supplementaryViewRegistrationBlock:(nullable void(^)(UICollectionView *))supplementaryViewRegistrationBlock;

@end
NS_ASSUME_NONNULL_END       // }
