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
#import "LYRUIPresenceViewPresenter.h"
#import "LYRUIAvatarView.h"
#import "LYRUIAvatarViewDefaultTheme.h"
#import "LYRUIAvatarViewPresenter.h"
#import "LYRUIImageWithLettersView.h"
#import "LYRUIImageWithLettersViewPresenter.h"
#import "LYRUIBaseItemView.h"
#import "LYRUIBaseItemViewDefaultTheme.h"
#import "LYRUIBaseItemViewLayout.h"
#import "LYRUIConversationItemView.h"
#import "LYRUIConversationItemViewUnreadTheme.h"
#import "LYRUIConversationItemViewPresenter.h"
#import "LYRUIConversationItemAccessoryViewProviding.h"
#import "LYRUIConversationItemTitleFormatter.h"
#import "LYRUIMessageTimeDefaultFormatter.h"
#import "LYRUIConversationListView.h"
#import "LYRUIConversationListViewPresenter.h"
#import "LYRUIListCellPresenter.h"
#import "LYRUIListHeaderView.h"
#import "LYRUIListSupplementaryViewPresenter.h"
#import "LYRUIListLayout.h"
#import "LYRUIIdentityItemView.h"
#import "LYRUIIdentityItemViewPresenter.h"
#import "LYRUIIdentityItemAccessoryViewProviding.h"
#import "LYRUIIdentityNameFormatter.h"
#import "LYRUITimeAgoFormatter.h"
#import "LYRUIIdentityListView.h"
#import "LYRUIIdentityListViewPresenter.h"
#import "LYRUIImageFetcher.h"
#import "LYRUIImageFactory.h"
#import "LYRUIInitialsFormatter.h"
#import "LYRUIDataFactory.h"
#import "LYRUIDispatcher.h"
#import "NSCache+LYRUIImageCaching.h"
#import "LYRUIBundleProvider.h"
#import "LYRUIComposeBar.h"
#import "LYRUIComposeBarLayout.h"
#import "LYRUIComposeBarPresenter.h"
#import "LYRUIAvatarViewProvider.h"
#import "LYRUIMessageItemView.h"
#import "LYRUIMessageItemViewLayout.h"
#import "LYRUIMessageItemViewPresenter.h"
#import "LYRUIMessageItemAccessoryViewProviding.h"
#import "LYRUIMessageCollectionViewCell.h"
#import "LYRUIMessageCellPresenter.h"
#import "LYRUIMessageListMessageTimeView.h"
#import "LYRUIMessageListMessageTimeViewLayout.h"
#import "LYRUIMessageListTimeSupplementaryViewPresenter.h"
#import "LYRUIMessageListMessageStatusView.h"
#import "LYRUIMessageListMessageStatusViewLayout.h"
#import "LYRUIMessageListStatusSupplementaryViewPresenter.h"
#import "LYRUIListLoadingIndicatorView.h"
#import "LYRUIListLoadingIndicatorPresenter.h"
#import "LYRUIMessageListView.h"
#import "LYRUIMessageListLayout.h"
#import "LYRUIMessageListViewPresenter.h"
#import "LYRUIMessageListTimeFormatter.h"
#import "LYRUIConversationView.h"
#import "LYRUIConversationViewLayout.h"
#import "LYRUIPanelTypingIndicatorView.h"
#import "LYRUIPanelTypingIndicatorViewLayout.h"
#import "LYRUITypingIndicatorFooterPresenter.h"
#import "LYRUIBubbleTypingIndicatorCollectionViewCell.h"
#import "LYRUITypingIndicatorCellPresenter.h"
#import "LYRUIReusableViewsQueue.h"
#import "LYRUITextMessage.h"
#import "LYRUITextMessageSerializer.h"
#import "LYRUITextMessageContentViewPresenter.h"
#import "LYRUIStandardMessageContainerViewPresenter.h"
#import "LYRUIStandardMessageContainerView.h"
#import "LYRUIStandardMessageContainerViewLayout.h"
#import "LYRUIStandardMessageContainerViewDefaultTheme.h"
#import "LYRUIFileMessage.h"
#import "LYRUIFileMessageSerializer.h"
#import "LYRUIFileMessageContentViewPresenter.h"
#import "LYRUIMessageOpenFileActionHandler.h"
#import "LYRUILinkMessage.h"
#import "LYRUILinkMessageSerializer.h"
#import "LYRUILinkMessageContentViewPresenter.h"
#import "LYRUILinkMessageContainerViewPresenter.h"
#import "LYRUIMessageOpenURLActionHandler.h"
#import "LYRUIImageMessage.h"
#import "LYRUIImageMessageSerializer.h"
#import "LYRUIImageMessageContentViewPresenter.h"
#import "LYRUILocationMessage.h"
#import "LYRUILocationMessageSerializer.h"
#import "LYRUILocationMessageContentViewPresenter.h"
#import "LYRUIMessageOpenMapActionHandler.h"
#import "LYRUIStatusMessageCollectionViewCell.h"
#import "LYRUIStatusCellPresenter.h"
#import "LYRUIStatusMessage.h"
#import "LYRUIStatusMessageSerializer.h"

@interface LYRUIDependencyInjectionDefaultModule ()

@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *defaultThemes;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *defaultAlternativeThemes;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *defaultPresenters;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *defaultLayouts;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, LYRUIDependencyProviding> *> *defaultProtocolImplementations;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *defaultObjects;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *defaultMessagePresenters;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *defaultMessageContainerPresenters;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, LYRUIDependencyProviding> *defaultMessageSerializers;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, LYRUIDependencyProviding> *> *defaultActionHandlers;

@property (nonatomic, strong) id<LYRUIImageCaching> imagesCache;
@property (nonatomic, strong) id<LYRUIThumbnailsCaching> thumbnailsCache;
@property (nonatomic, strong) LYRUIBundleProvider *bundleProvider;
@property (nonatomic, strong) LYRUIReusableViewsQueue *reusableViewsQueue;

@end

@implementation LYRUIDependencyInjectionDefaultModule

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imagesCache = [[NSCache<NSURL *, UIImage *> alloc] init];
        self.thumbnailsCache = [[NSCache<NSURL *, UIImage *> alloc] init];
        self.bundleProvider = [[LYRUIBundleProvider alloc] init];
        self.reusableViewsQueue = [[LYRUIReusableViewsQueue alloc] init];
        
        [self setupThemes];
        [self setupAlternativeThemes];
        [self setupPresenters];
        [self setupLayouts];
        [self setupProtocolImplementations];
        [self setupObjects];
        [self setupMessagePresenters];
        [self setupMessageContainerPresenters];
        [self setupMessageSerializers];
        [self setupActionHandlers];
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
    [self setThemeClass:[LYRUIStandardMessageContainerViewDefaultTheme class] forViewClass:[LYRUIStandardMessageContainerView class]];
}

- (void)setupAlternativeThemes {
    self.defaultAlternativeThemes = [[NSMutableDictionary alloc] init];
    
    [self setAlternativeThemeClass:[LYRUIConversationItemViewUnreadTheme class] forViewClass:[LYRUIConversationItemView class]];
}

- (void)setupPresenters {
    self.defaultPresenters = [[NSMutableDictionary alloc] init];
    
    [self setPresenterClass:[LYRUIPresenceViewPresenter class] forViewClass:[LYRUIPresenceView class]];
    [self setPresenterClass:[LYRUIAvatarViewPresenter class] forViewClass:[LYRUIAvatarView class]];
    [self setPresenterClass:[LYRUIImageWithLettersViewPresenter class] forViewClass:[LYRUIImageWithLettersView class]];
    [self setPresenterClass:[LYRUIConversationItemViewPresenter class] forViewClass:[LYRUIConversationItemView class]];
    [self setPresenterClass:[LYRUIListCellPresenter class] forViewClass:[UICollectionViewCell class]];
    self.defaultPresenters[NSStringFromClass([LYRUIListHeaderView class])] = ^id (LYRUIConfiguration *configuration) {
        return [LYRUIListSupplementaryViewPresenter headerPresenter];
    };
    [self setPresenterClass:[LYRUIConversationListViewPresenter class] forViewClass:[LYRUIConversationListView class]];
    [self setPresenterClass:[LYRUIIdentityItemViewPresenter class] forViewClass:[LYRUIIdentityItemView class]];
    [self setPresenterClass:[LYRUIIdentityListViewPresenter class] forViewClass:[LYRUIIdentityListView class]];
    [self setPresenterClass:[LYRUIComposeBarPresenter class] forViewClass:[LYRUIComposeBar class]];
    [self setPresenterClass:[LYRUIMessageItemViewPresenter class] forViewClass:[LYRUIMessageItemView class]];
    [self setPresenterClass:[LYRUIMessageCellPresenter class] forViewClass:[LYRUIMessageCollectionViewCell class]];
    [self setPresenterClass:[LYRUIMessageListTimeSupplementaryViewPresenter class] forViewClass:[LYRUIMessageListMessageTimeView class]];
    [self setPresenterClass:[LYRUIMessageListStatusSupplementaryViewPresenter class] forViewClass:[LYRUIMessageListMessageStatusView class]];
    self.defaultPresenters[NSStringFromClass([LYRUIListLoadingIndicatorView class])] = ^id (LYRUIConfiguration *configuration) {
        return [LYRUIListLoadingIndicatorPresenter loadingOldItemsIndicatorPresenter];
    };
    [self setPresenterClass:[LYRUIMessageListViewPresenter class] forViewClass:[LYRUIMessageListView class]];
    [self setPresenterClass:[LYRUITypingIndicatorFooterPresenter class] forViewClass:[LYRUIPanelTypingIndicatorView class]];
    [self setPresenterClass:[LYRUITypingIndicatorCellPresenter class] forViewClass:[LYRUIBubbleTypingIndicatorCollectionViewCell class]];
    [self setPresenterClass:[LYRUIStatusCellPresenter class] forViewClass:[LYRUIStatusMessageCollectionViewCell class]];
}

- (void)setupLayouts {
    self.defaultLayouts = [[NSMutableDictionary alloc] init];

    [self setLayoutClass:[LYRUIListLayout class] forViewClass:[LYRUIConversationListView class]];
    [self setLayoutClass:[LYRUIBaseItemViewLayout class] forViewClass:[LYRUIConversationItemView class]];
    [self setLayoutClass:[LYRUIListLayout class] forViewClass:[LYRUIIdentityListView class]];
    [self setLayoutClass:[LYRUIBaseItemViewLayout class] forViewClass:[LYRUIIdentityItemView class]];
    [self setLayoutClass:[LYRUIComposeBarLayout class] forViewClass:[LYRUIComposeBar class]];
    [self setLayoutClass:[LYRUIMessageItemViewLayout class] forViewClass:[LYRUIMessageItemView class]];
    [self setLayoutClass:[LYRUIMessageListMessageTimeViewLayout class] forViewClass:[LYRUIMessageListMessageTimeView class]];
    [self setLayoutClass:[LYRUIMessageListMessageStatusViewLayout class] forViewClass:[LYRUIMessageListMessageStatusView class]];
    [self setLayoutClass:[LYRUIMessageListLayout class] forViewClass:[LYRUIMessageListView class]];
    [self setLayoutClass:[LYRUIConversationViewLayout class] forViewClass:[LYRUIConversationView class]];
    [self setLayoutClass:[LYRUIPanelTypingIndicatorViewLayout class] forViewClass:[LYRUIPanelTypingIndicatorView class]];
    [self setLayoutClass:[LYRUIStandardMessageContainerViewLayout class] forViewClass:[LYRUIStandardMessageContainerView class]];
}

- (void)setupProtocolImplementations {
    self.defaultProtocolImplementations = [[NSMutableDictionary alloc] init];
    
    [self setImplementationClass:[LYRUIAvatarViewProvider class]
                     forProtocol:@protocol(LYRUIConversationItemAccessoryViewProviding)];
    [self setImplementationClass:[LYRUIConversationItemTitleFormatter class]
                     forProtocol:@protocol(LYRUIConversationItemTitleFormatting)];
    [self setImplementationClass:[LYRUIMessageTimeDefaultFormatter class]
                     forProtocol:@protocol(LYRUITimeFormatting)];
    [self setImplementationClass:[LYRUIAvatarViewProvider class]
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
    [self setupImagesCaches];
    [self setImplementationClass:[LYRUIAvatarViewProvider class]
                     forProtocol:@protocol(LYRUIMessageItemAccessoryViewProviding)];
    
    [self setImplementationClass:[LYRUITimeAgoFormatter class]
                     forProtocol:@protocol(LYRUITimeFormatting)
                     usedInClass:[LYRUIIdentityItemViewPresenter class]];
    [self setImplementationClass:[LYRUIMessageListTimeFormatter class]
                     forProtocol:@protocol(LYRUITimeFormatting)
                     usedInClass:[LYRUIMessageListTimeSupplementaryViewPresenter class]];
}

- (void)setupImagesCaches {
    NSString *anyClassKey = NSStringFromClass([LYRUIDIAnyClass class]);
    NSString *imagesCachingKey = NSStringFromProtocol(@protocol(LYRUIImageCaching));
    __weak __typeof(self) weakSelf = self;
    self.defaultProtocolImplementations[anyClassKey][imagesCachingKey] = ^id (LYRUIConfiguration *configuration) {
        return weakSelf.imagesCache;
    };
    
    NSString *thumbnailsCachingKey = NSStringFromProtocol(@protocol(LYRUIThumbnailsCaching));
    self.defaultProtocolImplementations[anyClassKey][thumbnailsCachingKey] = ^id (LYRUIConfiguration *configuration) {
        return weakSelf.thumbnailsCache;
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
    
    [self setProvider:^id (LYRUIConfiguration *configuration) {
        return [NSNotificationCenter defaultCenter];
    } forObjectType:[NSNotificationCenter class]];
    
    [self setProvider:^id (LYRUIConfiguration *configuration) {
        return weakSelf.reusableViewsQueue;
    } forObjectType:[LYRUIReusableViewsQueue class]];
}

- (void)setupMessagePresenters {
    self.defaultMessagePresenters = [[NSMutableDictionary alloc] init];
    
    [self setMessagePresenterClass:[LYRUITextMessageContentViewPresenter class] forMessageClass:[LYRUITextMessage class]];
    [self setMessagePresenterClass:[LYRUIFileMessageContentViewPresenter class] forMessageClass:[LYRUIFileMessage class]];
    [self setMessagePresenterClass:[LYRUILinkMessageContentViewPresenter class] forMessageClass:[LYRUILinkMessage class]];
    [self setMessagePresenterClass:[LYRUIImageMessageContentViewPresenter class] forMessageClass:[LYRUIImageMessage class]];
    [self setMessagePresenterClass:[LYRUILocationMessageContentViewPresenter class] forMessageClass:[LYRUILocationMessage class]];
}

- (void)setupMessageContainerPresenters {
    self.defaultMessageContainerPresenters = [[NSMutableDictionary alloc] init];
    
    [self setMessageContainerPresenterClass:[LYRUIStandardMessageContainerViewPresenter class] forMessageClass:[LYRUITextMessage class]];
    [self setMessageContainerPresenterClass:[LYRUIStandardMessageContainerViewPresenter class] forMessageClass:[LYRUIFileMessage class]];
    [self setMessageContainerPresenterClass:[LYRUILinkMessageContainerViewPresenter class] forMessageClass:[LYRUILinkMessage class]];
    [self setMessageContainerPresenterClass:[LYRUIStandardMessageContainerViewPresenter class] forMessageClass:[LYRUIImageMessage class]];
    [self setMessageContainerPresenterClass:[LYRUIStandardMessageContainerViewPresenter class] forMessageClass:[LYRUILocationMessage class]];
}

- (void)setupMessageSerializers {
    self.defaultMessageSerializers = [[NSMutableDictionary alloc] init];
    
    [self setMessageSerializerClass:[LYRUITextMessageSerializer class] forMIMEType:LYRUITextMessage.MIMEType];
    [self setMessageSerializerClass:[LYRUIFileMessageSerializer class] forMIMEType:LYRUIFileMessage.MIMEType];
    [self setMessageSerializerClass:[LYRUILinkMessageSerializer class] forMIMEType:LYRUILinkMessage.MIMEType];
    [self setMessageSerializerClass:[LYRUIImageMessageSerializer class] forMIMEType:LYRUIImageMessage.MIMEType];
    [self setMessageSerializerClass:[LYRUILocationMessageSerializer class] forMIMEType:LYRUILocationMessage.MIMEType];
    [self setMessageSerializerClass:[LYRUIStatusMessageSerializer class] forMIMEType:LYRUIStatusMessage.MIMEType];
}

- (void)setupActionHandlers {
    self.defaultActionHandlers = [[NSMutableDictionary alloc] init];
    
    [self setActionHandlerClass:[LYRUIMessageOpenFileActionHandler class] forEvent:@"open-file"];
    [self setActionHandlerClass:[LYRUIMessageOpenURLActionHandler class] forEvent:@"open-url"];
    [self setActionHandlerClass:[LYRUIMessageOpenMapActionHandler class] forEvent:@"open-map"];
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

- (void)setPresenterClass:(Class)presenterClass forViewClass:(Class)viewClass {
    self.defaultPresenters[NSStringFromClass(viewClass)] = [self providerWithClass:presenterClass];
}

- (void)setLayoutClass:(Class)layoutClass forViewClass:(Class)viewClass {
    self.defaultLayouts[NSStringFromClass(viewClass)] = [self providerWithClass:layoutClass];
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

- (void)setMessagePresenterClass:(Class)presenterClass forMessageClass:(Class)messageClass {
    self.defaultMessagePresenters[NSStringFromClass(messageClass)] = [self providerWithClass:presenterClass];
}

- (void)setMessageContainerPresenterClass:(Class)presenterClass forMessageClass:(Class)messageClass {
    self.defaultMessageContainerPresenters[NSStringFromClass(messageClass)] = [self providerWithClass:presenterClass];
}

- (void)setMessageSerializerClass:(Class)serializerClass forMIMEType:(NSString *)MIMEType {
    self.defaultMessageSerializers[MIMEType] = [self providerWithClass:serializerClass];
}

- (void)setActionHandlerClass:(Class)implementationClass forEvent:(NSString *)event {
    [self setActionHandlerClass:implementationClass forEvent:event usedInMessageType:[LYRUIDIAnyClass class]];
}

- (void)setActionHandlerClass:(Class)implementationClass forEvent:(NSString *)event usedInMessageType:(Class)usageMessageType {
    NSString *usageClassKey = NSStringFromClass(usageMessageType);
    if (self.defaultActionHandlers[usageClassKey] == nil) {
        self.defaultActionHandlers[usageClassKey] = [[NSMutableDictionary alloc] init];
    }
    self.defaultActionHandlers[usageClassKey][event] = [self providerWithClass:implementationClass];
}

@end
