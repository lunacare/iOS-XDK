//
//  LYRUIQueryPaginationController.h
//  Layer-XDK-UI-iOS
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

#import <LayerKit/LayerKit.h>
#import "LYRUIConfigurable.h"

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUIMessageListPaginationController : NSObject <LYRUIConfigurable>

/**
 @abstract A query controller used to load more messages.
 */
@property (nonatomic, weak) LYRQueryController *queryController;

/**
 @abstract A conversation used to determine total number of messages.
 */
@property (nonatomic, weak, readonly) LYRConversation *conversation;

/**
 @abstract Page size used by controller.
 @discussion When negative value is set, items are loaded from last to first. Default value is -30.
 */
@property (nonatomic) NSInteger pageSize;

/**
 @abstract A bool value indicating if more items are available for loading.
 */
@property (nonatomic, readonly) BOOL moreItemsAvailable;

/**
 @abstract A method for loading next page of items.
 */
- (void)loadNextPage;

/**
 @abstract A method for loading next page of items with a callback.
 @param callback A block called after loading next page of items.
 */
- (void)loadNextPageWithCallback:(void(^ _Nullable)(BOOL))callback;

/**
 @abstract A method for extracting `LYRConversation` from the `LYRPredicate`.
 @param predicate A predicate from query controller, used to retrieve the conversation.
 @return An instance of `LYRConversation`.
 */
- (LYRConversation *)conversationFromPredicate:(LYRPredicate *)predicate;

@end
NS_ASSUME_NONNULL_END       // }
