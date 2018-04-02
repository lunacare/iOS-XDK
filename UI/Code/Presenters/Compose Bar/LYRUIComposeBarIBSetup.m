//
//  LYRUIComposeBarIBSetup.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 16.08.2017.
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

#import "LYRUIComposeBarIBSetup.h"
#import "LYRUIComposeBar.h"

@implementation LYRUIComposeBarIBSetup

- (void)prepareComposeBarForInterfaceBuilder:(LYRUIComposeBar *)composeBar {
    LYRUIConfiguration *layerConfiguration = [[LYRUIConfiguration alloc] init];
    composeBar.layerConfiguration = layerConfiguration;
    
    UIView *leftItem = [[UIView alloc] init];
    leftItem.translatesAutoresizingMaskIntoConstraints = NO;
    leftItem.backgroundColor = UIColor.grayColor;
    leftItem.clipsToBounds = YES;
    leftItem.layer.cornerRadius = 12.0;
    [leftItem.widthAnchor constraintEqualToConstant:24.0].active = YES;
    [leftItem.heightAnchor constraintEqualToConstant:24.0].active = YES;
    composeBar.leftItems = @[leftItem];

    composeBar.placeholderColor = [UIColor greenColor];
    composeBar.placeholder = @"placeholder";
}

@end
