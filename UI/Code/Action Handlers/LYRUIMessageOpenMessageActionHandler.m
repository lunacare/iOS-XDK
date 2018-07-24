//
//  LYRUIMessageOpenMessageActionHandler.m
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 6/11/18.
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

#import "LYRUIMessageOpenMessageActionHandler.h"
#import "LYRUITempFileGenerator.h"
#import "LYRUIMessageViewController.h"

@implementation LYRUIMessageOpenMessageActionHandler

@synthesize layerConfiguration = _layerConfiguration;

#pragma mark - LYRUIConfigurable Implementation

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [self init];
    if (self) {
        self.layerConfiguration = configuration;
    }
    return self;
}

#pragma mark - LYRUIActionHandling Implementation

- (void)handleActionWithData:(NSDictionary *)data delegate:(id<LYRUIActionHandlingDelegate>)delegate {
    UIViewController *viewController = [self viewControllerForActionWithData:data];
    if (viewController) {
        [delegate actionHandler:self presentViewController:viewController];
    }
}

- (UIViewController *)viewControllerForActionWithData:(NSDictionary *)data {
    if (data == nil || data[@"message_part_id"] == nil) {
        return nil;
    }
    NSURL *messagePartID = data[@"message_part_id"];
    LYRUIMessageViewController *messageViewController = [[LYRUIMessageViewController alloc] initWithConfiguration:self.layerConfiguration];
    messageViewController.messagePartID = messagePartID;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:messageViewController];
    navigationController.navigationBar.translucent = NO;
    navigationController.navigationItem.hidesBackButton = NO;
    return navigationController;
}

@end
