//
//  LYRUIDependencyInjector.m
//  Layer-XDK-UI-iOS
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
#import "LYRUIMessageType.h"
#import "LYRUIDependencyInjectionBaseModule.h"

extern LYRUIMessageSizeVariant LYRUIMessageSizeVariantMedium;

@interface LYRUIDependencyInjector ()

@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *customMessagePresenters;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *customMessageContainerPresenters;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *customMessageSerializers;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, LYRUIDependencyProviding> *> *customActionHandlers;

@property (nonatomic, strong) LYRUIDependencyInjectionBaseModule *customMessagesModule;

@end

@implementation LYRUIDependencyInjector
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.module = [[LYRUIDependencyInjectionDefaultModule alloc] init];
        self.customMessagesModule = [[LYRUIDependencyInjectionBaseModule alloc] init];
    }
    return self;
}

#pragma mark - LYRUIDependencyInjection

- (id)themeForViewClass:(Class)viewClass {
    LYRUIDependencyProviding provider = self.module.themes[NSStringFromClass(viewClass)];
    return provider ? provider(self.layerConfiguration) : nil;
}

- (id)alternativeThemeForViewClass:(Class)viewClass {
    LYRUIDependencyProviding provider = self.module.alternativeThemes[NSStringFromClass(viewClass)];
    return provider ? provider(self.layerConfiguration) : nil;
}

- (id)presenterForViewClass:(Class)viewClass {
    LYRUIDependencyProviding provider = self.module.presenters[NSStringFromClass(viewClass)];
    return provider ? provider(self.layerConfiguration) : nil;
}

- (id)layoutForViewClass:(Class)viewClass {
    LYRUIDependencyProviding provider = self.module.layouts[NSStringFromClass(viewClass)];
    return provider ? provider(self.layerConfiguration) : nil;
}

- (id)protocolImplementation:(Protocol *)protocol forClass:(Class)class {
    NSString *protocolKey = NSStringFromProtocol(protocol);
    LYRUIDependencyProviding provider = self.module.protocolImplementations[NSStringFromClass(class)][protocolKey];
    if (provider == nil) {
        NSString *anyClassKey = NSStringFromClass([LYRUIDIAnyClass class]);
        provider = self.module.protocolImplementations[anyClassKey][protocolKey];
    }
    return provider ? provider(self.layerConfiguration) : nil;
}

- (id)objectOfType:(Class)type {
    LYRUIDependencyProviding provider = self.module.objects[NSStringFromClass(type)];
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
    for (NSDictionary *presenters in self.module.sizedMessagePresenters.allValues) {
        for (NSString *className in presenters.allKeys) {
            Class class = NSClassFromString(className);
            if (className != nil) {
                [classes addObject:class];
            }
        }
    }
    for (NSDictionary *presenters in self.customMessagesModule.sizedMessagePresenters.allValues) {
        for (NSString *className in presenters.allKeys) {
            Class class = NSClassFromString(className);
            if (className != nil) {
                [classes addObject:class];
            }
        }
    }
    return classes.allObjects;
}

- (nullable id<LYRUIMessageItemContentPresenting>)presenterForMessageClass:(Class)messageClass sizeVariant:(LYRUIMessageSizeVariant)sizeVariant {
    if (!sizeVariant) {
        return nil;
    }
    NSMutableDictionary<NSString *, LYRUIDependencyProviding> *messagePresenters = self.customMessagesModule.sizedMessagePresenters[sizeVariant];
    LYRUIDependencyProviding provider = messagePresenters[NSStringFromClass(messageClass)];
    if (provider == nil) {
        messagePresenters = self.module.sizedMessagePresenters[sizeVariant];
        provider = messagePresenters[NSStringFromClass(messageClass)];
    }
    if (provider) {
        return provider(self.layerConfiguration);
    }
    return nil;
}

- (id<LYRUIMessageItemContentPresenting>)containerPresenterForMessageClass:(Class)messageClass sizeVariant:(LYRUIMessageSizeVariant)sizeVariant {
    if (!sizeVariant) {
        return nil;
    }
    NSMutableDictionary<NSString *, LYRUIDependencyProviding> *messageContainerPresenters = self.customMessagesModule.sizedMessageContainerPresenters[sizeVariant];
    LYRUIDependencyProviding provider = messageContainerPresenters[NSStringFromClass(messageClass)];
    if (provider == nil) {
        messageContainerPresenters = self.module.sizedMessageContainerPresenters[sizeVariant];
        provider = messageContainerPresenters[NSStringFromClass(messageClass)];
    }
    if (provider) {
        return provider(self.layerConfiguration);
    }
    return nil;
}

- (id<LYRUIMessageTypeSerializing>)serializerForMessagePartMIMEType:(NSString *)MIMEType {
    LYRUIDependencyProviding provider = self.customMessagesModule.messageSerializers[MIMEType];
    if (provider == nil) {
        provider = self.module.messageSerializers[MIMEType];
    }
    if (provider) {
        return provider(self.layerConfiguration);
    }
    return nil;
}

- (id<LYRUIActionHandling>)handlerOfMessageActionWithEvent:(NSString *)event forMessageType:(Class)messageClass {
    LYRUIDependencyProviding provider = self.customMessagesModule.actionHandlers[NSStringFromClass(messageClass)][event];
    if (provider == nil) {
        NSString *anyClassKey = NSStringFromClass([LYRUIDIAnyClass class]);
        provider = self.customMessagesModule.actionHandlers[anyClassKey][event];
    }
    if (provider == nil) {
        NSString *anyClassKey = NSStringFromClass([LYRUIDIAnyClass class]);
        provider = self.module.actionHandlers[anyClassKey][event];
    }
    if (provider) {
        return provider(self.layerConfiguration);
    }
    return nil;
}

#pragma mark - Custom messages registration

- (void)registerMessageTypeClass:(Class)messageTypeClass
             withSerializerClass:(Class)serializerClass
           contentPresenterClass:(Class)contentPresenterClass {
    [self registerMessageTypeClass:messageTypeClass
               withSerializerClass:serializerClass
             contentPresenterClass:contentPresenterClass
           containerPresenterClass:nil
                       sizeVariant:LYRUIMessageSizeVariantMedium];
}

- (void)registerMessageTypeClass:(Class)messageTypeClass
             withSerializerClass:(Class)serializerClass
           contentPresenterClass:(Class)contentPresenterClass
                     sizeVariant:(LYRUIMessageSizeVariant)sizeVariant {
    [self registerMessageTypeClass:messageTypeClass
               withSerializerClass:serializerClass
             contentPresenterClass:contentPresenterClass
           containerPresenterClass:nil
                       sizeVariant:sizeVariant];
}

- (void)registerMessageTypeClass:(Class)messageTypeClass
             withSerializerClass:(Class)serializerClass
           contentPresenterClass:(Class)contentPresenterClass
         containerPresenterClass:(Class)containerPresenterClass {
    [self registerMessageTypeClass:messageTypeClass
               withSerializerClass:serializerClass
             contentPresenterClass:contentPresenterClass
           containerPresenterClass:contentPresenterClass
                       sizeVariant:LYRUIMessageSizeVariantMedium];
}


- (void)registerMessageTypeClass:(Class)messageTypeClass
             withSerializerClass:(Class)serializerClass
           contentPresenterClass:(Class)contentPresenterClass
         containerPresenterClass:(Class)containerPresenterClass
                     sizeVariant:(LYRUIMessageSizeVariant)sizeVariant {
    if (messageTypeClass == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"`messageTypeClass` argument can not be nil." userInfo:nil];
    }
    if (![messageTypeClass isSubclassOfClass:[LYRUIMessageType class]]) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"`messageTypeClass` must be a subclass of `LYRUIMessageType`." userInfo:nil];
    }
    if (serializerClass == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"`serializerClass` argument can not be nil." userInfo:nil];
    }
    if (![serializerClass conformsToProtocol:@protocol(LYRUIMessageTypeSerializing)]) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"`serializerClass` must conform to `LYRUIMessageTypeSerializing` protocol." userInfo:nil];
    }
    if (contentPresenterClass == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"`contentPresenterClass` argument can not be nil." userInfo:nil];
    }
    if (![contentPresenterClass conformsToProtocol:@protocol(LYRUIMessageItemContentPresenting)]) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"`contentPresenterClass` must conform to `LYRUIMessageItemContentPresenting` protocol." userInfo:nil];
    }
    if (containerPresenterClass != nil && ![containerPresenterClass conformsToProtocol:@protocol(LYRUIMessageItemContentContainerPresenting)]) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"`containerPresenterClass` must conform to `LYRUIMessageItemContentContainerPresenting` protocol." userInfo:nil];
    }
    [self.customMessagesModule setMessageSerializerClass:serializerClass forMIMEType:[messageTypeClass MIMEType]];
    [self.customMessagesModule setMessagePresenterClass:contentPresenterClass forMessageClass:messageTypeClass sizeVariant:sizeVariant];
    if (containerPresenterClass != nil) {
        [self.customMessagesModule setMessageContainerPresenterClass:containerPresenterClass forMessageClass:messageTypeClass sizeVariant:sizeVariant];
    }
}

- (void)registerActionHandlerClass:(Class)actionHandlerClass
                          forEvent:(NSString *)event {
    [self registerActionHandlerClass:actionHandlerClass forEvent:event messageTypeClass:nil];
}

- (void)registerActionHandlerClass:(Class)actionHandlerClass
                          forEvent:(NSString *)event
                  messageTypeClass:(Class)messageTypeClass {
    if (actionHandlerClass == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"`actionHandlerClass` argument can not be nil." userInfo:nil];
    }
    if (![actionHandlerClass conformsToProtocol:@protocol(LYRUIActionHandling)]) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"`actionHandlerClass` must conform to `LYRUIActionHandling` protocol." userInfo:nil];
    }
    if (event == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"`event` argument can not be nil." userInfo:nil];
    }
    [self.customMessagesModule setActionHandlerClass:actionHandlerClass forEvent:event usedInMessageType:messageTypeClass];
}

#pragma mark - Deprecated Methods

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

- (nullable id<LYRUIMessageItemContentPresenting>)presenterForMessageClass:(Class)messageClass {
    return [self presenterForMessageClass:messageClass sizeVariant:LYRUIMessageSizeVariantMedium];
}

- (id<LYRUIMessageItemContentPresenting>)containerPresenterForMessageClass:(Class)messageClass {
    return [self containerPresenterForMessageClass:messageClass sizeVariant:LYRUIMessageSizeVariantMedium];
}

#pragma clang diagnostic pop

@end
