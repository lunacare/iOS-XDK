//
//  LYRUIStatusCellPresenter.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 01.02.2018.
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

#import "LYRUIStatusCellPresenter.h"
#import "LYRUIStatusMessage.h"
#import "LYRUIStatusMessageCollectionViewCell.h"
#import "LYRUIListDataSource.h"

@interface LYRUIStatusCellPresenter ()

@property (nonatomic, strong) LYRUIStatusMessageCollectionViewCell *sizingCell;

@end

@implementation LYRUIStatusCellPresenter
@synthesize listDataSource = _listDataSource;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sizingCell = [[LYRUIStatusMessageCollectionViewCell alloc] init];
    }
    return self;
}

#pragma mark - LYRUIListCellSizeCalculating

- (NSSet<Class> *)handledItemTypes {
    return [NSSet setWithObject:[LYRUIStatusMessage class]];
}

- (CGSize)cellSizeInCollectionView:(UICollectionView *)collectionView forItemAtIndexPath:(NSIndexPath *)indexPath {
    LYRUIStatusMessage *statusMessage = (LYRUIStatusMessage *)[self.listDataSource itemAtIndexPath:indexPath];
    self.sizingCell.textView.text = statusMessage.text;
    CGFloat width = CGRectGetWidth(collectionView.bounds) - 24.0;
    CGFloat textHeight = [self textSizeInTextView:self.sizingCell.textView withMaxWidth:width].height;
    CGFloat height = ceil(textHeight) + 20.0;
    return CGSizeMake(width, height);
}

- (CGSize)textSizeInTextView:(UITextView *)textView withMaxWidth:(CGFloat)maxWidth {
    CGRect stringRect = [textView.text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                                    options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                 attributes:textView.typingAttributes
                                                    context:nil];
    return stringRect.size;
}

#pragma mark - LYRUIListCellPresenting

- (NSString *)cellReuseIdentifier {
    return NSStringFromClass([LYRUIStatusMessageCollectionViewCell class]);
}

- (void)registerCellInCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:[LYRUIStatusMessageCollectionViewCell class] forCellWithReuseIdentifier:self.cellReuseIdentifier];
}

- (void)setupCell:(LYRUIStatusMessageCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    LYRUIStatusMessage *statusMessage = (LYRUIStatusMessage *)[self.listDataSource itemAtIndexPath:indexPath];
    cell.textView.text = statusMessage.text;
}

@end
