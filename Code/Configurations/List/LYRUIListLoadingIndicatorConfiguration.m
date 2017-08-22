//
//  LYRUIListLoadingIndicatorConfiguration.m
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

#import "LYRUIListLoadingIndicatorConfiguration.h"
#import "LYRUIListLoadingIndicatorView.h"

CGFloat const LYRUIListMinimumOffsetToLoadMoreItems = 200.0;

@interface LYRUIListLoadingIndicatorConfiguration ()

@property (nonatomic, readwrite) NSString *viewKind;
@property (nonatomic, strong) Class loadingIndicatorViewClass;
@property (nonatomic) CGFloat loadindIndicatorHeight;
@property (nonatomic, copy) BOOL(^shouldLoadMoreBlock)(UIScrollView *);

@end

@implementation LYRUIListLoadingIndicatorConfiguration
@synthesize listDelegate = _listDelegate,
            listDataSource = _listDataSource,
            canLoadMoreItems = _canLoadMoreItems;

+ (instancetype)loadingOldItemsIndicatorConfiguration {
    return [[[self class] alloc] initWithViewClass:[LYRUIListLoadingIndicatorView class]
                                            height:44.0
                                              kind:UICollectionElementKindSectionHeader
                               shouldLoadMoreBlock:^ BOOL (UIScrollView *scrollView) {
                                   return (scrollView.contentOffset.y < 200.0);
                               }];
}

+ (instancetype)loadingNewItemsIndicatorConfiguration {
    return [[[self class] alloc] initWithViewClass:[LYRUIListLoadingIndicatorView class]
                                            height:44.0
                                              kind:UICollectionElementKindSectionFooter
                               shouldLoadMoreBlock:^ BOOL (UIScrollView *scrollView) {
                                   CGFloat maxContentOffset = scrollView.contentSize.height - CGRectGetHeight(scrollView.bounds);
                                   return (scrollView.contentOffset.y > (maxContentOffset - LYRUIListMinimumOffsetToLoadMoreItems));
                               }];
}

- (instancetype)initWithViewClass:(Class)viewClass
                           height:(CGFloat)height
                             kind:(NSString *)kind
              shouldLoadMoreBlock:(BOOL(^)(UIScrollView *))shouldLoadMoreBlock {
    self = [super init];
    if (self) {
        self.loadingIndicatorViewClass = viewClass;
        self.viewKind = kind;
        self.loadindIndicatorHeight = height;
        self.shouldLoadMoreBlock = shouldLoadMoreBlock;
    }
    return self;
}

- (NSString *)viewReuseIdentifier {
    return NSStringFromClass([LYRUIListLoadingIndicatorView class]);
}

#pragma mark - LYRUIListSupplementaryViewConfiguring methods

- (void)setupSupplementaryView:(LYRUIListLoadingIndicatorView *)view forItemAtIndexPath:(NSIndexPath *)indexPath {}

- (void)registerSupplementaryViewInCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:[LYRUIListLoadingIndicatorView class]
       forSupplementaryViewOfKind:self.viewKind
              withReuseIdentifier:self.viewReuseIdentifier];
}

#pragma mark - LYRUIListSupplementaryViewSizeCalculating methods

- (CGSize)supplementaryViewSizeInCollectionView:(UICollectionView *)collectionView forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.canLoadMoreItems) {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), self.loadindIndicatorHeight);
    }
    return CGSizeZero;
}

- (void)invalidateAllSupplementaryViewSizes {}

#pragma mark - LYRUIListLoadingMoreDelegate methods

- (BOOL)shouldLoadMoreItemsWithScrollView:(nonnull UIScrollView *)scrollView {
    if (self.shouldLoadMoreBlock) {
        return self.shouldLoadMoreBlock(scrollView);
    }
    return NO;
}

@end
