//
//  LYRUIMediaMessageContentViewPresenter.m
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 5/30/18.
//  Copyright (c) 2018 Layer. All rights reserved.
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

#import "LYRUIMediaMessageContentViewPresenter.h"
#import "LYRUIMessageItemView.h"
#import <LayerKit/LayerKit.h>
#import "LYRUIDispatcher.h"
#import "LYRUIImageLoader.h"
#import "LYRUIMediaMessage.h"
#import "LYRUIImageFetcher.h"
#import "NSCache+LYRUIImageCaching.h"
#import "LYRUIReusableViewsQueue.h"
#import "UIView+LYRUIMessageConfiguration.h"

CGFloat const LYRUIMediaItemViewMaxHeight = 450.0;
CGFloat const LYRUIMediaItemVIewMinHeight = 104.0;

@implementation LYRUIMediaMessageContentViewPresenter

- (UIImageView *)viewForMessage:(LYRUIMediaMessage *)message {
    UIImageView *imageView = [self.reusableViewsQueue dequeueReusableViewOfType:[UIImageView class]];
    if (imageView == nil) {
        imageView = [[UIImageView alloc] init];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    [self setupViewConstraints:imageView forImageSize:message.previewSize];
    [self setupImageView:imageView withMessageType:message];

    return imageView;
}

- (void)setupImageView:(__weak UIImageView *)imageView withMessageType:(LYRUIMediaMessage *)messageType {
    NSString *contextId = [NSUUID UUID].UUIDString;
    imageView.lyr_presentationContextId = contextId;

    NSURL *previewImageURL = messageType.previewURL ?: messageType.previewLocalURL;
    UIImage *cachedPreviewImage = [self.imagesCache objectForKey:previewImageURL];
    if (cachedPreviewImage != nil) {
        [self presentImage:cachedPreviewImage inImageView:imageView contextId:contextId];
        return;
    } else {
        imageView.image = nil;
        [self setupImageView:imageView withMIMEType:messageType.mediaMIMEType];
        [self fetchAndPresentImageWithURL:previewImageURL inImageView:imageView contextId:contextId completion:nil];
    }
}

- (void)setupViewConstraints:(UIView *)view forImageSize:(CGSize)size {
    CGFloat maxHeight = LYRUIMediaItemViewMaxHeight;
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

- (CGFloat)viewHeightForMessage:(LYRUIMediaMessage *)message minWidth:(CGFloat)minWidth maxWidth:(CGFloat)maxWidth {
    CGSize imageSize = message.previewSize;
    if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
        imageSize = [self sizeOfImageWithURL:message.previewURL ?: message.previewLocalURL];
    }
    CGFloat height = [self heightForSize:imageSize withMinWidth:minWidth maxWidth:maxWidth];
    height = MAX(LYRUIMediaItemVIewMinHeight, height);
    return MIN(height, LYRUIMediaItemViewMaxHeight);
}

@end
