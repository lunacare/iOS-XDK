//
//  LYRUIImageFetcher.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 20.07.2017.
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

#import "LYRUIImageFetcher.h"
#import "NSCache+LYRUIImageCaching.h"
#import "LYRUIImageFactory.h"
#import "LYRUIDataFactory.h"
#import "NSCache+LYRUIImageCaching.h"
#import "LYRUIDispatcher.h"

@interface LYRUIImageFetcher ()

@property (nonatomic, strong) id<LYRUIImageCaching> imagesCache;
@property (nonatomic, strong) id<LYRUIImageCreating> imageFactory;
@property (nonatomic, strong) id<LYRUIDataCreating> dataFactory;
@property (nonatomic, strong) id<LYRUIDispatching> dispatcher;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation LYRUIImageFetcher

- (instancetype)init {
    self = [self initWithImagesCache:nil imageFactory:nil dataFactory:nil dispatcher:nil andSession:nil];
    return self;
}

- (instancetype)initWithImagesCache:(id<LYRUIImageCaching>)imagesCache
                       imageFactory:(id<LYRUIImageCreating>)imageFactory
                        dataFactory:(id<LYRUIDataCreating>)dataFactory
                         dispatcher:(id<LYRUIDispatching>)dispatcher
                         andSession:(NSURLSession *)session {
    self = [super init];
    if (self) {
        if (imagesCache == nil) {
            imagesCache = [NSCache sharedImagesCache];
        }
        self.imagesCache = imagesCache;
        if (imageFactory == nil) {
            imageFactory = [[LYRUIImageFactory alloc] init];
        }
        self.imageFactory = imageFactory;
        if (dataFactory == nil) {
            dataFactory = [[LYRUIDataFactory alloc] init];
        }
        self.dataFactory = dataFactory;
        if (dispatcher == nil) {
            dispatcher = [[LYRUIDispatcher alloc] init];
        }
        self.dispatcher = dispatcher;
        if (session == nil) {
            session = [NSURLSession sharedSession];
        }
        self.session = session;
    }
    return self;
}

- (NSURLSessionDownloadTask *)fetchImageWithURL:(NSURL *)URL andCallback:(void(^)(UIImage *))callback {
    UIImage *cachedImage = [self.imagesCache objectForKey:URL];
    if (cachedImage) {
        if (callback) {
            callback(cachedImage);
        }
        return nil;
    }
    
    __weak __typeof(self) weakSelf = self;
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithURL:URL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        UIImage *image;
        if (!error && location) {
            image = [weakSelf.imageFactory imageWithData:[weakSelf.dataFactory dataWithContentsOfURL:location]];
            [weakSelf.imagesCache setObject:image forKey:URL];
        }
        [weakSelf.dispatcher dispatchAsyncOnMainQueue:^{
            if (callback) {
                callback(image);
            }
        }];
    }];
    [task resume];
    return task;
}

@end
