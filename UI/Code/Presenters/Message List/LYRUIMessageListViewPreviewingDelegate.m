//
//  LYRUIMessageListViewPreviewingDelegate.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 26.02.2018.
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

#import "LYRUIMessageListViewPreviewingDelegate.h"
#import "LYRUIViewWithAction.h"

@interface LYRUIMessageListViewPreviewingDelegate ()

@property (nonatomic, weak) UIView *sourceView;
@property (nonatomic, weak) UIViewController *presentationViewController;

@end

@implementation LYRUIMessageListViewPreviewingDelegate

#pragma mark - Public methods

- (void)registerViewControllerForPreviewing:(UIViewController *)viewController withSourceView:(UIView *)sourceView {
    self.sourceView = sourceView;
    self.presentationViewController = viewController;
    [viewController registerForPreviewingWithDelegate:self sourceView:sourceView];
}

#pragma mark - UIViewControllerPreviewingDelegate

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.presentationViewController presentViewController:viewControllerToCommit animated:YES completion:nil];
}

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    UIView *touchedView = [self.sourceView hitTest:location withEvent:nil];
    UIViewController *(^previewHandler)(void) = [self actionPreviewHandlerForView:touchedView];
    UIViewController *previewController;
    if (previewHandler) {
        previewController = previewHandler();
    }
    return previewController;
}

#pragma mark - Helpers

- (UIViewController *(^)(void))actionPreviewHandlerForView:(UIView *)view {
    if (view == nil) {
        return nil;
    }
    if (![view conformsToProtocol:@protocol(LYRUIViewWithAction)]) {
        return [self actionPreviewHandlerForView:view.superview];
    }
    id<LYRUIViewWithAction> viewWithAction = (id<LYRUIViewWithAction>)view;
    if (viewWithAction.actionPreviewHandler == nil) {
        return [self actionPreviewHandlerForView:view.superview];
    }
    return viewWithAction.actionPreviewHandler;
}

@end
