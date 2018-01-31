//
//  LYRUIMessageItemContentBasePresenter.h
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

#import "LYRUIMessageItemContentPresenting.h"
#import "LYRUIConfigurable.h"
@protocol LYRUIMessageViewContainer;
@protocol LYRUIImageCaching;
@protocol LYRUIImageFetching;
@protocol LYRUIDispatching;
@class LYRUIMessageType;
@class LYRUIImageLoader;

extern CGFloat const LYRUIMessageItemViewMinimumContentWidth;

extern CGFloat const LYRUIMessageItemViewImageDefaultRatio;

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUIMessageItemContentBasePresenter : NSObject <LYRUIMessageItemContentPresenting, LYRUIConfigurable>

@property (nonatomic, strong) id<LYRUIImageCaching> imagesCache;
@property (nonatomic, strong) id<LYRUIImageCaching> thumbnailsCache;
@property (nonatomic, strong) id<LYRUIImageFetching> imageFetcher;
@property (nonatomic, strong) id<LYRUIDispatching> dispatcher;
@property (nonatomic, strong) LYRUIImageLoader *imageLoader;

- (void)setupViewConstraints:(UIView *)view;

- (CGFloat)heightForSize:(CGSize)size withMinWidth:(CGFloat)minWidth maxWidth:(CGFloat)width;

#pragma mark - Views height calculation

- (CGSize)textSizeInLabel:(UILabel *)label withMaxWidth:(CGFloat)maxWidth;

- (CGSize)sizeOfImageWithURL:(NSURL *)imageURL;

#pragma mark - Images loading

- (void)fetchAndPresentImageWithURL:(NSURL *)imageURL
                        inImageView:(__weak UIImageView *)imageView
                          contextId:(NSString *)contextId
                         completion:(void(^ _Nullable)(void))completion;

- (void)presentImage:(UIImage *)image inImageView:(__weak UIImageView *)imageView contextId:(NSString *)contextId;

@end
NS_ASSUME_NONNULL_END       // }
