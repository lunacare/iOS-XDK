//
//  LYRUIMessageItemContentPresentersProvider.m
//  Layer-UI-iOS
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

#pragma mark - Properties

- (NSArray<id<LYRUIMessageItemContentPresenting>> *)allPresenters {
    return [self.presenters.allValues valueForKeyPath:@"@distinctUnionOfObjects.self"];
}

- (void)setActionHandlingDelegate:(id<LYRUIMessageListActionHandlingDelegate>)actionHandlingDelegate {
    _actionHandlingDelegate = actionHandlingDelegate;
    for (id<LYRUIMessageItemContentPresenting> configurator in self.presenters.allValues) {
        configurator.actionHandlingDelegate = actionHandlingDelegate;
    }
    for (id<LYRUIMessageItemContentContainerPresenting> configurator in self.containerPresenters.allValues) {
        configurator.actionHandlingDelegate = actionHandlingDelegate;
    }
}

#pragma mark - Presenters Management

- (void)registerContentPresenter:(id<LYRUIMessageItemContentPresenting>)configurator forMessageClass:(Class)messageClass {
    if (configurator != nil && messageClass != nil) {
        configurator.reusableViewsQueue = self.reusableViewsQueue;
        self.presenters[NSStringFromClass(messageClass)] = configurator;
    }
}

- (id<LYRUIMessageItemContentPresenting>)contentPresenterForMessageClass:(Class)messageClass {
    id<LYRUIMessageItemContentPresenting> configurator = self.presenters[NSStringFromClass(messageClass)];
    return configurator ?: self.defaultPresenter;
}

- (void)registerContainerPresenter:(id<LYRUIMessageItemContentContainerPresenting>)configurator forMessageClass:(Class)messageClass {
    if (configurator != nil && messageClass != nil) {
        configurator.reusableViewsQueue = self.reusableViewsQueue;
        self.containerPresenters[NSStringFromClass(messageClass)] = configurator;
    }
}

- (id<LYRUIMessageItemContentContainerPresenting>)containerPresenterForMessageClass:(Class)messageClass {
    id<LYRUIMessageItemContentContainerPresenting> configurator = self.containerPresenters[NSStringFromClass(messageClass)];
    return configurator;
}

- (id<LYRUIMessageItemContentPresenting>)presenterForMessageClass:(Class)messageClass {
    id<LYRUIMessageItemContentPresenting> configurator = [self containerPresenterForMessageClass:messageClass];
    if (configurator == nil) {
        configurator = [self contentPresenterForMessageClass:messageClass];
    }
    return configurator;
}

@end
