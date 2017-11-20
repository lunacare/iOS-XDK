//
//  LYRUIParticipantsSorting.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 09.08.2017.
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

#import "LYRUIParticipantsSorting.h"
#import "LYRUISortDescriptor.h"
#import <LayerKit/LayerKit.h>

LYRUIParticipantsSorting(^LYRUIParticipantsDefaultSorter)() = ^LYRUIParticipantsSorting() {
    NSSortDescriptor *avatarURLNonNilSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"avatarImageURL" ascending:NO comparator:^NSComparisonResult(NSURL * _Nonnull obj1, NSURL * _Nonnull obj2) {
        return NSOrderedSame;
    }];
    NSSortDescriptor *lastNameSortDecriptor = [LYRUISortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
    NSSortDescriptor *firstNameSortDecriptor = [LYRUISortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *displayNameSortDecriptor = [LYRUISortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    NSSortDescriptor *avatarURLSortDecriptor = [NSSortDescriptor sortDescriptorWithKey:@"avatarImageURL.absoluteString" ascending:YES];
    NSArray *sortDescriptors = @[
            avatarURLNonNilSortDescriptor,
            lastNameSortDecriptor,
            firstNameSortDecriptor,
            displayNameSortDecriptor,
            avatarURLSortDecriptor,
    ];
    return ^NSArray<LYRIdentity *> *(NSSet<LYRIdentity *> *participants) {
        NSArray *sortedParticipants = [participants sortedArrayUsingDescriptors:sortDescriptors];
        return sortedParticipants;
    };
};
