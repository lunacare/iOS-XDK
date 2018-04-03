//
//  LYRUIImageWithLettersViewPresenter.m
//  Layer-XDK-UI-iOS
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

#import "LYRUIImageWithLettersViewPresenter.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIImageWithLettersView.h"
#import "LYRUIImageFetching.h"
#import "LYRUIImageCreating.h"
#import "LYRUIInitialsFormatting.h"
#import "NSCache+LYRUIImageCaching.h"

@interface LYRUIImageWithLettersViewPresenter ()

@property (nonatomic, strong) id<LYRUIImageFetching> imageFetcher;
@property (nonatomic, strong) id<LYRUIImageCaching> imagesCache;
@property (nonatomic, strong) id<LYRUIImageCreating> imageFactory;
@property (nonatomic, strong) id<LYRUIInitialsFormatting> initialsFormatter;

@end

@implementation LYRUIImageWithLettersViewPresenter
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
    self.imageFetcher = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIImageFetching) forClass:[self class]];
    self.imageFactory = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIImageCreating) forClass:[self class]];
    self.initialsFormatter = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIInitialsFormatting) forClass:[self class]];
    self.imagesCache = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIImageCaching) forClass:[self class]];
}

#pragma mark - LYRUIImageWithLettersView presenter

- (void)setupImageWithLettersView:(LYRUIImageWithLettersView *)view withIdentity:(LYRIdentity *)identity {
    UIImage *cachedImage = [self.imagesCache objectForKey:identity.avatarImageURL];
    if (cachedImage) {
        view.image = cachedImage;
        view.letters = nil;
        return;
    }
    
    NSString *initials = [self.initialsFormatter initialsForIdentity:identity];
    [self setInitials:initials orPlaceholderInView:view];
    
    if (identity.avatarImageURL == nil) {
        return;
    }
    
    __weak __typeof(view) weakView = view;
    [view.imageFetchTask cancel];
    view.imageFetchTask = [self.imageFetcher fetchImageWithURL:identity.avatarImageURL andCallback:^(UIImage * _Nullable image) {
        if (image) {
            weakView.image = image;
            weakView.letters = nil;
        }
    }];
}

- (void)setupImageWithLettersViewWithMultipleParticipantsIcon:(LYRUIImageWithLettersView *)view {
    view.image = [self.imageFactory imageNamed:@"MultipleParticipantsPlaceholder"];
}

#pragma mark - Helpers

- (void)setInitials:(nullable NSString *)initials orPlaceholderInView:(LYRUIImageWithLettersView *)view {
    if (initials) {
        view.image = nil;
        view.letters = initials;
    } else {
        view.image = [self.imageFactory imageNamed:@"SingleParticipantPlaceholder"];
        view.letters = nil;
    }
}

@end
