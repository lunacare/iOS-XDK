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
#import "LYRUIConfigurable.h"
#import "LYRUIImageFetching.h"
@protocol LYRUIImageCaching;
@protocol LYRUIImageCreating;
@protocol LYRUIDataCreating;
@protocol LYRUIDispatching;

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUIImageFetcher : NSObject <LYRUIImageFetching, LYRUIConfigurable>

/**
 @abstract The object conforming to `LYRUIImageCaching` protocol which will be used for storing and reusing previously fetched images.
 */
@property (nonatomic, strong) id<LYRUIImageCaching> imagesCache;

/**
 @abstract The object conforming to `LYRUIImageCreating` protocol which will be used to create images from binary data.
 */
@property (nonatomic, strong) id<LYRUIImageCreating> imageFactory;

/**
 @abstract The object conforming to `LYRUIDataCreating` protocol which will be used to retrieve binary data from the download tasks.
 */
@property (nonatomic, strong) id<LYRUIDataCreating> dataFactory;

/**
 @abstract The object conforming to `LYRUIDispatching` protocol which will be used to dispatch the callback on main queue.
 */
@property (nonatomic, strong) id<LYRUIDispatching> dispatcher;

/**
 @abstract NSURLSession instance, used to fetch image with provided URL.
 */
@property (nonatomic, strong) NSURLSession *session;

@end
NS_ASSUME_NONNULL_END       // }
