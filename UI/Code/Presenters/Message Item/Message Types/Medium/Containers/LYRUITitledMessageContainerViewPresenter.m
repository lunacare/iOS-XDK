//
//  LYRUITitledMessageContainerViewPresenter.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 27.11.2017.
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

#import "LYRUITitledMessageContainerViewPresenter.h"
#import "LYRUITitledMessageContainerView.h"
#import "LYRUIMessageType.h"
#import "LYRUIMessageMetadata.h"
#import "LYRUIMessageItemContentPresentersProvider.h"
#import "LYRUIReusableViewsQueue.h"

static CGFloat const LYRUITitledMessageContainerViewMinHeaderHeight = 40.0;

@implementation LYRUITitledMessageContainerViewPresenter
@synthesize reusableViewsQueue = _reusableViewsQueue,
            presentersProvider = _presentersProvider,
            actionHandlingDelegate = _actionHandlingDelegate;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sizingContainerView = [[LYRUITitledMessageContainerView alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    __typeof(self) copy = [[[self class] allocWithZone:zone] init];
    return copy;
}

- (UIView *)viewForMessage:(LYRUIMessageType *)message {
    LYRUIMessageMetadata *metadata = message.metadata;
    
    id<LYRUIMessageItemContentPresenting> presenter = [self.presentersProvider contentPresenterForMessageClass:[message class]];
    presenter.actionHandlingDelegate = self.actionHandlingDelegate;
    UIView *contentView = [presenter viewForMessage:message];
    
    if (metadata == nil) {
        return contentView;
    }
    LYRUITitledMessageContainerView *container = [self.reusableViewsQueue dequeueReusableViewOfType:[LYRUITitledMessageContainerView class]];
    if (container == nil) {
        container = [[LYRUITitledMessageContainerView alloc] init];
    }
    [self setupStandardMessageContainerView:container withMessage:message];
    container.contentView = contentView;
    return container;
}

- (void)setupStandardMessageContainerView:(LYRUITitledMessageContainerView *)view
                              withMessage:(LYRUIMessageType *)message {
    view.icon.image = self.iconImage;
    LYRUIMessageMetadata *metadata = message.metadata;
    view.titleLabel.text = metadata.title;
    [view setNeedsUpdateConstraints];
}

- (UIColor *)backgroundColorForMessage:(LYRUIMessageType *)message {
    id<LYRUIMessageItemContentPresenting> presenter = [self.presentersProvider contentPresenterForMessageClass:[message class]];
    return [presenter backgroundColorForMessage:message];
}

- (CGFloat)viewHeightForMessage:(LYRUIMessageType *)message minWidth:(CGFloat)minWidth maxWidth:(CGFloat)maxWidth {
    CGFloat metadataHeight = 0;
    
    if (message.metadata != nil) {
        [self setupStandardMessageContainerView:self.sizingContainerView withMessage:message];
        CGFloat maxTextWidth = maxWidth - 24.0;
        CGSize titleTextSize = [self textSizeInLabel:self.sizingContainerView.titleLabel withMaxWidth:maxTextWidth];
        metadataHeight = MAX(ceil(titleTextSize.height + 24.0), LYRUITitledMessageContainerViewMinHeaderHeight);
        minWidth = ceil(titleTextSize.width + 52.0);
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
