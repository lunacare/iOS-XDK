//
//  LYRUIInitialsFormatting.h
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
@class LYRIdentity;

NS_ASSUME_NONNULL_BEGIN     // {
/**
 @abstract Objects conforming to the `LYRUIInitialsFormatting` protocol will be used to provide a string with formatted initials for given `LYRIdentity` object.
 */
@protocol LYRUIInitialsFormatting <NSObject>

/**
 @abstract Provides a string with formatted initials for given `LYRIdentity` object.
 @param identity An `LYRIdentity` instance.
 @return The `NSString` with formatted initials for provided `identity`. If there's no sufficient data to create initials, a nil is returned.
 */
- (nullable NSString *)initialsForIdentity:(LYRIdentity *)identity;

@end
NS_ASSUME_NONNULL_END       // }
