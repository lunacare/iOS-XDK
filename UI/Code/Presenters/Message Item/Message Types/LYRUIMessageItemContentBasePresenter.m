//
//  LYRUIMessageItemContentBasePresenter.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 29.09.2017.
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

#import "LYRUIMessageItemContentBasePresenter.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIMessageType.h"
#import "LYRUIMessageMetadata.h"
#import "LYRUIDispatching.h"
#import "LYRUIImageLoader.h"
#import "LYRUIImageFetching.h"
#import "LYRUIImageCaching.h"
#import "UIView+LYRUIMessageConfiguration.h"
#import "UIImage+LYRUIThumbnail.h"
#import "LYRUIReusableViewsQueue.h"

CGFloat const LYRUIMessageItemViewMinimumContentWidth = 192.0;

CGFloat const LYRUIMessageItemViewImageDefaultRatio = 4.0 / 3.0;
static CGSize const LYRUIMessageItemViewImageDefaultSize = { 4.0, 3.0 };
static CGFloat const LYRUIMessageItemViewMaximumPreviewImageSize = 300.0;

@implementation LYRUIMessageItemContentBasePresenter
@synthesize reusableViewsQueue = _reusableViewsQueue,
            presentersProvider = _presentersProvider,
            actionHandlingDelegate = _actionHandlingDelegate,
            layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [self init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    self.imagesCache = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIImageCaching)
                                                                  forClass:[self class]];
    self.thumbnailsCache = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIThumbnailsCaching)
                                                                      forClass:[self class]];
    self.imageFetcher = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIImageFetching)
                                                                   forClass:[self class]];
    self.dispatcher = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIDispatching)
                                                                 forClass:[self class]];
    self.imageLoader = [layerConfiguration.injector objectOfType:[LYRUIImageLoader class]];
    self.reusableViewsQueue = [layerConfiguration.injector objectOfType:[LYRUIReusableViewsQueue class]];
}

#pragma mark - Public methods

- (void)setupViewConstraints:(UIView *)view {
    [NSLayoutConstraint deactivateConstraints:view.constraints];
    [view.widthAnchor constraintGreaterThanOrEqualToConstant:LYRUIMessageItemViewMinimumContentWidth].active = YES;
}

- (CGFloat)heightForSize:(CGSize)size withMinWidth:(CGFloat)minWidth maxWidth:(CGFloat)maxWidth {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return 0.0;
    }
    CGFloat ratio = 1.0;
    if (size.width > maxWidth) {
        ratio = maxWidth / size.width;
    } else if (size.width < minWidth) {
        ratio = minWidth / size.width;
    }
    CGFloat height = size.height * ratio;
    return height;
}

#pragma mark - LYRUIMessageItemViewConfiguring

- (UIView *)viewForMessage:(LYRUIMessageType *)message {
    return nil;
}

- (UIColor *)backgroundColorForMessage:(LYRUIMessageType *)message {
    return [UIColor colorWithWhite:242.0/255.0 alpha:1.0];
}

- (CGFloat)viewHeightForMessage:(LYRUIMessageType *)message minWidth:(CGFloat)minWidth maxWidth:(CGFloat)maxWidth {
    return 0.0;
}

#pragma mark - Helpers

- (BOOL)isMessageOutgoing:(LYRUIMessageType *)message {
    return [message.sender.userID isEqualToString:self.layerConfiguration.client.authenticatedUser.userID];
}

#pragma mark - Views height calculation

- (CGSize)textSizeInLabel:(UILabel *)label withMaxWidth:(CGFloat)maxWidth {
    CGRect stringRect = [label.text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                                 options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                              attributes:@{ NSFontAttributeName: label.font }
                                                 context:nil];
    return stringRect.size;
}

- (CGSize)sizeOfImageWithURL:(NSURL *)imageURL {
    if (imageURL == nil) {
        return CGSizeZero;
    }
    UIImage *image = [self.imagesCache objectForKey:imageURL];
    if (image != nil) {
        return image.size;
    }
    return LYRUIMessageItemViewImageDefaultSize;
}

#pragma mark - Images loading

- (void)fetchAndPresentImageWithURL:(NSURL *)imageURL
                        inImageView:(__weak UIImageView *)imageView
                          contextId:(NSString *)contextId
                         completion:(void(^)(void))completion {
    if ([imageView lyr_isOutOfContext:contextId] || imageURL == nil) {
        if (completion) {
            completion();
        }
        return;
    }
    
    UIImage *cachedImage = [self.imagesCache objectForKey:imageURL];
    if (cachedImage != nil) {
        [self presentImage:cachedImage inImageView:imageView contextId:contextId];
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    CGFloat maxImageSize = LYRUIMessageItemViewMaximumPreviewImageSize;
    if ([imageURL isFileURL]) {
        [self.dispatcher dispatchAsyncOnGlobalQueue:DISPATCH_QUEUE_PRIORITY_DEFAULT block:^{
            UIImage *displayingImage = [weakSelf.imageLoader imageForImageURL:imageURL];
            [weakSelf.dispatcher dispatchAsyncOnMainQueue:^{
                [weakSelf presentImage:displayingImage inImageView:imageView contextId:contextId];
                if (completion) {
                    completion();
                }
            }];
            if (displayingImage) {
                [weakSelf.imagesCache setObject:displayingImage forKey:imageURL];
                if (displayingImage.size.width > maxImageSize || displayingImage.size.height > maxImageSize) {
                    [weakSelf.thumbnailsCache setObject:displayingImage.lyr_thumbnail forKey:imageURL];
                }
            }
        }];
    } else {
        [self.imageFetcher fetchImageWithURL:imageURL andCallback:^(UIImage * _Nullable image) {
            [weakSelf.dispatcher dispatchAsyncOnMainQueue:^{
                [weakSelf presentImage:image inImageView:imageView contextId:contextId];
                if (completion) {
                    completion();
                }
            }];
            if (image && (image.size.width > maxImageSize || image.size.height > maxImageSize)) {
                [weakSelf.thumbnailsCache setObject:image.lyr_thumbnail forKey:imageURL];
            }
        }];
    }
}

- (void)presentImage:(UIImage *)image inImageView:(__weak UIImageView *)imageView contextId:(NSString *)contextId {
    if (image == nil || [imageView lyr_isOutOfContext:contextId]) {
        return;
    }
    imageView.image = image;
    [imageView setNeedsLayout];
}

@end
