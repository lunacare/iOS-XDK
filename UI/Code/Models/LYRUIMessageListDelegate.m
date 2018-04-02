//
//  LYRUIMessageListDelegate.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 18.08.2017.
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

#import "LYRUIMessageListDelegate.h"

static CGFloat const LYRUIMessageListTopInset = 8.0;
static CGFloat const LYRUIMessageListBottomInset = 16.0;

@implementation LYRUIMessageListDelegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    CGFloat topInset = 0.0;
    if (section == 0) {
        topInset = LYRUIMessageListTopInset;
    }
    CGFloat bottomInset = 0.0;
    if (section == ([collectionView.dataSource numberOfSectionsInCollectionView:collectionView] - 1)) {
        bottomInset = LYRUIMessageListBottomInset;
    }
    return UIEdgeInsetsMake(topInset, 0.0, bottomInset, 0.0);
}

@end
