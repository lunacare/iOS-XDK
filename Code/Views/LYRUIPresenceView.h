//
//  LYRUIPresenceView.h
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

#import <UIKit/UIKit.h>
@class LYRUIConfiguration;
@class LYRIdentity;
@protocol LYRUIPresenceIndicatorTheme;
@protocol LYRUIParticipantsCountViewTheme;

NS_ASSUME_NONNULL_BEGIN     // {
@protocol LYRUIPresenceViewTheme <LYRUIParticipantsCountViewTheme, LYRUIPresenceIndicatorTheme>
@end

IB_DESIGNABLE
/**
 @abstract The `LYRUIPresenceView` displays a badge with number of `identities`, or a colored shape representation of the status of `LYRIdentity` presence, when `identities` contain only one `LYRIdentity` object.
 */
@interface LYRUIPresenceView : UIView

/**
 @abstract The `identities` to setup the view with. If array contains one `LYRUIIdentity` object, the view will show a colored shape representation of its presence status. Otherwise it will present a badge with number of `identities`.
 */
@property (nonatomic, weak) NSArray<LYRIdentity *> *identities;

/**
 @abstract The `configuration` od UI components. Used to retrieve setup and themes.
 @discussion If using storyboards, the property must be set explicitly.
 */
@property (nonatomic, weak) LYRUIConfiguration *layerConfiguration;

/**
 @abstract An object which contains set of colors to use in `LYRUIPresenceView` dependant views. Default is an `LYRUIPresenceViewDefaultTheme` instance.
 */
@property (nonatomic, copy) id<LYRUIPresenceViewTheme> theme UI_APPEARANCE_SELECTOR;

/**
 @abstract Initializes a new `LYRUIPresenceView` with the configuration.
 @param configuration An `LYRUIConfiguration` instance, used to retrieve themes, and setup.
 @return An `LYRUIPresenceView` object.
 */
- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration;

@end
NS_ASSUME_NONNULL_END       // }
