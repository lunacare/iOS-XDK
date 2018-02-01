//
//  LYRUIMessageListTimeSupplementaryViewPresenter.m
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

#import "LYRUIMessageListTimeSupplementaryViewPresenter.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIMessageListMessageTimeViewLayout.h"
#import "LYRUIMessageListMessageTimeView.h"
#import "LYRUITimeFormatting.h"
#import "LYRUIMessageListLayout.h"
#import "LYRUIMessageListView.h"
#import "LYRUIListDataSource.h"
#import "LYRUIListDelegate.h"
#import "LYRUIListSection.h"
#import <LayerKit/LayerKit.h>
#import "LYRUIMessageType.h"

static CGFloat const LYRUIMessageListTimeSupplementaryViewDefaultHeight = 37.0;

@interface LYRUIMessageListTimeSupplementaryViewPresenter ()

@property (nonatomic, strong) id<LYRUITimeFormatting> timeFormatter;
@property (nonatomic, strong) LYRUIMessageListMessageTimeViewLayout *messageTimeLayout;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, NSNumber *> *showTimeForIndexPath;

@end

@implementation LYRUIMessageListTimeSupplementaryViewPresenter
@synthesize listDataSource = _listDataSource,
            listDelegate = _listDelegate,
            layerConfiguration = _layerConfiguration;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.messageTimeHeight = LYRUIMessageListTimeSupplementaryViewDefaultHeight;
        self.showTimeForIndexPath = [[NSMutableDictionary alloc] init];
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
    self.timeFormatter = [layerConfiguration.injector protocolImplementation:@protocol(LYRUITimeFormatting)
                                                                    forClass:[self class]];
    self.messageTimeLayout = [layerConfiguration.injector layoutForViewClass:[LYRUIMessageListMessageTimeView class]];
}

- (NSString *)viewKind {
    return LYRUIMessageListMessageTimeViewKind;
}

- (NSString *)viewReuseIdentifier {
    return NSStringFromClass([LYRUIMessageListMessageTimeView class]);
}

#pragma mark - LYRUIListSupplementaryViewPresenting

- (void)setupSupplementaryView:(LYRUIMessageListMessageTimeView *)view forItemAtIndexPath:(NSIndexPath *)indexPath {
    LYRMessage *message = (LYRMessage *)[self.listDataSource itemAtIndexPath:indexPath];
    [self setupMessageTimeView:view withMessage:message];
}

- (void)setupMessageTimeView:(LYRUIMessageListMessageTimeView *)timeView
                 withMessage:(LYRMessage *)message {
    timeView.layout = self.messageTimeLayout;
    NSString *timestamp = [self.timeFormatter stringForTime:message.sentAt withCurrentTime:[NSDate date]];
    NSIndexPath *firstItemIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    if (!self.listDelegate.canLoadMoreItems &&
        [[self.listDataSource indexPathOfItem:message] isEqual:firstItemIndexPath]) {
        timeView.title = [NSString stringWithFormat:@"Conversation began %@", timestamp];
        return;
    }
    timeView.title = timestamp;
}

- (void)registerSupplementaryViewInCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:[LYRUIListHeaderView class]
       forSupplementaryViewOfKind:self.viewKind
              withReuseIdentifier:self.viewReuseIdentifier];
}

#pragma mark - LYRUIListSupplementaryViewSizeCalculating

- (CGSize)supplementaryViewSizeInCollectionView:(UICollectionView *)collectionView forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self shouldShowMessageTimeAtIndexPath:indexPath]) {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), self.messageTimeHeight);
    }
    return CGSizeZero;
}

- (BOOL)shouldShowMessageTimeAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showTimeForIndexPath[indexPath]) {
        return self.showTimeForIndexPath[indexPath].boolValue;
    }
    id<LYRUIListDataSource> dataSource = self.listDataSource;
    id item = [dataSource itemAtIndexPath:indexPath];
    if (![item isKindOfClass:[LYRUIMessageType class]]) {
        return NO;
    }
    LYRUIListSection *section = dataSource.sections[indexPath.section];
    LYRMessage *previousMessage;
    if (indexPath.item > 0) {
        previousMessage = section.items[indexPath.item - 1];
    }
    if (previousMessage == nil) {
        return YES;
    }
    LYRMessage *message = (LYRMessage *)item;
    BOOL shouldShowTime = [message.sentAt timeIntervalSinceDate:previousMessage.sentAt] > self.messageListView.messageGroupingTimeInterval;
    self.showTimeForIndexPath[indexPath] = @(shouldShowTime);
    return shouldShowTime;
}

- (void)invalidateAllSupplementaryViewSizes {
    [self.showTimeForIndexPath removeAllObjects];
}

@end
