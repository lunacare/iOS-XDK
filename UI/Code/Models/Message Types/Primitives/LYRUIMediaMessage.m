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

- (LYRUIMessageMetadata *)metadataForTitle:(NSString *)title album:(NSString *)album genre:(NSString *)genre subtitle:(NSString *)subtitle type:(NSString *)type {
    LYRUIMessageMetadata *metadata;
    NSString *metadataTitle;        // slotB
    NSString *metadataDescription;  // slotC
    NSString *metadataFooter;       // slotD
    NSMutableArray<NSString *> *queueSlotOrder = [NSMutableArray array];
    NSMutableArray<NSString *> *queueTitle = [NSMutableArray array];
    if (self.title.length) {
        [queueTitle addObject:self.title];
        [queueSlotOrder addObject:self.title];
    }
    if (self.sourceURL) {
        NSString *sourceFileName = self.sourceURL.lastPathComponent.stringByDeletingPathExtension;
        [queueTitle addObject:sourceFileName];
        [queueSlotOrder addObject:sourceFileName];
    }
    if (queueTitle.count == 0) {
        type = type ?: @"Media Message";
        [queueTitle addObject:type];
        [queueSlotOrder addObject:type];
    }

    NSMutableArray<NSString *> *queueSubtitle = [NSMutableArray array];
    if (self.artist.length) {
        [queueSubtitle addObject:self.artist];
        [queueSlotOrder addObject:self.artist];
    }
    if (album.length) {
        [queueSubtitle addObject:album];
        [queueSlotOrder addObject:album];
    }
    if (genre.length) {
        [queueSubtitle addObject:genre];
        [queueSlotOrder addObject:genre];
    }
    if (subtitle.length) {
        [queueSubtitle addObject:subtitle];
        [queueSlotOrder addObject:subtitle];
    }

    NSMutableArray<NSString *> *queueFooter = [NSMutableArray array];
    if (self.duration) {
        NSString *duration = [self formattedDuration];
        [queueFooter addObject:duration];
        [queueSlotOrder addObject:duration];
    }
    if (self.size != LYRSizeNotDefined) {
        NSString *size = [self formattedSize];
        [queueFooter addObject:size];
        [queueSlotOrder addObject:size];
    }

    metadataTitle = queueTitle.firstObject;
    if (metadataTitle) {
        [queueTitle removeObjectAtIndex:0];
    }

    metadataDescription = queueSubtitle.firstObject;
    if (metadataDescription) {
        [queueSubtitle removeObjectAtIndex:0];
    }
    if (!metadataDescription) {
        metadataDescription = queueFooter.firstObject;
        if (metadataDescription) {
            [queueFooter removeObjectAtIndex:0];
        }
    }
    if (!metadataDescription) {
        metadataDescription = queueTitle.firstObject;
        if (metadataDescription) {
            [queueTitle removeObjectAtIndex:0];
        }
    }
    metadataFooter = queueFooter.firstObject;
    if (metadataFooter) {
        [queueFooter removeObjectAtIndex:0];
    }
    if (!metadataFooter) {
        metadataFooter = queueSubtitle.firstObject;
    }
    if (!metadataFooter) {
        metadataFooter = queueFooter.firstObject;
        if (metadataFooter) {
            [queueFooter removeObjectAtIndex:0];
        }
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
