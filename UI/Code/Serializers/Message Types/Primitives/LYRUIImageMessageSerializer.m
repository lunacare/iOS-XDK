//
//  LYRUIImageMessageSerializer.m
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

#import "LYRUIImageMessageSerializer.h"
#import <LayerKit/LayerKit.h>
#import "LYRMessage+LYRUIHelpers.h"
#import "LYRMessagePart+LYRUIHelpers.h"
#import "LYRUIMessageActionSerializer.h"

@implementation LYRUIImageMessageSerializer

- (LYRUIImageMessage *)typedMessageWithMessagePart:(LYRMessagePart *)messagePart {
    if ([messagePart.MIMEType rangeOfString:@"image/"].location == 0) {
        LYRMessagePart *imagePart = messagePart;
        if (imagePart.transferStatus == LYRContentTransferReadyForDownload) {
            [imagePart downloadContent:NULL];
        }
        
        NSString *previewImagePartMIMEType = [NSString stringWithFormat:@"%@+preview", messagePart.MIMEType];
        LYRMessagePart *previewImagePart = [imagePart childPartWithMIMEType:previewImagePartMIMEType];
        if (previewImagePart.transferStatus == LYRContentTransferReadyForDownload) {
            [previewImagePart downloadContent:NULL];
        }
        
        LYRMessagePart *imageSizeMessagePart  = [imagePart childPartWithMIMEType:@"application/json+imageSize"];
        CGSize imageSize = [self imageSizeFromProperties:imageSizeMessagePart.properties];
        NSURL *imageLocalURL = [self localFileURLForFileMessagePart:imagePart
                                                       withMIMEType:messagePart.MIMEType];
        
        return [[LYRUIImageMessage alloc] initWithSourceImageMIMEType:messagePart.MIMEType
                                                        imageLocalURL:imageLocalURL
                                                      sourceImageData:imagePart.data
                                                 previewImageLocalURL:previewImagePart.fileURL
                                                     previewImageData:previewImagePart.data
                                                                 size:imageSize
                                                               sender:messagePart.message.sender
                                                               sentAt:messagePart.message.sentAt
                                                               status:[self statusWithMessage:messagePart.message]];
    }
    
    LYRMessagePart *imagePart = [messagePart childPartWithRole:@"source"];
    if (imagePart.transferStatus == LYRContentTransferReadyForDownload) {
        [imagePart downloadContent:NULL];
    }
    
    LYRMessagePart *previewImagePart = [messagePart childPartWithRole:@"previev"];
    if (previewImagePart.transferStatus == LYRContentTransferReadyForDownload) {
        [previewImagePart downloadContent:NULL];
    }
    
    CGSize previewSize = [self imageSizeFromProperties:messagePart.properties
                                     widthPropertyName:@"preview_width"
                                    heightPropertyName:@"preview_height"];
    NSURL *previewImageURL = [self URLWithString:messagePart.properties[@"preview_url"]];
    NSURL *sourceImageURL = [self URLWithString:messagePart.properties[@"source_url"]];
    NSString *MIMEType = messagePart.properties[@"mime_type"] ?: imagePart.contentType ?: [self contentTypeForImageData:imagePart.data];
    NSURL *previewImageLocalURL = [self localFileURLForFileMessagePart:previewImagePart
                                                          withMIMEType:MIMEType];
    NSURL *sourceImageLocalURL = [self localFileURLForFileMessagePart:imagePart
                                                         withMIMEType:MIMEType];
    LYRUIMessageAction *action = [self.actionSerializer actionFromProperties:messagePart.properties
                                                            withDefaultEvent:@"open-url"];
    return [[LYRUIImageMessage alloc] initWithArtist:messagePart.properties[@"artist"]
                                               title:messagePart.properties[@"title"]
                                            subtitle:messagePart.properties[@"subtitle"]
                                            fileName:messagePart.properties[@"file_name"]
                                       imageMIMEType:MIMEType
                                                size:[self imageSizeFromProperties:messagePart.properties]
                                         previewSize:previewSize
                                           createdAt:messagePart.properties[@"created_at"]
                                         orientation:[messagePart.properties[@"orientation"] integerValue]
                                     previewImageURL:previewImageURL
                                previewImageLocalURL:previewImageLocalURL
                                    previewImageData:previewImagePart.data
                                      sourceImageURL:sourceImageURL
                                 sourceImageLocalURL:sourceImageLocalURL
                                     sourceImageData:imagePart.data
                                              action:action
                                              sender:messagePart.message.sender
                                              sentAt:messagePart.message.sentAt
                                              status:[self statusWithMessage:messagePart.message]];
}

- (CGSize)imageSizeFromProperties:(NSDictionary *)properties {
    return [self imageSizeFromProperties:properties widthPropertyName:@"width" heightPropertyName:@"height"];
}

- (CGSize)imageSizeFromProperties:(NSDictionary *)properties
                widthPropertyName:(NSString *)widthPropertyName
               heightPropertyName:(NSString *)heightPropertyName {
    if (properties == nil) {
        return CGSizeZero;
    }
    CGFloat width = [properties[widthPropertyName] doubleValue];
    CGFloat height = [properties[heightPropertyName] doubleValue];
    return CGSizeMake(width, height);
}

- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUIImageMessage *)messageType
                                                    parentNodeId:(NSString *)parentNodeId
                                                            role:(NSString *)role
                                              MIMETypeAttributes:(NSDictionary *)MIMETypeAttributes {
    NSMutableDictionary *messageJson = [[NSMutableDictionary alloc] init];
    messageJson[@"artist"] = messageType.artist;
    messageJson[@"title"] = messageType.title;
    messageJson[@"subtitle"] = messageType.subtitle;
    if (!CGSizeEqualToSize(messageType.size, CGSizeZero)) {
        messageJson[@"width"] = @(messageType.size.width);
        messageJson[@"height"] = @(messageType.size.height);
    }
    if (!CGSizeEqualToSize(messageType.previewSize, CGSizeZero)) {
        messageJson[@"preview_width"] = @(messageType.previewSize.width);
        messageJson[@"preview_height"] = @(messageType.previewSize.height);
    }
    messageJson[@"created_at"] = messageType.createdAt;
    messageJson[@"orientation"] = @(messageType.orientation);
    messageJson[@"preview_url"] = messageType.previewImageURL;
    messageJson[@"source_url"] = messageType.sourceImageURL;
    [messageJson addEntriesFromDictionary:[self.actionSerializer propertiesForAction:messageType.action]];
    
    NSError *error = nil;
    NSData *messageJsonData = [NSJSONSerialization dataWithJSONObject:messageJson options:0 error:&error];
    if (error) {
        NSLog(@"Failed to serialize image message JSON object: %@", error);
        return nil;
    }
    NSMutableArray *messageParts = [[NSMutableArray alloc] init];
    
    NSString *MIMEType = [self MIMETypeForContentType:messageType.MIMEType
                                         parentNodeId:parentNodeId
                                                 role:role
                                           attributes:MIMETypeAttributes];
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithMIMEType:MIMEType data:messageJsonData];
    [messageParts addObject:messagePart];
    
    if (messageType.sourceImageData) {
        NSString *sourceMIMEType = [self MIMETypeForContentType:@"image/jpeg"
                                                   parentNodeId:messagePart.nodeId
                                                           role:@"source"
                                                     attributes:MIMETypeAttributes];
        LYRMessagePart *sourcePart = [LYRMessagePart messagePartWithMIMEType:sourceMIMEType data:messageType.sourceImageData];
        [messageParts addObject:sourcePart];
    }
    
    if (messageType.previewImageData) {
        NSString *previewMIMEType = [self MIMETypeForContentType:@"image/jpeg"
                                                    parentNodeId:messagePart.nodeId
                                                            role:@"preview"
                                                      attributes:MIMETypeAttributes];
        LYRMessagePart *previewPart = [LYRMessagePart messagePartWithMIMEType:previewMIMEType data:messageType.previewImageData];
        [messageParts addObject:previewPart];
    }
    
    return messageParts;
}

- (LYRMessageOptions *)messageOptionsForTypedMessage:(LYRUIImageMessage *)messageType {
    LYRMessageOptions *messageOptions = [self defaultMessageOptionsWithPushNotificationText:@"sent you a photo."];
    return messageOptions;
}

- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x42:
            return @"image/bmp";
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

@end
