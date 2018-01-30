//
//  LYRUIDependencyInjector.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 19.12.2017.
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

#import "LYRUIDependencyInjector.h"
#import "LYRUIConfigurable.h"
#import "LYRUIDependencyInjectionDefaultModule.h"
#import "LYRUIMessageTypeSerializing.h"
#import "LYRUIMessageItemContentPresenting.h"
#import "LYRUIMessageItemContentContainerPresenting.h"
#import "LYRUIActionHandling.h"

@implementation LYRUIDependencyInjector
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)init {
    self = [super init];
    if (self) {
        id<LYRUIDependencyInjectionModule> module = [[LYRUIDependencyInjectionDefaultModule alloc] init];
        self.module = module;
    }
    return self;
}

#pragma mark - LYRUIDependencyInjection

- (id)themeForViewClass:(Class)viewClass {
    LYRUIDependencyProviding provider = self.module.defaultThemes[NSStringFromClass(viewClass)];
    return provider(self.layerConfiguration);
}

- (id)alternativeThemeForViewClass:(Class)viewClass {
    LYRUIDependencyProviding provider = self.module.defaultAlternativeThemes[NSStringFromClass(viewClass)];
    return provider(self.layerConfiguration);
}

- (id)presenterForViewClass:(Class)viewClass {
    LYRUIDependencyProviding provider = self.module.defaultPresenters[NSStringFromClass(viewClass)];
    return provider(self.layerConfiguration);
}

- (id)layoutForViewClass:(Class)viewClass {
    LYRUIDependencyProviding provider = self.module.defaultLayouts[NSStringFromClass(viewClass)];
    return provider(self.layerConfiguration);
}

- (id)protocolImplementation:(Protocol *)protocol forClass:(Class)class {
    NSString *protocolKey = NSStringFromProtocol(protocol);
    LYRUIDependencyProviding provider = self.module.defaultProtocolImplementations[NSStringFromClass(class)][protocolKey];
    if (provider == nil) {
        NSString *anyClassKey = NSStringFromClass([LYRUIDIAnyClass class]);
        provider = self.module.defaultProtocolImplementations[anyClassKey][protocolKey];
    }
    return provider(self.layerConfiguration);
}

- (id)objectOfType:(Class)type {
    LYRUIDependencyProviding provider = self.module.defaultObjects[NSStringFromClass(type)];
    if (provider) {
        return provider(self.layerConfiguration);
    }
    if ([type conformsToProtocol:@protocol(LYRUIConfigurable)]) {
        return [[type alloc] initWithConfiguration:self.layerConfiguration];
    }
    return [[type alloc] init];
}

- (NSArray<Class> *)handledMessageClasses {
    NSMutableSet *classes = [[NSMutableSet alloc] init];
    for (NSString *className in self.module.defaultMessagePresenters.allKeys) {
        Class class = NSClassFromString(className);
        if (className != nil) {
            [classes addObject:class];
        }
    }
    for (NSString *className in self.module.defaultMessageContainerPresenters.allKeys) {
        Class class = NSClassFromString(className);
        if (className != nil) {
            [classes addObject:class];
        }
    }
    return classes.allObjects;
}

- (id<LYRUIMessageItemContentPresenting>)presenterForMessageClass:(Class)messageClass {
    LYRUIDependencyProviding provider = self.module.defaultMessagePresenters[NSStringFromClass(messageClass)];
    if (provider) {
        return provider(self.layerConfiguration);
    }
    return nil;
}

- (id<LYRUIMessageItemContentPresenting>)containerPresenterForMessageClass:(Class)messageClass {
    LYRUIDependencyProviding provider = self.module.defaultMessageContainerPresenters[NSStringFromClass(messageClass)];
    if (provider) {
        return provider(self.layerConfiguration);
    }
    return nil;
}

- (id<LYRUIMessageTypeSerializing>)serializerForMessagePartMIMEType:(NSString *)MIMEType {
    LYRUIDependencyProviding provider = self.module.defaultMessageSerializers[MIMEType];
    if (provider) {
        return provider(self.layerConfiguration);
    }
    return nil;
}

- (id<LYRUIActionHandling>)handlerOfMessageActionWithEvent:(NSString *)event forMessageType:(Class)messageClass {
    LYRUIDependencyProviding provider = self.module.defaultActionHandlers[NSStringFromClass(messageClass)][event];
    if (provider == nil) {
        NSString *anyClassKey = NSStringFromClass([LYRUIDIAnyClass class]);
        provider = self.module.defaultActionHandlers[anyClassKey][event];
    }
    return provider(self.layerConfiguration);
}

@end
