//
//  LYRUIMessageListView.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 18.08.2017.
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

#import "LYRUIMessageListView.h"
#import "LYRUIMessageListViewConfiguration.h"
#import "LYRUIMessageListIBSetup.h"
#import "LYRUIMessageListQueryControllerDelegate.h"
#import "LYRUIMessageListDelegate.h"
#import "LYRUIListSection.h"
#import "LYRUIMessageListPaginationController.h"
#import <LayerKit/LayerKit.h>

@interface LYRUIMessageListView ()

@property (nonatomic, weak, readwrite) LYRConversation *conversation;

@property (nonatomic, strong) LYRUIMessageListViewConfiguration *configuration;
@property (nonatomic, strong) LYRUIMessageListQueryControllerDelegate *queryControllerDelegate;
@property (nonatomic, strong) LYRUIMessageListPaginationController *paginationController;

@end

@implementation LYRUIMessageListView
@synthesize queryController = _queryController;
@dynamic queryControllerDelegate, delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.configuration = [[LYRUIMessageListViewConfiguration alloc] init];
        [self.configuration setupMessageListView:self];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.configuration = [[LYRUIMessageListViewConfiguration alloc] init];
        [self.configuration setupMessageListView:self];
    }
    return self;
}

- (void)prepareForInterfaceBuilder {
    [[[LYRUIMessageListIBSetup alloc] init] prepareMessageListForInterfaceBuilder:self];
}

- (void)setCurrentUser:(LYRIdentity *)currentUser {
    _currentUser = currentUser;
    
    if (![self.dataSource isKindOfClass:[LYRUIListDataSource class]]) {
        return;
    }
    LYRUIListDataSource *dataSource = (LYRUIListDataSource *)self.dataSource;
    
    for (id configuration in dataSource.allConfigurations) {
        if ([configuration respondsToSelector:@selector(setCurrentUser:)]) {
            [configuration setCurrentUser:currentUser];
        }
    }
}

- (void)setPageSize:(NSUInteger)pageSize {
    _pageSize = pageSize;
    self.paginationController.pageSize = -(NSInteger)pageSize;
    if (self.loadMoreItems) {
        self.loadMoreItems();
    }
}

- (void)setupWithConversation:(LYRConversation *)conversation client:(LYRClient *)layerClient {
    LYRQuery *query = [LYRQuery queryWithQueryableClass:[LYRMessage class]];
    query.predicate = [LYRPredicate predicateWithProperty:@"conversation"
                                        predicateOperator:LYRPredicateOperatorIsEqualTo
                                                    value:conversation];
    query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES]];
    
    NSUInteger numberOfMessagesAvailable = MAX(1, [layerClient countForQuery:query error:nil]);
    NSUInteger numberOfMessagesToDisplay = MIN(numberOfMessagesAvailable, self.pageSize);
    
    NSError *error = nil;
    LYRQueryController *queryController = [layerClient queryControllerWithQuery:query error:&error];
    if (!queryController) {
        return;
    }
    queryController.paginationWindow = -numberOfMessagesToDisplay;
    
    BOOL success = [queryController execute:&error];
    if (!success) {
        return;
    }
    
    self.queryController = queryController;
    self.conversation = conversation;
}

- (void)setQueryController:(LYRQueryController *)queryController {
    _queryController = queryController;
    self.queryControllerDelegate = [[LYRUIMessageListQueryControllerDelegate alloc] init];
    self.queryControllerDelegate.listDataSource = self.dataSource;
    self.queryControllerDelegate.collectionView = self.collectionView;
    self.queryController.delegate = self.queryControllerDelegate;
    
    self.paginationController = [[LYRUIMessageListPaginationController alloc] init];
    self.paginationController.pageSize = -(NSInteger)self.pageSize;
    self.paginationController.queryController = queryController;
    self.delegate.canLoadMoreItems = self.paginationController.moreItemsAvailable;
    __weak __typeof(self) weakSelf = self;
    self.loadMoreItems = ^{
        [weakSelf.paginationController loadNextPageWithCallback:^(BOOL moreItemsAvailable) {
            weakSelf.delegate.canLoadMoreItems = moreItemsAvailable;
        }];
    };
    if (queryController.paginationWindow > self.paginationController.pageSize) {
        self.loadMoreItems();
    }
    
    self.conversation = self.paginationController.conversation;
    
    LYRUIListSection *section = [[LYRUIListSection alloc] init];
    section.items = [queryController.paginatedObjects.array mutableCopy];
    self.items = [@[section] mutableCopy];
    
    [self.collectionView reloadData];
}

#pragma mark - Public methods

- (void)scrollToLastMessageAnimated:(BOOL)animated {
    LYRUIListSection *section = self.dataSource.sections.lastObject;
    if (section.items.count > 0) {
        [self.collectionView scrollToItemAtIndexPath:self.dataSource.lastItemIndexPath
                                    atScrollPosition:UICollectionViewScrollPositionTop
                                            animated:animated];
    }
}

@end
