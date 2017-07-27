//
//  LYRUIPresenceViewConfigurator.m
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

#import "LYRUIPresenceViewConfigurator.h"
#import "LYRUIPresenceView.h"
#import "LYRUIPresenceViewDefaultTheme.h"

@interface LYRUIPresenceViewConfigurator ()

@property (nonatomic, copy, readwrite) id<LYRUIPresenceViewTheming> theme;

@end

@implementation LYRUIPresenceViewConfigurator

- (instancetype)init {
    self = [self initWithTheme:nil];
    return self;
}

- (instancetype)initWithTheme:(id<LYRUIPresenceViewTheming>)theme {
    self = [super init];
    if (self) {
        if (theme == nil) {
            theme = [[LYRUIPresenceViewDefaultTheme alloc] init];
        }
        self.theme = theme;
        self.outsideStrokeColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Presence view setup

- (void)setupPresenceView:(LYRUIPresenceView *)presenceView forPresenceStatus:(LYRIdentityPresenceStatus)status {
    [presenceView updateWithFillColor:[self.theme fillColorForPresenceStatus:status]
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
