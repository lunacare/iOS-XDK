//
//  LYRUIDependencyInjectionModule.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 15.12.2017.
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
#import "LYRUIDependencyInjection.h"

typedef NSObject LYRUIDIAnyClass;

@protocol LYRUIDependencyInjectionModule <NSObject>

@property (nonatomic, readonly) NSDictionary<NSString *, LYRUIDependencyProviding> *themes;
@property (nonatomic, readonly) NSDictionary<NSString *, LYRUIDependencyProviding> *alternativeThemes;
@property (nonatomic, readonly) NSDictionary<NSString *, LYRUIDependencyProviding> *presenters;
@property (nonatomic, readonly) NSDictionary<NSString *, LYRUIDependencyProviding> *layouts;
@property (nonatomic, readonly) NSDictionary<NSString *, NSDictionary<NSString *, LYRUIDependencyProviding> *> *protocolImplementations;
@property (nonatomic, readonly) NSDictionary<NSString *, LYRUIDependencyProviding> *objects;
@property (nonatomic, readonly) NSDictionary<NSString *, LYRUIDependencyProviding> *messagePresenters;
@property (nonatomic, readonly) NSDictionary<NSString *, LYRUIDependencyProviding> *messageContainerPresenters;
@property (nonatomic, readonly) NSDictionary<NSString *, LYRUIDependencyProviding> *messageSerializers;
@property (nonatomic, readonly) NSDictionary<NSString *, NSDictionary<NSString *, LYRUIDependencyProviding> *> *actionHandlers;

@end
