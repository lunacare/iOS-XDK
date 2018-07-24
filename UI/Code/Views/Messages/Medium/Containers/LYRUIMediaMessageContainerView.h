//
//  LYRUIMediaMessageContainerView.h
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 6/5/18.
//  Copyright (c) 2018 Layer. All rights reserved.
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

#import "LYRUIStandardMessageContainerView.h"
#import "LYRUIProgressView.h"

NS_ASSUME_NONNULL_BEGIN     // {

/**
 @abstract The media message container view, based on the standard message
   container view, but adds a progress view inside the metadata container,
   and a play button inside the main view.
 */
@interface LYRUIMediaMessageContainerView : LYRUIStandardMessageContainerView

/**
 @abstract The progress view embedded inside the metadata container view.
 */
@property (nonatomic, strong, readonly) LYRUIProgressView *progressView;

/**
 @abstract The play/pause button embedded into the main view.
 */
@property (nonatomic, strong, readonly) UIButton *mediaControlButton;

@end

NS_ASSUME_NONNULL_END       // }
