//
//  LYRUIMessageCellConfiguration.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 28.08.2017.
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

#import "LYRUIMessageCellConfiguration.h"
#import "LYRUIMessageItemViewConfiguration.h"
#import "LYRUIMessageItemAccessoryViewProviding.h"
#import "LYRUIParticipantsFiltering.h"
#import "LYRUIMessageCollectionViewCell.h"
#import "LYRUIMessageItemView.h"
#import "LYRUIListDataSource.h"
#import "LYRUIListSection.h"
#import <LayerKit/LayerKit.h>

static CGFloat const LYRUIMessageCellConfigurationSmallWidth = 460.0;
static CGFloat const LYRUIMessageCellConfigurationWideWidth = 600.0;

static CGFloat const LYRUIMessageCellConfigurationSmallMaxWidthRatio = 0.6;
static CGFloat const LYRUIMessageCellConfigurationMediumMaxWidthRatio = 0.75;

static CGFloat const LYRUIMessageCellConfigurationViewsWithMarginsWidth = 64.0;

@interface LYRUIMessageCellConfiguration ()

@property (nonatomic, strong) LYRUIMessageItemViewConfiguration *messageItemConfiguration;

@end

@implementation LYRUIMessageCellConfiguration
@synthesize listDataSource = _listDataSource,
            participantsFilter = _participantsFilter;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.messageItemConfiguration = [[LYRUIMessageItemViewConfiguration alloc] init];
    }
    return self;
}

#pragma mark - LYRUICurerntUserFiltering

- (void)setParticipantsFilter:(LYRUIParticipantsFiltering)participantsFilter {
    _participantsFilter = participantsFilter;
    self.messageItemConfiguration.primaryAccessoryViewProvider.participantsFilter = participantsFilter;
}

#pragma mark - LYRUIListCellSizeCalculating

- (NSSet<Class> *)handledItemTypes {
    return [NSSet setWithObject:[LYRMessage class]];
}

- (CGSize)cellSizeInCollectionView:(UICollectionView *)collectionView forItemAtIndexPath:(NSIndexPath *)indexPath {
    LYRMessage *message = (LYRMessage *)[self.listDataSource itemAtIndexPath:indexPath];
    CGFloat width = CGRectGetWidth(collectionView.bounds);
    CGFloat height = [self cellHeightForMessage:message width:width];
    return CGSizeMake(width, height);
}

#pragma mark - LYRUIListCellConfiguring

- (NSString *)cellReuseIdentifier {
    return @"LYRUIMessageItemView";
}

- (void)registerCellInCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:[LYRUIMessageCollectionViewCell class] forCellWithReuseIdentifier:self.cellReuseIdentifier];
}

- (void)setupCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    LYRUIMessageItemView *messageItemView = ((LYRUIMessageCollectionViewCell *)cell).messageView;
    LYRMessage *message = (LYRMessage *)[self.listDataSource itemAtIndexPath:indexPath];
    [self setupMessageItemView:messageItemView withMessage:message];
}

- (void)setupMessageItemView:(LYRUIMessageItemView *)messageItemView withMessage:(LYRMessage *)message {
    [self setupAccessoryViewVisibility:messageItemView.primaryAccessoryViewContainer
                          forMessage:message];
    
    [self.messageItemConfiguration setupMessageItemView:messageItemView withMessage:message];
    
    [self setupMessageViewLayout:messageItemView
                      forMessage:message];
}

- (void)setupMessageViewLayout:(LYRUIMessageItemView *)messageView
                    forMessage:(LYRMessage *)message {
    BOOL outgoingMessage = [message.sender.userID isEqualToString:self.currentUser.userID];
    LYRUIMessageItemViewLayoutDirection layoutDirection =
        outgoingMessage ? LYRUIMessageItemViewLayoutDirectionRight : LYRUIMessageItemViewLayoutDirectionLeft;
    messageView.layout.layoutDirection = layoutDirection;
}

- (void)setupAccessoryViewVisibility:(UIView *)accessoryView
                          forMessage:(LYRMessage *)message {
    NSIndexPath *indexPath = [self.listDataSource indexPathOfItem:message];
    accessoryView.hidden = NO;
    LYRUIListSection *section = self.listDataSource.sections[indexPath.section];
    if (indexPath.item < (section.items.count - 1)) {
        LYRMessage *message = section.items[indexPath.item];
        LYRMessage *nextMessage = section.items[indexPath.item + 1];
        accessoryView.hidden = [message.sender.userID isEqualToString:nextMessage.sender.userID];
    }
}

#pragma mark - LYRUIMessageListCellHeightCalculator

- (CGFloat)cellHeightForMessage:(LYRMessage *)messageType width:(CGFloat)width {
    CGFloat maxContentViewWidth = [self maxContentViewWidthForCellWidth:width];
    return [self.messageItemConfiguration messageViewHeightForMessage:messageType
                                                             maxWidth:maxContentViewWidth];
}

- (CGFloat)maxContentViewWidthForCellWidth:(CGFloat)cellWidth {
    CGFloat maxContentViewWidth = cellWidth - LYRUIMessageCellConfigurationViewsWithMarginsWidth;
    if (cellWidth > LYRUIMessageCellConfigurationWideWidth) {
        maxContentViewWidth = (LYRUIMessageCellConfigurationSmallMaxWidthRatio * cellWidth);
    } else if (cellWidth > LYRUIMessageCellConfigurationSmallWidth) {
        maxContentViewWidth = (LYRUIMessageCellConfigurationMediumMaxWidthRatio * cellWidth);
    }
    return maxContentViewWidth;
}

@end
