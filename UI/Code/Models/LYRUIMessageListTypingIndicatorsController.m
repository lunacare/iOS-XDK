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
    self = [super init];
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
    NSUInteger lastMessageIndex = [self.collectionView numberOfItemsInSection:0] - 1;
    NSIndexPath *lastMessageIndexPath = [NSIndexPath indexPathForItem:lastMessageIndex inSection:0];
    BOOL shouldScrollToBottom = [self.collectionView.indexPathsForVisibleItems containsObject:lastMessageIndexPath];
    
    LYRUIListDataSource *dataSource = (LYRUIListDataSource *)self.collectionView.dataSource;
    LYRUIListSection *section = dataSource.sections.firstObject;
    if ([section.items containsObject:self.typingIndicator]) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(lastMessageIndex + 1) inSection:0];
    [self.collectionView performBatchUpdates:^{
        [section.items addObject:self.typingIndicator];
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        LYRUIBubbleTypingIndicatorCollectionViewCell *typingIndicatorCell =
            (LYRUIBubbleTypingIndicatorCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        typingIndicatorCell.typingIndicatorView.bubbleView.animating = YES;
        if (typingIndicatorCell && shouldScrollToBottom) {
            [self.collectionView scrollToItemAtIndexPath:indexPath
                                        atScrollPosition:UICollectionViewScrollPositionTop
                                                animated:YES];
        }
    }];
}

- (void)removeTypingIndicators {
    LYRUIListDataSource *dataSource = (LYRUIListDataSource *)self.collectionView.dataSource;
    LYRUIListSection *section = dataSource.sections.firstObject;
    if (![section.items containsObject:self.typingIndicator]) {
        return;
    }
    NSUInteger itemIndex = [section.items indexOfObject:self.typingIndicator];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:0];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView performBatchUpdates:^{
        [section.items removeObject:self.typingIndicator];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:nil];
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
