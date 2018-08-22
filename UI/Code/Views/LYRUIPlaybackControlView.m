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

#import "LYRUIPlaybackControlView.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIProgressView.h"
#import "LYRUIImageCreating.h"

static NSString *const LYRUIPlaybackControlViewPauseImage = @"playback-control-pause";
static NSString *const LYRUIPlaybackControlViewPlayImage = @"playback-control-play";
static NSString *const LYRUIPlaybackControlViewBrokenImage = @"Broken";
static NSString *const LYRUIPlaybackControlViewMutedImage = @"playback-control-muted";
static NSString *const LYRUIPlaybackControlViewUnmutedImage = @"playback-control-unmuted";
static NSString *const LYRUIPlaybackControlViewRewind10Image = @"playback-control-rewind-10";
static NSString *const LYRUIPlaybackControlViewRewind15Image = @"playback-control-rewind-15";
static NSString *const LYRUIPlaybackControlViewFastforward10Image = @"playback-control-fastforward-10";
static NSString *const LYRUIPlaybackControlViewFastforward15Image = @"playback-control-fastforward-15";

NSTimeInterval const LYRUIPlaybackSeekDistance = 10.f;

@interface LYRUIPlaybackControlView ()

@property (nonatomic, readonly, strong) id<LYRUIImageCreating> imageFactory;
@property (nonatomic, readonly) LYRUIProgressView *progressView;
@property (nonatomic, readonly) CALayer *topBorderLayer;
@property (nonatomic, readonly) UIImage *imagePause;
@property (nonatomic, readonly) UIImage *imagePlay;
@property (nonatomic, readonly) UIImage *imageBroken;
@property (nonatomic, readonly) UIImage *imageMuted;
@property (nonatomic, readonly) UIImage *imageUnmuted;
@property (nonatomic, readonly) UIImage *imageFF10;
@property (nonatomic, readonly) UIImage *imageFF15;
@property (nonatomic, readonly) UIImage *imageRW10;
@property (nonatomic, readonly) UIImage *imageRW15;

@end

@implementation LYRUIPlaybackControlView

@synthesize layerConfiguration = _layerConfiguration;
@synthesize layout = _layout;

#pragma mark - Initialization

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self lyr_commonInitWithCoder:nil frame:CGRectZero];
        self.layerConfiguration = configuration;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self lyr_commonInitWithCoder:nil frame:frame];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self lyr_commonInitWithCoder:aDecoder frame:CGRectZero];
    }
    return self;
}

- (void)lyr_commonInitWithCoder:(NSCoder *)coder frame:(CGRect)frame {
    [self addSeekAndAudioControlsWithCoder:coder frame:frame];
    [self addPlaybackControlsWithCoder:coder frame:frame];
    _topBorderLayer = [CALayer layer];
    _topBorderLayer.backgroundColor = [[UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:0.6] CGColor];
    [self.layer addSublayer:_topBorderLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.topBorderLayer.anchorPoint = CGPointZero;
    self.topBorderLayer.frame = CGRectMake(0, 0, self.frame.size.width, .5f);
    if ([self.delegate respondsToSelector:@selector(playbackControlNeedsLayout:)]) {
        [self.delegate playbackControlNeedsLayout:self];
    }
}

- (void)addSeekAndAudioControlsWithCoder:(NSCoder *)coder frame:(CGRect)frame {
    _seekAndAudioContainerView = coder ? [[UIView alloc] initWithCoder:coder] : [[UIView alloc] initWithFrame:frame];
    [self addSubview:_seekAndAudioContainerView];

    _currentTimeLabel = coder ? [[UILabel alloc] initWithCoder:coder] : [[UILabel alloc] initWithFrame:frame];
    _currentTimeLabel.textAlignment = NSTextAlignmentLeft;
    _currentTimeLabel.font = [UIFont systemFontOfSize:14.0];
    _currentTimeLabel.textColor = UIColor.blackColor;

    [_seekAndAudioContainerView addSubview:_currentTimeLabel];

    _progressView = coder ? [[LYRUIProgressView alloc] initWithCoder:coder] : [[LYRUIProgressView alloc] initWithFrame:frame];
    [_seekAndAudioContainerView addSubview:_progressView];

    _seekSlider = coder ? [[UISlider alloc] initWithCoder:coder] : [[UISlider alloc] initWithFrame:frame];
    _seekSlider.minimumTrackTintColor = [UIColor colorWithRed:16.0/255.0 green:148.0/255.0 blue:208.0/255.0 alpha:1.0];
    _seekSlider.maximumTrackTintColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:0.2];
    [_seekSlider addTarget:self action:@selector(didChangeSlider:) forControlEvents:UIControlEventValueChanged];
    [_seekAndAudioContainerView addSubview:_seekSlider];

    _muteButton = coder ? [[UIButton alloc] initWithCoder:coder] : [[UIButton alloc] initWithFrame:frame];
    _muteButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_muteButton addTarget:self action:@selector(didTapMuteButton:) forControlEvents:UIControlEventTouchUpInside];
    _muteButton.tintColor = [UIColor colorWithRed:27.0/255.0 green:28.0/255.0 blue:29.0/255.0 alpha:1.0];

    [_seekAndAudioContainerView addSubview:_muteButton];
}

- (void)addPlaybackControlsWithCoder:(NSCoder *)coder frame:(CGRect)frame {
    _playbackContainerView = coder ? [[UIView alloc] initWithCoder:coder] : [[UIView alloc] initWithFrame:frame];
    [self addSubview:_playbackContainerView];

    _seekBackwardButton = coder ? [[UIButton alloc] initWithCoder:coder] : [[UIButton alloc] initWithFrame:frame];
    _seekBackwardButton.tintColor = [UIColor colorWithRed:27.0/255.0 green:28.0/255.0 blue:29.0/255.0 alpha:1.0];
    _seekBackwardButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_seekBackwardButton addTarget:self action:@selector(didTapSeekButton:) forControlEvents:UIControlEventTouchUpInside];
    [_playbackContainerView addSubview:_seekBackwardButton];

    _playbackControlButton = coder ? [[UIButton alloc] initWithCoder:coder] : [[UIButton alloc] initWithFrame:frame];
    _playbackControlButton.tintColor = [UIColor colorWithRed:27.0/255.0 green:28.0/255.0 blue:29.0/255.0 alpha:1.0];
    _playbackControlButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_playbackControlButton addTarget:self action:@selector(didTapPlay:) forControlEvents:UIControlEventTouchUpInside];
    [_playbackContainerView addSubview:_playbackControlButton];

    _seekForwardButton = coder ? [[UIButton alloc] initWithCoder:coder] : [[UIButton alloc] initWithFrame:frame];
    _seekForwardButton.tintColor = [UIColor colorWithRed:27.0/255.0 green:28.0/255.0 blue:29.0/255.0 alpha:1.0];
    _seekForwardButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_seekForwardButton addTarget:self action:@selector(didTapSeekButton:) forControlEvents:UIControlEventTouchUpInside];
    [_playbackContainerView addSubview:_seekForwardButton];
}

#pragma mark - UI Controls Callbacks

- (void)didChangeSlider:(UISlider *)slider {
    if ([self.delegate respondsToSelector:@selector(playbackControlView:didSeekTo:)]) {
        [self.delegate playbackControlView:self didSeekTo:slider.value];
    }
}

- (void)didTapMuteButton:(UIButton *)muteButton {
    if (self.playbackMuted) {
        _playbackMuted = NO;
        if ([self.delegate respondsToSelector:@selector(playbackControlViewDidTapUnmute:)]) {
            [self.delegate playbackControlViewDidTapUnmute:self];
        }
    } else {
        _playbackMuted = YES;
        if ([self.delegate respondsToSelector:@selector(playbackControlViewDidTapMute:)]) {
            [self.delegate playbackControlViewDidTapMute:self];
        }
    }
    [self updateButtonImages];
}

- (void)didTapPlay:(UIButton *)playButton {
    if (self.playbackState == LYRUIMediaPlaybackStatePlaying) {
        if ([self.delegate respondsToSelector:@selector(playbackControlViewDidTapPlay:)]) {
            [self.delegate playbackControlViewDidTapPause:self];
        }
    } else if (self.playbackState == LYRUIMediaPlaybackStatePaused) {
        if ([self.delegate respondsToSelector:@selector(playbackControlViewDidTapPause:)]) {
            [self.delegate playbackControlViewDidTapPlay:self];
        }
    }
}

- (void)didTapSeekButton:(UIButton *)seekButton {
    if (seekButton == self.seekBackwardButton) {
        if ([self.delegate respondsToSelector:@selector(playbackControlView:didSeekTo:)]) {
            NSTimeInterval newPlaybackPosition = MAX(0, self.playbackPosition - LYRUIPlaybackSeekDistance);
            [self.delegate playbackControlView:self didSeekTo:newPlaybackPosition];
        }
    } else if (seekButton == self.seekForwardButton) {
        if ([self.delegate respondsToSelector:@selector(playbackControlView:didSeekTo:)]) {
            NSTimeInterval newPlaybackPosition = MIN(self.playbackDuration, self.playbackPosition + LYRUIPlaybackSeekDistance);
            [self.delegate playbackControlView:self didSeekTo:newPlaybackPosition];
        }
    }
}

#pragma mark - LYRUIConfigurable Implementation

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    if (self.layout == nil) {
        self.layout = [layerConfiguration.injector layoutForViewClass:[self class]];
    }
    if (self.layout == nil) {
        self.layout = [LYRUIDefaultPlaybackControlLayout new];
    }
    _imageFactory = [self.layerConfiguration.injector protocolImplementation:@protocol(LYRUIImageCreating) forClass:[self class]];
    _imagePause = [[self.imageFactory imageNamed:LYRUIPlaybackControlViewPauseImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _imagePlay = [[self.imageFactory imageNamed:LYRUIPlaybackControlViewPlayImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _imageBroken = [[self.imageFactory imageNamed:LYRUIPlaybackControlViewBrokenImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _imageMuted = [[self.imageFactory imageNamed:LYRUIPlaybackControlViewMutedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _imageUnmuted = [[self.imageFactory imageNamed:LYRUIPlaybackControlViewUnmutedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _imageFF10 = [[self.imageFactory imageNamed:LYRUIPlaybackControlViewFastforward10Image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _imageFF15 = [[self.imageFactory imageNamed:LYRUIPlaybackControlViewFastforward15Image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _imageRW10 = [[self.imageFactory imageNamed:LYRUIPlaybackControlViewRewind10Image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _imageRW15 = [[self.imageFactory imageNamed:LYRUIPlaybackControlViewRewind15Image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.seekBackwardButton setImage:self.imageRW10 forState:UIControlStateNormal];
    [self.seekForwardButton setImage:self.imageFF10 forState:UIControlStateNormal];
}

- (void)setLayout:(id<LYRUIViewLayout>)layout {
    if (self.layout) {
        [self.layout removeConstraintsFromView:self];
    }
    _layout = layout;
    [layout addConstraintsInView:self];
}

#pragma mark - State Management

/**
 @abstract Changes the playback control access, and its icons.
 @param playbackState The new playback state of the media player.
 */
- (void)setPlaybackState:(LYRUIMediaPlaybackState)playbackState {
    _playbackState = playbackState;
    BOOL enabled = YES;
    switch (playbackState) {
        case LYRUIMediaPlaybackStatePaused:
        case LYRUIMediaPlaybackStatePlaying:
            enabled = YES;
            break;
        case LYRUIMediaPlaybackStateLoading:
        case LYRUIMediaPlaybackStateInvalid:
        default:
            enabled = NO;
            break;
    }
    self.muteButton.enabled = enabled;
    self.seekSlider.enabled = enabled;
    self.playbackControlButton.enabled = enabled;
    self.seekBackwardButton.enabled = enabled;
    self.seekForwardButton.enabled = enabled;
    [self updateButtonImages];
}

- (void)updateButtonImages {
    [self.muteButton setImage:self.isPlaybackMuted ? self.imageMuted : self.imageUnmuted forState:UIControlStateNormal];
    UIImage *playbackButtonImage = nil;
    switch (self.playbackState) {
        case LYRUIMediaPlaybackStatePlaying:
            playbackButtonImage = self.imagePause;
            break;
        case LYRUIMediaPlaybackStateLoading:
        case LYRUIMediaPlaybackStatePaused:
            playbackButtonImage = self.imagePlay;
            break;
        default:
            playbackButtonImage = self.imageBroken;
            break;
    }
    [self.playbackControlButton setImage:playbackButtonImage forState:UIControlStateNormal];
}

/**
 @abstract Changes the total playback time, used to calculate the
   seek bar position.
 @param playbackDuration New media duration.
 */
- (void)setPlaybackDuration:(NSTimeInterval)playbackDuration {
    _playbackDuration = playbackDuration;
    [self updateTimeComponents];
}

/**
 @abstract Changes the current playback time, used to calculate the
   seek bar position.
 @param playbackPosition New current playback time.
 */
- (void)setPlaybackPosition:(NSTimeInterval)playbackPosition {
    _playbackPosition = playbackPosition;
    [self updateTimeComponents];
}

/**
 @abstract Changes the current playback's buffer availability in time unit.
 @param playbackBuffer The time value of how much the media has been buffered to.
 */
- (void)setPlaybackBuffer:(NSTimeInterval)playbackBuffer {
    _playbackBuffer = playbackBuffer;
    [self updateTimeComponents];
}

- (void)updateTimeComponents {
    self.currentTimeLabel.text = [self formattedPlaybackPosition];
    self.seekSlider.minimumValue = 0;
    self.seekSlider.maximumValue = self.playbackDuration;
    self.progressView.bufferProgress = self.playbackBuffer / self.playbackDuration;
    [self.seekSlider setValue:self.playbackPosition animated:YES];
}

- (NSString *)formattedPlaybackPosition
{
    static dispatch_once_t onceToken;
    static NSDateComponentsFormatter *dateComponentsFormatter;
    dispatch_once(&onceToken, ^{
        dateComponentsFormatter = [NSDateComponentsFormatter new];
        dateComponentsFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
        dateComponentsFormatter.allowedUnits = (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
    });
    return [dateComponentsFormatter stringFromTimeInterval:self.playbackPosition];
}

@end

@interface LYRUIDefaultPlaybackControlLayout ()

@property (nonatomic, strong) NSMutableArray *constraints;

@end

@implementation LYRUIDefaultPlaybackControlLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.constraints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] init];
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[self class]];
}

- (void)addConstraintsInView:(LYRUIPlaybackControlView *)view {
    view.seekAndAudioContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    view.currentTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    view.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    view.seekSlider.translatesAutoresizingMaskIntoConstraints = NO;
    view.muteButton.translatesAutoresizingMaskIntoConstraints = NO;
    view.playbackContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    view.seekBackwardButton.translatesAutoresizingMaskIntoConstraints = NO;
    view.playbackControlButton.translatesAutoresizingMaskIntoConstraints = NO;
    view.seekForwardButton.translatesAutoresizingMaskIntoConstraints = NO;

    // These constraints link the two container views (seekAndAudioContainerView,
    // and playbackContainerView) together.
    [self.constraints addObject:[view.seekAndAudioContainerView.topAnchor constraintEqualToAnchor:view.topAnchor]];
    [self.constraints addObject:[view.seekAndAudioContainerView.rightAnchor constraintEqualToAnchor:view.rightAnchor]];
    [self.constraints addObject:[view.seekAndAudioContainerView.leftAnchor constraintEqualToAnchor:view.leftAnchor]];
    [self.constraints addObject:[view.seekAndAudioContainerView.bottomAnchor constraintEqualToAnchor:view.playbackContainerView.topAnchor]];
    [self.constraints addObject:[view.seekAndAudioContainerView.heightAnchor constraintGreaterThanOrEqualToConstant:48.f]];
    [self.constraints addObject:[view.playbackContainerView.rightAnchor constraintEqualToAnchor:view.rightAnchor]];
    [self.constraints addObject:[view.playbackContainerView.leftAnchor constraintEqualToAnchor:view.leftAnchor]];
    [self.constraints addObject:[view.playbackContainerView.bottomAnchor constraintEqualToAnchor:view.bottomAnchor]];
    [self.constraints addObject:[view.playbackContainerView.heightAnchor constraintGreaterThanOrEqualToConstant:48.f]];


    // The seekAndAudioContainerView control constraints:
    [self.constraints addObject:[view.currentTimeLabel.topAnchor constraintEqualToAnchor:view.seekAndAudioContainerView.topAnchor]];
    [self.constraints addObject:[view.currentTimeLabel.leftAnchor constraintEqualToAnchor:view.seekAndAudioContainerView.leftAnchor constant:12.f]];
    [self.constraints addObject:[view.currentTimeLabel.bottomAnchor constraintEqualToAnchor:view.seekAndAudioContainerView.bottomAnchor]];
    [self.constraints addObject:[view.currentTimeLabel.widthAnchor constraintGreaterThanOrEqualToConstant:60.0f]];
    [self.constraints addObject:[view.seekSlider.topAnchor constraintEqualToAnchor:view.seekAndAudioContainerView.topAnchor]];
    [self.constraints addObject:[view.seekSlider.leftAnchor constraintEqualToAnchor:view.currentTimeLabel.rightAnchor]];
    [self.constraints addObject:[view.seekSlider.rightAnchor constraintEqualToAnchor:view.muteButton.leftAnchor constant:-6.f]];
    [self.constraints addObject:[view.seekSlider.bottomAnchor constraintEqualToAnchor:view.seekAndAudioContainerView.bottomAnchor]];
    [self.constraints addObject:[view.progressView.centerYAnchor constraintEqualToAnchor:view.seekSlider.centerYAnchor constant:1.0f]];
    [self.constraints addObject:[view.progressView.centerXAnchor constraintEqualToAnchor:view.seekSlider.centerXAnchor]];
    [self.constraints addObject:[view.progressView.widthAnchor constraintEqualToAnchor:view.seekSlider.widthAnchor]];
    [self.constraints addObject:[view.progressView.heightAnchor constraintEqualToConstant:2.0f]];
    [self.constraints addObject:[view.muteButton.topAnchor constraintEqualToAnchor:view.seekAndAudioContainerView.topAnchor]];
    [self.constraints addObject:[view.muteButton.rightAnchor constraintEqualToAnchor:view.seekAndAudioContainerView.rightAnchor constant:-6.f]];
    [self.constraints addObject:[view.muteButton.bottomAnchor constraintEqualToAnchor:view.seekAndAudioContainerView.bottomAnchor]];
    [self.constraints addObject:[view.muteButton.widthAnchor constraintEqualToConstant:28.0f]];

    // The playbackContainerView control constraints:
    [self.constraints addObject:[view.playbackControlButton.centerXAnchor constraintEqualToAnchor:view.playbackContainerView.centerXAnchor]];
    [self.constraints addObject:[view.playbackControlButton.topAnchor constraintEqualToAnchor:view.playbackContainerView.topAnchor]];
    [self.constraints addObject:[view.playbackControlButton.bottomAnchor constraintEqualToAnchor:view.playbackContainerView.bottomAnchor]];
    [self.constraints addObject:[view.playbackControlButton.widthAnchor constraintEqualToConstant:28.0f]];

    [self.constraints addObject:[view.seekBackwardButton.topAnchor constraintEqualToAnchor:view.playbackContainerView.topAnchor]];
    [self.constraints addObject:[view.seekBackwardButton.bottomAnchor constraintEqualToAnchor:view.playbackContainerView.bottomAnchor]];
    [self.constraints addObject:[view.seekBackwardButton.widthAnchor constraintEqualToConstant:28.0f]];

    if (@available(iOS 11.0, *)) {
        [self.constraints addObject:[view.playbackControlButton.leftAnchor constraintEqualToSystemSpacingAfterAnchor:view.seekBackwardButton.rightAnchor multiplier:1.0]];
        [self.constraints addObject:[view.seekForwardButton.leftAnchor constraintEqualToSystemSpacingAfterAnchor:view.playbackControlButton.rightAnchor multiplier:1.0]];
    } else {
        [self.constraints addObject:[view.playbackControlButton.leftAnchor constraintEqualToAnchor:view.seekBackwardButton.rightAnchor constant:4.0f]];
        [self.constraints addObject:[view.seekForwardButton.leftAnchor constraintEqualToAnchor:view.playbackControlButton.rightAnchor constant:4.0f]];
    }
    [self.constraints addObject:[view.seekForwardButton.topAnchor constraintEqualToAnchor:view.playbackContainerView.topAnchor]];
    [self.constraints addObject:[view.seekForwardButton.bottomAnchor constraintEqualToAnchor:view.playbackContainerView.bottomAnchor]];
    [self.constraints addObject:[view.seekForwardButton.widthAnchor constraintEqualToConstant:28.0f]];

    [NSLayoutConstraint activateConstraints:self.constraints];
}

- (void)updateConstraintsInView:(LYRUIPlaybackControlView *)view {
    // no-op
}

- (void)removeConstraintsFromView:(LYRUIPlaybackControlView *)view {
    [NSLayoutConstraint deactivateConstraints:self.constraints];
    [self.constraints removeAllObjects];
}

@end

