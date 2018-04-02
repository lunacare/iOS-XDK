//
//  LYRUIMessageSender.m
//  Layer-XDK-UI-iOS
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
#import <LayerKit/LayerKit.h>
#import "LYRUIMessageSerializer.h"
#import "LYRUIMessageType.h"
#import "LYRUITextMessage.h"
#import "LYRUIImageMessage.h"
#import "UIImage+LYRUIThumbnail.h"
#import "LYRUILocationMessage.h"
#import <CoreLocation/CoreLocation.h>

@interface LYRUIMessageSender ()

@property (nonatomic, strong) LYRUIMessageSerializer *messageSerializer;

@end

@implementation LYRUIMessageSender
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.messageSerializer = [[LYRUIMessageSerializer alloc] init];
    }
    return self;
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    self.messageSerializer = [layerConfiguration.injector objectOfType:[LYRUIMessageSerializer class]];
}

#pragma mark - Public methods

- (void)sendMessageWithAttributedString:(NSAttributedString *)attributedString {
    if (self.conversation == nil || self.layerConfiguration.client == nil) {
        return;
    }
    NSArray *messages = [self messagesFromAttributedString:attributedString];
    for (LYRMessage *message in messages) {
        [self sendLayerMessage:message];
    }
}

- (void)sendMessageWithImage:(UIImage *)image {
    if (self.conversation == nil || self.layerConfiguration.client == nil) {
        return;
    }
    LYRUIImageMessage *imageMessage = [[LYRUIImageMessage alloc] initWithImage:image
                                                                  previewImage:image.lyr_thumbnail];
    LYRMessage *message = [self.messageSerializer layerMessageWithTypedMessage:imageMessage];
    [self sendLayerMessage:message];
}

- (void)sendMessageWithLocation:(CLLocation *)location {
    if (self.conversation == nil || self.layerConfiguration.client == nil) {
        return;
    }
    LYRUILocationMessage *locationMessage = [[LYRUILocationMessage alloc] initWithLocation:location];
    LYRMessage *message = [self.messageSerializer layerMessageWithTypedMessage:locationMessage];
    [self sendLayerMessage:message];
}

- (void)sendMessage:(LYRUIMessageType *)message {
    LYRMessage *layerMessage = [self.messageSerializer layerMessageWithTypedMessage:message];
    [self sendLayerMessage:layerMessage];
}

#pragma mark - Message Sending

- (NSArray *)messagesFromAttributedString:(NSAttributedString *)attributedString {
    NSMutableArray *messages = [NSMutableArray new];
    [attributedString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(id attachment, NSRange range, BOOL *stop) {
        NSAttributedString *attributedSubstring = [attributedString attributedSubstringFromRange:range];
        NSString *substring = attributedSubstring.string;
        NSString *trimmedSubstring = [substring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (trimmedSubstring.length == 0) {
            return;
        }
        LYRUITextMessage *textMessage = [[LYRUITextMessage alloc] initWithText:trimmedSubstring];
        LYRMessage *message = [self.messageSerializer layerMessageWithTypedMessage:textMessage];
        if (message) {
            [messages addObject:message];
        }
    }];
    return messages;
}

- (void)sendLayerMessage:(LYRMessage *)message {
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
