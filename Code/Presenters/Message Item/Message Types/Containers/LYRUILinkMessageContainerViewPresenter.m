//
//  LYRUILinkMessageContainerViewPresenter.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 15.11.2017.
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

#import "LYRUILinkMessageContainerViewPresenter.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIStandardMessageContainerView.h"
#import "LYRUIImageCreating.h"
#import "LYRUILinkMessage.h"

static CGFloat const LYRUILinkMessageContainerDisclosureIndicatorWidth = 24.0;
static CGFloat const LYRUILinkMessageContainerDisclosureIndicatorMargin = 8.0;
static CGFloat const LYRUILinkMessageContainerDisclosureIndicatorAdditionalSpace =
                        LYRUILinkMessageContainerDisclosureIndicatorWidth + LYRUILinkMessageContainerDisclosureIndicatorMargin;

static NSString *const LYRUILinkMessageContainerDisclosureIndicatorImage = @"DisclosureIndicator";

@interface LYRUILinkMessageContainerViewPresenter ()

@property (nonatomic, strong) id<LYRUIImageCreating> imageFactory;

@end

@implementation LYRUILinkMessageContainerViewPresenter

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    [super setLayerConfiguration:layerConfiguration];
    self.imageFactory = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIImageCreating)
                                                                   forClass:[self class]];
}

- (LYRUIStandardMessageContainerView *)viewForMessage:(LYRUILinkMessage *)message {
    LYRUIStandardMessageContainerView *container = (LYRUIStandardMessageContainerView *) [super viewForMessage:message];
    container.disclosureIndicator.image = [self.imageFactory imageNamed:LYRUILinkMessageContainerDisclosureIndicatorImage];
    container.disclosureIndicatorHidden = [self shouldHideDisclosureForMessage:message];
    return container;
}

- (CGFloat)viewHeightForMessage:(LYRUILinkMessage *)message
                       minWidth:(CGFloat)minWidth
                       maxWidth:(CGFloat)maxWidth {
    if (![self shouldHideDisclosureForMessage:message]) {
        maxWidth -= LYRUILinkMessageContainerDisclosureIndicatorAdditionalSpace;
    }
    return [super viewHeightForMessage:message minWidth:minWidth maxWidth:maxWidth];
}

- (BOOL)shouldHideDisclosureForMessage:(LYRUILinkMessage *)message {
    return message.imageURL != nil || message.metadata == nil;
}

@end
