//
//  LYRUIMessageListStatusSupplementaryViewPresenter.m
//  Layer-XDK-UI-iOS
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

#import "LYRUIMessageListStatusSupplementaryViewPresenter.h"
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
#import "LYRUIMessageType.h"

static CGFloat const LYRUIMessageListStatusSupplementaryViewDefaultHeight = 17.0;

@interface LYRUIMessageListStatusSupplementaryViewPresenter ()

@property (nonatomic, strong) LYRUIMessageListMessageStatusViewLayout *messageStatusLayout;

@property (nonatomic, strong) NSIndexPath *firstMessageStatusIndexPath;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, NSNumber *> *showStatusForIndexPath;

@end

@implementation LYRUIMessageListStatusSupplementaryViewPresenter
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
}

- (NSString *)viewKind {
    return LYRUIMessageListMessageStatusViewKind;
}

- (NSString *)viewReuseIdentifier {
    return NSStringFromClass([LYRUIMessageListMessageStatusView class]);
}

#pragma mark - LYRUIListSupplementaryViewPresenting

- (void)setupSupplementaryView:(LYRUIListHeaderView *)view forItemAtIndexPath:(NSIndexPath *)indexPath {
    id item = (LYRMessage *)[self.listDataSource itemAtIndexPath:indexPath];
    if (![item isKindOfClass:[LYRUIMessageType class]]) {
        return;
    }
    LYRUIMessageType *message = (LYRUIMessageType *)item;
    [self setupMessageStatusView:view withMessage:message];
}

- (void)setupMessageStatusView:(LYRUIListHeaderView *)statusView
                   withMessage:(LYRUIMessageType *)message {
    statusView.layout = self.messageStatusLayout;
    statusView.title = message.status.statusDescription;
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
    LYRUIMessageType *message = [self messageAtIndexPath:indexPath];
    if (message == nil) {
        return NO;
    }
    LYRUIMessageType *nextMessage = [self nextMessageForIndexPath:indexPath];
    BOOL shouldShowStatus = ([self isOutgoingMessage:message] &&
                             [self indexPathIsAfterFirstMessageStatusIndexPath:indexPath] &&
                             [self message:message statusIsDifferentThanNextMessageStatus:nextMessage]);
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
        if (![item isKindOfClass:[LYRUIMessageType class]]) {
            continue;
        }
        LYRUIMessageType *message = (LYRUIMessageType *)item;
        if (![self isOutgoingMessage:message]) {
            continue;
        }
        NSUInteger itemIndex = [section.items indexOfObject:message];
        NSUInteger sectionIndex = [dataSource.sections indexOfObject:section];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex
                                                     inSection:sectionIndex];
        
        BOOL messageRead = (message.status.status == LYRRecipientStatusRead);
        
        LYRUIMessageType *previousMessage;
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

- (LYRUIMessageType *)messageAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self.listDataSource itemAtIndexPath:indexPath];
    if (![item isKindOfClass:[LYRUIMessageType class]]) {
        return nil;
    }
    return (LYRUIMessageType *)item;
}

- (LYRUIMessageType *)nextMessageForIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *nextMessageIndexPath = [NSIndexPath indexPathForItem:(indexPath.item + 1) inSection:indexPath.section];
    return [self messageAtIndexPath:nextMessageIndexPath];
}

- (BOOL)isOutgoingMessage:(LYRUIMessageType *)message {
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

- (BOOL)message:(LYRUIMessageType *)message statusIsDifferentThanNextMessageStatus:(LYRUIMessageType *)nextMessage {
    if (nextMessage == nil) {
        return YES;
    }
    return message.status.status != nextMessage.status.status;
}

@end
