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
@interface LYRUIAvatarView : UIView

@property (nonatomic, weak) NSArray<LYRIdentity *> *identities;

@property (nonatomic, copy, nullable) id<LYRUIParticipantsCountViewTheme, LYRUIPresenceIndicatorTheme, LYRUIAvatarViewTheme> theme UI_APPEARANCE_SELECTOR;

@property (nonatomic, copy) IBOutlet id<LYRUIAvatarViewLayout> layout;

@end
NS_ASSUME_NONNULL_END       // }
