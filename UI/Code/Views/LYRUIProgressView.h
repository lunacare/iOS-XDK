//
//  LYRUIProgressView.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN     // {

/**
 @abstract A progress bar view with two overlaying tracks, where the background
   track represents the buffer loading progress, and the foreground track
   represents the playback progress.
 */
@interface LYRUIProgressView : UIView

/**
 @abstract The buffer loading progress, where 1.0f is maximum.
 */
@property (nonatomic, readwrite, assign) float bufferProgress;

/**
 @abstract The playback progress, where 1.0f is maximum.
 */
@property (nonatomic, readwrite, assign) float playbackProgress;

/**
 @abstract The buffer progress track color.
 */
@property (nonatomic, readwrite, copy) UIColor *bufferProgressTrackTint;

/**
 @abstract The playback progress track color.
 */
@property (nonatomic, readwrite, copy) UIColor *playbackProgressTrackTint;

@end

NS_ASSUME_NONNULL_END       // }
