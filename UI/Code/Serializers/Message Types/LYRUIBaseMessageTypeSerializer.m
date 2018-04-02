//
//  LYRUIBaseMessageTypeSerializer.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 06.10.2017.
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

#import "LYRUIBaseMessageTypeSerializer.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIIdentityNameFormatter.h"
#import <LayerKit/LayerKit.h>
#import "LYRUIMessageType.h"
#import "LYRUIMessageTypeStatus.h"
#import "LYRUIMessageRecipientStatusFormatter.h"
#import "LYRUITempFileGenerator.h"
#import "LYRUIMessageAttributesManager.h"
#import "LYRUIMessageActionSerializer.h"

static NSString *const LYRUIUserNotificationDefaultActionsCategoryIdentifier = @"layer:///categories/default";

@interface LYRUIBaseMessageTypeSerializer ()

@property (nonatomic, strong) id<LYRUIIdentityNameFormatting> identityNameFormatter;
@property (nonatomic, strong) LYRUIMessageRecipientStatusFormatter *statusFormatter;
@property (nonatomic, strong) LYRUITempFileGenerator *tempFileGenerator;
@property (nonatomic, strong) LYRUIMessageActionSerializer *actionSerializer;

@end

@implementation LYRUIBaseMessageTypeSerializer
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [self init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    self.identityNameFormatter = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIIdentityNameFormatting)
                                                                            forClass:[self class]];
    self.statusFormatter = [layerConfiguration.injector objectOfType:[LYRUIMessageRecipientStatusFormatter class]];
    self.tempFileGenerator = [layerConfiguration.injector objectOfType:[LYRUITempFileGenerator class]];
    self.actionSerializer = [layerConfiguration.injector objectOfType:[LYRUIMessageActionSerializer class]];
}

- (LYRUIMessageType *)typedMessageWithMessagePart:(LYRMessagePart *)messagePart {
    return nil;
}

- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUIMessageType *)messageType {
    return [self layerMessagePartsWithTypedMessage:messageType parentNodeId:nil role:nil];
}

- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUIMessageType *)messageType
                                                    parentNodeId:(NSString *)parentNodeId
                                                            role:(NSString *)role {
    return [self layerMessagePartsWithTypedMessage:messageType
                                      parentNodeId:parentNodeId
                                              role:role
                                MIMETypeAttributes:nil];
}

- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUIMessageType *)messageType
                                                    parentNodeId:(NSString *)parentNodeId
                                                            role:(NSString *)role
                                              MIMETypeAttributes:(NSDictionary *)MIMETypeAttributes {
    return nil;
}

- (LYRMessageOptions *)messageOptionsForTypedMessage:(LYRUIMessageType *)messageType {
    return nil;
}

- (LYRUIMessageTypeStatus *)statusWithMessage:(LYRMessage *)message {
    LYRRecipientStatus recipientStatus = [self.statusFormatter statusForMessage:message];
    NSString *statusDescription = [self.statusFormatter stringForMessageRecipientStatus:message];
    return [[LYRUIMessageTypeStatus alloc] initWithRecipientStatus:recipientStatus description:statusDescription];
}

- (NSURL *)URLWithString:(NSString *)URLString {
    if (URLString == nil || ![URLString isKindOfClass:[NSString class]] || URLString.length == 0) {
        return nil;
    }
    return [NSURL URLWithString:URLString];
}

- (NSURL *)localFileURLForFileMessagePart:(LYRMessagePart *)messagePart withMIMEType:(NSString *)MIMEType {
    if (messagePart.fileURL) {
        NSString *fileExtension = [self.tempFileGenerator fileExtensionForMimeType:MIMEType];
        if (fileExtension == nil || [messagePart.fileURL.pathExtension isEqualToString:fileExtension]) {
            return messagePart.fileURL;
        }
        return [self.tempFileGenerator createTempSymlinkToURL:messagePart.fileURL forMIMEType:MIMEType];
    }
    if (messagePart.data) {
        return [self.tempFileGenerator createTempFileWithData:messagePart.data MIMEType:MIMEType];
    }
    return nil;
}

- (NSString *)MIMETypeForContentType:(NSString *)contentType
                        parentNodeId:(NSString *)parentNodeId
                                role:(NSString *)role
                          attributes:(NSDictionary *)attributes {
    NSMutableArray<NSString *> *attributesToAppend = [[NSMutableArray alloc] init];
    if (parentNodeId != nil) {
        [attributesToAppend addObject:[NSString stringWithFormat:@"%@=%@", LYRUIMessagePartParentNodeIdKey, parentNodeId]];
    }
    if (role == nil) {
        role = LYRUIMessagePartRoleRoot;
    }
    for (NSString *key in attributes) {
        [attributesToAppend addObject:[NSString stringWithFormat:@"%@=%@", key, attributes[key]]];
    }
    NSMutableString *MIMEType = [NSMutableString stringWithFormat:@"%@; %@=%@", contentType, LYRUIMessagePartRoleKey, role];
    for (NSString *attribute in attributesToAppend) {
        [MIMEType appendFormat:@"; %@", attribute];
    }
    return MIMEType;
}

- (LYRMessageOptions *)defaultMessageOptionsWithMessageText:(NSString *)messageText {
    NSString *pushAlert = [NSString stringWithFormat:@"%@: %@", self.currentUserName, messageText];
    return [self defaultMessageOptionsWithPushNotificationAlert:pushAlert];
}

- (LYRMessageOptions *)defaultMessageOptionsWithPushNotificationText:(NSString *)notificationText {
    NSString *pushAlert = [NSString stringWithFormat:@"%@ %@", self.currentUserName, notificationText];
    return [self defaultMessageOptionsWithPushNotificationAlert:pushAlert];
}
    
- (LYRMessageOptions *)defaultMessageOptionsWithPushNotificationAlert:(NSString *)pushAlert {
    LYRMessageOptions *messageOptions = [LYRMessageOptions new];
    
    if (pushAlert) {
        LYRPushNotificationConfiguration *defaultConfiguration = [LYRPushNotificationConfiguration new];
        defaultConfiguration.alert = pushAlert;
        defaultConfiguration.category = LYRUIUserNotificationDefaultActionsCategoryIdentifier;
        
        messageOptions.pushNotificationConfiguration = defaultConfiguration;
    }
    return messageOptions;
}

- (NSString *)currentUserName {
    return [self.identityNameFormatter nameForIdentity:self.layerConfiguration.client.authenticatedUser];
}

@end
