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
#import "LYRUIIdentityListView.h"
#import "LYRUIIdentityListViewConfiguration.h"
#import "LYRUIImageFetcher.h"
#import "LYRUIImageFactory.h"
#import "LYRUIInitialsFormatter.h"
#import "LYRUIDataFactory.h"
#import "LYRUIDispatcher.h"
#import "NSCache+LYRUIImageCaching.h"
#import "LYRUIBundleProvider.h"

@interface LYRUIDependencyInjectionDefaultModule ()

@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *defaultThemes;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *defaultAlternativeThemes;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *defaultConfigurations;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *defaultLayouts;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, LYRUIDependencyProviding> *> *defaultProtocolImplementations;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *defaultObjects;

@property (nonatomic, strong) id<LYRUIImageCaching> imagesCache;
@property (nonatomic, strong) LYRUIBundleProvider *bundleProvider;

@end

@implementation LYRUIDependencyInjectionDefaultModule

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imagesCache = [[NSCache<NSURL *, UIImage *> alloc] init];
        self.bundleProvider = [[LYRUIBundleProvider alloc] init];
        
        [self setupThemes];
        [self setupAlternativeThemes];
        [self setupConfigurations];
        [self setupLayouts];
        [self setupProtocolImplementations];
        [self setupObjects];
    }
    return self;
}

#pragma mark - Setup

- (void)setupThemes {
    self.defaultThemes = [[NSMutableDictionary alloc] init];
    
    [self setThemeClass:[LYRUIPresenceViewDefaultTheme class] forViewClass:[LYRUIPresenceView class]];
    [self setThemeClass:[LYRUIAvatarViewDefaultTheme class] forViewClass:[LYRUIAvatarView class]];
    [self setThemeClass:[LYRUIBaseItemViewDefaultTheme class] forViewClass:[LYRUIConversationItemView class]];
    [self setThemeClass:[LYRUIBaseItemViewDefaultTheme class] forViewClass:[LYRUIIdentityItemView class]];
}

- (void)setupAlternativeThemes {
    self.defaultAlternativeThemes = [[NSMutableDictionary alloc] init];
    
    [self setAlternativeThemeClass:[LYRUIConversationItemViewUnreadTheme class] forViewClass:[LYRUIConversationItemView class]];
}

- (void)setupConfigurations {
    self.defaultConfigurations = [[NSMutableDictionary alloc] init];
    
    [self setConfigurationClass:[LYRUIPresenceViewConfiguration class] forViewClass:[LYRUIPresenceView class]];
    [self setConfigurationClass:[LYRUIAvatarViewConfiguration class] forViewClass:[LYRUIAvatarView class]];
    [self setConfigurationClass:[LYRUIImageWithLettersViewConfiguration class] forViewClass:[LYRUIImageWithLettersView class]];
    [self setConfigurationClass:[LYRUIConversationItemViewConfiguration class] forViewClass:[LYRUIConversationItemView class]];
    [self setConfigurationClass:[LYRUIListCellConfiguration class] forViewClass:[UICollectionViewCell class]];
    [self setConfigurationClass:[LYRUIListSupplementaryViewConfiguration class] forViewClass:[LYRUIListHeaderView class]];
    [self setConfigurationClass:[LYRUIConversationListViewConfiguration class] forViewClass:[LYRUIConversationListView class]];
    [self setConfigurationClass:[LYRUIIdentityItemViewConfiguration class] forViewClass:[LYRUIIdentityItemView class]];
    [self setConfigurationClass:[LYRUIIdentityListViewConfiguration class] forViewClass:[LYRUIIdentityListView class]];
}

- (void)setupLayouts {
    self.defaultLayouts = [[NSMutableDictionary alloc] init];
    
    self.defaultLayouts[NSStringFromClass([LYRUIConversationItemView class])] = ^id (LYRUIConfiguration *configuration) {
        LYRUIConversationItemViewLayoutMetrics *metrics = [[LYRUIConversationItemViewLayoutMetrics alloc] init];
        return [[LYRUIBaseItemViewLayout alloc] initWithMetrics:metrics];
    };
    [self setLayoutClass:[LYRUIListLayout class] forViewClass:[LYRUIConversationListView class]];
    self.defaultLayouts[NSStringFromClass([LYRUIConversationItemView class])] = ^id (LYRUIConfiguration *configuration) {
        LYRUIConversationItemViewLayoutMetrics *metrics = [[LYRUIConversationItemViewLayoutMetrics alloc] init];
        return [[LYRUIBaseItemViewLayout alloc] initWithMetrics:metrics];
    };
    [self setLayoutClass:[LYRUIListLayout class] forViewClass:[LYRUIIdentityListView class]];
    self.defaultLayouts[NSStringFromClass([LYRUIIdentityItemView class])] = ^id (LYRUIConfiguration *configuration) {
        LYRUIIdentityItemViewLayoutMetrics *metrics = [[LYRUIIdentityItemViewLayoutMetrics alloc] init];
        return [[LYRUIBaseItemViewLayout alloc] initWithMetrics:metrics];
    };
}

- (void)setupProtocolImplementations {
    self.defaultProtocolImplementations = [[NSMutableDictionary alloc] init];
    
    [self setImplementationClass:[LYRUIConversationItemAccessoryViewProvider class]
                     forProtocol:@protocol(LYRUIConversationItemAccessoryViewProviding)];
    [self setImplementationClass:[LYRUIConversationItemTitleFormatter class]
                     forProtocol:@protocol(LYRUIConversationItemTitleFormatting)];
    [self setImplementationClass:[LYRUIMessageTextDefaultFormatter class]
                     forProtocol:@protocol(LYRUIMessageTextFormatting)];
    [self setImplementationClass:[LYRUIMessageTimeDefaultFormatter class]
                     forProtocol:@protocol(LYRUITimeFormatting)];
    [self setImplementationClass:[LYRUIIdentityItemAccessoryViewProvider class]
                     forProtocol:@protocol(LYRUIIdentityItemAccessoryViewProviding)];
    [self setImplementationClass:[LYRUIIdentityNameFormatter class]
                     forProtocol:@protocol(LYRUIIdentityNameFormatting)];
    [self setImplementationClass:[LYRUIImageFetcher class]
                     forProtocol:@protocol(LYRUIImageFetching)];
    [self setImplementationClass:[LYRUIImageFactory class]
                     forProtocol:@protocol(LYRUIImageCreating)];
    [self setImplementationClass:[LYRUIInitialsFormatter class]
                     forProtocol:@protocol(LYRUIInitialsFormatting)];
    [self setImplementationClass:[LYRUIDataFactory class]
                     forProtocol:@protocol(LYRUIDataCreating)];
    [self setImplementationClass:[LYRUIDispatcher class]
                     forProtocol:@protocol(LYRUIDispatching)];
    [self setupImagesCache];
    
    [self setImplementationClass:[LYRUITimeAgoFormatter class]
                     forProtocol:@protocol(LYRUITimeFormatting)
                     usedInClass:[LYRUIIdentityItemViewConfiguration class]];
}

- (void)setupImagesCache {
    NSString *anyClassKey = NSStringFromClass([LYRUIDIAnyClass class]);
    NSString *imagesCachingKey = NSStringFromProtocol(@protocol(LYRUIImageCaching));
    __weak __typeof(self) weakSelf = self;
    self.defaultProtocolImplementations[anyClassKey][imagesCachingKey] = ^id (LYRUIConfiguration *configuration) {
        return weakSelf.imagesCache;
    };
}

- (void)setupObjects {
    self.defaultObjects = [[NSMutableDictionary alloc] init];
    
    [self setProvider:^id (LYRUIConfiguration *configuration) {
        return [NSCalendar currentCalendar];
    } forObjectType:[NSCalendar class]];
    
    [self setProvider:^id (LYRUIConfiguration *configuration) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [configuration.injector objectOfType:[NSLocale class]];
        dateFormatter.timeZone = [configuration.injector objectOfType:[NSTimeZone class]];
        return dateFormatter;
    } forObjectType:[NSDateFormatter class]];
    
    [self setProvider:^id (LYRUIConfiguration *configuration) {
        return [NSLocale currentLocale];
    } forObjectType:[NSLocale class]];
    
    [self setProvider:^id (LYRUIConfiguration *configuration) {
        return [NSTimeZone systemTimeZone];
    } forObjectType:[NSTimeZone class]];
    
    [self setProvider:^id (LYRUIConfiguration *configuration) {
        return [NSURLSession sharedSession];
    } forObjectType:[NSURLSession class]];
    
    __weak __typeof(self) weakSelf = self;
    [self setProvider:^id (LYRUIConfiguration *configuration) {
        return [weakSelf.bundleProvider bundleWithLayerAssets];
    } forObjectType:[NSBundle class]];
}

#pragma mark - Helpers

- (LYRUIDependencyProviding)providerWithClass:(Class)objectClass {
    return ^id (LYRUIConfiguration *configuration) {
        if ([objectClass conformsToProtocol:@protocol(LYRUIConfigurable)]) {
            return [[objectClass alloc] initWithConfiguration:configuration];
        }
        return [[objectClass alloc] init];
    };
}

- (void)setThemeClass:(Class)themeClass forViewClass:(Class)viewClass {
    self.defaultThemes[NSStringFromClass(viewClass)] = [self providerWithClass:themeClass];
}

- (void)setAlternativeThemeClass:(Class)themeClass forViewClass:(Class)viewClass {
    self.defaultAlternativeThemes[NSStringFromClass(viewClass)] = [self providerWithClass:themeClass];
}

- (void)setConfigurationClass:(Class)configurationClass forViewClass:(Class)viewClass {
    self.defaultConfigurations[NSStringFromClass(viewClass)] = [self providerWithClass:configurationClass];
}

- (void)setLayoutClass:(Class)configurationClass forViewClass:(Class)viewClass {
    self.defaultLayouts[NSStringFromClass(viewClass)] = [self providerWithClass:configurationClass];
}

- (void)setImplementationClass:(Class)implementationClass forProtocol:(Protocol *)protocol {
    [self setImplementationClass:implementationClass forProtocol:protocol usedInClass:[LYRUIDIAnyClass class]];
}

- (void)setImplementationClass:(Class)implementationClass forProtocol:(Protocol *)protocol usedInClass:(Class)usageClass {
    NSString *usageClassKey = NSStringFromClass(usageClass);
    NSString *protocolKey = NSStringFromProtocol(protocol);
    if (self.defaultProtocolImplementations[usageClassKey] == nil) {
        self.defaultProtocolImplementations[usageClassKey] = [[NSMutableDictionary alloc] init];
    }
    self.defaultProtocolImplementations[usageClassKey][protocolKey] = [self providerWithClass:implementationClass];
}

- (void)setProvider:(LYRUIDependencyProviding)provider forObjectType:(Class)objectType {
    self.defaultObjects[NSStringFromClass(objectType)] = provider;
}

@end
