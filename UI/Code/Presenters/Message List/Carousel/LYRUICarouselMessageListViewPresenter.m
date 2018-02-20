//
//  LYRUICarouselMessageListViewPresenter.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 01.02.2018.
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

#import "LYRUICarouselMessageListViewPresenter.h"
#import "LYRUICarouselMessageListView.h"
#import "LYRUICarouselMessageListLayout.h"
#import "LYRUICarouselItemCellPresenter.h"
#import "LYRUIListDataSource.h"
#import "LYRUICarouselListDelegate.h"

@implementation LYRUICarouselMessageListViewPresenter

- (void)setupListView:(LYRUICarouselMessageListView *)messageListView {
    [super setupListView:messageListView];
    messageListView.translatesAutoresizingMaskIntoConstraints = NO;
    messageListView.clipsToBounds = NO;
    messageListView.collectionView.showsVerticalScrollIndicator = NO;
    messageListView.collectionView.showsHorizontalScrollIndicator = NO;
}

- (Class)delegateClass {
    return [LYRUICarouselListDelegate class];
}

- (Class)cellPresenterClass {
    return [LYRUICarouselItemCellPresenter class];
}

@end
