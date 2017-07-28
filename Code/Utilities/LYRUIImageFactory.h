//
//  LYRUIImageFactory.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 25.07.2017.
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

#import "LYRUIImageCreating.h"

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUIImageFactory : NSObject <LYRUIImageCreating>

/**
 @abstract Initializes a new `LYRUIImageFactory` object with the given bundle.
 @param bundle An `NSBundle` instance which will be used for creating `UIImage` from image asset. Default is the bundle for this class.
 @return An `LYRUIImageFactory` object.
 */
- (instancetype)initWithBundle:(nullable NSBundle *)bundle;

@end
NS_ASSUME_NONNULL_END       // }
