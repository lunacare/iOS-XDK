//
//  LYRUIImageMessage.h
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

#import "LYRUIMessageType.h"
@class CLLocation;

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUIImageMessage : LYRUIMessageType

@property (nonatomic, readonly, nullable) NSString *artist;

@property (nonatomic, readonly, nullable) NSString *title;

@property (nonatomic, readonly, nullable) NSString *subtitle;

@property (nonatomic, readonly, nullable) NSString *fileName;

@property (nonatomic, readonly, nullable) NSString *imageMIMEType;

@property (nonatomic, readonly) CGSize size;

@property (nonatomic, readonly) CGSize previewSize;

@property (nonatomic, readonly, nullable) NSDate *createdAt;

@property (nonatomic, readonly) NSUInteger orientation;

@property (nonatomic, readonly, nullable) NSURL *previewImageURL;

@property (nonatomic, readonly, nullable) NSURL *previewImageLocalURL;

@property (nonatomic, readonly, nullable) NSData *previewImageData;

@property (nonatomic, readonly, nullable) NSURL *sourceImageURL;

@property (nonatomic, readonly, nullable) NSURL *sourceImageLocalURL;

@property (nonatomic, readonly, nullable) NSData *sourceImageData;

- (nonnull instancetype)initWithArtist:(nullable NSString *)artist
                                 title:(nullable NSString *)title
                              subtitle:(nullable NSString *)subtitle
                              fileName:(nullable NSString *)fileName
                         imageMIMEType:(nullable NSString *)imageMIMEType
                                  size:(CGSize)size
                           previewSize:(CGSize)previewSize
                             createdAt:(nullable NSDate *)createdAt
                           orientation:(NSUInteger)orientation
                       previewImageURL:(nullable NSURL *)previewImageURL
                  previewImageLocalURL:(nullable NSURL *)previewImageLocalURL
                      previewImageData:(nullable NSData *)previewImageData
                        sourceImageURL:(nullable NSURL *)sourceImageURL
                   sourceImageLocalURL:(nullable NSURL *)sourceImageLocalURL
                       sourceImageData:(nullable NSData *)sourceImageData
                                action:(nullable LYRUIMessageAction *)action
                                sender:(nullable LYRIdentity *)sender
                                sentAt:(nullable NSDate *)sentAt
                                status:(nullable LYRUIMessageTypeStatus *)status;

- (instancetype)initWithSourceImageMIMEType:(NSString *)imageMIMEType
                              imageLocalURL:(nullable NSURL *)sourceImageLocalURL
                            sourceImageData:(nullable NSData *)sourceImageData
                       previewImageLocalURL:(nullable NSURL *)previewImageLocalURL
                           previewImageData:(nullable NSData *)previewImageData
                                       size:(CGSize)size
                                     sender:(nullable LYRIdentity *)sender
                                     sentAt:(nullable NSDate *)sentAt
                                     status:(nullable LYRUIMessageTypeStatus *)status;

- (nonnull instancetype)initWithImage:(nullable UIImage *)image
                         previewImage:(nullable UIImage *)previewImage;

@end
NS_ASSUME_NONNULL_END       // }
