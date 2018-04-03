//
//  LYRUIIdentityListView.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 27.07.2017.
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

#import "LYRUIIdentityListView.h"
#import "LYRUIIdentityListIBSetup.h"
#import "LYRUIIdentityListViewPresenter.h"

@interface LYRUIIdentityListView ()

@property (nonatomic, weak, readwrite) UICollectionView *collectionView;

@end

@implementation LYRUIIdentityListView
@dynamic layout;
@synthesize collectionView = _collectionView;

- (void)prepareForInterfaceBuilder {
    [LYRUIIdentityListIBSetup prepareIdentityListForInterfaceBuilder:self];
}

@end
