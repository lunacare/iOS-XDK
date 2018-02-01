//
//  LYRUIMessageListLayout.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 24.08.2017.
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

#import "LYRUIMessageListLayout.h"
#import "LYRUIListDataSource.h"
#import "LYRUIListSection.h"

NSString *const LYRUIMessageListMessageTimeViewKind = @"LYRUIMessageTime";
NSString *const LYRUIMessageListMessageStatusViewKind = @"LYRUIMessageStatus";

@interface LYRUIMessageListLayout ()

@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, NSNumber *> *offsetForIndexPath;
@property (nonatomic) CGFloat contentSizeAdditionalHeight;

@end

@implementation LYRUIMessageListLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sectionFootersPinToVisibleBounds = YES;
        self.minimumLineSpacing = 4.0;
    }
    return self;
}

#pragma mark - Supplementary views sizes

- (CGSize)timeSupplementaryViewSizeAtIndexPath:(NSIndexPath *)indexPath {
    CGSize timeViewSize = [self.delegate collectionView:self.collectionView
                                                 layout:self
                                       sizeOfViewOfKind:LYRUIMessageListMessageTimeViewKind
                                            atIndexPath:indexPath];
    return timeViewSize;
}

- (CGSize)statusSupplementaryViewSizeAtIndexPath:(NSIndexPath *)indexPath {
    CGSize statusViewSize = [self.delegate collectionView:self.collectionView
                                                   layout:self
                                         sizeOfViewOfKind:LYRUIMessageListMessageStatusViewKind
                                              atIndexPath:indexPath];
    return statusViewSize;
}

#pragma mark - Layout invalidation

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds {
    UICollectionViewFlowLayoutInvalidationContext *context = (UICollectionViewFlowLayoutInvalidationContext *)[super invalidationContextForBoundsChange:newBounds];
    context.invalidateFlowLayoutDelegateMetrics = (CGRectGetWidth(newBounds) != CGRectGetWidth(self.collectionView.bounds));
    return context;
}

#pragma mark - Additional supplementary views

- (void)prepareLayout {
    [super prepareLayout];
    
    if (!self.delegate) {
        return;
    }
    
    self.offsetForIndexPath = [[NSMutableDictionary alloc] init];
    CGFloat offset = 0.0;
    for (LYRUIListSection *section in self.dataSource.sections) {
        NSUInteger sectionIndex = [self.dataSource.sections indexOfObject:section];
        for (NSUInteger itemIndex = 0; itemIndex < section.items.count; itemIndex += 1) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];

            CGSize timeViewSize = [self timeSupplementaryViewSizeAtIndexPath:indexPath];
            if (!CGSizeEqualToSize(timeViewSize, CGSizeZero)) {
                offset += timeViewSize.height;
            }
            
            self.offsetForIndexPath[indexPath] = @(offset);
            
            CGSize statusViewSize = [self statusSupplementaryViewSizeAtIndexPath:indexPath];
            if (!CGSizeEqualToSize(statusViewSize, CGSizeZero)) {
                offset += statusViewSize.height;
            }
        }
    }
    self.contentSizeAdditionalHeight = offset;
}

- (CGSize)collectionViewContentSize {
    CGSize contentSize = [super collectionViewContentSize];
    contentSize.height += self.contentSizeAdditionalHeight;
    return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frame = attributes.frame;
    CGFloat offset = self.offsetForIndexPath[indexPath].doubleValue;
    frame.origin.y += offset;
    attributes.frame = frame;
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    if (!self.delegate) {
        return [super layoutAttributesForElementsInRect:rect];
    }
    
    NSArray<UICollectionViewLayoutAttributes *> *rectAttributes = [super layoutAttributesForElementsInRect:rect];
    NSIndexPath *indexPath = rectAttributes.firstObject.indexPath ?: self.dataSource.lastItemIndexPath;
    CGFloat offset = self.offsetForIndexPath[indexPath].floatValue;
    CGRect expandedRect = rect;
    expandedRect.origin.y -= offset;
    expandedRect.size.height += offset;
    NSArray<UICollectionViewLayoutAttributes *> *expandedAttributes = [super layoutAttributesForElementsInRect:expandedRect];
                                                                   
    NSMutableArray<UICollectionViewLayoutAttributes *> *allAttributes = [expandedAttributes mutableCopy];
    
    NSMutableArray *additionalAttributes = [NSMutableArray new];
    
    for (UICollectionViewLayoutAttributes *attributes in expandedAttributes) {
        if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView &&
            attributes.representedElementKind == UICollectionElementKindSectionFooter) {
            [self fixFooterAttributes:attributes];
            continue;
        } else if (attributes.representedElementCategory != UICollectionElementCategoryCell) {
            continue;
        }
        CGFloat offset = self.offsetForIndexPath[attributes.indexPath].doubleValue;
        CGRect frame = attributes.frame;
        frame.origin.y += offset;
        attributes.frame = frame;
        if (!CGRectIntersectsRect(rect, frame)) {
            [allAttributes removeObject:attributes];
            continue;
        }
        
        CGSize timeViewSize = [self timeSupplementaryViewSizeAtIndexPath:attributes.indexPath];
        if (!CGSizeEqualToSize(timeViewSize, CGSizeZero)) {
            [additionalAttributes addObject:[self layoutAttributesForSupplementaryViewOfKind:LYRUIMessageListMessageTimeViewKind
                                                                                 atIndexPath:attributes.indexPath]];
        }
        
        CGSize statusViewSize = [self statusSupplementaryViewSizeAtIndexPath:attributes.indexPath];
        if (!CGSizeEqualToSize(statusViewSize, CGSizeZero)) {
            [additionalAttributes addObject:[self layoutAttributesForSupplementaryViewOfKind:LYRUIMessageListMessageStatusViewKind
                                                                                 atIndexPath:attributes.indexPath]];
        }
    }
    
    return [allAttributes arrayByAddingObjectsFromArray:additionalAttributes];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind
                                                                     atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionViewLayoutAttributes *footerAttributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
        [self fixFooterAttributes:footerAttributes];
        return footerAttributes;
    }
    CGSize size = [self sizeForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return nil;
    }
    return [self layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath withSize:size];
}

- (CGSize)sizeForSupplementaryViewOfKind:(NSString *)kind
                             atIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    if ([kind isEqualToString:LYRUIMessageListMessageTimeViewKind]) {
        size = [self timeSupplementaryViewSizeAtIndexPath:indexPath];
    } else if ([kind isEqualToString:LYRUIMessageListMessageStatusViewKind]) {
        size = [self statusSupplementaryViewSizeAtIndexPath:indexPath];
    }
    return size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind
                                                                     atIndexPath:(NSIndexPath *)indexPath
                                                                        withSize:(CGSize)size {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind
                                                                                                                  withIndexPath:indexPath];
    
    UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frame = cellAttributes.frame;
    if ([kind isEqualToString:LYRUIMessageListMessageTimeViewKind]) {
        frame.size = size;
        frame.origin.y -= size.height;
    } else if ([kind isEqualToString:LYRUIMessageListMessageStatusViewKind]) {
        frame.origin.y += frame.size.height;
        frame.size = size;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        frame.origin.y += self.contentSizeAdditionalHeight;
    }
    attributes.frame = frame;
    return attributes;
}

- (void)fixFooterAttributes:(UICollectionViewLayoutAttributes *)footerAttributes {
    CGRect frame = footerAttributes.frame;
    frame.origin.y = self.collectionView.contentOffset.y + CGRectGetHeight(self.collectionView.bounds) - frame.size.height;
    frame.size.width = CGRectGetWidth(self.collectionView.bounds);
    footerAttributes.frame = frame;
}

@end
