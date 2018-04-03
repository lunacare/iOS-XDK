//
//  LYRUIMessageOpenURLActionHandler.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 26.09.2017.
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

#import "LYRUIMessageOpenURLActionHandler.h"
#import <LayerKit/LayerKit.h>
#import <SafariServices/SafariServices.h>

@implementation LYRUIMessageOpenURLActionHandler

- (void)handleActionWithData:(NSDictionary *)data delegate:(id<LYRUIActionHandlingDelegate>)delegate {
    UIViewController *viewController = [self viewControllerForActionWithData:data];
    if (viewController) {
        [delegate actionHandler:self presentViewController:viewController];
    }
}

- (UIViewController *)viewControllerForActionWithData:(NSDictionary *)data {
    if (data == nil || data[@"url"] == nil) {
        return nil;
    }
    NSURL *linkURL = [NSURL URLWithString:data[@"url"]];
    UIViewController *viewController = [[SFSafariViewController alloc] initWithURL:linkURL];
    return viewController;
}

@end
