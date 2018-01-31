//
//  LYRMessageAttributesManager.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 30.01.2018.
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

#import "LYRUIMessageAttributesManager.h"
#import <LayerKit/LayerKit.h>

NSString *const LYRUIMessagePartRoleRoot = @"root";
static NSString *const LYRUIMessagePartParentNodeIdKey = @"parent-node-id";
static NSString *const LYRUIMessagePartRoleKey = @"role";

@implementation LYRUIMessageAttributesManager

- (LYRMessagePart *)messageRootPart:(LYRMessage *)message {
    LYRMessagePart *rootPart;
    for (LYRMessagePart *part in message.parts) {
        if ([[self messagePartRole:part] isEqualToString:LYRUIMessagePartRoleRoot]) {
            rootPart = part;
            break;
        }
    }
    return rootPart;
}

- (NSDictionary *)messageProperties:(LYRMessage *)message {
    LYRMessagePart *rootMessagePart = [self messageRootPart:message];
    return [self messagePartProperties:rootMessagePart];
}

- (NSArray<LYRMessagePart *> *)message:(LYRMessage *)message childMessagePartsOfPart:(LYRMessagePart *)messagePart {
    NSMutableArray *mutableChildParts = [[NSMutableArray alloc] init];
    for (LYRMessagePart *part in message.parts) {
        NSString *nodeId = [self messagePartNodeId:messagePart];
        if ([[self messagePartParentNodeId:part] isEqualToString:nodeId]) {
            [mutableChildParts addObject:part];
        }
    }
    return [mutableChildParts copy];
}

- (NSString *)messagePartContentType:(LYRMessagePart *)messagePart {
    return [messagePart.MIMEType componentsSeparatedByString:@";"].firstObject;
}

- (NSDictionary *)messagePartMIMETypeAttributes:(LYRMessagePart *)messagePart {
    if (messagePart.MIMEType == nil) {
        return @{};
    }
    NSRange plistBeginningRange = [messagePart.MIMEType rangeOfString:@";"];
    if (plistBeginningRange.location == NSNotFound || messagePart.MIMEType.length == plistBeginningRange.location + 1) {
        return @{};
    }
    NSMutableString *plistString = [[messagePart.MIMEType substringFromIndex:plistBeginningRange.location + 1] mutableCopy];
    if (![plistString hasSuffix:@";"]) {
        [plistString appendString:@";"];
    }
    NSData *plistData = [plistString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *attributes = [NSPropertyListSerialization propertyListWithData:plistData
                                                                         options:NSPropertyListImmutable
                                                                          format:nil
                                                                           error:&error];
    if (error != nil) {
        NSLog(@"Failed to extract attributes from MIME Type: %@", error);
    }
    return attributes;
}

- (NSString *)messagePartNodeId:(LYRMessagePart *)messagePart {
    return [messagePart.identifier lastPathComponent];
}

- (NSString *)messagePartParentNodeId:(LYRMessagePart *)messagePart {
    NSDictionary *MIMETypeAttributes = [self messagePartMIMETypeAttributes:messagePart];
    return MIMETypeAttributes[LYRUIMessagePartParentNodeIdKey];
}

- (NSString *)messagePartRole:(LYRMessagePart *)messagePart {
    NSDictionary *MIMETypeAttributes = [self messagePartMIMETypeAttributes:messagePart];
    return MIMETypeAttributes[LYRUIMessagePartRoleKey];
}

- (NSArray<LYRMessagePart *> *)messagePartChildParts:(LYRMessagePart *)messagePart {
    return [self message:messagePart.message childMessagePartsOfPart:messagePart];
}

- (LYRMessagePart *)messagePart:(LYRMessagePart *)messagePart childPartWithMIMEType:(NSString *)MIMEType {
    NSArray *childParts = [self messagePartChildParts:messagePart];
    for (LYRMessagePart *part in childParts) {
        if ([[self messagePartContentType:part] isEqualToString:MIMEType]) {
            return part;
        }
    }
    return nil;
}

- (LYRMessagePart *)messagePart:(LYRMessagePart *)messagePart childPartWithRole:(NSString *)role {
    NSArray *childParts = [self messagePartChildParts:messagePart];
    for (LYRMessagePart *part in childParts) {
        if ([[self messagePartRole:part] isEqualToString:role]) {
            return part;
        }
    }
    return nil;
}

- (NSArray<LYRMessagePart *> *)messagePart:(LYRMessagePart *)messagePart childPartsWithRole:(NSString *)role {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    NSArray *childParts = [self messagePartChildParts:messagePart];
    for (LYRMessagePart *part in childParts) {
        if ([[self messagePartRole:part] isEqualToString:role]) {
            [parts addObject:part];
        }
    }
    return [parts copy];
}

- (NSDictionary *)messagePartProperties:(LYRMessagePart *)messagePart {
    if (![[self messagePartContentType:messagePart] containsString:@"json"]) {
        return nil;
    }
    if (messagePart.data == nil) {
        [messagePart downloadContent:NULL];
        return nil;
    }
    NSError *error = nil;
    NSDictionary *properties = [NSJSONSerialization JSONObjectWithData:messagePart.data
                                                               options:NSJSONReadingAllowFragments
                                                                 error:&error];
    if (error) {
        NSLog(@"Could not parse message part properties: %@", error);
        return nil;
    }
    return properties;
}

@end
