//
//  LYRUIInitialsFormatter.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 25.07.2017.
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

#import "LYRUIInitialsFormatter.h"
#import <LayerKit/LayerKit.h>

@implementation LYRUIInitialsFormatter

- (NSString *)initialsForIdentity:(LYRIdentity *)identity {
    NSString *firstName = [self trimmedString:identity.firstName];
    NSString *lastName = [self trimmedString:identity.lastName];
    NSString *displayName = [self trimmedString:identity.displayName];
    
    if (firstName || lastName) {
        return [NSString stringWithFormat:@"%@%@",
                [firstName substringToIndex:1] ?: @"",
                [lastName substringToIndex:1] ?: @""];
    } else if (displayName) {
        if (displayName.length == 1) {
            return displayName;
        }
        
        if (![displayName containsString:@" "]) {
            return [displayName substringToIndex:2];
        }
        
        NSCharacterSet *characterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet;
        NSString *trimmedDisplayName = [displayName stringByTrimmingCharactersInSet:characterSet];
        NSArray *displayNameParts = [trimmedDisplayName componentsSeparatedByString:@" "];
        return [NSString stringWithFormat:@"%@%@",
                [displayNameParts.firstObject substringToIndex:1],
                [displayNameParts.lastObject substringToIndex:1]];
    }
    
    return nil;
}

#pragma mark - Helpers

- (nullable NSString *)trimmedString:(nullable NSString *)string {
    if (string == nil) {
        return nil;
    }
    
    NSCharacterSet *charactersToTrim = NSCharacterSet.whitespaceAndNewlineCharacterSet;
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:charactersToTrim];
    if (trimmedString.length == 0) {
        return nil;
    }
    
    return trimmedString;
}

@end
