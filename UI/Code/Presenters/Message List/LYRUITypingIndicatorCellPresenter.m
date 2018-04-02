//
//  LYRUITypingIndicatorCellPresenter.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 28.01.2018.
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

#import "LYRUITypingIndicatorCellPresenter.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIBubbleTypingIndicatorCollectionViewCell.h"
#import "LYRUIBubbleTypingIndicatorView.h"
#import "LYRUITypingIndicator.h"
#import "LYRUIListDataSource.h"

static CGFloat const LYRUITypingIndicatorCellHeight = 39.0;

@implementation LYRUITypingIndicatorCellPresenter
@synthesize listDataSource = _listDataSource,
            layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

#pragma mark - LYRUIListCellSizeCalculating

- (NSSet<Class> *)handledItemTypes {
    return [NSSet setWithObject:[LYRUITypingIndicator class]];
}

- (CGSize)cellSizeInCollectionView:(UICollectionView *)collectionView forItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = CGRectGetWidth(collectionView.bounds);
    return CGSizeMake(width, LYRUITypingIndicatorCellHeight);
}

#pragma mark - LYRUIListCellPresenting

- (NSString *)cellReuseIdentifier {
    return NSStringFromClass([LYRUIBubbleTypingIndicatorView class]);
}

- (void)registerCellInCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:[LYRUIBubbleTypingIndicatorCollectionViewCell class] forCellWithReuseIdentifier:self.cellReuseIdentifier];
}

- (void)setupCell:(LYRUIBubbleTypingIndicatorCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self.listDataSource itemAtIndexPath:indexPath];
    if (![item isKindOfClass:[LYRUITypingIndicator class]]) {
        return;
    }
    LYRUIBubbleTypingIndicatorView *typingIndicatorView = cell.typingIndicatorView;
    typingIndicatorView.layerConfiguration = self.layerConfiguration;
    LYRUITypingIndicator *typingIndicator = (LYRUITypingIndicator *)item;
    typingIndicatorView.identities = typingIndicator.typingParticipants;
}

@end
