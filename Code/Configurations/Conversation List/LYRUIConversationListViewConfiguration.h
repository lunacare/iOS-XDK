//
//  LYRUIConversationListViewConfiguration.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 31.07.2017.
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

#import "LYRUIConversationListView.h"
@class LYRUIListSection<ModelType>;
@class LYRConversation;

/**
 @abstract The `LYRUIConversationListViewConfiguration` objects will be used for configuring a `LYRUIConversationListView` with proper layout, data source, and delegate for presenting list of `LYRConversation` items.
 */
@interface LYRUIConversationListViewConfiguration : NSObject

/**
 @abstract Configures provided `LYRUIConversationListView` for presenting `LYRConversation` items.
 @param conversationListView An `LYRUIConversationListView` instance to be configured. The `layout`, `dataSource`, and `delegate` properties of the list view will be set properly to present `LYRConversation` items.
 */
- (void)setupConversationListView:(LYRUIConversationListView *)conversationListView;

@end
