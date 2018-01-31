//
//  LYRUIFilePreviewController.m
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

#import "LYRUIFilePreviewController.h"

@interface LYRUIFilePreviewController () <QLPreviewControllerDataSource>

@property (nonatomic, strong, readwrite) id<QLPreviewItem> item;

@end

@implementation LYRUIFilePreviewController

- (instancetype)initWithPreviewItem:(id<QLPreviewItem>)previewItem {
    self = [super init];
    if (self) {
        self.item = previewItem;
        self.dataSource = self;
    }
    return self;
}

#pragma mark - 

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return (self.item != nil) ? 1 : 0;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.item;
}

@end
