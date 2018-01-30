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
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIMessageListViewPresenter.h"
#import "LYRUIMessageListIBSetup.h"
#import "LYRUIMessageListQueryControllerDelegate.h"
#import "LYRUIMessageListDelegate.h"
#import "LYRUIListDataSource.h"
#import "LYRUIListSection.h"
#import "LYRUIMessageListPaginationController.h"
#import <LayerKit/LayerKit.h>
#import "LYRUIMessageAction.h"
#import "LYRUIMessageSender.h"
#import "LYRUIActionHandling.h"

@interface LYRUIMessageListView () <LYRUIActionHandlingDelegate>

@property (nonatomic, strong) LYRUIMessageListQueryControllerDelegate *queryControllerDelegate;
@property (nonatomic, strong) LYRUIMessageListPaginationController *paginationController;
@property (nonatomic, strong, readwrite) LYRUIMessageSender *messageSender;
@property (nonatomic, weak) UIViewController *presentationViewController;

@end

@implementation LYRUIMessageListView
@synthesize queryController = _queryController;
@dynamic queryControllerDelegate, delegate;

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    [super setLayerConfiguration:layerConfiguration];
    self.messageSender = [layerConfiguration.injector objectOfType:[LYRUIMessageSender class]];
}

- (void)dealloc {
    [self.typingIndicatorsController removeNotificationsObserver];
}

- (void)prepareForInterfaceBuilder {
    [[[LYRUIMessageListIBSetup alloc] init] prepareMessageListForInterfaceBuilder:self];
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

- (void)registerViewControllerForPreviewing:(UIViewController *)viewController {
    self.presentationViewController = viewController;
}

- (void)setPageSize:(NSUInteger)pageSize {
    _pageSize = pageSize;
    self.paginationController.pageSize = -(NSInteger)pageSize;
    if (self.loadMoreItems) {
        self.loadMoreItems();
    }
}

- (void)setConversation:(LYRConversation *)conversation {
    LYRQuery *query = [LYRQuery queryWithQueryableClass:[LYRMessage class]];
    query.predicate = [LYRPredicate predicateWithProperty:@"conversation"
                                        predicateOperator:LYRPredicateOperatorIsEqualTo
                                                    value:conversation];
    query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES]];
    
    LYRClient *layerClient = self.layerConfiguration.client;
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
    _conversation = conversation;
}

- (void)setQueryController:(LYRQueryController *)queryController {
    id<LYRUIDependencyInjection> injector = self.layerConfiguration.injector;
    
    _queryController = queryController;
    self.queryControllerDelegate = [injector objectOfType:[LYRUIMessageListQueryControllerDelegate class]];
    self.queryControllerDelegate.listDataSource = self.dataSource;
    self.queryControllerDelegate.collectionView = self.collectionView;
    self.queryController.delegate = self.queryControllerDelegate;
    
    self.paginationController = [injector objectOfType:[LYRUIMessageListPaginationController class]];
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
    
    _conversation = self.paginationController.conversation;
    [self.typingIndicatorsController registerForNotificationsInConversation:self.conversation];
    
    self.messageSender.conversation = self.conversation;
    
    [self.queryControllerDelegate updateObjectsWithQueryController:queryController];
    [self.collectionView reloadData];
}

#pragma mark - LYRUIMessageListActionHandlingDelegate

- (void)handleAction:(LYRUIMessageAction *)action withHandler:(id<LYRUIActionHandling>)handler {
    if (self.messageActionHandlingDelegate) {
        [self.messageActionHandlingDelegate handleAction:action withHandler:handler];
        return;
    }
    
    if (handler == nil) {
        handler = [self.layerConfiguration.injector handlerOfMessageActionWithEvent:action.event
                                                                     forMessageType:nil];
    }
    [handler handleActionWithData:action.data delegate:self];
}

#pragma mark - LYRUIActionHandlingDelegate

- (void)actionHandler:(id<LYRUIActionHandling>)actionHandler sendMessage:(LYRUIMessageType *)messageType {
    [self.messageSender sendMessage:messageType];
}

- (void)actionHandler:(id<LYRUIActionHandling>)actionHandler presentViewController:(UIViewController *)viewController {
    [self.presentationViewController presentViewController:viewController animated:YES completion:nil];
}

@end
