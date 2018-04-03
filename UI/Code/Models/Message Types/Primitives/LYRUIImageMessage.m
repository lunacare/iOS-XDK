//
//  LYRUIImageMessage.m
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

#import "LYRUIImageMessage.h"

@interface LYRUIImageMessage ()

@property (nonatomic, readwrite) NSString *artist;
@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) NSString *subtitle;
@property (nonatomic, readwrite) NSString *fileName;
@property (nonatomic, readwrite) NSString *imageMIMEType;
@property (nonatomic, readwrite) CGSize size;
@property (nonatomic, readwrite) CGSize previewSize;
@property (nonatomic, readwrite) NSDate *createdAt;
@property (nonatomic, readwrite) NSUInteger orientation;
@property (nonatomic, readwrite) NSURL *previewImageURL;
@property (nonatomic, readwrite) NSURL *previewImageLocalURL;
@property (nonatomic, readwrite) NSData *previewImageData;
@property (nonatomic, readwrite) NSURL *sourceImageURL;
@property (nonatomic, readwrite) NSURL *sourceImageLocalURL;
@property (nonatomic, readwrite) NSData *sourceImageData;

@end

@implementation LYRUIImageMessage

- (instancetype)initWithArtist:(NSString *)artist
                         title:(NSString *)title
                      subtitle:(NSString *)subtitle
                      fileName:(NSString *)fileName
                 imageMIMEType:(NSString *)imageMIMEType
                          size:(CGSize)size
                   previewSize:(CGSize)previewSize
                     createdAt:(NSDate *)createdAt
                   orientation:(NSUInteger)orientation
               previewImageURL:(NSURL *)previewImageURL
          previewImageLocalURL:(NSURL *)previewImageLocalURL
              previewImageData:(NSData *)previewImageData
                sourceImageURL:(NSURL *)sourceImageURL
           sourceImageLocalURL:(NSURL *)sourceImageLocalURL
               sourceImageData:(NSData *)sourceImageData
                        action:(LYRUIMessageAction *)action
                        sender:(LYRIdentity *)sender
                        sentAt:(NSDate *)sentAt
                        status:(LYRUIMessageTypeStatus *)status {
    if (action == nil) {
        if (sourceImageURL != nil) {
            action = [[LYRUIMessageAction alloc] initWithURL:sourceImageURL];
        } else {
            action = [[LYRUIMessageAction alloc] initWithFileURL:sourceImageLocalURL];
        }
    }
    self = [super initWithAction:action
                          sender:sender
                          sentAt:sentAt
                          status:status];
    if (self) {
        self.artist = artist;
        self.title = title;
        self.subtitle = subtitle;
        self.fileName = fileName;
        self.imageMIMEType = imageMIMEType;
        self.size = size;
        self.previewSize = previewSize;
        self.createdAt = createdAt;
        self.orientation = orientation;
        self.previewImageURL = previewImageURL;
        self.previewImageLocalURL = previewImageLocalURL;
        self.previewImageData = previewImageData;
        self.sourceImageURL = sourceImageURL;
        self.sourceImageLocalURL = sourceImageLocalURL;
        self.sourceImageData = sourceImageData;
    }
    return self;
}

- (instancetype)initWithSourceImageMIMEType:(NSString *)imageMIMEType
                              imageLocalURL:(NSURL *)sourceImageLocalURL
                            sourceImageData:(NSData *)sourceImageData
                       previewImageLocalURL:(NSURL *)previewImageLocalURL
                           previewImageData:(NSData *)previewImageData
                                       size:(CGSize)size
                                     sender:(LYRIdentity *)sender
                                     sentAt:(NSDate *)sentAt
                                     status:(LYRUIMessageTypeStatus *)status {
    self = [self initWithArtist:nil
                          title:nil
                       subtitle:nil
                       fileName:nil
                  imageMIMEType:imageMIMEType
                           size:size
                    previewSize:size
                      createdAt:nil
                    orientation:1
                previewImageURL:nil
           previewImageLocalURL:previewImageLocalURL
               previewImageData:previewImageData
                 sourceImageURL:nil
            sourceImageLocalURL:sourceImageLocalURL
                sourceImageData:sourceImageData
                         action:nil
                         sender:sender
                         sentAt:sentAt
                         status:status];
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
                 previewImage:(UIImage *)previewImage {
    NSData *sourceImageData = UIImageJPEGRepresentation(image, 1.0);
    NSData *previewImageData = UIImageJPEGRepresentation(previewImage, 1.0);
    self = [self initWithArtist:nil
                          title:nil
                       subtitle:nil
                       fileName:nil
                  imageMIMEType:@"image/jpeg"
                           size:image.size
                    previewSize:previewImage.size
                      createdAt:nil
                    orientation:0
                previewImageURL:nil
           previewImageLocalURL:nil
               previewImageData:previewImageData
                 sourceImageURL:nil
            sourceImageLocalURL:nil
                sourceImageData:sourceImageData
                         action:nil
                         sender:nil
                         sentAt:nil
                         status:nil];
    return self;
}

- (NSUInteger)orientationWithImageOrientation:(UIImageOrientation)imageOrientation {
    switch (imageOrientation) {
        case UIImageOrientationUp:
            return 1;
        case UIImageOrientationUpMirrored:
            return 2;
        case UIImageOrientationDown:
            return 3;
        case UIImageOrientationDownMirrored:
            return 4;
        case UIImageOrientationLeftMirrored:
            return 5;
        case UIImageOrientationLeft:
            return 6;
        case UIImageOrientationRightMirrored:
            return 7;
        case UIImageOrientationRight:
            return 8;
    }
}

- (LYRUIMessageMetadata *)metadata {
    LYRUIMessageMetadata *metadata;
    if (self.title.length > 0 || self.artist.length > 0 || self.subtitle.length > 0) {
        metadata = [[LYRUIMessageMetadata alloc] initWithDescription:self.subtitle
                                                               title:self.title
                                                              footer:self.artist];
    }
    return metadata;
}

+ (NSString *)MIMEType {
    return @"application/vnd.layer.image+json";
}

- (NSString *)summary {
    return self.title ?: @"Image";
}

@end
