//
//  LYRUIMessageOpenFileActionHandler.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 25.09.2017.
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

#import "LYRUIMessageOpenFileActionHandler.h"
#import <LayerKit/LayerKit.h>
#import "LYRUITempFileGenerator.h"
#import "LYRUIFilePreviewController.h"

@interface LYRUIMessageOpenFileActionHandler ()

@property (nonatomic, strong) LYRUITempFileGenerator *tempFileGenerator;

@end

@implementation LYRUIMessageOpenFileActionHandler

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tempFileGenerator = [[LYRUITempFileGenerator alloc] init];
    }
    return self;
}

- (void)handleActionWithData:(id)data delegate:(id<LYRUIActionHandlingDelegate>)delegate {
    if (data == nil || data[@"url"] == nil) {
        return;
    }
    NSURL *fileURL = [NSURL fileURLWithPath:data[@"url"]];
    if ([QLPreviewController canPreviewItem:fileURL]) {
        UIViewController *viewController = [[LYRUIFilePreviewController alloc] initWithPreviewItem:fileURL];
        [delegate actionHandler:self presentViewController:viewController];
    }
}

@end