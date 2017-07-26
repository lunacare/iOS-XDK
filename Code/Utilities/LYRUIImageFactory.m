//
//  LYRUIImageFactory.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 25.07.2017.
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

#import "LYRUIImageFactory.h"

@interface LYRUIImageFactory ()

@property (nonatomic, strong) NSBundle *bundle;

@end

@implementation LYRUIImageFactory

- (instancetype)init {
    self = [self initWithBundle:nil];
    return self;
}

- (instancetype)initWithBundle:(NSBundle *)bundle {
    self = [super init];
    if (self) {
        if (bundle == nil) {
            bundle = [NSBundle bundleForClass:[self class]];
        }
        self.bundle = bundle;
    }
    return self;
}

- (UIImage *)imageNamed:(NSString *)imageName {
    return [UIImage imageNamed:imageName inBundle:self.bundle compatibleWithTraitCollection:nil];
}

- (nullable UIImage *)imageWithData:(NSData *)data {
    return [UIImage imageWithData:data];
}

@end
