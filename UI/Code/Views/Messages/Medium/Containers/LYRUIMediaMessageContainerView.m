//
//  LYRUIMediaMessageContainerView.m
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

#import "LYRUIMediaMessageContainerView.h"

@implementation LYRUIMediaMessageContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self lyr_mediaMessageCommonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self lyr_mediaMessageCommonInit];
    }
    return self;
}

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super initWithConfiguration:configuration];
    if (self) {
        [self lyr_mediaMessageCommonInit];
    }
    return self;
}

- (void)lyr_mediaMessageCommonInit {
    _mediaControlButton = [[UIButton alloc] init];
    _mediaControlButton.backgroundColor = UIColor.clearColor;
    [self addSubview:_mediaControlButton];

    _progressView = [[LYRUIProgressView alloc] initWithFrame:self.bounds];
    [self.metadataContainer addSubview:_progressView];
}

@end
