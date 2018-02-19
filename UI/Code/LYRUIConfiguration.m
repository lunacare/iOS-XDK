//
//  LYRUIConfiguration.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 14.12.2017.
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

#import "LYRUIConfiguration.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIDependencyInjector.h"

@implementation LYRUIConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        self.participantsSorter = LYRUIParticipantsDefaultSorter();
        self.injector = [[LYRUIDependencyInjector alloc] init];
        self.injector.layerConfiguration = self;
    }
    return self;
}

- (instancetype)initWithLayerClient:(LYRClient *)client {
    self = [self init];
    if (self) {
        self.client = client;
    }
    return self;
}

- (void)setClient:(LYRClient *)client {
    _client = client;
    if (self.participantsFilter == nil && client.authenticatedUser != nil) {
        self.participantsFilter = LYRUIParticipantsDefaultFilterWithCurrentUser(client.authenticatedUser);
    }
}

- (void)registerMessageTypeClass:(Class)messageTypeClass
             withSerializerClass:(Class)serializerClass
           contentPresenterClass:(Class)contentPresenterClass {
    [self.injector registerMessageTypeClass:messageTypeClass
                        withSerializerClass:serializerClass
                      contentPresenterClass:contentPresenterClass];
}

- (void)registerMessageTypeClass:(Class)messageTypeClass
             withSerializerClass:(Class)serializerClass
           contentPresenterClass:(Class)contentPresenterClass
         containerPresenterClass:(Class)containerPresenterClass {
    [self.injector registerMessageTypeClass:messageTypeClass
                        withSerializerClass:serializerClass
                      contentPresenterClass:contentPresenterClass
                    containerPresenterClass:containerPresenterClass];
}

- (void)registerActionHandlerClass:(Class)actionHandlerClass
                          forEvent:(NSString *)event {
    [self.injector registerActionHandlerClass:actionHandlerClass forEvent:event];
}

- (void)registerActionHandlerClass:(Class)actionHandlerClass
                          forEvent:(NSString *)event
                  messageTypeClass:(Class)messageTypeClass {
    [self.injector registerActionHandlerClass:actionHandlerClass forEvent:event messageTypeClass:messageTypeClass];
}

@end
