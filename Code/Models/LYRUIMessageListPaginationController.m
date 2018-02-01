//
//  LYRUIQueryPaginationController.m
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

#import "LYRUIMessageListPaginationController.h"
#import "LYRUIConfiguration+DependencyInjection.h"

static NSInteger const LYRUIMessageListPaginationControllerDefaultPageSize = -30;

@interface LYRUIMessageListPaginationController ()

@property (nonatomic, getter=isLoadingMore) BOOL loadingMore;
@property (nonatomic, readonly) NSUInteger itemsToLoad;
@property (nonatomic, readonly) NSUInteger itemsAvailableRemotely;
@property (nonatomic, readonly) NSUInteger itemsAvailableLocally;

@property (nonatomic, weak, readwrite) LYRConversation *conversation;

@property (nonatomic, strong) NSNotificationCenter *notificationCenter;

@property (nonatomic, weak) id observer;

@end

@implementation LYRUIMessageListPaginationController
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pageSize = LYRUIMessageListPaginationControllerDefaultPageSize;
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

- (void)dealloc {
    if (self.observer) {
        [self.notificationCenter removeObserver:self.observer];
    }
}

#pragma mark - Public methods

- (void)loadNextPage {
    [self loadNextPageWithCallback:nil];
}

- (void)loadNextPageWithCallback:(void(^)(BOOL))callback {
    if (self.isLoadingMore) {
        return;
    }
    
    self.loadingMore = YES;
    if (!self.queryController || !self.moreItemsAvailable) {
        self.loadingMore = NO;
        return;
    }
    
    if (self.itemsAvailableLocally < self.itemsToLoad &&
        self.itemsAvailableRemotely > self.itemsAvailableLocally) {
        [self synchronizeNextPageWithCallback:callback];
    } else {
        [self expandPaginationWindowWithCallback:callback];
    }
}

- (void)synchronizeNextPageWithCallback:(void(^)(BOOL))callback {
    __weak typeof(self) weakSelf = self;
    self.observer = [self.notificationCenter addObserverForName:LYRConversationDidFinishSynchronizingNotification
                                                         object:self.conversation
                                                          queue:nil
                                                     usingBlock:^(NSNotification * _Nonnull note) {
        if (weakSelf.observer) {
            [weakSelf.notificationCenter removeObserver:weakSelf.observer];
        }
        [weakSelf expandPaginationWindowWithCallback:callback];
    }];
    
    NSError *error = nil;
    NSUInteger messagesToSynchronize = self.itemsToLoad - self.itemsAvailableLocally;
    BOOL success = [self.conversation synchronizeMoreMessages:messagesToSynchronize error:&error];
    if (!success) {
        if (weakSelf.observer) {
            [self.notificationCenter removeObserver:weakSelf.observer];
        }
        self.loadingMore = NO;
    }
}

- (void)expandPaginationWindowWithCallback:(void(^)(BOOL))callback {
    self.loadingMore = NO;
    NSUInteger paginationWindow = MIN(ABS(self.queryController.paginationWindow) + self.itemsToLoad,
                                      self.queryController.totalNumberOfObjects);
    self.queryController.paginationWindow = -(NSInteger)paginationWindow;
    if (callback) {
        callback(self.conversation.totalNumberOfMessages > paginationWindow);
    }
}

#pragma mark - Properties

- (BOOL)moreItemsAvailable {
    return self.itemsAvailableLocally != 0 || self.itemsAvailableRemotely != 0;
}

- (NSUInteger)itemsToLoad {
    NSUInteger pageToLoad = (self.queryController.count / ABS(self.pageSize)) + 1;
    NSUInteger totalItems = MIN((pageToLoad * ABS(self.pageSize)), self.conversation.totalNumberOfMessages);
    NSUInteger itemsToLoad = totalItems - self.queryController.count;
    return itemsToLoad;
}

- (NSUInteger)itemsAvailableLocally {
    return self.queryController.totalNumberOfObjects - ABS(self.queryController.count);
}

- (NSUInteger)itemsAvailableRemotely {
    return (NSUInteger)MAX((NSInteger)0, (NSInteger)self.conversation.totalNumberOfMessages - (NSInteger)ABS(self.queryController.count));
}

- (void)setQueryController:(LYRQueryController *)queryController {
    _queryController = queryController;
    self.conversation = [self conversationFromPredicate:queryController.query.predicate];
}

- (LYRConversation *)conversationFromPredicate:(LYRPredicate *)predicate {
    LYRConversation *conversation;
    if ([predicate isKindOfClass:[LYRCompoundPredicate class]]) {
        for (LYRPredicate *subPredicate in [(LYRCompoundPredicate *)predicate subpredicates]) {
            conversation = [self conversationFromPredicate:subPredicate];
            if (conversation) {
                return conversation;
            }
        }
    } else {
        if ([predicate.property isEqualToString:@"conversation"]) {
            conversation = predicate.value;
        }
    }
    return conversation;
}

@end
