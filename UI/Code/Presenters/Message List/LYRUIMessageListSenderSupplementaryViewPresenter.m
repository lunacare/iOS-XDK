//
//  LYRUIMessageListSenderSupplementaryViewPresenter.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 5/10/18.
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

#import "LYRUIMessageListSenderSupplementaryViewPresenter.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIMessageListMessageSenderViewLayout.h"
#import "LYRUIMessageListMessageSenderView.h"
#import "LYRUIMessageListLayout.h"
#import "LYRUIMessageListView.h"
#import "LYRUIListDataSource.h"
#import "LYRUIListDelegate.h"
#import "LYRUIListSection.h"
#import <LayerKit/LayerKit.h>
#import "LYRUIMessageType.h"
#import "LYRUITextMessage.h"
#import "LYRUILocationMessage.h"
#import "LYRUIImageMessage.h"
#import "LYRUILinkMessage.h"
#import "LYRUIFileMessage.h"

static CGFloat const LYRUIMessageListSenderSupplementaryViewDefaultHeight = 17.0;

@interface LYRUIMessageListSenderSupplementaryViewPresenter ()

@property (nonatomic, strong) LYRUIMessageListMessageSenderViewLayout *messageSenderLayout;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, NSNumber *> *showSenderForIndexPath;

@end

@implementation LYRUIMessageListSenderSupplementaryViewPresenter
@synthesize listDataSource = _listDataSource, listDelegate = _listDelegate, layerConfiguration = _layerConfiguration;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.messageSenderHeight = LYRUIMessageListSenderSupplementaryViewDefaultHeight;
        self.showSenderForIndexPath = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [self init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    self.messageSenderLayout = [layerConfiguration.injector layoutForViewClass:[LYRUIMessageListMessageSenderView class]];
}

- (NSString *)viewKind {
    return LYRUIMessageListMessageSenderViewKind;
}

- (NSString *)viewReuseIdentifier {
    return NSStringFromClass([LYRUIMessageListMessageSenderView class]);
}

#pragma mark - LYRUIListSupplementaryViewPresenting

- (void)setupSupplementaryView:(LYRUIMessageListMessageSenderView *)view forItemAtIndexPath:(NSIndexPath *)indexPath {
    LYRMessage *message = (LYRMessage *)[self.listDataSource itemAtIndexPath:indexPath];
    [self setupMessageSenderView:view withMessage:message];
}

- (void)setupMessageSenderView:(LYRUIMessageListMessageSenderView *)senderView
                   withMessage:(LYRMessage *)message {
    senderView.layout = self.messageSenderLayout;
    if ([message isKindOfClass:LYRUIMessageType.class]) {
        LYRUIMessageType *uiMessage = (LYRUIMessageType *)message;
        if (uiMessage.sender.displayName.length) {
            senderView.title = uiMessage.sender.displayName;
        } else {
            NSMutableArray *identityNames = [NSMutableArray array];
            if (uiMessage.sender.firstName.length) {
                [identityNames addObject:uiMessage.sender.firstName];
            }
            if (uiMessage.sender.lastName.length) {
                [identityNames addObject:uiMessage.sender.lastName];
            }
            if (identityNames.count) {
                senderView.title = [identityNames componentsJoinedByString:@" "];
            } else if (uiMessage.sender.emailAddress.length) {
                senderView.title = uiMessage.sender.emailAddress;
            } else {
                senderView.title = @"Unknown";
            }
        }
    } else {
        senderView.title = nil;
    }
}

- (void)registerSupplementaryViewInCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:[LYRUIListHeaderView class]
       forSupplementaryViewOfKind:self.viewKind
              withReuseIdentifier:self.viewReuseIdentifier];
}

#pragma mark - LYRUIListSupplementaryViewSizeCalculating

- (CGSize)supplementaryViewSizeInCollectionView:(UICollectionView *)collectionView forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self shouldShowMessageSenderAtIndexPath:indexPath]) {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), self.messageSenderHeight);
    }
    return CGSizeZero;
}

- (BOOL)shouldShowMessageSenderAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showSenderForIndexPath[indexPath]) {
        return self.showSenderForIndexPath[indexPath].boolValue;
    }
    id<LYRUIListDataSource> dataSource = self.listDataSource;
    id item = [dataSource itemAtIndexPath:indexPath];
    BOOL supported = NO;
    for (Class supportedClass in [self.class supportedMessageTypes]) {
        // Lookup for any supported message types where we can display
        // the sender name.
        if ([item isKindOfClass:supportedClass]) {
            supported = YES;
            break;
        }
    }
    if (!supported) {
        self.showSenderForIndexPath[indexPath] = @(NO);
        return NO;
    }
    LYRUIMessageType *message = (LYRUIMessageType *)item;
    if (message.sender == nil) {
        self.showSenderForIndexPath[indexPath] = @(NO);
        return NO;
    }
    LYRUIListSection *section = dataSource.sections[indexPath.section];
    LYRUIMessageType *previousMessage;
    if (indexPath.item > 0) {
        previousMessage = section.items[indexPath.item - 1];
    }
    if (previousMessage == nil) {
        self.showSenderForIndexPath[indexPath] = @(NO);
        return NO;
    }
    BOOL senderDiffers = ![message.sender isEqual:previousMessage.sender];
    BOOL relevantTimeDifference = [message.sentAt timeIntervalSinceDate:previousMessage.sentAt] > self.messageListView.messageGroupingTimeInterval;
    BOOL shouldShowSender = [self isIncomingMessage:message] && (senderDiffers || relevantTimeDifference);
    self.showSenderForIndexPath[indexPath] = @(shouldShowSender);
    return shouldShowSender;
}

- (void)invalidateAllSupplementaryViewSizes {
    [self.showSenderForIndexPath removeAllObjects];
}

#pragma mark - Helpers

- (BOOL)isIncomingMessage:(LYRUIMessageType *)message {
    NSString *currentUserId = self.layerConfiguration.client.authenticatedUser.userID;
    return ![message.sender.userID isEqualToString:currentUserId];
}

+ (NSArray<Class> *)supportedMessageTypes {
    return @[ LYRUITextMessage.class, LYRUILocationMessage.class, LYRUIImageMessage.class, LYRUILinkMessage.class, LYRUIFileMessage.class ];
}

@end
