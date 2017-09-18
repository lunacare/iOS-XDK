//
//  LYRUIMessageListStatusSupplementaryViewConfiguration.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 17.10.2017.
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

#import "LYRUIMessageListStatusSupplementaryViewConfiguration.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIMessageListMessageStatusViewLayout.h"
#import "LYRUIMessageListMessageStatusView.h"
#import "LYRUIListHeaderView.h"
#import "LYRUIMessageRecipientStatusFormatter.h"
#import "LYRUIMessageListLayout.h"
#import "LYRUIMessageListView.h"
#import "LYRUIListDataSource.h"
#import "LYRUIListDelegate.h"
#import "LYRUIListSection.h"
#import <LayerKit/LayerKit.h>

static CGFloat const LYRUIMessageListStatusSupplementaryViewDefaultHeight = 17.0;

@interface LYRUIMessageListStatusSupplementaryViewConfiguration ()

@property (nonatomic, strong) LYRUIMessageListMessageStatusViewLayout *messageStatusLayout;
@property (nonatomic, strong) LYRUIMessageRecipientStatusFormatter *statusFormatter;

@property (nonatomic, strong) NSIndexPath *firstMessageStatusIndexPath;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, NSNumber *> *showStatusForIndexPath;

@end

@implementation LYRUIMessageListStatusSupplementaryViewConfiguration
@synthesize listDataSource = _listDataSource,
            listDelegate = _listDelegate,
            layerConfiguration = _layerConfiguration;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.messageStatusHeight = LYRUIMessageListStatusSupplementaryViewDefaultHeight;
        self.showStatusForIndexPath = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [self init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    self.messageStatusLayout = [layerConfiguration.injector layoutForViewClass:[LYRUIMessageListMessageStatusView class]];
    self.statusFormatter = [layerConfiguration.injector objectOfType:[LYRUIMessageRecipientStatusFormatter class]];
}

- (NSString *)viewKind {
    return LYRUIMessageListMessageStatusViewKind;
}

- (NSString *)viewReuseIdentifier {
    return NSStringFromClass([LYRUIMessageListMessageStatusView class]);
}

#pragma mark - LYRUIListSupplementaryViewConfiguring

- (void)setupSupplementaryView:(LYRUIListHeaderView *)view forItemAtIndexPath:(NSIndexPath *)indexPath {
    LYRMessage *message = (LYRMessage *)[self.listDataSource itemAtIndexPath:indexPath];
    [self setupMessageStatusView:view withMessage:message];
}

- (void)setupMessageStatusView:(LYRUIListHeaderView *)statusView
                   withMessage:(LYRMessage *)message {
    statusView.layout = self.messageStatusLayout;
    statusView.title = [self.statusFormatter stringForMessageRecipientStatus:message];
}

- (void)registerSupplementaryViewInCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:[LYRUIListHeaderView class]
       forSupplementaryViewOfKind:self.viewKind
              withReuseIdentifier:self.viewReuseIdentifier];
}

#pragma mark - LYRUIListSupplementaryViewSizeCalculating

- (CGSize)supplementaryViewSizeInCollectionView:(UICollectionView *)collectionView forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self shouldShowMessageStatusAtIndexPath:indexPath]) {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), self.messageStatusHeight);
    }
    return CGSizeZero;
}

- (void)invalidateAllSupplementaryViewSizes {
    [self.showStatusForIndexPath removeAllObjects];
    self.firstMessageStatusIndexPath = nil;
}

- (BOOL)shouldShowMessageStatusAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showStatusForIndexPath[indexPath]) {
        return self.showStatusForIndexPath[indexPath].boolValue;
    }
    id<LYRUIListDataSource> dataSource = self.listDataSource;
    id item = [dataSource itemAtIndexPath:indexPath];
    if (![item isKindOfClass:[LYRMessage class]]) {
        return NO;
    }
    LYRMessage *message = (LYRMessage *)item;
    BOOL shouldShowStatus = ([self isOutgoingMessage:message] &&
                             [self indexPathIsAfterFirstMessageStatusIndexPath:indexPath]);
    self.showStatusForIndexPath[indexPath] = @(shouldShowStatus);
    return shouldShowStatus;
}

#pragma mark - First visible message status

- (void)updateFirstVisibleMessageStatusIndexPath {
    id<LYRUIListDataSource> dataSource = self.listDataSource;
    LYRUIListSection *section = dataSource.sections.firstObject;
    if (section.items.count == 0) {
        return;
    }
    for (id item in [section.items reverseObjectEnumerator].allObjects) {
        if (![item isKindOfClass:[LYRMessage class]]) {
            continue;
        }
        LYRMessage *message = (LYRMessage *)item;
        if (![self isOutgoingMessage:message]) {
            continue;
        }
        NSUInteger itemIndex = [section.items indexOfObject:message];
        NSUInteger sectionIndex = [dataSource.sections indexOfObject:section];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex
                                                     inSection:sectionIndex];
        
        BOOL messageRead = ([self.statusFormatter statusForMessage:message] == LYRRecipientStatusRead);
        
        LYRMessage *previousMessage;
        if (indexPath.item > 0) {
            previousMessage = section.items[indexPath.item - 1];
        }
        BOOL firstMessageInSection = ![self isOutgoingMessage:previousMessage];
        if (messageRead || firstMessageInSection) {
            self.firstMessageStatusIndexPath = indexPath;
            return;
        }
    }
}

#pragma mark - Helpers

- (BOOL)isOutgoingMessage:(LYRMessage *)message {
    NSString *currentUserId = self.layerConfiguration.client.authenticatedUser.userID;
    return [message.sender.userID isEqualToString:currentUserId];
}

- (BOOL)indexPathIsAfterFirstMessageStatusIndexPath:(NSIndexPath *)indexPath {
    if (self.firstMessageStatusIndexPath == nil) {
        [self updateFirstVisibleMessageStatusIndexPath];
    }
    return (self.firstMessageStatusIndexPath != nil &&
            ((indexPath.section == self.firstMessageStatusIndexPath.section &&
              indexPath.item >= self.firstMessageStatusIndexPath.item) ||
             indexPath.section > self.firstMessageStatusIndexPath.section));
}

@end
