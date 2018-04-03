//
//  LYRUIListLoadingIndicatorView.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 29.08.2017.
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

#import "LYRUIListLoadingIndicatorView.h"

@interface LYRUIListLoadingIndicatorView ()

@property (nonatomic, weak, readwrite) UIActivityIndicatorView *activityIndicator;

@end

@implementation LYRUIListLoadingIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
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

- (void)lyr_commonInit {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:activityIndicator];
    self.activityIndicator = activityIndicator;
    activityIndicator.center = CGPointMake(round(CGRectGetWidth(self.bounds) / 2.0),
                                           round(CGRectGetHeight(self.bounds) / 2.0));
    activityIndicator.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
                                          UIViewAutoresizingFlexibleLeftMargin |
                                          UIViewAutoresizingFlexibleRightMargin |
                                          UIViewAutoresizingFlexibleBottomMargin);
    [activityIndicator startAnimating];
}

@end
