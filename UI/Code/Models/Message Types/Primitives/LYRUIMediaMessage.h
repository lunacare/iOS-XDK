//
//  LYRUIMediaMessage.h
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

#import <LayerKit/LYRConstants.h>
#import "LYRUIMessageType.h"

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUIMediaMessage : LYRUIMessageType

@property (nonatomic, readonly, copy, nullable) NSString *artist;

@property (nonatomic, readonly, copy, nullable) NSString *title;

@property (nonatomic, readonly) LYRSize size;

@property (nonatomic, readonly) NSTimeInterval duration;

@property (nonatomic, readonly, copy, nullable) NSString *mediaMIMEType;

@property (nonatomic, readonly, copy, nullable) NSURL *sourceURL;

@property (nonatomic, readonly, copy, nullable) NSURL *previewURL;

@property (nonatomic, readonly, nullable) LYRProgress *localSourceProgress;

@property (nonatomic, readonly, assign) LYRContentTransferStatus localSourceStatus;

@property (nonatomic, readonly, copy, nullable) NSURL *sourceLocalURL;

@property (nonatomic, readonly, copy, nullable) NSURL *previewLocalURL;

@property (nonatomic, readonly) CGSize previewSize;

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
                   messagePart:(nullable LYRMessagePart *)messagePart;

- (LYRUIMessageMetadata *)metadataForTitle:(nullable NSString *)title album:(nullable NSString *)album genre:(nullable NSString *)genre subtitle:(nullable NSString *)subtitle type:(nullable NSString *)type;

- (NSString *)formattedDuration;

- (NSString *)formattedSize;

@end
NS_ASSUME_NONNULL_END       // }
