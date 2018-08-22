//
//  LYRUIMediaHandler.m
//  Pods
//
//  Created by Klemen Verdnik on 6/4/18.
//

#import "LYRUIMediaHandler.h"
#import <AVFoundation/AVFoundation.h>
#import "LYRMessagePart+LYRUIHelpers.h"

NSString *const LYRUIMediaHandlerErrorDomain = @"LYRUIMediaHandlerErrorDomain";
NSString *const LYRUIMediaPlayingDidChangePlaybackProgressNotification = @"LYRUIMediaPlayingDidChangePlaybackProgressNotification";
NSString *const LYRUIMediaPlayingDidChangeBufferProgressNotification = @"LYRUIMediaPlayingDidChangeBufferProgressNotification";
NSString *const LYRUIMediaPlayingProgressKey = @"progress";
NSString *const LYRUIMediaPlayingDidChangeStateNotification = @"LYRUIMediaPlayingDidChangeStateNotification";
NSString *const LYRUIMediaPlayingStateKey = @"state";
NSString *const LYRUIMediaPlayingDidChangeSizeNotification = @"LYRUIMediaPlayingDidChangeSizeNotification";
NSString *const LYRUIMediaPlayingSizeKey = @"size";

@interface LYRUIMediaPlaybackControlContext : NSObject

@property (nonatomic, readonly, strong) UIView *viewToOverlay;
@property (nonatomic, readonly, weak) UIControl *playbackControl;
@property (nonatomic, readonly, strong) LYRUIMediaMessage *mediaMessage;

+ (instancetype)controlContextWithControl:(UIControl *)control viewToOverlay:(UIView *)viewToOverlay mediaMessage:(LYRUIMediaMessage *)mediaMessage;

@end

@implementation LYRUIMediaPlaybackControlContext

- (instancetype)initWithControl:(UIControl *)control viewToOverlay:(UIView *)viewToOverlay mediaMessage:(LYRUIMediaMessage *)mediaMessage
{
    self = [super init];
    if (self) {
        _playbackControl = control;
        _viewToOverlay = viewToOverlay;
        _mediaMessage = mediaMessage;
    }
    return self;
}

+ (instancetype)controlContextWithControl:(UIControl *)control viewToOverlay:(UIView *)viewToOverlay mediaMessage:(LYRUIMediaMessage *)mediaMessage
{
    return [[self alloc] initWithControl:control viewToOverlay:viewToOverlay mediaMessage:mediaMessage];
}

@end

@interface LYRUIMediaHandler () <LYRProgressDelegate>

@property (nonatomic, readonly) AVPlayer *player;
@property (nonatomic, readonly) AVPlayerLayer *videoLayer;
@property (nonatomic, readwrite) AVPlayerItem *playerItem;
@property (nonatomic, readwrite) LYRProgress *messagePartTransferProgress;
@property (nonatomic, readwrite) UIView *view;
@property (nonatomic, readwrite, strong) id timeObserver;

@end

@implementation LYRUIMediaHandler

#pragma mark - LYRUIConfigurable Implementation

@synthesize layerConfiguration;
@synthesize state = _state;
@synthesize currentMediaMessageOpened = _currentMediaMessageOpened;
@synthesize playbackDuration = _playbackDuration;
@synthesize playbackTime = _playbackTime;
@synthesize bufferProgress = _bufferProgress;
@synthesize delegate = _delegate;
@synthesize muted = _muted;
@synthesize mediaSize = _mediaSize;

- (nonnull instancetype)initWithConfiguration:(nonnull LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
        _player = [AVPlayer playerWithPlayerItem:nil];
        _videoLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _videoLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        _state = LYRUIMediaPlaybackStateNotLoaded;
        _playbackTime = 0.0f;
        _playbackDuration = 0.0f;
        _bufferProgress = 0.0f;
        [self registerPeriodicTimeObserver];
    }
    return self;
}

- (void)dealloc {
    [self.player removeTimeObserver:self.timeObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self.player forKeyPath:@"status"];
}

#pragma mark - AVPlayerItem Status Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.playerItem && [keyPath isEqualToString:@"status"]) {
        if (self.playerItem.status == AVPlayerItemStatusFailed) {
            self.state = LYRUIMediaPlaybackStateInvalid;
        }
    }
}

#pragma mark - LYRUIMediaPlaying Content Loading

- (BOOL)openMediaWithMessage:(LYRUIMediaMessage *)mediaMessage error:(NSError * _Nullable __autoreleasing *)error {
    if ([mediaMessage.messagePart.identifier isEqual:_currentMediaMessageOpened.messagePart.identifier]) {
        // Already open.
        if (self.state != LYRUIMediaPlaybackStateLoading) {
            // Only skip if content already loaded.
            return YES;
        } else {
            [self layoutVideoLayer];
        }
    }

    // Make sure to eject the previous media from the player.
    [self closeMedia];
    _playbackDuration = mediaMessage.duration;

    if (mediaMessage.sourceURL) {
        // In case the media is available via remote URL, ready for streaming.
        self.playerItem = [AVPlayerItem playerItemWithURL:mediaMessage.sourceURL];
    } else if (mediaMessage.sourceLocalURL) {
        // In case the media is available via LayerKit's LYRMessagePart rich content,
        // which is persisted on disk ready for consumption.
        self.playerItem = [AVPlayerItem playerItemWithURL:mediaMessage.sourceLocalURL];
    }

    // Load the media into the player.
    if (self.playerItem) {
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        self.state = LYRUIMediaPlaybackStatePaused;
        // Detach self from previous transfer progress update caller.
        [self configureTransferProgressTracking:nil];
    } else {
        // Content has to be loaded first.
        self.state = LYRUIMediaPlaybackStateLoading;

        // Update the transfer progress.
        [self configureTransferProgressTracking:mediaMessage.messagePart];
    }
    self.mediaSize = self.playerItem.presentationSize;
    
    // Register AVPlayerItem notifications.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];

    _currentMediaMessageOpened = mediaMessage;
    return NO;
}

- (void)closeMedia {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self detachMediaOverlay];
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
    }
    self.playerItem = nil;
    [self.player pause];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.state = LYRUIMediaPlaybackStateNotLoaded;
}

- (void)configureTransferProgressTracking:(nullable LYRMessagePart *)messagePart {
    LYRMessagePart *sourcePart = [messagePart childPartWithRole:@"source"];
    self.messagePartTransferProgress.delegate = nil;
    self.messagePartTransferProgress = sourcePart.progress;
    if (sourcePart) {
        self.messagePartTransferProgress.delegate = self;
    }
}

#pragma mark - Notification handling

- (void)playerItemDidFinishPlaying:(NSNotification *)notification {
    [self setState:self.player.rate == 0 ? LYRUIMediaPlaybackStatePaused : LYRUIMediaPlaybackStatePlaying];
}

#pragma mark - LYRUIMediaPlaying Playback Control

- (void)play {
    if (!CGSizeEqualToSize(self.mediaSize, self.playerItem.presentationSize)) {
        self.mediaSize = self.playerItem.presentationSize;
        if ([self.delegate respondsToSelector:@selector(mediaPlayer:didChangeSize:)]) {
            [self.delegate mediaPlayer:self didChangeSize:self.mediaSize];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:LYRUIMediaPlayingDidChangeSizeNotification object:self userInfo:@{ LYRUIMediaPlayingSizeKey : [NSValue valueWithCGSize:self.mediaSize] }];
    }
    if (self.state == LYRUIMediaPlaybackStatePaused) {
        if (CMTimeCompare(self.player.currentItem.currentTime, self.player.currentItem.asset.duration) >= 0) {
            [self seekPlaybackToTime:0];
        }
        self.state = LYRUIMediaPlaybackStatePlaying;
        [self.player play];
    }
}

- (void)pause {
    if (self.state == LYRUIMediaPlaybackStatePlaying) {
        [self.player pause];
        self.state = LYRUIMediaPlaybackStatePaused;
    }
}

- (void)registerPeriodicTimeObserver {
    // Invoke callback every half second
    __weak __typeof(self) weakSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.1, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        __strong __typeof(self) strongSelf = weakSelf;

        // Report playback progress.
        float currentTime = CMTimeGetSeconds(time);
        float playbackDuration = CMTimeGetSeconds(strongSelf.player.currentItem.duration);
        if (CMTimeCompare(strongSelf.player.currentItem.duration, kCMTimeIndefinite) != 0) {
            strongSelf->_playbackDuration = playbackDuration;
        }
        if (strongSelf->_playbackTime != currentTime) {
            strongSelf->_playbackTime = currentTime;
            float playbackProgress = (strongSelf.playbackDuration != 0 && strongSelf->_playbackTime != 0) ? strongSelf.playbackTime / strongSelf.playbackDuration : 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:LYRUIMediaPlayingDidChangePlaybackProgressNotification object:strongSelf userInfo:@{ LYRUIMediaPlayingProgressKey : @(playbackProgress) }];
            if ([strongSelf.delegate respondsToSelector:@selector(mediaPlayer:didChangePlaybackProgress:)]) {
                [strongSelf.delegate mediaPlayer:strongSelf didChangePlaybackProgress:playbackProgress];
            }
        }

        // Report buffer progress.
        NSValue *lastTimeRange = strongSelf.playerItem.loadedTimeRanges.lastObject;
        if (lastTimeRange) {
            CMTimeRange lastLoadedTimeRange = [lastTimeRange CMTimeRangeValue];
            CMTime loadedEndTime = CMTimeRangeGetEnd(lastLoadedTimeRange);
            float bufferProgressInTime = CMTimeGetSeconds(loadedEndTime);
            float bufferProgress = bufferProgressInTime / strongSelf.playbackDuration;
            strongSelf.bufferProgress = bufferProgress;
        }

        // Report playback state.
        [strongSelf setState:strongSelf.player.rate == 0 ? LYRUIMediaPlaybackStatePaused : LYRUIMediaPlaybackStatePlaying];
    }];
}

- (void)seekPlaybackToProgress:(float)playbackProgress {
    const int32_t preferredTimeScale = 600;
    [self.player seekToTime:CMTimeMakeWithSeconds((_playbackDuration / _playbackTime) * playbackProgress, preferredTimeScale)];
}

- (void)seekPlaybackToTime:(NSTimeInterval)playbackTime {
    const int32_t preferredTimeScale = 600;
    [self.player seekToTime:CMTimeMakeWithSeconds(playbackTime, preferredTimeScale)];
    [self setState:self.player.rate == 0 ? LYRUIMediaPlaybackStatePaused : LYRUIMediaPlaybackStatePlaying];
}

- (void)setState:(LYRUIMediaPlaybackState)state {
    if (_state == state) {
        return;
    }
    _state = state;
    [[NSNotificationCenter defaultCenter] postNotificationName:LYRUIMediaPlayingDidChangeStateNotification object:self userInfo:@{ LYRUIMediaPlayingStateKey : @(state) }];
    if ([self.delegate respondsToSelector:@selector(mediaPlayer:didChangeState:)]) {
        [self.delegate mediaPlayer:self didChangeState:self.state];
    }
}

- (void)setBufferProgress:(float)bufferProgress {
    if (_bufferProgress == bufferProgress) {
        return;
    }
    _bufferProgress = bufferProgress;
    [[NSNotificationCenter defaultCenter] postNotificationName:LYRUIMediaPlayingDidChangeBufferProgressNotification object:self userInfo:@{ LYRUIMediaPlayingProgressKey : @(self.bufferProgress) }];
    if ([self.delegate respondsToSelector:@selector(mediaPlayer:didChangeBufferProgress:)]) {
        [self.delegate mediaPlayer:self didChangeBufferProgress:self.bufferProgress];
    }
}

#pragma mark - LYRUIMediaPlaying Audio Control

- (BOOL)isMuted {
    return self.player.isMuted;
}

- (void)mute {
    [self.player setMuted:YES];
}

- (void)unmute {
    [self.player setMuted:NO];
}

#pragma mark - LYRUIMediaPlaying UI Overlay

- (BOOL)attachMediaOverlayToView:(UIView *)view forMediaMessage:(nullable LYRUIMediaMessage *)mediaMessage {
    if (view == _view) {
        // If the overlay is already attached.
        return YES;
    }
    if (![mediaMessage.messagePart.identifier isEqual:self.currentMediaMessageOpened.messagePart.identifier]) {
        // Ignore, if the view representing the message is not the same as
        // the currently lodaded media message.
        return NO;
    }
    [self detachMediaOverlay];
    _view = view;
    [self layoutVideoLayer];
    [self.view.layer addSublayer:self.videoLayer];
    [self.view setNeedsLayout];
    _playbackDuration = mediaMessage.duration;
    [self configureTransferProgressTracking:mediaMessage.messagePart];
    return YES;
}

- (void)layoutVideoLayer {
    self.videoLayer.frame = CGRectMake(0, 0, self.view.layer.frame.size.width, self.view.layer.frame.size.height);
    self.videoLayer.bounds = CGRectMake(0, 0, self.view.layer.bounds.size.width, self.view.layer.bounds.size.height);
}

- (void)detachMediaOverlay {
    [self.videoLayer removeFromSuperlayer];
}

#pragma mark - LYRProgressDelegate Implementation

- (void)progressDidChange:(LYRProgress *)progress {
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.bufferProgress = progress.fractionCompleted;
    });
}

@end
