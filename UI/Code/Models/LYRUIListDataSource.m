//
//  LYRUIListDataSource.m
//  Layer-UI-iOS
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

#import "LYRUIListDataSource.h"
#import "LYRUIListSection.h"
#import "LYRUIListHeaderView.h"
#import "LYRUIListCellPresenting.h"
#import "LYRUIListSupplementaryViewPresenting.h"

@interface LYRUIListDataSource ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, id<LYRUIListCellPresenting>> *cellPresenters;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<LYRUIListSupplementaryViewPresenting>> *supplementaryViewPresenters;

@end

@implementation LYRUIListDataSource
@synthesize sections = _sections;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellPresenters = [[NSMutableDictionary alloc] init];
        self.supplementaryViewPresenters = [[NSMutableDictionary alloc] init];
        self.sections = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectionNumber {
    LYRUIListSection *section = self.sections[sectionNumber];
    return section.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LYRUIListSection *section = self.sections[indexPath.section];
    id modelItem = section.items[indexPath.item];
    
    NSString *itemType = NSStringFromClass([modelItem class]);
    id<LYRUIListCellPresenting> cellPresenter = self.cellPresenters[itemType];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellPresenter.cellReuseIdentifier
                                                                           forIndexPath:indexPath];
    [cellPresenter setupCell:cell forItemAtIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    id<LYRUIListSupplementaryViewPresenting> supplementaryViewPresenter = self.supplementaryViewPresenters[kind];
    NSString *reuseIdentifier = supplementaryViewPresenter.viewReuseIdentifier;
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:reuseIdentifier
                                                                               forIndexPath:indexPath];
    [supplementaryViewPresenter setupSupplementaryView:view forItemAtIndexPath:indexPath];
    return view;
}

#pragma mark - LYRUIListDataSource methods

- (NSArray *)selectedItemsInCollectionView:(UICollectionView *)collectionView {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in collectionView.indexPathsForSelectedItems) {
        LYRUIListSection *section = self.sections[indexPath.section];
        id item = section.items[indexPath.item];
        [items addObject:item];
    }
    return items;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Cannot retrieve Item with nil `indexPath` argument." userInfo:nil];
    }
    if (self.sections.count < (indexPath.section + 1)) {
        return nil;
    }
    LYRUIListSection *section = self.sections[indexPath.section];
    if (section.items.count < (indexPath.item + 1)) {
        return nil;
    }
    return section.items[indexPath.item];
}

- (NSIndexPath *)indexPathOfItem:(id)item {
    if (item == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Cannot retrieve Index Path with nil `item` argument." userInfo:nil];
    }
    for (LYRUIListSection *section in self.sections) {
        if (section.items == nil) {
            continue;
        }
        NSUInteger itemIndex = [section.items indexOfObject:item];
        if (itemIndex == NSNotFound) {
            continue;
        }
        NSUInteger sectionIndex = [self.sections indexOfObject:section];
        return [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
    }
    return nil;
}

- (NSIndexPath *)lastItemIndexPath {
    LYRUIListSection *section;
    for (LYRUIListSection *aSection in self.sections.reverseObjectEnumerator) {
        if (aSection.items.count == 0) {
            continue;
        }
        section = aSection;
        break;
    }
    if (section == nil) {
        return nil;
    }
    NSUInteger sectionIndex = [self.sections indexOfObject:section];
    NSUInteger itemIndex = section.items.count - 1;
    return [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
}

#pragma mark - LYRUIListCellPresenting registration

- (void)registerCellPresenter:(id<LYRUIListCellPresenting>)cellPresenter {
    for (Class itemType in cellPresenter.handledItemTypes) {
        NSString *key = NSStringFromClass(itemType);
        if (key.length == 0) {
            continue;
        }
        self.cellPresenters[key] = cellPresenter;
        cellPresenter.listDataSource = self;
    }
}

#pragma mark - LYRUIListSupplementaryViewPresenting registration

- (void)registerSupplementaryViewPresenter:(id<LYRUIListSupplementaryViewPresenting>)supplementaryViewPresenter {
    NSString *key = supplementaryViewPresenter.viewKind;
    self.supplementaryViewPresenters[key] = supplementaryViewPresenter;
    supplementaryViewPresenter.listDataSource = self;
}

@end
