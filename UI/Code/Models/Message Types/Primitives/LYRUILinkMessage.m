//
//  LYRUILinkMessage.m
//  Layer-XDK-UI-iOS
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

#import "LYRUILinkMessage.h"

@interface LYRUILinkMessage ()

@property (nonatomic, readwrite) NSString *author;
@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) NSString *contentDescription;
@property (nonatomic, readwrite) NSURL *imageURL;
@property (nonatomic, readwrite) CGSize imageSize;
@property (nonatomic, readwrite) NSURL *URL;

@end

@implementation LYRUILinkMessage

- (instancetype)initWithAuthor:(NSString *)author
                         title:(NSString *)title
            contentDescription:(NSString *)contentDescription
                      imageURL:(NSURL *)imageURL
                     imageSize:(CGSize)imageSize
                           URL:(NSURL *)URL
                        action:(LYRUIMessageAction *)action
                        sender:(LYRIdentity *)sender
                        sentAt:(NSDate *)sentAt
                        status:(LYRUIMessageTypeStatus *)status {
    if (action == nil && URL != nil) {
        action = [[LYRUIMessageAction alloc] initWithURL:URL];
    }
    self = [super initWithAction:action
                          sender:sender
                          sentAt:sentAt
                          status:status];
    if (self) {
        self.author = author;
        self.title = title;
        self.contentDescription = contentDescription;
        self.imageURL = imageURL;
        self.imageSize = imageSize;
        self.URL = URL;
    }
    return self;
}

- (LYRUIMessageMetadata *)metadata {
    LYRUIMessageMetadata *metadata;
    if (self.title.length > 0 || self.contentDescription.length > 0 || self.author.length > 0) {
        metadata = [[LYRUIMessageMetadata alloc] initWithDescription:self.contentDescription
                                                               title:self.title
                                                              footer:self.author];
    }
    return metadata;
}

+ (NSString *)MIMEType {
    return @"application/vnd.layer.link+json";
}

- (NSString *)summary {
    return self.title ? [NSString stringWithFormat:@"Link to %@", self.title] : @"Link";
}

@end
