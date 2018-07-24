//
//  LYRUIAudioMessage.m
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 5/24/18.
//  Copyright (c) 2018 Layer. All rights reserved.
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

#import "LYRUIAudioMessage.h"

@implementation LYRUIAudioMessage

- (instancetype)initWithAlbum:(nullable NSString *)album
                        genre:(nullable NSString *)genre
                       artist:(nullable NSString *)artist
                        title:(nullable NSString *)title
                         size:(LYRSize)size
                     duration:(NSTimeInterval)duration
                mediaMIMEType:(nullable NSString *)mediaMIMEType
                    sourceURL:(nullable NSURL *)sourceURL
                   previewURL:(nullable NSURL *)previewURL
          localSourceProgress:(nullable LYRProgress *)localSourceProgress
            localSourceStatus:(LYRContentTransferStatus)localSourceStatus
               sourceLocalURL:(nullable NSURL *)sourceLocalURL
              previewLocalURL:(nullable NSURL *)previewLocalURL
                  previewSize:(CGSize)previewSize
                       action:(nullable LYRUIMessageAction *)action
                       sender:(nullable LYRIdentity *)sender
                       sentAt:(nullable NSDate *)sentAt
                       status:(nullable LYRUIMessageTypeStatus *)status
                  messagePart:(nullable LYRMessagePart *)messagePart {
    if (action == nil && sourceURL != nil) {
        action = [[LYRUIMessageAction alloc] initWithURL:sourceURL];
    }
    self = [super initWithArtist:artist title:title size:size duration:duration mediaMIMEType:mediaMIMEType sourceURL:sourceURL previewURL:previewURL localSourceProgress:localSourceProgress localSourceStatus:localSourceStatus sourceLocalURL:sourceLocalURL previewLocalURL:previewLocalURL previewSize:previewSize action:action sender:sender sentAt:sentAt status:status messagePart:messagePart];
    if (self) {
        _album = album;
        _genre = genre;
    }
    return self;
}

- (LYRUIMessageMetadata *)metadata {
    return [self metadataForTitle:self.title subtitle:self.album artist:self.artist];
}

+ (NSString *)MIMEType {
    return @"application/vnd.layer.audio+json";
}

- (NSString *)summary {
    return self.title ? self.title : @"Audio Message";
}

@end
