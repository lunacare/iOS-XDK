//
//  LYRUIListHeaderView.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 30.07.2017.
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

#import "LYRUIListHeaderView.h"
#import "LYRUIListHeaderViewLayout.h"

@interface LYRUIListHeaderView ()

@property (nonatomic, weak, readwrite) UILabel *label;

@end

@implementation LYRUIListHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (void)lyr_commonInit {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightBold];
    label.textColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
    [self addSubview:label];
    self.label = label;
    self.layout = [[LYRUIListHeaderViewLayout alloc] init];
}

#pragma mark - Properties

- (NSString *)title {
    return self.label.text;
}

- (void)setTitle:(NSString *)title {
    self.label.text = title;
}

#pragma mark - Layout

- (void)setLayout:(id<LYRUIListHeaderViewLayout>)layout {
    if ([self.layout isEqual:layout]) {
        return;
    }
    if (self.layout != nil) {
        [self.layout removeConstraintsFromView:self];
    }
    _layout = [layout copyWithZone:nil];
    [self.layout addConstraintsInView:self];
}

- (void)updateConstraints {
    [self.layout updateConstraintsInView:self];
    [super updateConstraints];
}

@end
