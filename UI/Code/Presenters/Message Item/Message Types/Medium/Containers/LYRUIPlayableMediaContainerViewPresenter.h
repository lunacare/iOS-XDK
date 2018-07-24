//
//  LYRUIPlayableMediaContainerViewPresenter.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 15.11.2017.
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

#import "LYRUIStandardMessageContainerViewPresenter.h"
#import "LYRUIMediaPlaying.h"
#import "LYRUIMediaMessageContainerView.h"

NS_ASSUME_NONNULL_BEGIN     // {

/**
 @abstract An abstract playable media container view presenter, based on the
   standard mesage container view presenter, implementing a media play / pause
   support. It should be 
 */
@interface LYRUIPlayableMediaContainerViewPresenter : LYRUIStandardMessageContainerViewPresenter

/**
 @abstract The reference to the shared instance owned by the dependency injection
   manager.
 */
@property (nonatomic, readonly, strong) id<LYRUIMediaPlaying> mediaPlayer;

/**
 @abstract The current view controller by the media player.
 */
@property (nonatomic, readonly, strong, nullable) __kindof LYRUIMediaMessageContainerView *currentControlledView;

/**
 @abstract The current message loaded into the media player.
 */
@property (nonatomic, readonly, strong, nullable) LYRUIMediaMessage *currentMediaMessage;

#pragma mark - Overridable Media Player Event Methods

/**
 @abstract Invoked when media player that's handling the current media message
   updates the buffer progrogress info.
 @param view The view that ought to be updated.
 @param bufferProgress The new buffer progress value.
 */
- (void)updateView:(__kindof LYRUIMediaMessageContainerView *)view withBufferProgress:(float)bufferProgress;

/**
 @abstract Invoked when media player that's handling the current media message
   updates the playback duration info.
 @param view The view that ought to be updated.
 @param playbackDuration The new playback duration value.
 */
- (void)updateView:(__kindof LYRUIMediaMessageContainerView *)view withPlaybackDuration:(NSTimeInterval)playbackDuration;

/**
 @abstract Invoked when media player that's handling the current media message
   updates the playback time info.
 @param view The view that ought to be updated.
 @param playbackTime The new playback time value.
 */
- (void)updateView:(__kindof LYRUIMediaMessageContainerView *)view withPlaybackTime:(NSTimeInterval)playbackTime;

/**
 @abstract Invoked when media player that's handling the current media message
   updates the playback state info (when it loads, plays or pauses the playback).
 @param view The view that ought to be updated.
 @param playbackState The new playback state value.
 */
- (void)updateView:(__kindof LYRUIMediaMessageContainerView *)view withPlaybackState:(LYRUIMediaPlaybackState)playbackState;

@end

NS_ASSUME_NONNULL_END       // }
