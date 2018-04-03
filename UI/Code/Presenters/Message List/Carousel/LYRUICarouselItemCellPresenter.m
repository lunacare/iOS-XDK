//
//  LYRUICarouselItemCellPresenter.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 04.12.2017.
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

#import "LYRUICarouselItemCellPresenter.h"
#import "LYRUIMessageItemView.h"
#import "LYRUIMessageType.h"
#import "LYRUICarouselItemViewLayout.h"

@implementation LYRUICarouselItemCellPresenter

- (void)setupMessageViewLayout:(LYRUIMessageItemView *)messageView
                    forMessage:(LYRUIMessageType *)message {
    LYRUICarouselItemViewLayout *layout = [[LYRUICarouselItemViewLayout alloc] init];
    messageView.layout = layout;
}

- (void)setupAccessoryViewVisibility:(UIView *)accessoryView
                          forMessage:(LYRUIMessageType *)message {
    accessoryView.hidden = YES;
}

- (CGFloat)cellWidthInCollectionView:(UICollectionView *)collectionView {
    CGFloat collectionViewWidth = CGRectGetWidth(collectionView.bounds);
    CGFloat cellWidth = (0.8 * collectionViewWidth);
    if (collectionViewWidth > 600.0) {
        cellWidth = (0.6 * collectionViewWidth);
    } else if (collectionViewWidth > 460.0) {
        cellWidth = (0.75 * collectionViewWidth);
    }
    return MIN(cellWidth, 260.0);
}

- (CGFloat)maxContentViewWidthForCellWidth:(CGFloat)cellWidth {
    return cellWidth;
}

@end
