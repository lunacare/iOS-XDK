//
//  LYRUIDependencyInjectionBaseModule.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 16.02.2018.
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

#import "LYRUIDependencyInjectionBaseModule.h"
#import "LYRUIConfigurable.h"

@interface LYRUIDependencyInjectionBaseModule ()

@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *themes;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *alternativeThemes;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *presenters;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *layouts;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, LYRUIDependencyProviding> *> *protocolImplementations;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *objects;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *messagePresenters;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *messageContainerPresenters;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *messageSerializers;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, LYRUIDependencyProviding> *> *actionHandlers;

@end

@implementation LYRUIDependencyInjectionBaseModule

- (instancetype)init {
    self = [super init];
    if (self) {
        self.themes = [[NSMutableDictionary alloc] init];
        self.alternativeThemes = [[NSMutableDictionary alloc] init];
        self.presenters = [[NSMutableDictionary alloc] init];
        self.layouts = [[NSMutableDictionary alloc] init];
        self.protocolImplementations = [[NSMutableDictionary alloc] init];
        self.objects = [[NSMutableDictionary alloc] init];
        self.messagePresenters = [[NSMutableDictionary alloc] init];
        self.messageContainerPresenters = [[NSMutableDictionary alloc] init];
        self.messageSerializers = [[NSMutableDictionary alloc] init];
        self.actionHandlers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (LYRUIDependencyProviding)providerWithClass:(Class)objectClass {
    return ^id (LYRUIConfiguration *configuration) {
        if ([objectClass conformsToProtocol:@protocol(LYRUIConfigurable)]) {
            return [[objectClass alloc] initWithConfiguration:configuration];
        }
        return [[objectClass alloc] init];
    };
}

- (void)setThemeClass:(Class)themeClass forViewClass:(Class)viewClass {
    [self setThemeProvider:[self providerWithClass:themeClass] forViewClass:viewClass];
}

- (void)setThemeProvider:(LYRUIDependencyProviding)provider forViewClass:(Class)viewClass {
    self.themes[NSStringFromClass(viewClass)] = provider;
}

- (void)setAlternativeThemeClass:(Class)themeClass forViewClass:(Class)viewClass {
    [self setAlternativeThemeProvider:[self providerWithClass:themeClass] forViewClass:viewClass];
}

- (void)setAlternativeThemeProvider:(LYRUIDependencyProviding)provider forViewClass:(Class)viewClass {
    self.alternativeThemes[NSStringFromClass(viewClass)] = provider;
}

- (void)setPresenterClass:(Class)presenterClass forViewClass:(Class)viewClass {
    [self setPresenterProvider:[self providerWithClass:presenterClass] forViewClass:viewClass];
}

- (void)setPresenterProvider:(LYRUIDependencyProviding)provider forViewClass:(Class)viewClass {
    self.presenters[NSStringFromClass(viewClass)] = provider;
}

- (void)setLayoutClass:(Class)layoutClass forViewClass:(Class)viewClass {
    [self setLayoutProvider:[self providerWithClass:layoutClass] forViewClass:viewClass];
}

- (void)setLayoutProvider:(LYRUIDependencyProviding)provider forViewClass:(Class)viewClass {
    self.layouts[NSStringFromClass(viewClass)] = provider;
}

- (void)setImplementationClass:(Class)implementationClass forProtocol:(Protocol *)protocol {
    [self setImplementationClass:implementationClass forProtocol:protocol usedInClass:nil];
}

- (void)setImplementationClass:(Class)implementationClass forProtocol:(Protocol *)protocol usedInClass:(Class)usageClass {
    [self setImplementationProvider:[self providerWithClass:implementationClass]
                        forProtocol:protocol
                        usedInClass:usageClass];
}

- (void)setImplementationProvider:(LYRUIDependencyProviding)provider forProtocol:(Protocol *)protocol usedInClass:(Class)usageClass {
    if (usageClass == nil) {
        usageClass = [LYRUIDIAnyClass class];
    }
    NSString *usageClassKey = NSStringFromClass(usageClass);
    NSString *protocolKey = NSStringFromProtocol(protocol);
    if (self.protocolImplementations[usageClassKey] == nil) {
        self.protocolImplementations[usageClassKey] = [[NSMutableDictionary alloc] init];
    }
    self.protocolImplementations[usageClassKey][protocolKey] = provider;
}

- (void)setProvider:(LYRUIDependencyProviding)provider forObjectType:(Class)objectType {
    self.objects[NSStringFromClass(objectType)] = provider;
}

- (void)setMessagePresenterClass:(Class)presenterClass forMessageClass:(Class)messageClass {
    self.messagePresenters[NSStringFromClass(messageClass)] = [self providerWithClass:presenterClass];
}

- (void)setMessageContainerPresenterClass:(Class)presenterClass forMessageClass:(Class)messageClass {
    self.messageContainerPresenters[NSStringFromClass(messageClass)] = [self providerWithClass:presenterClass];
}

- (void)setMessageSerializerClass:(Class)serializerClass forMIMEType:(NSString *)MIMEType {
    self.messageSerializers[MIMEType] = [self providerWithClass:serializerClass];
}

- (void)setActionHandlerClass:(Class)implementationClass forEvent:(NSString *)event {
    [self setActionHandlerClass:implementationClass forEvent:event usedInMessageType:nil];
}

- (void)setActionHandlerClass:(Class)implementationClass forEvent:(NSString *)event usedInMessageType:(Class)usageMessageType {
    if (usageMessageType == nil) {
        usageMessageType = [LYRUIDIAnyClass class];
    }
    NSString *usageClassKey = NSStringFromClass(usageMessageType);
    if (self.actionHandlers[usageClassKey] == nil) {
        self.actionHandlers[usageClassKey] = [[NSMutableDictionary alloc] init];
    }
    self.actionHandlers[usageClassKey][event] = [self providerWithClass:implementationClass];
}

@end
