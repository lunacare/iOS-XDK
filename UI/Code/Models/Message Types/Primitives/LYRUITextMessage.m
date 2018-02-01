//
//  LYRUITextMessage.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 04.10.2017.
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

#import "LYRUITextMessage.h"

@interface LYRUITextMessage ()

@property (nonatomic, readwrite) NSString *author;
@property (nonatomic, readwrite) NSString *text;
@property (nonatomic, readwrite) NSString *textMIMEType;
@property (nonatomic, readwrite) NSString *summary;
@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) NSString *subtitle;

@end

@implementation LYRUITextMessage
@synthesize summary;

- (instancetype)initWithText:(NSString *)text {
    self = [self initWithText:text sender:nil sentAt:nil status:nil];
    return self;
}

- (instancetype)initWithText:(NSString *)text
                       title:(NSString *)title {
    self = [self initWithAuthor:nil
                           text:text
                   textMIMEType:nil
                        summary:nil
                          title:title
                       subtitle:nil
                         action:nil
                         sender:nil
                         sentAt:nil
                         status:nil];
    return self;
}

- (instancetype)initWithText:(NSString *)text
                      sender:(LYRIdentity *)sender
                      sentAt:(NSDate *)sentAt
                      status:(LYRUIMessageTypeStatus *)status {
    self = [self initWithAuthor:nil
                           text:text
                   textMIMEType:@"text/plain"
                        summary:nil
                          title:nil
                       subtitle:nil
                         action:nil
                         sender:sender
                         sentAt:sentAt
                         status:status];
    return self;
}

- (instancetype)initWithAuthor:(NSString *)author
                          text:(NSString *)text
                  textMIMEType:(NSString *)textMIMEType
                       summary:(NSString *)summary
                         title:(NSString *)title
                      subtitle:(NSString *)subtitle
                        action:(LYRUIMessageAction *)action
                        sender:(LYRIdentity *)sender
                        sentAt:(NSDate *)sentAt
                        status:(LYRUIMessageTypeStatus *)status {
    self = [super initWithAction:action
                          sender:sender
                          sentAt:sentAt
                          status:status];
    if (self) {
        self.author = author;
        self.text = text;
        self.textMIMEType = textMIMEType;
        self.summary = summary ?: title ?: text;
        self.title = title;
        self.subtitle = subtitle;
    }
    return self;
}

- (LYRUIMessageMetadata *)metadata {
    LYRUIMessageMetadata *metadata;
    if (self.title.length > 0 || self.author.length > 0 || self.subtitle.length > 0) {
        metadata = [[LYRUIMessageMetadata alloc] initWithDescription:self.subtitle
                                                               title:self.title
                                                              footer:self.author];
    }
    return metadata;
}

+ (NSString *)MIMEType {
    return @"application/vnd.layer.text+json";
}

@end
