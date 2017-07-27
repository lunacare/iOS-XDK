//
//  LYRUIListSupplementaryViewConfiguration.m
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

#import "LYRUIListSupplementaryViewConfiguration.h"
#import "LYRUIListDataSource.h"
#import "LYRUIListSection.h"

@interface LYRUIListSupplementaryViewConfiguration ()

@property (nonatomic, readwrite) NSString *viewKind;
@property (nonatomic, readwrite) NSString *viewReuseIdentifier;

@end

@implementation LYRUIListSupplementaryViewConfiguration
@synthesize listDelegate = _listDelegate,
            listDataSource = _listDataSource;

+ (LYRUIListSupplementaryViewConfiguration<LYRUIListHeaderView *> *)headerConfiguration {
    LYRUIListSupplementaryViewConfiguration<LYRUIListHeaderView *> *headerConfiguration =
        [[[self class] alloc] initWithSupplementaryViewClass:[LYRUIListHeaderView class]
                                                        kind:UICollectionElementKindSectionHeader
                                             reuseIdentifier:NSStringFromClass([LYRUIListHeaderView class])
                                     supplementaryViewHeight:64.0
                            supplementaryViewVisibilityBlock:^ BOOL (id<LYRUIListDataSource> dataSource, NSIndexPath *indexPath) {
                                return (dataSource.sections[indexPath.section].header != nil);
                            }
                                 supplementaryViewSetupBlock:^(UICollectionReusableView<LYRUIListHeaderView> *headerView, id<LYRUIListDataSource> dataSource, NSIndexPath *indexPath) {
                                     id<LYRUIListSectionHeader> header = dataSource.sections[indexPath.section].header;
                                     headerView.title = header.title;
                                 } supplementaryViewRegistrationBlock:nil];
    return headerConfiguration;
}

- (instancetype)initWithSupplementaryViewClass:(Class)supplementaryViewClass
                                          kind:(NSString *)kind
                               reuseIdentifier:(NSString *)reuseIdentifier
                       supplementaryViewHeight:(CGFloat)supplementaryViewHeight
              supplementaryViewVisibilityBlock:(BOOL(^)(id<LYRUIListDataSource>, NSIndexPath *))supplementaryViewVisibilityBlock
                   supplementaryViewSetupBlock:(void(^)(id, id<LYRUIListDataSource>, NSIndexPath *))supplementaryViewSetupBlock
            supplementaryViewRegistrationBlock:(void(^)(UICollectionView *))supplementaryViewRegistrationBlock {
    self = [super init];
    if (self) {
        self.viewKind = kind;
        self.viewReuseIdentifier = reuseIdentifier;
        self.supplementaryViewHeight = supplementaryViewHeight;
        self.supplementaryViewSetupBlock = supplementaryViewSetupBlock;
        if (supplementaryViewVisibilityBlock == nil) {
            supplementaryViewVisibilityBlock = ^ BOOL (id<LYRUIListDataSource> dataSource, NSIndexPath *indexPath) {
                return YES;
            };
        }
        self.supplementaryViewVisibilityBlock = supplementaryViewVisibilityBlock;
        if (supplementaryViewRegistrationBlock == nil) {
            supplementaryViewRegistrationBlock = ^(UICollectionView *collectionView) {
                [collectionView registerClass:supplementaryViewClass
                   forSupplementaryViewOfKind:kind
                          withReuseIdentifier:reuseIdentifier];
            };
        }
        self.supplementaryViewRegistrationBlock = supplementaryViewRegistrationBlock;
    }
    return self;
}

- (void)setupSupplementaryView:(LYRUIListHeaderView *)view forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.supplementaryViewSetupBlock) {
        self.supplementaryViewSetupBlock(view, self.listDataSource, indexPath);
    }
}


- (void)registerSupplementaryViewInCollectionView:(UICollectionView *)collectionView {
    if (self.supplementaryViewRegistrationBlock) {
        self.supplementaryViewRegistrationBlock(collectionView);
    }
}

- (CGSize)supplementaryViewSizeInCollectionView:(UICollectionView *)collectionView forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.supplementaryViewVisibilityBlock && self.supplementaryViewVisibilityBlock(self.listDataSource, indexPath)) {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), self.supplementaryViewHeight);
    }
    return CGSizeZero;
}

- (void)invalidateSupplementaryViewsSizes {}

@end
