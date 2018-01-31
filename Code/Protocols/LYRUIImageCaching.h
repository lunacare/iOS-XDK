//
//  LYRUIImageCaching.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 26.07.2017.
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN     // {
/**
 @abstract Objects conforming to the `LYRUIImageCaching` protocol will be used to store and reuse images fetched from remote servers.
 */
@protocol LYRUIImageCaching <NSObject>

/**
 @abstract Provides a `UIImage` stored for provided `NSURL` address.
 @param key The `NSURL` with remote address of an image.
 @return A `UIImage` instance, when an image was stored for provided `NSURL` key. Otherwise rerurns nil.
 */
- (nullable UIImage *)objectForKey:(NSURL *)key;

/**
 @abstract Stores an `UIImage` for provided `NSURL` address.
 @param obj The `UIImage` instance to store.
 @param key The address of image, to associate the `UIImage` instance with.
 */
- (void)setObject:(UIImage *)obj forKey:(NSURL *)key;

@end

/**
 @abstract Objects conforming to the `LYRUIThumbnailsCaching` protocol will be used to store and reuse locall thumbnails of images.
 */
@protocol LYRUIThumbnailsCaching <LYRUIImageCaching>
@end
NS_ASSUME_NONNULL_END       // }
