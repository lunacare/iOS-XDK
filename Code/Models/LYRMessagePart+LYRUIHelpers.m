//
//  LYRMessagePart+LYRUIHelpers.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 03.10.2017.
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

#import "LYRMessagePart+LYRUIHelpers.h"
#import "LYRUIMessageAttributesManager.h"
#import <objc/runtime.h>

static void *LYRUIMessagePartAttributesManagerKey = &LYRUIMessagePartAttributesManagerKey;

@interface LYRMessagePart ()

@property (nonatomic, readonly) LYRUIMessageAttributesManager *attributesManager;

@end


@implementation LYRMessagePart (LYRUIHelpers)

- (LYRUIMessageAttributesManager *)attributesManager {
    LYRUIMessageAttributesManager *attributesManager = objc_getAssociatedObject([self class], LYRUIMessagePartAttributesManagerKey);
    if (attributesManager == nil) {
        attributesManager = [[LYRUIMessageAttributesManager alloc] init];
        objc_setAssociatedObject([self class], LYRUIMessagePartAttributesManagerKey, attributesManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return attributesManager;
}

- (NSString *)contentType {
    return [self.attributesManager messagePartContentType:self];
}

- (NSDictionary *)MIMETypeAttributes {
    return [self.attributesManager messagePartMIMETypeAttributes:self];
}

- (NSString *)nodeId {
    return [self.attributesManager messagePartNodeId:self];
}

- (NSString *)parentNodeId {
    return [self.attributesManager messagePartParentNodeId:self];
}

- (NSString *)role {
    return [self.attributesManager messagePartRole:self];
}

- (NSArray<LYRMessagePart *> *)childParts {
    return [self.attributesManager messagePartChildParts:self];
}

- (LYRMessagePart *)childPartWithMIMEType:(NSString *)MIMEType {
    return [self.attributesManager messagePart:self childPartWithMIMEType:MIMEType];
}

- (LYRMessagePart *)childPartWithRole:(NSString *)role {
    return [self.attributesManager messagePart:self childPartWithRole:role];
}

- (NSArray<LYRMessagePart *> *)childPartsWithRole:(NSString *)role {
    return [self.attributesManager messagePart:self childPartsWithRole:role];
}

- (NSDictionary *)properties {
    return [self.attributesManager messagePartProperties:self];
}

@end
