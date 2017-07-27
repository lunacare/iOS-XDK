//
//  LYRUIListLayout.m
//  Layer-UI-iOS
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

#import "LYRUIListLayout.h"
#import "LYRUIListDataSource.h"

@implementation LYRUIListLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    LYRUIListLayout *copy = [[[self class] allocWithZone:zone] init];
    copy.minimumLineSpacing = self.minimumLineSpacing;
    copy.minimumInteritemSpacing = self.minimumInteritemSpacing;
    copy.itemSize = self.itemSize;
    copy.estimatedItemSize = self.estimatedItemSize;
    copy.scrollDirection = self.scrollDirection;
    copy.headerReferenceSize = self.headerReferenceSize;
    copy.footerReferenceSize = self.footerReferenceSize;
    copy.sectionInset = self.sectionInset;
    copy.sectionHeadersPinToVisibleBounds = self.sectionHeadersPinToVisibleBounds;
    copy.sectionFootersPinToVisibleBounds = self.sectionFootersPinToVisibleBounds;
    return copy;
}

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds {
    UICollectionViewFlowLayoutInvalidationContext *context = (UICollectionViewFlowLayoutInvalidationContext *)[super invalidationContextForBoundsChange:newBounds];
    context.invalidateFlowLayoutDelegateMetrics = (CGRectGetWidth(newBounds) != CGRectGetWidth(self.collectionView.bounds));
    return context;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    if (!self.delegate) {
        return;
    }
    
    [self.delegate invalidateSupplementaryViewsSizes];
}

#pragma mark - Properties

- (id<LYRUIListLayoutDelegate>)delegate {
    if (![self.collectionView.delegate conformsToProtocol:@protocol(LYRUIListLayoutDelegate)]) {
        return nil;
    }
    return (id<LYRUIListLayoutDelegate>)self.collectionView.delegate;
}

- (id<LYRUIListDataSource>)dataSource {
    if (![self.collectionView.dataSource conformsToProtocol:@protocol(LYRUIListDataSource)]) {
        return nil;
    }
    return (id<LYRUIListDataSource>)self.collectionView.dataSource;
}

#pragma mark - LYRUIListViewLayout methods

- (void)addConstraintsInView:(UIView<LYRUIListView> *)view {
    view.collectionView.translatesAutoresizingMaskIntoConstraints = YES;
    view.collectionView.frame = view.bounds;
    view.collectionView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
}

- (void)updateConstraintsInView:(UIView<LYRUIListView> *)view {}

- (void)removeConstraintsFromView:(UIView<LYRUIListView> *)view {}

@end
