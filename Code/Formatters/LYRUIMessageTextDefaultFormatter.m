//
//  LYRUIMessageTextDefaultFormatter.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 09.08.2017.
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

#import "LYRUIMessageTextDefaultFormatter.h"
#import <LayerKit/LayerKit.h>

static NSString *const LYRUIMessageMIMETypeTextPlain = @"text/plain";

@implementation LYRUIMessageTextDefaultFormatter

- (NSString *)stringForMessage:(LYRMessage *)message {
    NSString *lastMessageText;
    LYRMessagePart *messagePart = message.parts[0];
    if ([messagePart.MIMEType isEqualToString:LYRUIMessageMIMETypeTextPlain]) {
        lastMessageText = [[NSString alloc] initWithData:messagePart.data encoding:NSUTF8StringEncoding];
    } else if ([messagePart.MIMEType containsString:@"image/"]) {
        lastMessageText = @"🏞";
    } else if ([messagePart.MIMEType containsString:@"video/"]) {
        lastMessageText = @"🎞";
    } else {
        lastMessageText = @"📄";
    }
    return lastMessageText;
}

@end
