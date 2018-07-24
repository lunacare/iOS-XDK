//
//  LYRUIProgressView.m
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

#import "LYRUIProgressView.h"

const NSTimeInterval LYRUIProgressViewAnimationInterval = 0.2f;

static inline float LYRUIProgressView_CLAMP(float x, float low, float high) {
    return x > high ? high : (x < low ? low : x);
}

@interface LYRUIProgressView ()

@property (nonatomic, strong, readonly, nonnull) CALayer *playbackProgressFillLayer;
@property (nonatomic, strong, readonly, nonnull) CALayer *bufferProgressFillLayer;

@end

@implementation LYRUIProgressView

#pragma mark - Initialization

- (instancetype)lyr_commonInit {
    _playbackProgressFillLayer = [CALayer layer];
    _playbackProgressFillLayer.backgroundColor = [[UIColor colorWithRed:16.0/255.0 green:148.0/255.0 blue:208.0/255.0 alpha:1.0] CGColor];
    _playbackProgressFillLayer.anchorPoint = CGPointZero;
    _bufferProgressFillLayer = [CALayer layer];
    _bufferProgressFillLayer.backgroundColor = [[UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:0.6] CGColor];
    _bufferProgressFillLayer.anchorPoint = CGPointZero;
    _playbackProgress = 0.0f;
    _bufferProgress = 0.0f;
    [self.layer addSublayer:_bufferProgressFillLayer];
    [self.layer addSublayer:_playbackProgressFillLayer];
    self.userInteractionEnabled = NO;
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutProgressLayers];
}

- (void)layoutProgressLayers {
    CGFloat fullWidth = self.bounds.size.width;
    CGRect fullSizedProgress = CGRectMake(self.bounds.origin.x, self.bounds.origin.x, fullWidth, self.bounds.size.height);
    CGRect bufferProgress = fullSizedProgress;
    bufferProgress.size.width = fullWidth * self.bufferProgress;
    CGRect playbackProgress = fullSizedProgress;
    playbackProgress.size.width = fullWidth * self.playbackProgress;
    _bufferProgressFillLayer.bounds = bufferProgress;
    _playbackProgressFillLayer.bounds = playbackProgress;
}

#pragma mark - Progress Update

- (void)setBufferProgress:(float)bufferProgress {
    _bufferProgress = LYRUIProgressView_CLAMP(bufferProgress, 0.f, 1.f);
    [self layoutProgressLayers];
}

- (void)setPlaybackProgress:(float)playbackProgress {
    _playbackProgress = LYRUIProgressView_CLAMP(playbackProgress, 0.f, 1.f);
    [self layoutProgressLayers];
}

#pragma mark - Color Updates

- (void)setBufferProgressTrackTint:(UIColor *)bufferProgressTrackTint {
    _bufferProgressTrackTint = bufferProgressTrackTint.copy;
    _bufferProgressFillLayer.backgroundColor = bufferProgressTrackTint.CGColor;
}

- (void)setPlaybackProgressTrackTint:(UIColor *)playbackProgressTrackTint {
    _playbackProgressTrackTint = playbackProgressTrackTint.copy;
    _playbackProgressFillLayer.backgroundColor = playbackProgressTrackTint.CGColor;
}

@end
