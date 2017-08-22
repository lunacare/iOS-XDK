//
//  LYRUIListLoadingIndicatorConfiguration.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 19.10.2017.
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
#import "LYRUIListSupplementaryViewConfiguring.h"
#import "LYRUIListSupplementaryViewSizeCalculating.h"
#import "LYRUIListDelegate.h"

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUIListLoadingIndicatorConfiguration : NSObject <LYRUIListSupplementaryViewConfiguring,
                                                              LYRUIListSupplementaryViewSizeCalculating,
                                                              LYRUIListLoadingMoreDelegate>

/**
 @abstract Initializes loading indicator configuration using `LYRUIListLoadingIndicatorView` as a list header.
 @returns An instance of `LYRUIListLoadingIndicatorConfiguration` ready for use as a old items loading indicator in `LYRUIListDelagate` and `LYRUIListDataSource`.
 */
+ (instancetype)loadingOldItemsIndicatorConfiguration;

/**
 @abstract Initializes loading indicator configuration using `LYRUIListLoadingIndicatorView` as a list footer.
 @returns An instance of `LYRUIListLoadingIndicatorConfiguration` ready for use as a new items loading indicator in `LYRUIListDelagate` and `LYRUIListDataSource`.
 */
+ (instancetype)loadingNewItemsIndicatorConfiguration;

/**
 @abstract Initializes loading indicator configuration with all necessary properties.
 @param viewClass Class of loading indicator supplementary view used by the configuration.
 @param height Height of the loading indicator supplementary view
 @param kind Kind of supplementary view handled by the configuration. Will be added to `handledItemTypes`.
 @param shouldLoadMoreBlock Block used in `shouldLoadMoreItemsWithScrollView:` method to determine if list should load additional messages.
 @returns An instance of `LYRUIListLoadingIndicatorConfiguration` ready for use in `LYRUIListDelagate` and `LYRUIListDataSource`.
 */
- (instancetype)initWithViewClass:(Class)viewClass
                           height:(CGFloat)height
                             kind:(NSString *)kind
              shouldLoadMoreBlock:(BOOL(^)(UIScrollView *))shouldLoadMoreBlock;

@end
NS_ASSUME_NONNULL_END       // }
