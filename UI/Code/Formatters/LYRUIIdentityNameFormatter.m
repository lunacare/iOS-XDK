//
//  LYRUIIdentityNameFormatter.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 13.07.2017.
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

#import "LYRUIIdentityNameFormatter.h"
#import <LayerKit/LayerKit.h>

@implementation LYRUIIdentityNameFormatter

- (NSString *)nameForIdentity:(LYRIdentity *)identity {
    NSCharacterSet *charactersToTrim = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSPersonNameComponents *components = [[NSPersonNameComponents alloc] init];
    components.givenName = [identity.firstName stringByTrimmingCharactersInSet:charactersToTrim];
    components.familyName = [identity.lastName stringByTrimmingCharactersInSet:charactersToTrim];
    NSString *formattedName = [NSPersonNameComponentsFormatter localizedStringFromPersonNameComponents:components
                                                                                                 style:NSPersonNameComponentsFormatterStyleMedium
                                                                                               options:0];
    if (!formattedName || formattedName.length == 0) {
        return identity.displayName ?: @"";
    }
    return formattedName;
}

@end
