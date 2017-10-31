//
//  LYRUIListCellConfiguration.h
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

#import <UIKit/UIKit.h>
#import "LYRUIListCellSizeCalculating.h"
#import "LYRUIListCellConfiguring.h"

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUIListCellConfiguration<CellType, ConfigurationType, ModelType> : NSObject <LYRUIListCellSizeCalculating, LYRUIListCellConfiguring>

/**
 @abstract A set of model types that are handled by the configuration.
 */
@property (nonatomic, readwrite) NSSet<Class> *handledItemTypes;

/**
 @abstract Reuse identifier of the collection view cell used by the configuration to present model data.
 */
@property (nonatomic, readwrite) NSString *cellReuseIdentifier;

/**
 @abstract View configuration object for updating cells with model objects data.
 */
@property (nonatomic, strong) ConfigurationType viewConfiguration;

/**
 @abstract Cell setup block, called inside `setupCell:forItemAtIndexPath:`. The cell, model object, and view configuration are passed to the block, to setup the cell (or it's subview) with the data from model object, using view configuration.
 */
@property (nonatomic, copy) void(^cellSetupBlock)(CellType, ModelType, ConfigurationType);

/**
 @abstract Cell registration block, used to register cell class for reuse identifier in the collection view.
 */
@property (nonatomic, copy) void(^cellRegistrationBlock)(UICollectionView *);

/**
 @abstract Height of cell returned in `cellSizeInCollectionView:forItemAtIndexPath:`.
 */
@property (nonatomic) CGFloat cellHeight;

/**
 @abstract Initializes cell configuration with all necessary properties.
 @param cellClass Class of table view cell which will be used by the configuration.
 @param modelClass Class of model handled by the configuration. Will be added to `handledItemTypes`.
 @param viewConfiguration View configuration object for updating cells with model objects data.
 @param cellHeight Height of cell returned in `cellSizeInCollectionView:forItemAtIndexPath:`.
 @param cellSetupBlock Cell setup block, called inside `setupCell:forItemAtIndexPath:`. The cell, model object, and view configuration are passed to the block, to setup the cell (or it's subview) with the data from model object, using view configuration.
 @param cellRegistrationBlock Cell registration block, used to register cell class for reuse identifier in the collection view. Default is block registering provided `cellClass` for reuse identifier equal to the class name.
 @returns An instance of `LYRUIListCellConfiguration` ready for use in `LYRUIListDelagate` and `LYRUIListDataSource`.
 */
- (instancetype)initWithCellClass:(Class)cellClass
                       modelClass:(Class)modelClass
                viewConfiguration:(ConfigurationType)viewConfiguration
                       cellHeight:(CGFloat)cellHeight
                   cellSetupBlock:(void(^)(CellType, ModelType, ConfigurationType))cellSetupBlock
            cellRegistrationBlock:(nullable void(^)(UICollectionView *))cellRegistrationBlock;

@end
NS_ASSUME_NONNULL_END       // }
