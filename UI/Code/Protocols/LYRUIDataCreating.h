//
//  LYRUIDataCreating.h
//  Layer-XDK-UI-iOS
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
 @abstract Objects conforming to the `LYRUIDataCreating` protocol will be used to create `NSData` instances.
 */
@protocol LYRUIDataCreating <NSObject>

/**
 @abstract Provides a `NSData` created from contents of provided `NSURL`.
 @param url The `NSURL` object with address of contents to use for creating the `NSData` instance.
 @return A `NSData` instance with contents from provided `url`.
 */
- (nullable NSData *)dataWithContentsOfURL:(NSURL *)url;

@end
NS_ASSUME_NONNULL_END       // }
