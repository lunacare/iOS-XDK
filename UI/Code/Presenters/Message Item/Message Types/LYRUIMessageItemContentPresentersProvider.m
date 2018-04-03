//
//  LYRUIMessageItemContentPresentersProvider.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 02.10.2017.
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

#import "LYRUIMessageItemContentPresentersProvider.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIMessageItemContentPresenting.h"

@interface LYRUIMessageItemContentPresentersProvider ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, id<LYRUIMessageItemContentPresenting>> *presenters;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<LYRUIMessageItemContentContainerPresenting>> *containerPresenters;

@end

@implementation LYRUIMessageItemContentPresentersProvider
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.presenters = [[NSMutableDictionary alloc] init];
        self.containerPresenters = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [self init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    [self setupMessagePresenters];
    [self setupMessageContainerPresenters];
}

- (void)setupMessagePresenters {
    for (Class messageClass in self.layerConfiguration.injector.handledMessageClasses) {
        id<LYRUIMessageItemContentPresenting> presenter = [self.layerConfiguration.injector presenterForMessageClass:messageClass];
        [self registerContentPresenter:presenter forMessageClass:messageClass];
    }
}

- (void)setupMessageContainerPresenters {
    for (Class messageClass in self.layerConfiguration.injector.handledMessageClasses) {
        id<LYRUIMessageItemContentContainerPresenting> presenter = [self.layerConfiguration.injector containerPresenterForMessageClass:messageClass];
        [self registerContainerPresenter:presenter forMessageClass:messageClass];
    }
}

#pragma mark - Presenters Management

- (void)registerContentPresenter:(id<LYRUIMessageItemContentPresenting>)presenter forMessageClass:(Class)messageClass {
    if (presenter != nil && messageClass != nil) {
        presenter.presentersProvider = self;
        self.presenters[NSStringFromClass(messageClass)] = presenter;
    }
}

- (id<LYRUIMessageItemContentPresenting>)contentPresenterForMessageClass:(Class)messageClass {
    id<LYRUIMessageItemContentPresenting> presenter = self.presenters[NSStringFromClass(messageClass)];
    return presenter ?: self.defaultPresenter;
}

- (void)registerContainerPresenter:(id<LYRUIMessageItemContentContainerPresenting>)presenter forMessageClass:(Class)messageClass {
    if (presenter != nil && messageClass != nil) {
        presenter.presentersProvider = self;
        self.containerPresenters[NSStringFromClass(messageClass)] = presenter;
    }
}

- (id<LYRUIMessageItemContentContainerPresenting>)containerPresenterForMessageClass:(Class)messageClass {
    id<LYRUIMessageItemContentContainerPresenting> presenter = self.containerPresenters[NSStringFromClass(messageClass)];
    return presenter;
}

- (id<LYRUIMessageItemContentPresenting>)presenterForMessageClass:(Class)messageClass {
    id<LYRUIMessageItemContentPresenting> presenter = [self containerPresenterForMessageClass:messageClass];
    if (presenter == nil) {
        presenter = [self contentPresenterForMessageClass:messageClass];
    }
    return presenter;
}

@end
