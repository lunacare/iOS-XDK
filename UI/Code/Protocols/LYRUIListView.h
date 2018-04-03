//
//  LYRUIListView.h
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
#import "LYRUIViewLayout.h"
@protocol LYRUIListView;

NS_ASSUME_NONNULL_BEGIN     // {
@protocol LYRUIListViewLayout <LYRUIViewLayout>

- (void)addConstraintsInView:(UIView<LYRUIListView> *)view;
- (void)removeConstraintsFromView:(UIView<LYRUIListView> *)view;
- (void)updateConstraintsInView:(UIView<LYRUIListView> *)view;

@end

@protocol LYRUIListView <NSObject>

@property (nonatomic, weak, readonly) UICollectionView *collectionView;
@property (nonatomic, copy) id<LYRUIListViewLayout> layout;

@end
NS_ASSUME_NONNULL_END       // }
