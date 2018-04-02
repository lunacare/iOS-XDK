//
//  LYRUIStandardMessageContainerViewPresenter.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 12.10.2017.
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

#import "LYRUIStandardMessageContainerViewPresenter.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIStandardMessageContainerView.h"
#import "LYRUIMessageType.h"
#import "LYRUIMessageMetadata.h"
#import "LYRUIMessageItemContentPresentersProvider.h"
#import "LYRUIReusableViewsQueue.h"

@implementation LYRUIStandardMessageContainerViewPresenter
@synthesize reusableViewsQueue = _reusableViewsQueue,
            presentersProvider = _presentersProvider,
            actionHandlingDelegate = _actionHandlingDelegate,
            layerConfiguration = _layerConfiguration;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sizingContainerView = [[LYRUIStandardMessageContainerView alloc] init];
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
    self.sizingContainerView.layerConfiguration = layerConfiguration;
    self.reusableViewsQueue = [layerConfiguration.injector objectOfType:[LYRUIReusableViewsQueue class]];
}

- (UIView *)viewForMessage:(LYRUIMessageType *)message {
    LYRUIStandardMessageContainerView *container = [self.reusableViewsQueue dequeueReusableViewOfType:[LYRUIStandardMessageContainerView class]];
    if (container == nil) {
        container = [[LYRUIStandardMessageContainerView alloc] init];
        container.layerConfiguration = self.layerConfiguration;
    }
    [self setupStandardMessageContainerView:container withMessage:message];
    
    id<LYRUIMessageItemContentPresenting> presenter = [self.presentersProvider contentPresenterForMessageClass:[message class]];
    UIView *contentView = [presenter viewForMessage:message];
    container.contentView = contentView;
    
    return container;
}

- (void)setupStandardMessageContainerView:(LYRUIStandardMessageContainerView *)view
                              withMessage:(LYRUIMessageType *)message {
    LYRUIMessageMetadata *metadata = message.metadata;
    view.descriptionLabel.text = metadata.messageDescription;
    view.titleLabel.text = metadata.title;
    view.footerLabel.text = metadata.footer;
    [view setNeedsUpdateConstraints];
}

- (UIColor *)backgroundColorForMessage:(LYRUIMessageType *)message {
    id<LYRUIMessageItemContentPresenting> presenter = [self.presentersProvider contentPresenterForMessageClass:[message class]];
    presenter.actionHandlingDelegate = self.actionHandlingDelegate;
    return [presenter backgroundColorForMessage:message];
}

- (CGFloat)viewHeightForMessage:(LYRUIMessageType *)message minWidth:(CGFloat)minWidth maxWidth:(CGFloat)maxWidth {
    CGFloat metadataHeight = 0;

    if (message.metadata != nil) {
        [self setupStandardMessageContainerView:self.sizingContainerView withMessage:message];
        CGFloat maxTextWidth = maxWidth - 24.0;
        CGSize descriptionTextSize = [self textSizeInLabel:self.sizingContainerView.descriptionLabel withMaxWidth:maxTextWidth];
        CGSize titleTextSize = [self textSizeInLabel:self.sizingContainerView.titleLabel withMaxWidth:maxTextWidth];
        CGSize footerTextSize = [self textSizeInLabel:self.sizingContainerView.footerLabel withMaxWidth:maxTextWidth];
        metadataHeight = 8.0 + descriptionTextSize.height + titleTextSize.height + footerTextSize.height + 9.0;
        if (descriptionTextSize.height > 0.0) {
            if (titleTextSize.height > 0.0) {
                metadataHeight += 3.0;
            } else if (footerTextSize.height > 0.0) {
                metadataHeight += 8.0;
            }
        }
        if (titleTextSize.height > 0.0 && footerTextSize.height > 0.0) {
            metadataHeight += 8.0;
        }
        metadataHeight = ceil(metadataHeight);

        CGFloat minContainerWidth = ceil(MAX(descriptionTextSize.width, MAX(titleTextSize.width, footerTextSize.width)) + 24.0);
        minWidth = MAX(minWidth, minContainerWidth);
    }

    id<LYRUIMessageItemContentPresenting> presenter = [self.presentersProvider contentPresenterForMessageClass:[message class]];
    CGFloat contentViewHeight = [presenter viewHeightForMessage:message minWidth:minWidth maxWidth:maxWidth];

    return metadataHeight + contentViewHeight;
}

- (CGSize)textSizeInLabel:(UILabel *)label withMaxWidth:(CGFloat)maxWidth {
    CGRect stringRect = [label.text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                                 options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                              attributes:@{ NSFontAttributeName: label.font }
                                                 context:nil];
    return stringRect.size;
}

@end
