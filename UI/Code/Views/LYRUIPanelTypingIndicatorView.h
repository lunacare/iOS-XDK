//
//  LYRUIPanelTypingIndicatorView.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 14.09.2017.
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

#import "LYRUIConfigurable.h"
#import <LayerKit/LayerKit.h>
#import "LYRUIViewLayout.h"
@class LYRUIPanelTypingIndicatorView;

NS_ASSUME_NONNULL_BEGIN     // {
extern NSString * __nullable (^LYRUIPanelTypingIndicatorViewDefaultTitleFotmatting)(NSArray *);

@protocol LYRUIPanelTypingIndicatorViewLayout <LYRUIViewLayout>

- (void)addConstraintsInView:(LYRUIPanelTypingIndicatorView *)view;
- (void)removeConstraintsFromView:(LYRUIPanelTypingIndicatorView *)view;
- (void)updateConstraintsInView:(LYRUIPanelTypingIndicatorView *)view;

@end

@interface LYRUIPanelTypingIndicatorView : UICollectionReusableView <LYRUIConfigurable>

@property (nonatomic, copy) id<LYRUIPanelTypingIndicatorViewLayout> layout;

@property (nonatomic, weak, readonly) UILabel *label;
@property (nonatomic, copy) NSSet<LYRIdentity *> *identities;

@property (nonatomic, copy) NSString * __nullable (^titleFotmatting)(NSArray *);

@end
NS_ASSUME_NONNULL_END       // }
