//
//  LYRUIConversationItemViewPresenter.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 12.07.2017.
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

#import "LYRUIIdentityItemViewPresenter.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUITimeFormatting.h"
#import "LYRUIIdentityNameFormatting.h"
#import "LYRUIIdentityItemAccessoryViewProviding.h"

@implementation LYRUIIdentityItemViewPresenter
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

#pragma mark - Properties

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    self.accessoryViewProvider = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIIdentityItemAccessoryViewProviding) forClass:[self class]];
    self.nameFormatter = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIIdentityNameFormatting) forClass:[self class]];
    self.lastSeenAtTimeFormatter = [layerConfiguration.injector protocolImplementation:@protocol(LYRUITimeFormatting) forClass:[self class]];
}

#pragma mark - LYRUIConversationItemView setup

- (void)setupIdentityItemView:(UIView<LYRUIIdentityItemView> *)view
                 withIdentity:(LYRIdentity *)identity {
    if (view == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Cannot setup Identity Item View with nil `view` argument." userInfo:nil];
    }
    if (identity == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Cannot setup Identity Item View with nil `identity` argument." userInfo:nil];
    }
    
    if ([view conformsToProtocol:@protocol(LYRUIConfigurable)]) {
        id<LYRUIConfigurable> configurableView = (id<LYRUIConfigurable>)view;
        configurableView.layerConfiguration = self.layerConfiguration;
    }
    
    view.titleLabel.text = [self.nameFormatter nameForIdentity:identity];
    view.detailLabel.text = [self.lastSeenAtTimeFormatter stringForTime:identity.lastSeenAt
                                                      withCurrentTime:[NSDate date]];
    if (self.metadataFormatter) {
        view.subtitleLabel.text = self.metadataFormatter(identity.metadata);
    }
    
    [view.accessoryView removeFromSuperview];
    UIView *accessoryView = [self.accessoryViewProvider accessoryViewForIdentity:identity];
    if (accessoryView) {
        [view addSubview:accessoryView];
        view.accessoryView = accessoryView;
    }
    [view setNeedsUpdateConstraints];
}

@end
