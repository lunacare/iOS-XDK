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

#import "LYRUIPlayableMediaContainerViewPresenter.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "UIButton+LYRUIBlockAction.h"
#import "LYRUIStandardMessageContainerView.h"
#import "LYRUIMediaMessageContainerView.h"
#import "LYRUIImageCreating.h"
#import "LYRUIMediaMessage.h"
#import "LYRUIMediaPlaying.h"
#import <LayerKit/LayerKit.h>

static NSString *const LYRUIPlayableMediaMessageContainerPlayImage = @"Play";
static NSString *const LYRUIPlayableMediaMessageContainerPauseImage = @"Pause";
static NSString *const LYRUIPlayableMediaMessageContainerBrokenImage = @"Broken";

@interface LYRUIPlayableMediaContainerViewPresenter ()

@property (nonatomic, strong) id<LYRUIImageCreating> imageFactory;
@property (nonatomic, strong) id<LYRUIMediaPlaying> mediaPlayer;
@property (nonatomic, strong) __kindof LYRUIMediaMessageContainerView *currentControlledView;
@property (nonatomic, strong) LYRUIMediaMessage *currentMediaMessage;

@end

@implementation LYRUIPlayableMediaContainerViewPresenter

- (void)dealloc {
    [self removeObservers];
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    [super setLayerConfiguration:layerConfiguration];
    self.imageFactory = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIImageCreating)
                                                                   forClass:[self class]];
    self.mediaPlayer = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIMediaPlaying)
                                                                  forClass:[self class]];
    [self registerObservers];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LYRUIMediaPlayingDidChangePlaybackProgressNotification object:self.mediaPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LYRUIMediaPlayingDidChangeBufferProgressNotification object:self.mediaPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LYRUIMediaPlayingDidChangeStateNotification object:self.mediaPlayer];
}

- (void)registerObservers {
    [self removeObservers];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaPlayerDidChangePlaybackProgress:) name:LYRUIMediaPlayingDidChangePlaybackProgressNotification object:self.mediaPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaPlayerDidChangeBufferProgress:) name:LYRUIMediaPlayingDidChangeBufferProgressNotification object:self.mediaPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaPlayerDidChangeState:) name:LYRUIMediaPlayingDidChangeStateNotification object:self.mediaPlayer];
}

- (LYRUIMediaMessageContainerView *)viewForMessage:(LYRUIMediaMessage *)message {
    LYRUIMediaMessageContainerView *container = (LYRUIMediaMessageContainerView *)[super viewForMessage:message];
    __weak __typeof(self) weakSelf = self;
    __weak __typeof(LYRUIMediaMessageContainerView *) weakContainer = container;
    container.mediaControlButton.lyr_actionHandler = ^(UIButton *pressedButton) {
        BOOL success = [weakSelf.mediaPlayer attachMediaOverlayToView:weakContainer.contentViewContainer forMediaMessage:message];
        if (success && weakSelf.mediaPlayer.state == LYRUIMediaPlaybackStatePlaying) {
            [weakSelf.mediaPlayer pause];
            [weakSelf setupPlaybackWithContentView:weakContainer mediaMessage:message animated:YES];
            return;
        }
        if (weakSelf.currentControlledView != container) {
            // Reset the previously playing view to the default state, in
            // case we're managing a new view.
            [weakSelf.currentControlledView.progressView setPlaybackProgress:0];
            [weakSelf.currentControlledView.progressView setBufferProgress:0];
            [weakSelf setupMediaControllButton:weakSelf.currentControlledView.mediaControlButton withState:LYRUIMediaPlaybackStatePaused];
        }
        weakSelf.currentMediaMessage = message;
        weakSelf.currentControlledView = weakContainer;
        [weakSelf.mediaPlayer openMediaWithMessage:message error:nil];
        [weakSelf.mediaPlayer play];
        [weakSelf setupPlaybackWithContentView:weakContainer mediaMessage:message animated:YES];
    };
    container.mediaControlButton.enabled = YES;
    [self setupPlaybackWithContentView:container mediaMessage:message animated:NO];
    return container;
}

+ (Class<LYRUIMessageViewContainer, LYRUIStandardMessageContainerViewTheme, LYRUIConfigurable>)containerViewClass {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unimplemented subclass method +containerViewClass" userInfo:nil];
}

- (void)setupPlaybackWithContentView:(LYRUIMediaMessageContainerView *)messageContainerView mediaMessage:(LYRUIMediaMessage *)mediaMessage animated:(BOOL)animated {
    // Try to attach the media content to the mediaPlayer instance,
    // so that the view shows the up to date information about
    // the currently played media.
    BOOL success = [self.mediaPlayer attachMediaOverlayToView:messageContainerView.contentViewContainer forMediaMessage:mediaMessage];
    if (success) {
        self.currentMediaMessage = mediaMessage;
        self.currentControlledView = messageContainerView;
        if (self.mediaPlayer.playbackDuration != 0 || self.mediaPlayer.playbackTime != 0) {
            [messageContainerView.progressView setPlaybackProgress:self.mediaPlayer.playbackTime / self.mediaPlayer.playbackDuration];
        } else {
            [messageContainerView.progressView setPlaybackProgress:0];
        }
        [messageContainerView.progressView setBufferProgress:self.mediaPlayer.bufferProgress];
        [self setupMediaControllButton:messageContainerView.mediaControlButton withState:self.mediaPlayer.state];
    } else {
        [messageContainerView.progressView setPlaybackProgress:0];
        [messageContainerView.mediaControlButton setImage:[self.imageFactory imageNamed:LYRUIPlayableMediaMessageContainerPlayImage] forState:UIControlStateNormal];
    }
    
    [self updateView:messageContainerView withPlaybackDuration:self.mediaPlayer.playbackDuration];

    // In case the media content is handed via LayerKit's rich content management,
    // we have to show the progress of the transfer.
    if (mediaMessage.sourceURL == nil && mediaMessage.localSourceStatus != LYRContentTransferComplete) {
        [messageContainerView.progressView setBufferProgress:mediaMessage.localSourceProgress.completedUnitCount / mediaMessage.localSourceProgress.totalUnitCount];
    }
}

- (void)setupMediaControllButton:(UIButton *)mediaControlButton withState:(LYRUIMediaPlaybackState)state {
    switch (state) {
        case LYRUIMediaPlaybackStateNotLoaded:
        case LYRUIMediaPlaybackStatePaused:
            [mediaControlButton setImage:[self.imageFactory imageNamed:LYRUIPlayableMediaMessageContainerPlayImage] forState:UIControlStateNormal];
            break;
        case LYRUIMediaPlaybackStatePlaying:
            [mediaControlButton setImage:[self.imageFactory imageNamed:LYRUIPlayableMediaMessageContainerPauseImage] forState:UIControlStateNormal];
            break;
        default:
            [mediaControlButton setImage:[self.imageFactory imageNamed:LYRUIPlayableMediaMessageContainerBrokenImage] forState:UIControlStateNormal];
            break;
    }
}

#pragma mark - LYRUIMediaPlaybackDelegate implementations

- (void)mediaPlayerDidChangePlaybackProgress:(NSNotification *)notification {
    if (!self.currentMessageOpenedInMediaPlayer) {
        return;
    }
    float playbackProgress = [notification.userInfo[LYRUIMediaPlayingProgressKey] floatValue];
    [self.currentControlledView.progressView setPlaybackProgress:playbackProgress];
    [self updateView:self.currentControlledView withPlaybackTime:self.mediaPlayer.playbackTime];
}

- (void)mediaPlayerDidChangeBufferProgress:(NSNotification *)notification {
    if (!self.currentMessageOpenedInMediaPlayer) {
        return;
    }
    float bufferProgress = [notification.userInfo[LYRUIMediaPlayingProgressKey] floatValue];
    [self.currentControlledView.progressView setBufferProgress:bufferProgress];
    [self updateView:self.currentControlledView withBufferProgress:self.mediaPlayer.bufferProgress];
}

- (void)mediaPlayerDidChangeState:(NSNotification *)notification {
    if (!self.currentMessageOpenedInMediaPlayer) {
        return;
    }
    LYRUIMediaPlaybackState state = [notification.userInfo[LYRUIMediaPlayingStateKey] integerValue];
    [self setupMediaControllButton:self.currentControlledView.mediaControlButton withState:state];
    [self updateView:self.currentControlledView withPlaybackState:state];
}

- (BOOL)currentMessageOpenedInMediaPlayer {
    return [self.currentMediaMessage.messagePart.identifier isEqual:self.mediaPlayer.currentMediaMessageOpened.messagePart.identifier];
}

#pragma mark - UI Updates based on Media Player Changes

- (void)updateView:(__kindof LYRUIMediaMessageContainerView *)view withBufferProgress:(float)bufferProgress {

}

- (void)updateView:(__kindof LYRUIMediaMessageContainerView *)view withPlaybackDuration:(NSTimeInterval)playbackDuration {
    
}

- (void)updateView:(__kindof LYRUIMediaMessageContainerView *)view withPlaybackTime:(NSTimeInterval)playbackTime {

}

- (void)updateView:(__kindof LYRUIMediaMessageContainerView *)view withPlaybackState:(LYRUIMediaPlaybackState)playbackState {

}

@end
