//
//  LYRUIAvatarViewPresenter.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 21.07.2017.
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
@class LYRUIAvatarView;
@class LYRUIImageWithLettersViewPresenter;

/**
 @abstract The `LYRUIAvatarViewPresenter` sets the `LYRUIAvatarView` with the data from provided `identities` array.
 */
@interface LYRUIAvatarViewPresenter : NSObject <LYRUIConfigurable>

/**
 @abstract Updates the `LYRUIAvatarView` instance with the data from provided `identities` array.
 @param avatarView The `LYRUIAvatarView` instance to be set with provided data.
 @param identities An array of `LYRIdentity` instances to use for view setup.
 */
- (void)setupAvatarView:(LYRUIAvatarView *)avatarView withIdentities:(NSArray<LYRIdentity *> *)identities;

@end
