//
//  LYRUIPresenceView.h
//  Layer-UI-iOS
//
//  Created by Jeremy Wyld on 03.07.2017.
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

#if 0
#pragma mark Imports
#endif

#import <UIKit/UIKit.h>
#import <LayerKit/LayerKit.h>

NS_ASSUME_NONNULL_BEGIN     // {


#if 0
#pragma mark -
#endif

IB_DESIGNABLE
@interface LYRUIPresenceView : UIView

@property (nonatomic, assign, readwrite) LYRIdentityPresenceStatus presenceStatus;

- (nullable UIColor *)fillColorForPresenceStatus:(LYRIdentityPresenceStatus)status;
- (nullable UIColor *)strokeColorForPresenceStatus:(LYRIdentityPresenceStatus)status;

- (void)setFillColor:(nullable UIColor *)color forPresenceStatus:(LYRIdentityPresenceStatus)status UI_APPEARANCE_SELECTOR;
- (void)setStrokeColor:(nullable UIColor *)color forPresenceStatus:(LYRIdentityPresenceStatus)status UI_APPEARANCE_SELECTOR;

@end

NS_ASSUME_NONNULL_END       // }
