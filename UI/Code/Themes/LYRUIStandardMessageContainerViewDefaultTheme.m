//
//  LYRUIStandardMessageContainerViewDefaultTheme.m
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

#import "LYRUIStandardMessageContainerViewDefaultTheme.h"

@implementation LYRUIStandardMessageContainerViewDefaultTheme
@synthesize descriptionLabelFont, descriptionLabelTextColor,
            titleLabelFont, titleLabelTextColor,
            footerLabelFont, footerLabelTextColor,
            metadataContainerBackgroundColor;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleLabelFont = [UIFont systemFontOfSize:14.0];
        self.titleLabelTextColor = UIColor.blackColor;
        self.descriptionLabelFont = [UIFont systemFontOfSize:12.0];
        self.descriptionLabelTextColor = [UIColor colorWithRed:110.0/255.0 green:114.0/255.0 blue:122.0/255.0 alpha:1.0];
        self.footerLabelFont = [UIFont systemFontOfSize:11.0];
        self.footerLabelTextColor = [UIColor colorWithRed:164.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
        self.metadataContainerBackgroundColor = UIColor.clearColor;
    }
    return self;
}

@end
