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
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIPresenceView.h"
#import "LYRUIPresenceViewDefaultTheme.h"
#import "LYRUIPresenceViewConfiguration.h"
#import "LYRUIAvatarView.h"
#import "LYRUIAvatarViewDefaultTheme.h"
#import "LYRUIAvatarViewConfiguration.h"
#import "LYRUIImageWithLettersView.h"
#import "LYRUIImageWithLettersViewConfiguration.h"
#import "LYRUIBaseItemView.h"
#import "LYRUIBaseItemViewDefaultTheme.h"
#import "LYRUIBaseItemViewLayout.h"
#import "LYRUIConversationItemView.h"
#import "LYRUIConversationItemViewUnreadTheme.h"
#import "LYRUIConversationItemViewLayoutMetrics.h"
#import "LYRUIConversationItemViewConfiguration.h"
#import "LYRUIConversationItemAccessoryViewProvider.h"
#import "LYRUIConversationItemTitleFormatter.h"
#import "LYRUIMessageTextDefaultFormatter.h"
#import "LYRUIMessageTimeDefaultFormatter.h"
#import "LYRUIConversationListView.h"
#import "LYRUIConversationListViewConfiguration.h"
#import "LYRUIListCellConfiguration.h"
#import "LYRUIListHeaderView.h"
#import "LYRUIListSupplementaryViewConfiguration.h"
#import "LYRUIListLayout.h"
#import "LYRUIIdentityItemView.h"
#import "LYRUIIdentityItemViewLayoutMetrics.h"
#import "LYRUIIdentityItemViewConfiguration.h"
#import "LYRUIIdentityItemAccessoryViewProvider.h"
#import "LYRUIIdentityNameFormatter.h"
#import "LYRUITimeAgoFormatter.h"
#import "LYRUIImageFetcher.h"
#import "LYRUIImageFactory.h"
#import "LYRUIInitialsFormatter.h"
#import "LYRUIDataFactory.h"
#import "LYRUIDispatcher.h"
#import "NSBundle+LYRUIAssets.h"
#import "NSCache+LYRUIImageCaching.h"

@interface LYRUIDependencyInjectionDefaultModule ()

@property (nonatomic, strong) id<LYRUIImageCaching> imagesCache;

@end

@implementation LYRUIDependencyInjectionDefaultModule
@synthesize defaultThemes = _defaultThemes,
            defaultAlternativeThemes = _defaultAlternativeThemes,
            defaultConfigurations = _defaultConfigurations,
            defaultLayouts = _defaultLayouts,
            defaultProtocolImplementations = _defaultProtocolImplementations,
            defaultObjects = _defaultObjects;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imagesCache = [[NSCache<NSURL *, UIImage *> alloc] init];
    }
    return self;
}

- (NSDictionary *)defaultThemes {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LYRUIDependencyProviding baseItemThemeProvider = ^id (LYRUIConfiguration *configuration) {
            return [[LYRUIBaseItemViewDefaultTheme alloc] init];
        };
        
        _defaultThemes = @{
                NSStringFromClass([LYRUIPresenceView class]): ^id (LYRUIConfiguration *configuration) {
                    return [[LYRUIPresenceViewDefaultTheme alloc] init];
                },
                NSStringFromClass([LYRUIAvatarView class]): ^id (LYRUIConfiguration *configuration) {
                    return [[LYRUIAvatarViewDefaultTheme alloc] init];
                },
                NSStringFromClass([LYRUIConversationItemView class]): baseItemThemeProvider,
                NSStringFromClass([LYRUIIdentityItemView class]): baseItemThemeProvider,
        };
    });
    return _defaultThemes;
}

- (NSDictionary<NSString *,LYRUIDependencyProviding> *)defaultAlternativeThemes {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultThemes = @{
                NSStringFromClass([LYRUIConversationItemView class]): ^id (LYRUIConfiguration *configuration) {
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
                NSStringFromClass([LYRUIPresenceView class]): ^id (LYRUIConfiguration *configuration) {
                    return [[LYRUIPresenceViewConfiguration alloc] init];
                },
                NSStringFromClass([LYRUIAvatarView class]): ^id (LYRUIConfiguration *configuration) {
                    return [[LYRUIAvatarViewConfiguration alloc] initWithConfiguration:configuration];
                },
                NSStringFromClass([LYRUIImageWithLettersView class]): ^id (LYRUIConfiguration *configuration) {
                    return [[LYRUIImageWithLettersViewConfiguration alloc] init];
                },
                NSStringFromClass([LYRUIConversationItemView class]): ^id (LYRUIConfiguration *configuration) {
                    return [[LYRUIConversationItemViewConfiguration alloc] initWithConfiguration:configuration];
                },
                NSStringFromClass([UICollectionViewCell class]): ^id (LYRUIConfiguration *configuration) {
                    return [[LYRUIListCellConfiguration alloc] init];
                },
                NSStringFromClass([LYRUIListHeaderView class]): ^id (LYRUIConfiguration *configuration) {
                    return [LYRUIListSupplementaryViewConfiguration headerConfiguration];
                },
                NSStringFromClass([LYRUIConversationListView class]): ^id (LYRUIConfiguration *configuration) {
                    return [[LYRUIConversationListViewConfiguration alloc] initWithConfiguration:configuration];
                },
                NSStringFromClass([LYRUIIdentityItemView class]): ^id (LYRUIConfiguration *configuration) {
                    return [[LYRUIIdentityItemViewConfiguration alloc] initWithConfiguration:configuration];
                },
        };
    });
    return _defaultConfigurations;
}

- (NSDictionary *)defaultLayouts {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultLayouts = @{
                NSStringFromClass([LYRUIConversationItemView class]): ^id (LYRUIConfiguration *configuration) {
                    LYRUIConversationItemViewLayoutMetrics *metrics = [[LYRUIConversationItemViewLayoutMetrics alloc] init];
                    return [[LYRUIBaseItemViewLayout alloc] initWithMetrics:metrics];
                },
                NSStringFromClass([LYRUIConversationListView class]): ^id (LYRUIConfiguration *configuration) {
                    return [[LYRUIListLayout alloc] init];
                },
                NSStringFromClass([LYRUIConversationItemView class]): ^id (LYRUIConfiguration *configuration) {
                    LYRUIConversationItemViewLayoutMetrics *metrics = [[LYRUIConversationItemViewLayoutMetrics alloc] init];
                    return [[LYRUIBaseItemViewLayout alloc] initWithMetrics:metrics];
                },
                NSStringFromClass([LYRUIIdentityItemView class]): ^id (LYRUIConfiguration *configuration) {
                    LYRUIIdentityItemViewLayoutMetrics *metrics = [[LYRUIIdentityItemViewLayoutMetrics alloc] init];
                    return [[LYRUIBaseItemViewLayout alloc] initWithMetrics:metrics];
                },
        };
    });
    return _defaultLayouts;
}

- (NSDictionary *)defaultProtocolImplementations {
    __weak __typeof(self) weakSelf = self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultProtocolImplementations = @{
                @"defaults": @{
                        NSStringFromProtocol(@protocol(LYRUIConversationItemAccessoryViewProviding)): ^id (LYRUIConfiguration *configuration) {
                            return [[LYRUIConversationItemAccessoryViewProvider alloc] initWithConfiguration:configuration];
                        },
                        NSStringFromProtocol(@protocol(LYRUIConversationItemTitleFormatting)): ^id (LYRUIConfiguration *configuration) {
                            return [[LYRUIConversationItemTitleFormatter alloc] initWithConfiguration:configuration];
                        },
                        NSStringFromProtocol(@protocol(LYRUIMessageTextFormatting)): ^id (LYRUIConfiguration *configuration) {
                            return [[LYRUIMessageTextDefaultFormatter alloc] init];
                        },
                        NSStringFromProtocol(@protocol(LYRUITimeFormatting)): ^id (LYRUIConfiguration *configuration) {
                            return [[LYRUIMessageTimeDefaultFormatter alloc] init];
                        },
                        NSStringFromProtocol(@protocol(LYRUIIdentityItemAccessoryViewProviding)): ^id (LYRUIConfiguration *configuration) {
                            return [[LYRUIIdentityItemAccessoryViewProvider alloc] init];
                        },
                        NSStringFromProtocol(@protocol(LYRUIIdentityNameFormatting)): ^id (LYRUIConfiguration *configuration) {
                            return [[LYRUIIdentityNameFormatter alloc] init];
                        },
                        NSStringFromProtocol(@protocol(LYRUIImageFetching)): ^id (LYRUIConfiguration *configuration) {
                            return [[LYRUIImageFetcher alloc] initWithConfiguration:configuration];
                        },
                        NSStringFromProtocol(@protocol(LYRUIImageCreating)): ^id (LYRUIConfiguration *configuration) {
                            return [[LYRUIImageFactory alloc] initWithConfiguration:configuration];
                        },
                        NSStringFromProtocol(@protocol(LYRUIInitialsFormatting)): ^id (LYRUIConfiguration *configuration) {
                            return [[LYRUIInitialsFormatter alloc] init];
                        },
                        NSStringFromProtocol(@protocol(LYRUIDataCreating)): ^id (LYRUIConfiguration *configuration) {
                            return [[LYRUIDataFactory alloc] init];
                        },
                        NSStringFromProtocol(@protocol(LYRUIDispatching)): ^id (LYRUIConfiguration *configuration) {
                            return [[LYRUIDispatcher alloc] init];
                        },
                        NSStringFromProtocol(@protocol(LYRUIImageCaching)): ^id (LYRUIConfiguration *configuration) {
                            return weakSelf.imagesCache;
                        },
                },
                NSStringFromClass([LYRUIIdentityItemViewConfiguration class]): @{
                        NSStringFromProtocol(@protocol(LYRUITimeFormatting)): ^id (LYRUIConfiguration *configuration) {
                            return [[LYRUITimeAgoFormatter alloc] initWithConfiguration:configuration];
                        },
                },
        };
    });
    return _defaultProtocolImplementations;
}

- (NSDictionary *)defaultObjects {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultObjects = @{
                NSStringFromClass([NSCalendar class]): ^id (LYRUIConfiguration *configuration) {
                    return [NSCalendar currentCalendar];
                },
                NSStringFromClass([NSDateFormatter class]): ^id (LYRUIConfiguration *configuration) {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.locale = [configuration.injector objectOfType:[NSLocale class]];
                    dateFormatter.timeZone = [configuration.injector objectOfType:[NSTimeZone class]];
                    return dateFormatter;
                },
                NSStringFromClass([NSLocale class]): ^id (LYRUIConfiguration *configuration) {
                    return [NSLocale currentLocale];
                },
                NSStringFromClass([NSTimeZone class]): ^id (LYRUIConfiguration *configuration) {
                    return [NSTimeZone systemTimeZone];
                },
                NSStringFromClass([NSURLSession class]): ^id (LYRUIConfiguration *configuration) {
                    return [NSURLSession sharedSession];
                },
                NSStringFromClass([NSTimeZone class]): ^id (LYRUIConfiguration *configuration) {
                    return [NSBundle bundleWithLayerAssets];
                },
        };
    });
    return _defaultObjects;
}

@end
