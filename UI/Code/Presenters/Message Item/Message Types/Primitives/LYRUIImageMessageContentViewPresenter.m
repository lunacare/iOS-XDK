//
//  LYRUIImageMessageContentViewPresenter.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 03.09.2017.
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

#import "LYRUIImageMessageContentViewPresenter.h"
#import "LYRUIMessageItemView.h"
#import <LayerKit/LayerKit.h>
#import "LYRUIDispatcher.h"
#import "LYRUIImageLoader.h"
#import "LYRUIImageMessage.h"
#import "LYRUIImageFetcher.h"
#import "NSCache+LYRUIImageCaching.h"
#import "LYRUIReusableViewsQueue.h"
#import "UIView+LYRUIMessageConfiguration.h"

static CGFloat const LYRUIMessageItemViewImageMaxHeight = 450.0;

@implementation LYRUIImageMessageContentViewPresenter

- (UIImageView *)viewForMessage:(LYRUIImageMessage *)message {
    UIImageView *imageView = [self.reusableViewsQueue dequeueReusableViewOfType:[UIImageView class]];
    if (imageView == nil) {
        imageView = [[UIImageView alloc] init];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    [self setupViewConstraints:imageView forImageSize:message.size];
    [self setupImageView:imageView withMessageType:message];
    
    return imageView;
}

- (void)setupImageView:(__weak UIImageView *)imageView withMessageType:(LYRUIImageMessage *)messageType {
    NSString *contextId = [NSUUID UUID].UUIDString;
    imageView.lyr_presentationContextId = contextId;
    
    NSURL *sourceImageURL = messageType.sourceImageURL ?: messageType.sourceImageLocalURL;
    UIImage *cachedSourceImage = [self.imagesCache objectForKey:sourceImageURL];
    if (cachedSourceImage != nil) {
        [self presentImage:cachedSourceImage inImageView:imageView contextId:contextId];
        return;
    }
    
    NSURL *previewImageURL = messageType.previewImageURL ?: messageType.previewImageLocalURL;
    UIImage *cachedPreviewImage = [self.imagesCache objectForKey:previewImageURL] ?: [self.thumbnailsCache objectForKey:sourceImageURL];
    if (cachedPreviewImage != nil) {
        [self presentImage:cachedPreviewImage inImageView:imageView contextId:contextId];
        [self fetchAndPresentImageWithURL:sourceImageURL inImageView:imageView contextId:contextId completion:nil];
    } else {
        __weak __typeof(self) weakSelf = self;
        imageView.image = nil;
        [self fetchAndPresentImageWithURL:previewImageURL inImageView:imageView contextId:contextId completion:^{
            [weakSelf fetchAndPresentImageWithURL:sourceImageURL inImageView:imageView contextId:contextId completion:nil];
        }];
    }
}

- (void)setupViewConstraints:(UIView *)view forImageSize:(CGSize)size {
    CGFloat maxHeight = LYRUIMessageItemViewImageMaxHeight;
    CGFloat ratio = (size.height != 0.0) ? (size.width / size.height) : LYRUIMessageItemViewImageDefaultRatio;
    [self setupViewConstraints:view];
    if (size.width != 0.0) {
        CGFloat width = (size.height > maxHeight) ? (maxHeight * ratio) : size.width;
        NSLayoutConstraint *widthConstraint = [view.widthAnchor constraintEqualToConstant:width];
        widthConstraint.priority = 501.0;
        widthConstraint.active = YES;
    }
    NSLayoutConstraint *ratioConstraint = [view.widthAnchor constraintEqualToAnchor:view.heightAnchor multiplier:ratio];
    ratioConstraint.priority = UILayoutPriorityDefaultHigh;
    ratioConstraint.active = YES;
    [view.heightAnchor constraintLessThanOrEqualToConstant:maxHeight].active = YES;
}

- (CGFloat)viewHeightForMessage:(LYRUIImageMessage *)message
                       minWidth:(CGFloat)minWidth
                       maxWidth:(CGFloat)maxWidth {
    CGSize imageSize = message.size;
    if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
        imageSize = [self sizeOfImageWithURL:message.sourceImageURL];
    }
    CGFloat height = [self heightForSize:imageSize withMinWidth:minWidth maxWidth:maxWidth];
    return MIN(height, LYRUIMessageItemViewImageMaxHeight);
}

@end
