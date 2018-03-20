//
//  LYRUIMessageListTypingIndicatorsController.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 15.09.2017.
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

#import "LYRUIMessageListTypingIndicatorsController.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import <LayerKit/LayerKit.h>
#import "LYRUIListSection.h"
#import "LYRUIListDataSource.h"
#import "LYRUIBubbleTypingIndicatorCollectionViewCell.h"
#import "LYRUIBubbleTypingIndicatorView.h"
#import "LYRUIDotsBubbleView.h"
#import "LYRUITypingIndicator.h"

@interface LYRUIMessageListTypingIndicatorsController ()

@property (nonatomic, strong) NSNotificationCenter *notificationCenter;
@property (nonatomic, strong) NSMutableSet<LYRIdentity *> *typingParticipants;
@property (nonatomic, strong) LYRConversation *conversation;
@property (nonatomic, strong) LYRUITypingIndicator *typingIndicator;

@end

@implementation LYRUIMessageListTypingIndicatorsController
@synthesize collectionView = _collectionView,
            layerConfiguration = _layerConfiguration;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.typingParticipants = [[NSMutableSet alloc] init];
        self.typingIndicator = [[LYRUITypingIndicator alloc] init];
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
    self.notificationCenter = [layerConfiguration.injector objectOfType:[NSNotificationCenter class]];
}

- (void)registerForNotificationsInConversation:(LYRConversation *)conversation {
    self.conversation = conversation;
    [self.notificationCenter addObserver:self
                                selector:@selector(didReceiveTypingIndicator:)
                                    name:LYRConversationDidReceiveTypingIndicatorNotification
                                  object:nil];
}

- (void)removeNotificationsObserver {
    self.conversation = nil;
    [self.notificationCenter removeObserver:self];
}

#pragma mark - Notification handler

- (void)didReceiveTypingIndicator:(NSNotification *)notification {
    if (!notification.object || ![notification.object isEqual:self.conversation]) {
        return;
    }
    
    LYRTypingIndicator *typingIndicator = notification.userInfo[LYRTypingIndicatorObjectUserInfoKey];
    if (typingIndicator.action == LYRTypingIndicatorActionBegin) {
        [self.typingParticipants addObject:typingIndicator.sender];
        self.typingIndicator.typingParticipants = self.typingParticipants;
        if (self.typingParticipants.count == 1) {
            [self addTypingIndicators];
        } else {
            [self updateTypingIndicators];
        }
    } else {
        [self.typingParticipants removeObject:typingIndicator.sender];
        self.typingIndicator.typingParticipants = self.typingParticipants;
        if (self.typingParticipants.count == 0) {
            [self removeTypingIndicators];
        } else {
            [self updateTypingIndicators];
        }
    }
}

- (void)addTypingIndicators {
    CGPoint oldOffset = self.collectionView.contentOffset;
    BOOL shouldScrollToBottom = [self shouldScrollToBottom];
    
    if ([self dataSourceContainsTypingIndicator:YES]) {
        return;
    }
    NSIndexPath *indexPath = [self newItemIndexPath];
    LYRUIListSection *section = [self typingIndicatorSection];
    [self.collectionView performBatchUpdates:^{
        [section.items addObject:self.typingIndicator];
        [self.collectionView.collectionViewLayout invalidateLayout];
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        self.collectionView.contentOffset = oldOffset;
        LYRUIBubbleTypingIndicatorCollectionViewCell *typingIndicatorCell =
            (LYRUIBubbleTypingIndicatorCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        typingIndicatorCell.typingIndicatorView.bubbleView.animating = YES;
        if (typingIndicatorCell && shouldScrollToBottom) {
            [self scrollToBottom];
        }
    }];
}

- (void)removeTypingIndicators {
    CGPoint oldOffset = self.collectionView.contentOffset;
    BOOL shouldMaintainOffset = [self shouldMaintainOffset];
    BOOL shouldScrollToBottom = [self shouldScrollToBottom];
    
    if ([self dataSourceContainsTypingIndicator:NO]) {
        return;
    }
    NSIndexPath *indexPath = [self lastItemIndexPath];
    LYRUIListSection *section = [self typingIndicatorSection];
    [self.collectionView performBatchUpdates:^{
        [section.items removeObject:self.typingIndicator];
        [self.collectionView.collectionViewLayout invalidateLayout];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        if (shouldMaintainOffset) {
            self.collectionView.contentOffset = oldOffset;
        }
        if (shouldScrollToBottom) {
            [self scrollToBottom];
        }
    }];
}

- (BOOL)shouldMaintainOffset {
    CGFloat contentHeight = [self.collectionView.collectionViewLayout collectionViewContentSize].height;
    CGFloat collectionViewHeight = self.collectionView.bounds.size.height;
    return (contentHeight < collectionViewHeight);
}

- (BOOL)shouldScrollToBottom {
    return [self.collectionView.indexPathsForVisibleItems containsObject:[self lastItemIndexPath]];
}

- (void)scrollToBottom {
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGSize contentSize = [self.collectionView.collectionViewLayout collectionViewContentSize];
    contentOffset.y = contentSize.height - self.collectionView.bounds.size.height;
    [self.collectionView setContentOffset:contentOffset animated:YES];
}

- (LYRUIListSection *)typingIndicatorSection {
    LYRUIListDataSource *dataSource = (LYRUIListDataSource *)self.collectionView.dataSource;
    return dataSource.sections.firstObject;
}

- (BOOL)dataSourceContainsTypingIndicator:(BOOL)contains {
    LYRUIListSection *section = [self typingIndicatorSection];
    return ([section.items containsObject:self.typingIndicator] == contains);
}

- (NSIndexPath *)lastItemIndexPath {
    LYRUIListDataSource *dataSource = (LYRUIListDataSource *)self.collectionView.dataSource;
    return [dataSource lastItemIndexPath];
}

- (NSIndexPath *)newItemIndexPath {
    NSIndexPath *lastItemIndexPath = [self lastItemIndexPath];
    return [NSIndexPath indexPathForItem:lastItemIndexPath.item + 1 inSection:lastItemIndexPath.section];
}

- (void)updateTypingIndicators {
    LYRUIListDataSource *dataSource = (LYRUIListDataSource *)self.collectionView.dataSource;
    LYRUIListSection *section = dataSource.sections.firstObject;
    if (![section.items containsObject:self.typingIndicator]) {
        return;
    }
    NSUInteger itemIndex = [section.items indexOfObject:self.typingIndicator];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:0];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

@end
