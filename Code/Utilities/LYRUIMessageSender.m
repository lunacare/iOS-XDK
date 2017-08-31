//
//  LYRUIMessageSender.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 31.08.2017.
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

#import "LYRUIMessageSender.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "ATLMediaAttachment.h"
#import <LayerKit/LayerKit.h>

static NSString *const LYRUIPushNotificationSoundName = @"layerbell.caf";
static NSString *const LYRUIDefaultPushAlertGIF = @"sent you a GIF.";
static NSString *const LYRUIDefaultPushAlertImage = @"sent you a photo.";
static NSString *const LYRUIDefaultPushAlertLocation = @"sent you a location.";
static NSString *const LYRUIDefaultPushAlertVideo = @"sent you a video.";
static NSString *const LYRUIDefaultPushAlertText = @"sent you a message.";

static NSString *const LYRUIMIMETypeTextPlain = @"text/plain";
static NSString *const LYRUIMIMETypeImageGIF = @"image/gif";
static NSString *const LYRUIMIMETypeImagePNG = @"image/png";
static NSString *const LYRUIMIMETypeImageJPEG = @"image/jpeg";
static NSString *const LYRUIMIMETypeLocation = @"location/coordinate";
static NSString *const LYRUIMIMETypeVideoMP4 = @"video/mp4";

static NSString *const LYRUIUserNotificationDefaultActionsCategoryIdentifier = @"layer:///categories/default";

@implementation LYRUIMessageSender
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

#pragma mark - Public methods

- (void)sendMessageWithAttributedString:(NSAttributedString *)attributedString {
    if (self.conversation == nil || self.layerConfiguration.client == nil) {
        return;
    }
    NSArray *mediaAttachments = [self mediaAttachmentsFromAttributedString:attributedString];
    NSArray *messages = [self messagesForMediaAttachments:mediaAttachments];
    for (LYRMessage *message in messages) {
        [self sendMessage:message];
    }
}

#pragma mark - Media attachments

- (NSArray *)mediaAttachmentsFromAttributedString:(NSAttributedString *)attributedString {
    NSMutableArray *mediaAttachments = [NSMutableArray new];
    [attributedString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(id attachment, NSRange range, BOOL *stop) {
        if ([attachment isKindOfClass:[ATLMediaAttachment class]]) {
            ATLMediaAttachment *mediaAttachment = (ATLMediaAttachment *)attachment;
            [mediaAttachments addObject:mediaAttachment];
            return;
        }
        NSAttributedString *attributedSubstring = [attributedString attributedSubstringFromRange:range];
        NSString *substring = attributedSubstring.string;
        NSString *trimmedSubstring = [substring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (trimmedSubstring.length == 0) {
            return;
        }
        ATLMediaAttachment *mediaAttachment = [ATLMediaAttachment mediaAttachmentWithText:trimmedSubstring];
        [mediaAttachments addObject:mediaAttachment];
    }];
    return mediaAttachments;
}

#pragma mark - Message Sending

- (NSArray *)messagesForMediaAttachments:(NSArray *)mediaAttachments {
    NSMutableArray *messages = [NSMutableArray new];
    for (ATLMediaAttachment *attachment in mediaAttachments) {
        LYRMessage *message = [self messageForAttachment:attachment];
        if (message)[messages addObject:message];
    }
    return messages;
}

- (LYRMessage *)messageForAttachment:(ATLMediaAttachment *)attachment {
    LYRPushNotificationConfiguration *defaultConfiguration = [self pushNotificationConfigurationForAttachment:attachment];
    
    NSArray *messageParts = [self messagePartsWithMediaAttachment:attachment];
    LYRMessageOptions *messageOptions = [[LYRMessageOptions alloc] init];
    messageOptions.pushNotificationConfiguration = defaultConfiguration;
    
    NSError *error;
    LYRMessage *message = [self.layerConfiguration.client newMessageWithParts:messageParts options:messageOptions error:&error];
    if (error) {
        return nil;
    }
    return message;
}

- (LYRPushNotificationConfiguration *)pushNotificationConfigurationForAttachment:(ATLMediaAttachment *)attachment {
    LYRPushNotificationConfiguration *defaultConfiguration = [[LYRPushNotificationConfiguration alloc] init];
    defaultConfiguration.alert = [self pushMessageForAttachment:attachment];
    defaultConfiguration.sound = LYRUIPushNotificationSoundName;
    defaultConfiguration.category = LYRUIUserNotificationDefaultActionsCategoryIdentifier;
    return defaultConfiguration;
}

- (NSString *)pushMessageForAttachment:(ATLMediaAttachment *)attachment {
    NSString *pushMessageDetails;
    NSString *senderName = [self.layerConfiguration.client.authenticatedUser displayName];
    if ([attachment.mediaMIMEType isEqualToString:LYRUIMIMETypeTextPlain]) {
        return [NSString stringWithFormat:@"%@: %@", senderName, attachment.textRepresentation];
    } else if ([attachment.mediaMIMEType isEqualToString:LYRUIMIMETypeImageGIF]) {
        pushMessageDetails = LYRUIDefaultPushAlertGIF;
    } else if ([attachment.mediaMIMEType isEqualToString:LYRUIMIMETypeImagePNG] ||
               [attachment.mediaMIMEType isEqualToString:LYRUIMIMETypeImageJPEG]) {
        pushMessageDetails = LYRUIDefaultPushAlertImage;
    } else if ([attachment.mediaMIMEType isEqualToString:LYRUIMIMETypeLocation]) {
        pushMessageDetails = LYRUIDefaultPushAlertLocation;
    } else if ([attachment.mediaMIMEType isEqualToString:LYRUIMIMETypeVideoMP4]){
        pushMessageDetails = LYRUIDefaultPushAlertVideo;
    } else {
        pushMessageDetails = LYRUIDefaultPushAlertText;
    }
    return [NSString stringWithFormat:@"%@ %@", senderName, pushMessageDetails];
}

- (NSArray *)messagePartsWithMediaAttachment:(ATLMediaAttachment *)mediaAttachment {
    NSMutableArray *messageParts = [NSMutableArray array];
    if (!mediaAttachment.mediaInputStream) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Cannot create an LYRMessagePart with `nil` mediaInputStream."
                                     userInfo:nil];
    }
    
    if ([mediaAttachment.mediaMIMEType isEqualToString:LYRUIMIMETypeTextPlain]) {
        return @[[LYRMessagePart messagePartWithText:mediaAttachment.textRepresentation]];
    }
    
    // Create the message part for the main media (should be on index zero).
    [messageParts addObject:[LYRMessagePart messagePartWithMIMEType:mediaAttachment.mediaMIMEType
                                                             stream:mediaAttachment.mediaInputStream]];
    
    // If there's a thumbnail in the attachment, add it to the message parts on the second index.
    if (mediaAttachment.thumbnailInputStream) {
        [messageParts addObject:[LYRMessagePart messagePartWithMIMEType:mediaAttachment.thumbnailMIMEType
                                                                 stream:mediaAttachment.thumbnailInputStream]];
    }
    
    // If there's any additional metadata, add it to the message parts on the third index.
    if (mediaAttachment.metadataInputStream) {
        [messageParts addObject:[LYRMessagePart messagePartWithMIMEType:mediaAttachment.metadataMIMEType
                                                                 stream:mediaAttachment.metadataInputStream]];
    }
    return messageParts;
}

- (void)sendMessage:(LYRMessage *)message {
    NSError *error;
    BOOL success = [self.conversation sendMessage:message error:&error];
    if (!success) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Messaging Error"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

@end
