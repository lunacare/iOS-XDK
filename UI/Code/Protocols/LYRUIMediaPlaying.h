//
//  LYRUIMediaPlaying.h
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 6/4/18.
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

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LYRUIMediaMessage.h"
#import "LYRUIProgressView.h"

NS_ASSUME_NONNULL_BEGIN     // {

@protocol LYRUIMediaPlaybackDelegate;

/**
 @abstract An enum value representing the current state of the media player.
 */
typedef enum : NSUInteger {
    LYRUIMediaPlaybackStateNotLoaded,   // Don't have the content avaialbe.
    LYRUIMediaPlaybackStateLoading,     // Loading content.
    LYRUIMediaPlaybackStatePaused,      // Content available, but not playing (paused).
    LYRUIMediaPlaybackStatePlaying,     // Playing content.
    LYRUIMediaPlaybackStateInvalid,     // Content not accessible.
} LYRUIMediaPlaybackState;

/**
 @abstract The name of the media player notification that is posted every time
   the plyaback progress changes (backward or forward).
 */
extern NSString *const LYRUIMediaPlayingDidChangePlaybackProgressNotification;

/**
 @abstract The name of the media player notification that is posted every time
   the buffer progress changes.
 */
extern NSString *const LYRUIMediaPlayingDidChangeBufferProgressNotification;

/**
 @abstract The key to the progress value (@c float) of the playback progress
   change notification.
 */
extern NSString *const LYRUIMediaPlayingProgressKey;

/**
 @abstract The name of the media player notification that is posted every time
   the media player state changes.
 */
extern NSString *const LYRUIMediaPlayingDidChangeStateNotification;

/**
 @abstract The key to the state value (@c LYRUIMediaPlaybackState) of the
   media player state change notification.
 */
extern NSString *const LYRUIMediaPlayingStateKey;

/**
 @abstract The name of the media player notification that's posted every time
   the video's dimensions change.
 */
extern NSString *const LYRUIMediaPlayingDidChangeSizeNotification;

/**
 @abstract The key to the size value (@c NSValue(CGSize)) of the
   media player video size change notification.
 */
extern NSString *const LYRUIMediaPlayingSizeKey;

/**
 @abstract A protocol to which the media playback implementation should
   conform to.
 */
@protocol LYRUIMediaPlaying <NSObject>

#pragma mark - Player State

/**
 @abstract Represents the current state of the player.
 */
@property (nonatomic, assign, readonly) LYRUIMediaPlaybackState state;

#pragma mark - Content Loading

/**
 @abstract The media message used to load the media content into the player.
 */
@property (nonatomic, strong, readonly, nullable) LYRUIMediaMessage *currentMediaMessageOpened;

/**
 @abstract The current progress of the buffer.
 */
@property (nonatomic, assign, readonly) float bufferProgress;

/**
 @abstract Loads the media content into the player found in the media message.
 @param mediaMessage The Media Message either containing or pointing to the
   media content.
 @param error An error that occured while trying to load or preprare the content.
 @return Returns @c YES if the content can be retireved and loaded for playback;
   otherwise @c NO, if the content cannot be accessible.
 */
- (BOOL)openMediaWithMessage:(LYRUIMediaMessage *)mediaMessage error:(NSError **)error;

/**
 @abstract Unloads the media content from the player.
 */
- (void)closeMedia;

#pragma mark - Playback Control

/**
 @abstract The total time of the media content.
 */
@property (nonatomic, assign, readonly) NSTimeInterval playbackDuration;

/**
 @abstract The current time of the playback.
 */
@property (nonatomic, assign, readonly) NSTimeInterval playbackTime;

/**
 @abstract Starts playing or resumes the playback of media content (if loaded).
 */
- (void)play;

/**
 @abstract Pauses the media playback.
 */
- (void)pause;

/**
 @abstract Sets the playback time based on the percentage.
 @param playbackProgress A normalized percentage value (1.00 being at 100%).
 */
- (void)seekPlaybackToProgress:(float)playbackProgress;

/**
 @abstract Sets the playback time based on time.
 @param playbackTime Time value represented in seconds (1.00 being one second).
 */
- (void)seekPlaybackToTime:(NSTimeInterval)playbackTime;

#pragma mark - Audio Control

/**
 @abstract Indicates if the sound output is muted.
 */
@property (nonatomic, assign, readonly, getter=isMuted) BOOL muted;

/**
 @abstract Mutes the sound output.
 */
- (void)mute;

/**
 @abstract Unmutes the sound output.
 */
- (void)unmute;

#pragma mark - UI Overlay

/**
 @abstract The original media size, if video is loaded.
 */
@property (nonatomic, assign) CGSize mediaSize;

/**
 @abstract Adds (transfers) a video playback layer onto the given @c UIView.
 @param view The view to which the video layer will be added at the top of the
   layer stack.
 @parak mediaMessage The media message associated with the content view that
   the player should attach the overlay to. If given mediaMessage is not the
   same as the one opened by the player, overlay won't be attached to the view.
 @return Returns @c YES if the overlay was successfully attached to the view;
   otherwise @c NO.
 @discussion Only one view can have the video overlay attached to it. If overlay
   is transferred if it's attached to a different view.
 */
- (BOOL)attachMediaOverlayToView:(UIView *)view forMediaMessage:(nullable LYRUIMediaMessage *)mediaMessage;

/**
 @abstract Removes the video overlay from the last view it was attached on.
 */
- (void)detachMediaOverlay;

/**
 @abstract Layouts video layer by stretching it across the attached view.
 @discussion Call whenever super view's layout changes.
 */
- (void)layoutVideoLayer;

#pragma mark - Progress Reporting

/**
 @abstract The delegate that is responsible of tracking progress of the
   media player buffer and playback and the playback state.
 */
@property (nonatomic, weak, readwrite) id<LYRUIMediaPlaybackDelegate> delegate;

@end

/**
 @abstract A protocol representing the callbacks that should be handled
   by the progress tracking delegate.
 */
@protocol LYRUIMediaPlaybackDelegate <NSObject>

/**
 @abstract Sender calls the delegate method when the playback's current time
   changes.
 @param player The sender informing about the progress change.
 @param playbackProgress The progress in percentage (1.00 being 100%).
 */
- (void)mediaPlayer:(id<LYRUIMediaPlaying>)player didChangePlaybackProgress:(float)playbackProgress;

/**
 @abstract Sender calls the delegate method when the media player's
   buffered content is increased.
 @param player The sender informing about the progress change.
 @param bufferProgress The progress in percentage (1.00 being 100%).
 */
- (void)mediaPlayer:(id<LYRUIMediaPlaying>)player didChangeBufferProgress:(float)bufferProgress;

/**
 @abstract Sender calls the delegate method when the media player's state changes.
 @param player The sender informing about the state change.
 */
- (void)mediaPlayer:(id<LYRUIMediaPlaying>)player didChangeState:(LYRUIMediaPlaybackState)state;

/**
 @abstract Sender calls the delegate method when the media player's presentation size changes.
 @param size The sender informing about the size change.
 */
- (void)mediaPlayer:(id<LYRUIMediaPlaying>)player didChangeSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END       // }
