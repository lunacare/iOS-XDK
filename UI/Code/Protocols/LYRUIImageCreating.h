//
//  LYRUIImageCreating.h
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
 @abstract Objects conforming to the `LYRUIImageCreating` protocol will be used to create `UIImage` instances.
 */
@protocol LYRUIImageCreating <NSObject>

/**
 @abstract Provides a `UIImage` created from asset with provided `imageName`.
 @param imageName The name of an image asset.
 @return A `UIImage` instance created from image asset with given name.
 */
- (UIImage *)imageNamed:(NSString *)imageName;

/**
 @abstract Provides a `UIImage` created from `NSData`.
 @param data The `NSData` object with binary data of an image.
 @return A `UIImage` instance created from image binary data.
 */
- (nullable UIImage *)imageWithData:(NSData *)data;

@end
NS_ASSUME_NONNULL_END       // }
