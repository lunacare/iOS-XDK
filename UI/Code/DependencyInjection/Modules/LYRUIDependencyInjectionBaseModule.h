//
//  LYRUIDependencyInjectionBaseModule.h
//  Layer-XDK-UI-iOS
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

#import <Foundation/Foundation.h>
#import "LYRUIDependencyInjectionModule.h"

@interface LYRUIDependencyInjectionBaseModule : NSObject <LYRUIDependencyInjectionModule>

- (LYRUIDependencyProviding)providerWithClass:(Class)objectClass;

- (void)setThemeClass:(Class)themeClass forViewClass:(Class)viewClass;
- (void)setThemeProvider:(LYRUIDependencyProviding)provider forViewClass:(Class)viewClass;

- (void)setAlternativeThemeClass:(Class)themeClass forViewClass:(Class)viewClass;
- (void)setAlternativeThemeProvider:(LYRUIDependencyProviding)provider forViewClass:(Class)viewClass;

- (void)setPresenterClass:(Class)presenterClass forViewClass:(Class)viewClass;
- (void)setPresenterProvider:(LYRUIDependencyProviding)provider forViewClass:(Class)viewClass;

- (void)setLayoutClass:(Class)layoutClass forViewClass:(Class)viewClass;
- (void)setLayoutProvider:(LYRUIDependencyProviding)provider forViewClass:(Class)viewClass;

- (void)setImplementationClass:(Class)implementationClass forProtocol:(Protocol *)protocol;
- (void)setImplementationClass:(Class)implementationClass forProtocol:(Protocol *)protocol usedInClass:(Class)usageClass;
- (void)setImplementationProvider:(LYRUIDependencyProviding)provider forProtocol:(Protocol *)protocol usedInClass:(Class)usageClass;

- (void)setProvider:(LYRUIDependencyProviding)provider forObjectType:(Class)objectType;

- (void)setMessagePresenterClass:(Class)presenterClass forMessageClass:(Class)messageClass;
- (void)setMessageContainerPresenterClass:(Class)presenterClass forMessageClass:(Class)messageClass;
- (void)setMessageSerializerClass:(Class)serializerClass forMIMEType:(NSString *)MIMEType;
- (void)setActionHandlerClass:(Class)implementationClass forEvent:(NSString *)event;
- (void)setActionHandlerClass:(Class)implementationClass forEvent:(NSString *)event usedInMessageType:(Class)usageMessageType;

@end
