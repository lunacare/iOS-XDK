//
//  LYURIIdentityNameFormatting.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 12.07.2017.
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

/**
 @abstract The `LYRUIIdentityNameFormatting` protocol must be adopted by objects that will be providing a formatted name of `LYRIdentity`.
 */
@protocol LYRUIIdentityNameFormatting <NSObject>

/**
 @abstract Provides a formatted name to display for a given identity.
 @param identity The `LYRIdentity` object.
 @return The string to be displayed as the name for a given identity in the identity list.
 */
- (nullable NSString *)nameForIdentity:(nonnull LYRIdentity *)identity;

@end
