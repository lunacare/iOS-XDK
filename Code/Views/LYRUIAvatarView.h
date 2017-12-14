//
//  LYRUIAvatarView.h
//  Layer-UI-iOS
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

#import <UIKit/UIKit.h>
#import <LayerKit/LayerKit.h>
@class LYRUIConfiguration;
@class LYRUIAvatarView;
@protocol LYRUIPresenceIndicatorTheme;
@protocol LYRUIParticipantsCountViewTheme;
@protocol LYRUIAvatarViewTheme;

NS_ASSUME_NONNULL_BEGIN     // {
@protocol LYRUIAvatarViewLayout <NSObject, NSCopying> // TODO: make it conform to LYRUIViewLayout protocol after merging

- (void)addConstraintsInView:(LYRUIAvatarView *)view;
- (void)removeConstraintsFromView:(LYRUIAvatarView *)view;
- (void)updateConstraintsInView:(LYRUIAvatarView *)view;

@end

IB_DESIGNABLE
/**
 @abstract The `LYRUIAvatarView` displays avatars, or a badge with number of `identities`, when set up with multiple `LYRIdentity` objects. When single `identity` object is passed, the view presents avatar with the presence view, representing presence status of `LYRIdentity`.
 @warning When view is resized to under 32pt width or height, it hides avatars and shows only the presence view, or badge with number of `identities`.
 */
@interface LYRUIAvatarView : UIView

/**
 @abstract The `identities` to setup the view with. If array contains one `LYRUIIdentity` object, the view will show an avatar with presence status view. Otherwise it will present multi-avatar, replaced with a badge with number of `identities` when resized under 32pt width or height.
 */
@property (nonatomic, copy) NSArray<LYRIdentity *> *identities;

/**
 @abstract The `configuration` od UI components. Used to retrieve setup and themes.
 @discussion If using storyboards, the property must be set explicitly.
 */
@property (nonatomic, weak) LYRUIConfiguration *layerConfiguration;

/**
 @abstract An object which contains set of colors to use in `LYRUIAvatarView` dependant views. Default is nil, and subviews use their defaults.
 */
@property (nonatomic, copy, nullable) id<LYRUIAvatarViewTheme> theme UI_APPEARANCE_SELECTOR;

/**
 @abstract Layout of the `LYRUIAvatarView` subviews. Default is nil, and is updated to `LYRUIAvatarViewSingleLayout`, or `LYRUIAvatarViewMultiLayout` depending on count of `identities` set.
 */
@property (nonatomic, copy) IBOutlet id<LYRUIAvatarViewLayout> layout;

/**
 @abstract Initializes a new `LYRUIPresenceView` with the configuration.
 @param configuration An `LYRUIConfiguration` instance, used to retrieve themes, and setup.
 @return An `LYRUIPresenceView` object.
 */
- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration;

@end
NS_ASSUME_NONNULL_END       // }
