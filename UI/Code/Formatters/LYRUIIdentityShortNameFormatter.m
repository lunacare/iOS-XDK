//
//  LYRUIIdentityShortNameFormatter.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 15.09.2017.
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

#import "LYRUIIdentityShortNameFormatter.h"
#import <LayerKit/LayerKit.h>

@implementation LYRUIIdentityShortNameFormatter

- (NSString *)nameForIdentity:(LYRIdentity *)identity {
    NSCharacterSet *charactersToTrim = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *firstName = [identity.firstName stringByTrimmingCharactersInSet:charactersToTrim];
    if (firstName && firstName.length > 0) {
        return firstName;
    }
    NSString *lastName = [identity.lastName stringByTrimmingCharactersInSet:charactersToTrim];
    if (lastName && lastName.length > 0) {
        return lastName;
    }
    NSString *fullDisplayName = [identity.displayName stringByTrimmingCharactersInSet:charactersToTrim];
    NSString *displayName = [fullDisplayName componentsSeparatedByCharactersInSet:charactersToTrim].firstObject;
    if (displayName && displayName.length > 0) {
        return displayName;
    }
    return nil;
}

@end
