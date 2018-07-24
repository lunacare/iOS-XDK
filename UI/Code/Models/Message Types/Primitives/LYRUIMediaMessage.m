//
//  LYRUIMediaMessage.m
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

#import "LYRUIMediaMessage.h"

@interface LYRUIMediaMessage ()

@property (nonatomic, readwrite) NSString *artist;
@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) LYRSize size;
@property (nonatomic, readwrite) NSTimeInterval duration;
@property (nonatomic, readwrite) NSString *mediaMIMEType;
@property (nonatomic, readwrite) NSURL *sourceURL;
@property (nonatomic, readwrite) NSURL *previewURL;
@property (nonatomic, readwrite) LYRProgress *localSourceProgress;
@property (nonatomic, readwrite) LYRContentTransferStatus localSourceStatus;
@property (nonatomic, readwrite) NSURL *sourceLocalURL;
@property (nonatomic, readwrite) NSURL *previewLocalURL;
@property (nonatomic, readwrite) CGSize previewSize;

@end

@implementation LYRUIMediaMessage

- (instancetype)initWithArtist:(nullable NSString *)artist
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
    self = [super initWithAction:action
                          sender:sender
                          sentAt:sentAt
                          status:status
                     messagePart:messagePart];
    if (self) {
        self.artist = artist;
        self.title = title;
        self.size = size;
        self.duration = duration;
        self.mediaMIMEType = mediaMIMEType;
        self.sourceURL = sourceURL;
        self.previewURL = previewURL;
        self.localSourceProgress = localSourceProgress;
        self.localSourceStatus = localSourceStatus;
        self.sourceLocalURL = sourceLocalURL;
        self.previewLocalURL = previewLocalURL;
        self.previewSize = previewSize;
    }
    return self;
}

- (LYRUIMessageMetadata *)metadata {
    LYRUIMessageMetadata *metadata;
    if (self.title.length > 0 || self.artist.length > 0) {
        metadata = [[LYRUIMessageMetadata alloc] initWithDescription:@"Media"
                                                               title:self.title
                                                              footer:self.artist];
    }
    return metadata;
}

- (LYRUIMessageMetadata *)metadataForTitle:(NSString *)title subtitle:(NSString *)subtitle artist:(NSString *)artist {
    LYRUIMessageMetadata *metadata;
    NSString *metadataTitle;        // slotB
    NSString *metadataDescription;  // slotC
    NSString *metadataFooter;       // slotD
    if (title.length > 0 && subtitle.length > 0 && artist.length > 0) {
        metadataTitle = title;
        metadataDescription = subtitle;
        metadataFooter = artist;
    } else if (title.length > 0 && subtitle.length == 0 && artist.length > 0) {
        metadataTitle = title;
        metadataDescription = subtitle;
        metadataFooter = [self formattedDuration];
    } else if (title.length > 0 && subtitle.length == 0 && artist.length == 0) {
        metadataTitle = title;
        metadataDescription = [self formattedDuration];
        metadataFooter = [self formattedSize];
    } else {
        metadataTitle = self.sourceURL.lastPathComponent;
        metadataDescription = [self formattedDuration];
        metadataFooter = [self formattedSize];
    }
    metadata = [[LYRUIMessageMetadata alloc] initWithDescription:metadataDescription
                                                           title:metadataTitle
                                                          footer:metadataFooter];
    return metadata;
}

- (NSString *)formattedDuration
{
    static dispatch_once_t onceToken;
    static NSDateComponentsFormatter *dateComponentsFormatter;
    dispatch_once(&onceToken, ^{
        dateComponentsFormatter = [NSDateComponentsFormatter new];
        dateComponentsFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
        dateComponentsFormatter.allowedUnits = (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
    });
    return [dateComponentsFormatter stringFromTimeInterval:self.duration];
}

- (NSString *)formattedSize
{
    static dispatch_once_t onceToken;
    static NSByteCountFormatter *byteCountFormatter;
    dispatch_once(&onceToken, ^{
        byteCountFormatter = [NSByteCountFormatter new];
    });
    return [byteCountFormatter stringFromByteCount:self.size];
}

+ (NSString *)MIMEType {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Missing implementation of %@ in %@.", NSStringFromSelector(@selector(MIMEType)), self.class] userInfo:nil];
}

- (NSString *)summary {
    return self.title ? self.title : @"Media Message";
}

@end
