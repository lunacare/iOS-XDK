//
//  LYRUIChoiceButton.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 16.01.2018.
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

#import "LYRUIChoiceButton.h"
#import "UIImage+LYRUIColorImage.h"

@implementation LYRUIChoiceButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];
        [self setTitleColor:[UIColor colorWithRed:16.0/255.0 green:148.0/255.0 blue:208.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:16.0/255.0 green:148.0/255.0 blue:208.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [self setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [self setTitleColor:UIColor.whiteColor forState:(UIControlStateSelected | UIControlStateDisabled)];
        [self setTitleColor:[UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [self setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:233.0/255.0 green:235.0/255.0 blue:239.0/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:25.0/255.0 green:165.0/255.0 blue:228.0/255.0 alpha:1.0]] forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:25.0/255.0 green:165.0/255.0 blue:228.0/255.0 alpha:1.0]] forState:(UIControlStateSelected | UIControlStateDisabled)];
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:247.0/255.0 alpha:1.0]] forState:UIControlStateDisabled];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

@end
