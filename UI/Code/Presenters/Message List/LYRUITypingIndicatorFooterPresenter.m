//
//  LYRUITypingIndicatorFooterPresenter.m
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

#import "LYRUITypingIndicatorFooterPresenter.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIPanelTypingIndicatorView.h"
#import "LYRUIListDataSource.h"
#import "LYRUITypingIndicator.h"
#import "LYRUIMessageListView.h"
#import "LYRUIMessageListTypingIndicatorsControlling.h"

static CGFloat const LYRUITypingIndicatorFooterHeight = 22.0;

@implementation LYRUITypingIndicatorFooterPresenter
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

#pragma mark - LYRUIListSupplementaryViewPresenting

- (void)setupSupplementaryView:(LYRUIPanelTypingIndicatorView *)view forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![self shouldShowTypingIndicator]) {
        return;
    }
    LYRUITypingIndicator *typingIndicator = self.typingIndicatorsController.typingIndicator;
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
    if ([self shouldShowTypingIndicator]) {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), LYRUITypingIndicatorFooterHeight);
    }
    return CGSizeZero;
}

- (void)invalidateAllSupplementaryViewSizes {}

#pragma mark - Helpers

- (BOOL)shouldShowTypingIndicator {
    return ((self.messageListView.typingIndicatorMode & LYRUITypingIndicatorModeText) &&
            self.typingIndicatorsController.typingIndicatorPresented);
}

@end
