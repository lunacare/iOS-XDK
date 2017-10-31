//
//  LYRUIConversationListIBSetup.m
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

#import "LYRUIConversationListIBSetup.h"
#import "LYRUIConversationListView.h"
#import "LYRUIListSection.h"
#import "LYRUIAvatarView.h"
#import "LYRUIConversationCollectionViewCell.h"
#import "LYRUIConversationItemViewConfiguration.h"
#import "LYRUIListDataSource.h"
#import "LYRUIListDelegate.h"
#import "LYRUIListCellConfiguration.h"
#import <LayerKit/LayerKit.h>

@implementation LYRUIConversationListIBSetup

- (void)prepareConversationListForInterfaceBuilder:(LYRUIConversationListView *)conversationList {
    [conversationList.collectionView registerClass:[LYRUIConversationCollectionViewCell class]
                    forCellWithReuseIdentifier:NSStringFromClass([NSObject class])];
    
    LYRUIListDelegate *delegate = (LYRUIListDelegate *)conversationList.delegate;
    CGFloat width = CGRectGetWidth(conversationList.bounds);
    CGFloat height = 72;
    if (width < 220) {
        height = 32;
    } else if (width < 270) {
        height = 48;
    } else if (width < 320) {
        height = 60;
    }
    
    LYRUIListSection *section1 = [[LYRUIListSection<LYRConversation *> alloc] init];
    [section1 addHeaderWithTitle:@"GENERAL"];
    section1.items = [@[[NSObject new], [NSObject new], [NSObject new]] mutableCopy];
    
    LYRUIListSection *section2 = [[LYRUIListSection<LYRConversation *> alloc] init];
    [section2 addHeaderWithTitle:@"DIRECT MESSAGES"];
    section2.items = [@[[NSObject new], [NSObject new], [NSObject new], [NSObject new]] mutableCopy];
    
    LYRUIListDataSource *dataSource = (LYRUIListDataSource *)conversationList.dataSource;
    dataSource.sections = [@[section1, section2] mutableCopy];
    
    LYRUIConversationItemViewConfiguration *conversationItemViewConfiguration = [[LYRUIConversationItemViewConfiguration alloc] init];
    LYRUIListCellConfiguration *cellConfiguration =
        [[LYRUIListCellConfiguration alloc] initWithCellClass:[LYRUIConversationCollectionViewCell class]
                                                   modelClass:[NSObject class]
                                            viewConfiguration:conversationItemViewConfiguration
                                                   cellHeight:height
                                               cellSetupBlock:^(LYRUIConversationCollectionViewCell *cell, LYRConversation *conversation, LYRUIConversationItemViewConfiguration *configuration) {
                                                   cell.conversationView.titleLabel.text = @"Name(s) / Title";
                                                   cell.conversationView.timeLabel.text = @"8:30am";
                                                   cell.conversationView.messageLabel.text = @"Message";
                                                   
                                                   LYRUIAvatarView *avatarView = [[LYRUIAvatarView alloc] init];
                                                   avatarView.translatesAutoresizingMaskIntoConstraints = NO;
                                                   NSMutableArray *identities = [NSMutableArray new];
                                                   NSUInteger identitiesCount;
                                                   if ([section2.items containsObject:conversation]) {
                                                       identitiesCount = 1;
                                                   } else {
                                                       identitiesCount = [section1.items indexOfObject:conversation] + 2;
                                                   }
                                                   for (NSUInteger i = 0; i < identitiesCount; i += 1) {
                                                       [identities addObject:[LYRIdentity new]];
                                                   }
                                                   avatarView.identities = identities;
                                                   avatarView.backgroundColor = [UIColor whiteColor];
                                                   cell.conversationView.accessoryView = avatarView;
                                                   
                                                   [cell.conversationView setNeedsUpdateConstraints];
                                               } cellRegistrationBlock:nil];
    
    [delegate registerCellSizeCalculation:cellConfiguration];
    [dataSource registerCellConfiguration:cellConfiguration];
    
    [conversationList.collectionView reloadData];
}

@end
