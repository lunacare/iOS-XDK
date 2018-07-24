//
//  LYRUILargePlayableMediaContainerViewPresenter.m
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 7/2/18.
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

#import "LYRUILargePlayableMediaContainerViewPresenter.h"
#import "LYRUILargeMediaMessageContainerView.h"
#import "LYRUIPlaybackControlView.h"

@interface LYRUILargePlayableMediaContainerViewPresenter () <LYRUIPlaybackControlDelegate>

@end

@implementation LYRUILargePlayableMediaContainerViewPresenter

- (LYRUILargeMediaMessageContainerView *)viewForMessage:(LYRUIMediaMessage *)message {
    [self.mediaPlayer openMediaWithMessage:message error:nil];
    LYRUILargeMediaMessageContainerView *view = (LYRUILargeMediaMessageContainerView *)[super viewForMessage:message];
    view.playbackControlView.delegate = self;
    view.playbackControlView.playbackState = self.mediaPlayer.state;
    view.playbackControlView.playbackDuration = self.mediaPlayer.playbackDuration;
    view.playbackControlView.playbackPosition = self.mediaPlayer.playbackTime;
    view.playbackControlView.playbackMuted = self.mediaPlayer.isMuted;
    view.playbackControlView.backgroundColor = UIColor.whiteColor;
    view.progressView.hidden = YES;
    return view;
}

- (void)updateView:(__kindof LYRUILargeMediaMessageContainerView *)view withBufferProgress:(float)bufferProgress {
    view.playbackControlView.playbackBuffer = self.mediaPlayer.playbackDuration * bufferProgress;
}

- (void)updateView:(__kindof LYRUILargeMediaMessageContainerView *)view withPlaybackDuration:(NSTimeInterval)playbackDuration {
    view.playbackControlView.playbackDuration = playbackDuration;
}

- (void)updateView:(__kindof LYRUILargeMediaMessageContainerView *)view withPlaybackTime:(NSTimeInterval)playbackTime {
    view.playbackControlView.playbackPosition = playbackTime;
}

- (void)updateView:(__kindof LYRUILargeMediaMessageContainerView *)view withPlaybackState:(LYRUIMediaPlaybackState)playbackState {
    view.playbackControlView.playbackState = playbackState;
    view.playbackControlView.playbackBuffer = self.mediaPlayer.playbackDuration * self.mediaPlayer.bufferProgress;
    [self.mediaPlayer attachMediaOverlayToView:self.currentControlledView.contentView forMediaMessage:self.currentMediaMessage];
}

- (void)setupStandardMessageContainerView:(LYRUIStandardMessageContainerView *)view withMessage:(LYRUIMessageType *)message {
    [super setupStandardMessageContainerView:view withMessage:message];
    view.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    view.titleLabel.textAlignment = NSTextAlignmentCenter;
    view.footerLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - LYRUIPlaybackControlDelegate Implementation

- (void)playbackControlViewDidTapPlay:(LYRUIPlaybackControlView *)view {
    if (((LYRUILargeMediaMessageContainerView *)self.currentControlledView).playbackControlView == view) {
        [self.mediaPlayer play];
    }
}

- (void)playbackControlViewDidTapPause:(LYRUIPlaybackControlView *)view {
    if (((LYRUILargeMediaMessageContainerView *)self.currentControlledView).playbackControlView == view) {
        [self.mediaPlayer pause];
    }
}

- (void)playbackControlViewDidTapMute:(LYRUIPlaybackControlView *)view {
    if (((LYRUILargeMediaMessageContainerView *)self.currentControlledView).playbackControlView == view) {
        [self.mediaPlayer mute];
    }
}

- (void)playbackControlViewDidTapUnmute:(LYRUIPlaybackControlView *)view {
    if (((LYRUILargeMediaMessageContainerView *)self.currentControlledView).playbackControlView == view) {
        [self.mediaPlayer unmute];
    }
}

- (void)playbackControlView:(LYRUIPlaybackControlView *)view didSeekTo:(NSTimeInterval)timeInterval {
    if (((LYRUILargeMediaMessageContainerView *)self.currentControlledView).playbackControlView == view) {
        [self.mediaPlayer seekPlaybackToTime:timeInterval];
    }
}

- (void)playbackControlNeedsLayout:(LYRUIPlaybackControlView *)view {
    if (((LYRUILargeMediaMessageContainerView *)self.currentControlledView).playbackControlView == view) {
        [self.mediaPlayer layoutVideoLayer];
    }
}

@end
