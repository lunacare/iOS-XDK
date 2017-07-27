//
//  LYRUIImageFetching.h
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN     // {
/**
 @abstract Objects conforming to the `LYRUIImageFetching` protocol will be used to fetch an image from given `NSURL`.
 */
@protocol LYRUIImageFetching <NSObject>

/**
 @abstract Fetches an image from provided `URL` and calls the `callback` when finished.
 @param URL An `NSURL` with address of the image.
 @param callback The callback block which is called after fetch is finished. When fetch fails, this callback should be called with nil parameter.
 @return The `NSURLSessionDownloadTask` in which the image is downloaded.
 */
- (nullable NSURLSessionDownloadTask *)fetchImageWithURL:(NSURL *)URL andCallback:(void(^)(UIImage * _Nullable))callback;

@end
NS_ASSUME_NONNULL_END       // }
