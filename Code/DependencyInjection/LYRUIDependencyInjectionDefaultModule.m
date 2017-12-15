//
//  LYRUIDependencyInjectionDefaultModule.m
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

#import "LYRUIDependencyInjectionDefaultModule.h"
#import "LYRUIPresenceView.h"
#import "LYRUIPresenceViewDefaultTheme.h"
#import "LYRUIPresenceViewConfiguration.h"
#import "LYRUIAvatarView.h"
#import "LYRUIAvatarViewDefaultTheme.h"
#import "LYRUIAvatarViewConfiguration.h"
#import "LYRUIBaseItemView.h"
#import "LYRUIBaseItemViewDefaultTheme.h"
#import "LYRUIBaseItemViewLayout.h"
#import "LYRUIConversationItemView.h"
#import "LYRUIConversationItemViewUnreadTheme.h"
#import "LYRUIConversationItemViewLayoutMetrics.h"
#import "LYRUIConversationItemAccessoryViewProvider.h"
#import "LYRUIConversationItemTitleFormatter.h"
#import "LYRUIMessageTextDefaultFormatter.h"
#import "LYRUIMessageTimeDefaultFormatter.h"

@implementation LYRUIDependencyInjectionDefaultModule
@synthesize defaultThemes = _defaultThemes,
            defaultAlternativeThemes = _defaultAlternativeThemes,
            defaultConfigurations = _defaultConfigurations,
            defaultLayouts = _defaultLayouts,
            defaultProtocolImplementations = _defaultProtocolImplementations;

- (NSDictionary *)defaultThemes {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LYRUIDependencyProviding baseItemThemeProvider = ^id (id<LYRUIDependencyInjection> injector) {
            return [[LYRUIBaseItemViewDefaultTheme alloc] init];
        };
        
        _defaultThemes = @{
                NSStringFromClass([LYRUIPresenceView class]): ^id (id<LYRUIDependencyInjection> injector) {
                    return [[LYRUIPresenceViewDefaultTheme alloc] init];
                },
                NSStringFromClass([LYRUIAvatarView class]): ^id (id<LYRUIDependencyInjection> injector) {
                    return [[LYRUIAvatarViewDefaultTheme alloc] init];
                },
                NSStringFromClass([LYRUIBaseItemView class]): baseItemThemeProvider,
                NSStringFromClass([LYRUIConversationItemView class]): baseItemThemeProvider,
        };
    });
    return _defaultThemes;
}

- (NSDictionary<NSString *,LYRUIDependencyProviding> *)defaultAlternativeThemes {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultThemes = @{
                NSStringFromClass([LYRUIConversationItemView class]): ^id (id<LYRUIDependencyInjection> injector) {
                    return [[LYRUIConversationItemViewUnreadTheme alloc] init];
                },
        };
    });
    return _defaultAlternativeThemes;
}

- (NSDictionary *)defaultConfigurations {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultConfigurations = @{
                NSStringFromClass([LYRUIPresenceView class]): ^id (id<LYRUIDependencyInjection> injector) {
                    return [[LYRUIPresenceViewConfiguration alloc] init];
                },
                NSStringFromClass([LYRUIAvatarView class]): ^id (id<LYRUIDependencyInjection> injector) {
                    return [[LYRUIAvatarViewConfiguration alloc] init];
                },
        };
    });
    return _defaultConfigurations;
}

- (NSDictionary *)defaultLayouts {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultLayouts = @{
                NSStringFromClass([LYRUIBaseItemView class]): ^id (id<LYRUIDependencyInjection> injector) {
                    LYRUIConversationItemViewLayoutMetrics *metrics = [[LYRUIConversationItemViewLayoutMetrics alloc] init];
                    return [[LYRUIBaseItemViewLayout alloc] initWithMetrics:metrics];
                },
        };
    });
    return _defaultLayouts;
}

- (NSDictionary *)defaultProtocolImplementations {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultProtocolImplementations = @{
                @"defaults": @{
                        NSStringFromProtocol(@protocol(LYRUIConversationItemAccessoryViewProviding)): ^id (id<LYRUIDependencyInjection> injector) {
                            return [[LYRUIConversationItemAccessoryViewProvider alloc] init];
                        },
                        NSStringFromProtocol(@protocol(LYRUIConversationItemTitleFormatting)): ^id (id<LYRUIDependencyInjection> injector) {
                            return [[LYRUIConversationItemTitleFormatter alloc] init];
                        },
                        NSStringFromProtocol(@protocol(LYRUIMessageTextFormatting)): ^id (id<LYRUIDependencyInjection> injector) {
                            return [[LYRUIMessageTextDefaultFormatter alloc] init];
                        },
                        NSStringFromProtocol(@protocol(LYRUITimeFormatting)): ^id (id<LYRUIDependencyInjection> injector) {
                            return [[LYRUIMessageTimeDefaultFormatter alloc] init];
                        },
                },
        };
    });
    return _defaultProtocolImplementations;
}

@end
