//
//  LYRUIMessageItemViewPresenter.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 18.08.2017.
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

#import "LYRUIMessageItemViewPresenter.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIMessageItemView.h"
#import <LayerKit/LayerKit.h>
#import "LYRUIMessageItemAccessoryViewProviding.h"
#import "LYRUIMessageType.h"
#import "LYRUIMessageItemContentPresentersProvider.h"
#import "LYRUIReusableViewsQueue.h"
#import "LYRUIMessageItemView.h"
#import "LYRUIMessageViewContainer.h"
#import "LYRUIViewReusing.h"
#import "LYRUIMessageItemContentBasePresenter.h"

static CGFloat const LYRUIMessageItemViewMinimumHeight = 32.0;

@interface LYRUIMessageItemViewPresenter () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) LYRUIMessageItemContentPresentersProvider *contentPresentersProvider;
@property (nonatomic, strong) LYRUIReusableViewsQueue *reusableViewsQueue;

@end

@implementation LYRUIMessageItemViewPresenter
@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [self init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    self.primaryAccessoryViewProvider = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIMessageItemAccessoryViewProviding)
                                                                                   forClass:[self class]];
    self.contentPresentersProvider = [layerConfiguration.injector objectOfType:[LYRUIMessageItemContentPresentersProvider class]];
    self.reusableViewsQueue = [layerConfiguration.injector objectOfType:[LYRUIReusableViewsQueue class]];
}

- (void)setupMessageItemView:(UIView<LYRUIMessageItemView> *)messageItemView withMessage:(LYRUIMessageType *)message {
    if (messageItemView == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Cannot setup Message Item View with nil `messageItemView` argument." userInfo:nil];
    }
    if (message == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Cannot setup Message Item View with nil `message` argument." userInfo:nil];
    }
    
    UIView *contentView = messageItemView.contentView;
    messageItemView.contentView = nil;
    [self enqueueReusableView:contentView];
    
    [self setupMessageItemViewBubbleColor:messageItemView withMessage:message];
    messageItemView.contentView = [self contentViewForMessage:message];
    [self setupAvatarViewInMessageItem:messageItemView withMessage:message];
    
    __weak __typeof(self) weakSelf = self;
    LYRUIMessageAction *action = message.action;
    messageItemView.actionHandler = ^{
        [weakSelf.actionHandlingDelegate handleAction:action withHandler:nil];
    };
    messageItemView.actionPreviewHandler = ^ UIViewController *{
        return [weakSelf.actionHandlingDelegate previewControllerForAction:action withHandler:nil];
    };
    messageItemView.tapGestureRecognizer.delegate = self;
}

- (void)enqueueReusableView:(__kindof UIView *)view {
    if ([view conformsToProtocol:@protocol(LYRUIMessageViewContainer)]) {
        UIView<LYRUIMessageViewContainer> *containerView = (UIView<LYRUIMessageViewContainer> *)view;
        UIView *contentView = containerView.contentView;
        containerView.contentView = nil;
        [self enqueueReusableView:contentView];
    }
    if ([view conformsToProtocol:@protocol(LYRUIViewReusing)]) {
        UIView<LYRUIViewReusing> *reusableView = (UIView<LYRUIViewReusing> *)view;
        [reusableView lyr_prepareForReuse];
    }
    [self.reusableViewsQueue enqueueReusableView:view];
}

- (UIView *)contentViewForMessage:(LYRUIMessageType *)message {
    id<LYRUIMessageItemContentPresenting> presenter = [self.contentPresentersProvider presenterForMessageClass:[message class]];
    presenter.actionHandlingDelegate = self.actionHandlingDelegate;
    return [presenter viewForMessage:message];
}

- (CGFloat)messageViewHeightForMessage:(LYRUIMessageType *)message maxWidth:(CGFloat)width {
    id<LYRUIMessageItemContentPresenting> presenter = [self.contentPresentersProvider presenterForMessageClass:[message class]];
    CGFloat contentViewHeight = [presenter viewHeightForMessage:message
                                                       minWidth:LYRUIMessageItemViewMinimumContentWidth
                                                       maxWidth:width];
    return MAX(contentViewHeight, LYRUIMessageItemViewMinimumHeight);
}

- (void)setupAvatarViewInMessageItem:(UIView<LYRUIMessageItemView> *)messageItemView withMessage:(LYRUIMessageType *)message {
    if (messageItemView.primaryAccessoryView == nil) {
        messageItemView.primaryAccessoryView = [self.primaryAccessoryViewProvider accessoryViewForMessage:message];
    } else {
        [self.primaryAccessoryViewProvider setupAccessoryView:messageItemView.primaryAccessoryView forMessage:message];
    }
}

#pragma mark - Color setup

- (void)setupMessageItemViewBubbleColor:(UIView<LYRUIMessageItemView> *)messageItemView withMessage:(LYRUIMessageType *)message {
    id<LYRUIMessageItemContentPresenting> presenter = [self.contentPresentersProvider presenterForMessageClass:[message class]];
    messageItemView.contentViewColor = [presenter backgroundColorForMessage:message];
}

#pragma mark = UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ![touch.view isKindOfClass:[UIControl class]];
}

@end
