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
#import"LYRUIConfiguration+DependencyInjection.h"
#import "NSCache+LYRUIImageCaching.h"
#import "LYRUIImageFactory.h"
#import "LYRUIDataFactory.h"
#import "NSCache+LYRUIImageCaching.h"
#import "LYRUIDispatcher.h"

@implementation LYRUIImageFetcher
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

#pragma mark - Properties

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    self.imagesCache = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIImageCaching) forClass:[self class]];
    self.imageFactory = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIImageCreating) forClass:[self class]];
    self.dataFactory = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIDataCreating) forClass:[self class]];
    self.dispatcher = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIDispatching) forClass:[self class]];
    self.session = [layerConfiguration.injector objectOfType:[NSURLSession class]];
}

#pragma mark - LYRUIImageFetching

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
            if (image) {
                [weakSelf.imagesCache setObject:image forKey:URL];
            }
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
