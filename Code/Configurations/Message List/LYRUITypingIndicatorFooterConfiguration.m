//
//  LYRUITypingIndicatorFooterConfiguration.m
//  Layer-UI-iOS
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

#import "LYRUITypingIndicatorFooterConfiguration.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIPanelTypingIndicatorView.h"
#import "LYRUIListDataSource.h"
#import "LYRUITypingIndicator.h"

static CGFloat const LYRUITypingIndicatorFooterHeight = 22.0;

@implementation LYRUITypingIndicatorFooterConfiguration
@synthesize listDataSource = _listDataSource,
            listDelegate = _listDelegate,
            layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (NSString *)viewKind {
    return UICollectionElementKindSectionFooter;
}

- (NSString *)viewReuseIdentifier {
    return NSStringFromClass([LYRUIPanelTypingIndicatorView class]);
}

#pragma mark - LYRUIListSupplementaryViewConfiguring

- (void)setupSupplementaryView:(LYRUIPanelTypingIndicatorView *)view forItemAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self.listDataSource itemAtIndexPath:self.listDataSource.lastItemIndexPath];
    if (![item isKindOfClass:[LYRUITypingIndicator class]]) {
        return;
    }
    LYRUITypingIndicator *typingIndicator = (LYRUITypingIndicator *)item;
    view.layerConfiguration = self.layerConfiguration;
    view.identities = typingIndicator.typingParticipants;
}

- (void)registerSupplementaryViewInCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:[LYRUIPanelTypingIndicatorView class]
       forSupplementaryViewOfKind:self.viewKind
              withReuseIdentifier:self.viewReuseIdentifier];
}

#pragma mark - LYRUIListSupplementaryViewSizeCalculating

- (CGSize)supplementaryViewSizeInCollectionView:(UICollectionView *)collectionView forItemAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self.listDataSource itemAtIndexPath:self.listDataSource.lastItemIndexPath];
    if ([item isKindOfClass:[LYRUITypingIndicator class]]) {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), LYRUITypingIndicatorFooterHeight);
    }
    return CGSizeZero;
}

- (void)invalidateAllSupplementaryViewSizes {}

@end
