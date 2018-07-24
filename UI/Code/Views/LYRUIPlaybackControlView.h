//
//  LYRUIPlaybackControlView.h
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 7/6/18.
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
#import "LYRUIMediaPlaying.h"
#import "LYRUIConfigurable.h"
#import "LYRUIViewLayout.h"
#import "LYRUIViewWithLayout.h"

NS_ASSUME_NONNULL_BEGIN     // {

@protocol LYRUIPlaybackControlDelegate, LYRUIPlaybackControlViewLayout;

/**
 @abstract A view containing a set of subviews representing the playback
   controls, such as a seek bar, current time, play and pause button.
 */
@interface LYRUIPlaybackControlView : LYRUIViewWithLayout <LYRUIConfigurable>

/**
 @abstract The delegate handling the UI actions.
 */
@property (nonatomic, nullable, weak) id<LYRUIPlaybackControlDelegate> delegate;

#pragma mark - Playback Properties

/**
 @abstract The playback state which prepares the view reflecting the current
   state of the media player (e.g. if it's capable of playing or not,
   if the playback is paused or playing, etc).
 */
@property (nonatomic, assign, readwrite) LYRUIMediaPlaybackState playbackState;

/**
 @abstract The state of the playback audio output where @c YES indicates it's
   muted, and @c NO that is unmuted.
 */
@property (nonatomic, assign, readwrite, getter=isPlaybackMuted) BOOL playbackMuted;

/**
 @abstract The total runtime of the media.
 */
@property (nonatomic, assign, readwrite) NSTimeInterval playbackDuration;

/**
 @abstract The current playback time.
 */
@property (nonatomic, assign, readwrite) NSTimeInterval playbackPosition;

/**
 @abstract The playback buffer availability.
 */
@property (nonatomic, assign, readwrite) NSTimeInterval playbackBuffer;

#pragma mark - Customization

/**
 @abstract The view containing the @c currentTimeLabel, @c seekSlider and
   @cmuteButton subviews.
 */
@property (nonatomic, readonly) UIView *seekAndAudioContainerView;

/**
 @abstract The label indicating the current playback time.
 */
@property (nonatomic, readonly) UILabel *currentTimeLabel;

/**
 @abstract The slider indicating and controlling the current playback position.
 */
@property (nonatomic, readonly) UISlider *seekSlider;

/**
 @abstract The audio control button in charge of the mute and unmute behavior.
 */
@property (nonatomic, readonly) UIButton *muteButton;

/**
 @abstract The view containing the @c seekBackwardButton, @c playbackControlButton
   and the @c seekForwardButton.
 */
@property (nonatomic, readonly) UIView *playbackContainerView;

/**
 @abstract The button in charge of moving the playback position backward in time.
 */
@property (nonatomic, readonly) UIButton *seekBackwardButton;

/**
 @abstract The button in charge of playing and pausing the playback.
 */
@property (nonatomic, readonly) UIButton *playbackControlButton;

/**
 @abstract The button in charge of moving the playback position forward in time.
 */
@property (nonatomic, readonly) UIButton *seekForwardButton;

@end

/**
 @abstract The delegate protocol describing the callbacks caused by
   the user interaction with the playback controls.
 */
@protocol LYRUIPlaybackControlDelegate<NSObject>

@required

#pragma mark - Playback Control Callback Methods

/**
 @abstract Called when the play button was pressed.
 @param view The view receiving the tap on the play button.
 */
- (void)playbackControlViewDidTapPlay:(LYRUIPlaybackControlView *)view;

/**
 @abstract Called when the pause button was pressed.
 @param view The view receiving the tap on the pause button.
 */
- (void)playbackControlViewDidTapPause:(LYRUIPlaybackControlView *)view;

/**
 @abstract Called when the seek bar was moved.
 @param view The view receiving the seek bar change.
 @param timeInterval The position in time the seek bar was changed to.
 */
- (void)playbackControlView:(LYRUIPlaybackControlView *)view didSeekTo:(NSTimeInterval)timeInterval;

#pragma mark - Audio Control Callback Methods

/**
 @abstract Called when the mute button was pressed.
 @param view The view receiving the tap on the mute button.
 */
- (void)playbackControlViewDidTapMute:(LYRUIPlaybackControlView *)view;

/**
 @abstract Called when the unmute button was pressed.
 @param view The view receiving the tap on the unmute button.
 */
- (void)playbackControlViewDidTapUnmute:(LYRUIPlaybackControlView *)view;

#pragma mark - UI Layout

/**
 @abstract Called whenever the layout changes.
 */
- (void)playbackControlNeedsLayout:(LYRUIPlaybackControlView *)view;

@end

/**
 @abstract The default playback control layout the @c LYRUIPlaybackControlView
   is configured with during initialization, if none defined in the dependency
   manager.
 @code This is an approximation of the default constraints:

   .------------------------------------------------------------------.
   |          ↥                       ↥                       ↥       |
   |↤[ currentTimeLabel ]↔︎[      seekSlider          ]↔︎[ muteButton ]↦|
   |          ↧                       ↧                       ↧       |
   '------------------------------------------------------------------'
                                     ↧ ↥
   .------------------------------------------------------------------.
   |           ↥                      ↥                   ↥           |
   |←─→[ seekBackwardBtn ]↤[ playbackControlBtn ]↦[seekForwardBtn ]←─→|
   |           ↧                      ↧                   ↧           |
   '------------------------------------------------------------------'
 */
@interface LYRUIDefaultPlaybackControlLayout : NSObject <LYRUIViewLayout>

@end

NS_ASSUME_NONNULL_END       // }
