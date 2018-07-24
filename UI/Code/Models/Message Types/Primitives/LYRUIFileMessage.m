//
//  LYRUIFileMessage.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 05.10.2017.
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

#import "LYRUIFileMessage.h"

@interface LYRUIFileMessage ()

@property (nonatomic, readwrite) NSString *author;
@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) NSString *comment;
@property (nonatomic, readwrite) NSString *fileMIMEType;
@property (nonatomic, readwrite) NSUInteger size;
@property (nonatomic, readwrite) NSDate *createdAt;
@property (nonatomic, readwrite) NSDate *updatedAt;
@property (nonatomic, readwrite) NSURL *sourceURL;
@property (nonatomic, readwrite) NSURL *sourceLocalURL;
@property (nonatomic, readwrite) NSData *sourceData;

@end

@implementation LYRUIFileMessage

- (nonnull instancetype)initWithAuthor:(NSString *)author
                                 title:(NSString *)title
                               comment:(NSString *)comment
                          fileMIMEType:(NSString *)fileMIMEType
                                  size:(NSUInteger)size
                             createdAt:(NSDate *)createdAt
                             updatedAt:(NSDate *)updatedAt
                             sourceURL:(NSURL *)sourceURL
                        sourceLocalURL:(NSURL *)sourceLocalURL
                            sourceData:(NSData *)sourceData
                                action:(LYRUIMessageAction *)action
                                sender:(LYRIdentity *)sender
                                sentAt:(NSDate *)sentAt
                                status:(LYRUIMessageTypeStatus *)status
                           messagePart:(LYRMessagePart *)messagePart {
    if (action == nil) {
        if (sourceURL != nil) {
            action = [[LYRUIMessageAction alloc] initWithURL:sourceURL];
        } else {
            action = [[LYRUIMessageAction alloc] initWithFileURL:sourceLocalURL];
        }
    }
    self = [super initWithAction:action
                          sender:sender
                          sentAt:sentAt
                          status:status
                     messagePart:messagePart];
    if (self) {
        self.author = author;
        self.title = title;
        self.comment = comment;
        self.fileMIMEType = fileMIMEType;
        self.size = size;
        self.createdAt = createdAt;
        self.updatedAt = updatedAt;
        self.sourceURL = sourceURL;
        self.sourceLocalURL = sourceLocalURL;
        self.sourceData = sourceData;
    }
    return self;
}

- (instancetype)initWithFileMIMEType:(NSString *)fileMIMEType
                      sourceLocalURL:(NSURL *)sourceLocalURL
                              sender:(LYRIdentity *)sender
                              sentAt:(NSDate *)sentAt
                              status:(LYRUIMessageTypeStatus *)status
                         messagePart:(LYRMessagePart *)messagePart {
    self = [self initWithAuthor:nil
                          title:nil
                        comment:nil
                   fileMIMEType:fileMIMEType
                           size:0
                      createdAt:nil
                      updatedAt:nil
                      sourceURL:nil
                 sourceLocalURL:sourceLocalURL
                     sourceData:nil
                         action:nil
                         sender:sender
                         sentAt:sentAt
                         status:status
                    messagePart:messagePart];
    return self;
}

- (LYRUIMessageMetadata *)metadata {
    if (self.title.length == 0 && self.author.length == 0 && self.size == 0) {
        return nil;
    }
    NSString *fileSize;
    if (self.size > 0) {
        fileSize = [NSString localizedStringWithFormat:@"%luKB", (unsigned long)(self.size / 1024)];
    }
    LYRUIMessageMetadata *metadata = [[LYRUIMessageMetadata alloc] initWithDescription:self.author
                                                                                 title:self.title
                                                                                footer:fileSize];
    return metadata;
}

+ (NSString *)MIMEType {
    return @"application/vnd.layer.file+json";
}

- (NSString *)summary {
    return self.title ?: @"File";
}

@end
