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

@interface LYRUIImageFetcher ()

@property (nonatomic, strong) NSCache<NSURL *, UIImage *> *imagesCache;

@end

@implementation LYRUIImageFetcher

- (instancetype)initWithImagesCache:(NSCache<NSURL *, UIImage *> *)imagesCache {
    self = [super init];
    if (self) {
        if (imagesCache == nil) {
             //TODO: add default shared cache
        }
        self.imagesCache = imagesCache;
    }
    return self;
}

- (void)fetchImageWithURL:(NSURL *)URL andCallback:(__weak void(^)(UIImage *))callback {
    __weak __typeof(self) weakSelf = self;
    [[[NSURLSession sharedSession] downloadTaskWithURL:URL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (!error && location) {
            __block UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            if (image) {
                [weakSelf.imagesCache setObject:image forKey:URL cost:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (callback) {
                        callback(image);
                    }
                });
            }
        }
    }] resume];
}

@end
