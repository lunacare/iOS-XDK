//
//  LYRUIIdentityItemView.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 13.07.2017.
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

#import "LYRUIIdentityItemView.h"
#import "LYRUIBaseItemViewLayout.h"
#import "LYRUIIdentityItemViewLayoutMetrics.h"
#import "LYRUISampleAccessoryView.h"
#import "LYRUIIdentityItemIBSetup.h"

@implementation LYRUIIdentityItemView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        LYRUIIdentityItemViewLayoutMetrics *metrics = [[LYRUIIdentityItemViewLayoutMetrics alloc] init];
        self.layout = [[LYRUIBaseItemViewLayout alloc] initWithMetrics:metrics];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        LYRUIIdentityItemViewLayoutMetrics *metrics = [[LYRUIIdentityItemViewLayoutMetrics alloc] init];
        self.layout = [[LYRUIBaseItemViewLayout alloc] initWithMetrics:metrics];
    }
    return self;
}

- (instancetype)initWithLayout:(id<LYRUIBaseItemViewLayout>)layout {
    if (layout == nil) {
        LYRUIIdentityItemViewLayoutMetrics *metrics = [[LYRUIIdentityItemViewLayoutMetrics alloc] init];
        layout = [[LYRUIBaseItemViewLayout alloc] initWithMetrics:metrics];
    }
    self = [super initWithLayout:layout];
    return self;
}

- (void)prepareForInterfaceBuilder {
    [[[LYRUIIdentityItemIBSetup alloc] init] prepareIdentityItemForInterfaceBuilder:self];
}

@end
