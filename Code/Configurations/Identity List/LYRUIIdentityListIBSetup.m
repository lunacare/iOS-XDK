//
//  LYRUIIdentityListIBSetup.m
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

#import "LYRUIIdentityListIBSetup.h"
#import "LYRUIIdentityListView.h"
#import "LYRUIListSection.h"
#import "LYRUIAvatarView.h"
#import "LYRUIIdentityCollectionViewCell.h"
#import "LYRUIIdentityItemViewConfiguration.h"
#import "LYRUIListDataSource.h"
#import "LYRUIListDelegate.h"
#import "LYRUIListCellConfiguration.h"
#import <LayerKit/LayerKit.h>

@implementation LYRUIIdentityListIBSetup

+ (void)prepareIdentityListForInterfaceBuilder:(LYRUIIdentityListView *)identityList {
    LYRUIListDelegate *delegate = (LYRUIListDelegate *)identityList.delegate;
    CGFloat width = CGRectGetWidth(identityList.bounds);
    CGFloat height = 60;
    if (width < 220) {
        height = 32;
    } else if (width < 320) {
        height = 48;
    }
        
    LYRUIListSection *section1 = [[LYRUIListSection<LYRIdentity *> alloc] init];
    section1.header = [[LYRUIListSectionHeader alloc] init];
    section1.header.title = @"MEMBERS";
    section1.items = [@[[LYRIdentity new], [LYRIdentity new], [LYRIdentity new]] mutableCopy];
    
    LYRUIListSection *section2 = [[LYRUIListSection<LYRIdentity *> alloc] init];
    section1.header = [[LYRUIListSectionHeader alloc] init];
    section1.header.title = @"NON-MEMBERS";
    section2.items = [@[[LYRIdentity new], [LYRIdentity new], [LYRIdentity new], [LYRIdentity new]] mutableCopy];
    
    LYRUIListDataSource *dataSource = (LYRUIListDataSource *)identityList.dataSource;
    dataSource.sections = [@[section1, section2] mutableCopy];
    
    LYRUIIdentityItemViewConfiguration *identityItemViewConfiguration = [[LYRUIIdentityItemViewConfiguration alloc] init];
    LYRUIListCellConfiguration *cellConfiguration =
        [[LYRUIListCellConfiguration alloc] initWithCellClass:[LYRUIIdentityCollectionViewCell class]
                                                   modelClass:[LYRIdentity class]
                                            viewConfiguration:identityItemViewConfiguration
                                                   cellHeight:height
                                               cellSetupBlock:^(LYRUIIdentityCollectionViewCell *cell, LYRIdentity *identity, LYRUIIdentityItemViewConfiguration *configuration) {
                                                   cell.identityView.titleLabel.text = @"Full name";
                                                   cell.identityView.detailLabel.text = @"23 mins ago";
                                                   LYRUIAvatarView *avatarView = [[LYRUIAvatarView alloc] init];
                                                   avatarView.translatesAutoresizingMaskIntoConstraints = NO;
                                                   avatarView.identities = @[identity];
                                                   avatarView.backgroundColor = [UIColor whiteColor];
                                                   cell.identityView.accessoryView = avatarView;
                                                   [cell.identityView setNeedsUpdateConstraints];
                                               } cellRegistrationBlock:nil];
    
    [delegate registerCellSizeCalculation:cellConfiguration];
    [dataSource registerCellConfiguration:cellConfiguration];
    
    [identityList.collectionView reloadData];
}

@end
