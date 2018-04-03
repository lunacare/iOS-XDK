//
//  LYRUIImageWithLettersViewPresenter.h
//  Layer-XDK-UI-iOS
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
#import <LayerKit/LayerKit.h>
@class LYRUIImageWithLettersView;

NS_ASSUME_NONNULL_BEGIN     // {
/**
 @abstract The `LYRUIImageWithLettersViewPresenter` sets the `LYRUIImageWithLettersView` with the data from provided `identity`.
 */
@interface LYRUIImageWithLettersViewPresenter : NSObject <LYRUIConfigurable>

/**
 @abstract Updates the `LYRUIImageWithLettersView` instance with the data from provided `identity`.
 @param view The `LYRUIPresenceView` instance to be set with provided data.
 @param identity An `LYRIdentity` instance to use for view setup.
 */
- (void)setupImageWithLettersView:(LYRUIImageWithLettersView *)view withIdentity:(LYRIdentity *)identity;

/**
 @abstract Updates the `LYRUIImageWithLettersView` instance with the multiple participants placeholder asset.
 @param view The `LYRUIPresenceView` instance to be set with placeholder image.
 */
- (void)setupImageWithLettersViewWithMultipleParticipantsIcon:(LYRUIImageWithLettersView *)view;

@end
NS_ASSUME_NONNULL_END       // }
