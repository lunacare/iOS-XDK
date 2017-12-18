//
//  LYRUIConversationItemViewConfiguration.h
//  Layer-UI-iOS
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
#import"LYRUIConfigurable.h"
#import "LYRUIIdentityItemView.h"
#import <LayerKit/LayerKit.h>
@protocol LYRUIIdentityNameFormatting;
@protocol LYRUITimeFormatting;
@protocol LYRUIIdentityItemAccessoryViewProviding;

NS_ASSUME_NONNULL_BEGIN
typedef NSString *_Nonnull (^LYRUIIdentityMetadataFormatting)(NSDictionary *);

@interface LYRUIIdentityItemViewConfiguration : NSObject <LYRUIConfigurable>

/**
 @abstract The object provides an accessory view for identity item.
 */
@property(nonatomic, strong) id<LYRUIIdentityItemAccessoryViewProviding> accessoryViewProvider;

/**
 @abstract The object provides a formatted name for the identity item.
 */
@property(nonatomic, strong) id<LYRUIIdentityNameFormatting> nameFormatter;

/**
 @abstract The object provides formatted date of last seen at for the identity item.
 */
@property(nonatomic, strong) id<LYRUITimeFormatting> lastSeenAtTimeFormatter;

/**
 @abstract An `LYRUIIdentityMetadataFormatting` block which will be used for formatting participants metadata to a string.
 */
@property(nonatomic, strong, nullable) LYRUIIdentityMetadataFormatting metadataFormatter;

/**
 @abstract Updates the view conforming to `LYRUIIdentityItemView` protocol with data from given identity.
 @param view The UIView conforming to `LYRUIIdentityItemView` protocol to be set up.
 @param identity The `LYRIdentity` object to be presented on identity list.
 */
- (void)setupIdentityItemView:(UIView<LYRUIIdentityItemView> *)view
                 withIdentity:(LYRIdentity *)identity;

@end
NS_ASSUME_NONNULL_END
