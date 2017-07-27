//
//  LYRUIImageFetcher.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 20.07.2017.
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

#import <Foundation/Foundation.h>
#import "LYRUIImageFetching.h"
@protocol LYRUIImageCaching;
@protocol LYRUIImageCreating;
@protocol LYRUIDataCreating;
@protocol LYRUIDispatching;

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUIImageFetcher : NSObject <LYRUIImageFetching>

/**
 @abstract Initializes a new `LYRUIImageFetcher` object with the given image fetcher, image factory, and initials formatter.
 @param imagesCache The object conforming to `LYRUIImageCaching` protocol which will be used for storing and reusing previously fetched images.
 @param imageFactory The object conforming to `LYRUIImageCreating` protocol which will be used to create images from binary data.
 @param dataFactory The object conforming to `LYRUIDataCreating` protocol which will be used to retrieve binary data from the download tasks.
 @param dispatcher The object conforming to `LYRUIDispatching` protocol which will be used to dispatch the callback on main queue.
 @return An `LYRUIImageFetcher` object.
 */
- (instancetype)initWithImagesCache:(nullable id<LYRUIImageCaching>)imagesCache
                       imageFactory:(nullable id<LYRUIImageCreating>)imageFactory
                        dataFactory:(nullable id<LYRUIDataCreating>)dataFactory
                         dispatcher:(nullable id<LYRUIDispatching>)dispatcher
                         andSession:(nullable NSURLSession *)session;

@end
NS_ASSUME_NONNULL_END       // }
