//
//  LYRUIShapedViewConfigurator.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 19.07.2017.
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

#import "LYRUIShapedViewConfigurator.h"
#import "LYRUIShapedView.h"
#import "LYRUIShapedViewDefaultTheme.h"

@interface LYRUIShapedViewConfigurator ()

@property (nonatomic, copy, readwrite) id<LYRUIShapedViewTheming> theme;

@end

@implementation LYRUIShapedViewConfigurator

- (instancetype)init {
    self = [self initWithTheme:nil];
    return self;
}

- (instancetype)initWithTheme:(id<LYRUIShapedViewTheming>)theme {
    self = [super init];
    if (self) {
        if (theme == nil) {
            theme = [[LYRUIShapedViewDefaultTheme alloc] init];
        }
        self.theme = theme;
        self.outsideStrokeColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Presence view setup

- (void)setupShapedView:(LYRUIShapedView *)shapedView forPresenceStatus:(LYRIdentityPresenceStatus)status {
    [shapedView updateWithFillColor:[self.theme fillColorForPresenceStatus:status]
                  insideStrokeColor:[self.theme strokeColorForPresenceStatus:status]
                 outsideStrokeColor:self.outsideStrokeColor];
}

#pragma mark - Properties

- (void)setOutsideStrokeColor:(UIColor *)outsideStrokeColor {
    if (outsideStrokeColor == nil) {
        outsideStrokeColor = [UIColor clearColor];
    }
    _outsideStrokeColor = outsideStrokeColor;
}

@end
