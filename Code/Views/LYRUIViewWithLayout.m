//
//  LYRUIViewWithLayout.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 04.07.2017.
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

#import "LYRUIViewWithLayout.h"

@implementation LYRUIViewWithLayout

- (void)setLayout:(id<LYRUIViewLayout>)layout {
    if ([self.layout isEqual:layout]) {
        return;
    }
    if (self.layout != nil) {
        [self.layout removeConstraintsFromView:self];
    }
    _layout = [layout copyWithZone:nil];
    [self.layout addConstraintsInView:self];
}

- (void)updateConstraints {
    [self.layout updateConstraintsInView:self];
    [super updateConstraints];
}

- (void)setFrame:(CGRect)frame {
    if ((self.updateConstraintsOnWidthChange && CGRectGetWidth(self.frame) != CGRectGetWidth(frame)) ||
        (self.updateConstraintsOnHeightChange && CGRectGetHeight(self.frame) != CGRectGetHeight(frame))) {
        [self setNeedsUpdateConstraints];
    }
    [super setFrame:frame];
}

- (void)setBounds:(CGRect)bounds {
    if ((self.updateConstraintsOnWidthChange && CGRectGetWidth(self.bounds) != CGRectGetWidth(bounds)) ||
        (self.updateConstraintsOnHeightChange && CGRectGetHeight(self.bounds) != CGRectGetHeight(bounds))) {
        [self setNeedsUpdateConstraints];
    }
    [super setBounds:bounds];
}

@end
