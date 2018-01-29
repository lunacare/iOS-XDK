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
#import "LYRUIListCellConfiguring.h"
#import "LYRUIListSupplementaryViewConfiguring.h"

@interface LYRUIListDataSource ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, id<LYRUIListCellConfiguring>> *cellConfigurations;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<LYRUIListSupplementaryViewConfiguring>> *supplementaryViewConfigurations;

@end

@implementation LYRUIListDataSource
@synthesize sections = _sections;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellConfigurations = [[NSMutableDictionary alloc] init];
        self.supplementaryViewConfigurations = [[NSMutableDictionary alloc] init];
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
    id<LYRUIListCellConfiguring> cellConfiguration = self.cellConfigurations[itemType];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellConfiguration.cellReuseIdentifier
                                                                           forIndexPath:indexPath];
    [cellConfiguration setupCell:cell forItemAtIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    id<LYRUIListSupplementaryViewConfiguring> supplementaryViewConfiguration = self.supplementaryViewConfigurations[kind];
    NSString *reuseIdentifier = supplementaryViewConfiguration.viewReuseIdentifier;
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:reuseIdentifier
                                                                               forIndexPath:indexPath];
    [supplementaryViewConfiguration setupSupplementaryView:view forItemAtIndexPath:indexPath];
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
    LYRUIListSection *section = self.sections[indexPath.section];
    return section.items[indexPath.item];
}

- (NSIndexPath *)indexPathOfItem:(id)item {
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
    LYRUIListSection *section = self.sections.lastObject;
    NSUInteger sectionIndex = self.sections.count - 1;
    NSUInteger itemIndex = section.items.count - 1;
    return [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
}

#pragma mark - LYRUIListCellConfiguring registration

- (void)registerCellConfiguration:(id<LYRUIListCellConfiguring>)cellConfiguration {
    for (Class itemType in cellConfiguration.handledItemTypes) {
        NSString *key = NSStringFromClass(itemType);
        if (key.length == 0) {
            continue;
        }
        self.cellConfigurations[key] = cellConfiguration;
        cellConfiguration.listDataSource = self;
    }
}

#pragma mark - LYRUIListSupplementaryViewConfiguring registration

- (void)registerSupplementaryViewConfiguration:(id<LYRUIListSupplementaryViewConfiguring>)supplementaryViewConfiguration {
    NSString *key = supplementaryViewConfiguration.viewKind;
    self.supplementaryViewConfigurations[key] = supplementaryViewConfiguration;
    supplementaryViewConfiguration.listDataSource = self;
}

@end
