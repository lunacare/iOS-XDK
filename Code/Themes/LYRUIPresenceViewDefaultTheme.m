//
//  LYRUIShapedViewDefaultTheme.m
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

#import "LYRUIPresenceViewDefaultTheme.h"
#import <LayerKit/LayerKit.h>

@implementation LYRUIPresenceViewDefaultTheme

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] init];
}

#pragma mark - LYRUIPresenceIndicatorTheme methods

- (UIColor *)fillColorForPresenceStatus:(LYRIdentityPresenceStatus)status {
    switch (status) {
        case LYRIdentityPresenceStatusOffline:
            return [UIColor colorWithRed:(219.0/255.0) green:(222.0/255.0) blue:(228.0/255.0) alpha:1.0];
        case LYRIdentityPresenceStatusAvailable:
            return [UIColor colorWithRed:(87.0/255.0) green:(191.0/255.0) blue:(70.0/255.0) alpha:1.0];
        case LYRIdentityPresenceStatusBusy:
            return [UIColor colorWithRed:(234.0/255.0) green:(57.0/255.0) blue:(57.0/255.0) alpha:1.0];
        case LYRIdentityPresenceStatusAway:
            return [UIColor colorWithRed:(255.0/255.0) green:(213.0/255.0) blue:(36.0/255.0) alpha:1.0];
        case LYRIdentityPresenceStatusInvisible:
            return [UIColor clearColor];
    }
}

- (UIColor *)insideStrokeColorForPresenceStatus:(LYRIdentityPresenceStatus)status {
    switch (status) {
        case LYRIdentityPresenceStatusOffline:
        case LYRIdentityPresenceStatusAvailable:
        case LYRIdentityPresenceStatusBusy:
        case LYRIdentityPresenceStatusAway:
        default:
            return [UIColor clearColor];
        case LYRIdentityPresenceStatusInvisible:
            return [UIColor colorWithRed:(87.0/255.0) green:(191.0/255.0) blue:(70.0/255.0) alpha:1.0];
    }
}

- (UIColor *)outsideStrokeColorForPresenceStatus:(LYRIdentityPresenceStatus)status {
    return [UIColor clearColor];
}

#pragma mark - LYRUIParticipantsCountViewTheme property

- (UIColor *)participantsCountColor {
    return [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
}

@end
