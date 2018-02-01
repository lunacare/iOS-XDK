//
//  LYRUIChoice.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 23.11.2017.
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

#import "LYRUIChoice.h"

@interface LYRUIChoice ()

@property (nonatomic, strong, readwrite) NSString *identifier;
@property (nonatomic, strong, readwrite) NSString *text;
@property (nonatomic, strong, readwrite) NSString *tooltip;
@property (nonatomic, strong, readwrite) NSDictionary *customResponseData;

@property (nonatomic, strong, readwrite) id<LYRUIChoiceProperties> defaultStateProperties;
@property (nonatomic, strong, readwrite) id<LYRUIChoiceProperties> selectedStateProperties;

@end

@implementation LYRUIChoice

- (instancetype)initWithText:(NSString *)text
                     tooltip:(NSString *)tooltip {
    self = [super init];
    if (self) {
        self.text = text;
        self.tooltip = tooltip;
    }
    return self;
}

- (instancetype)initWithIdentifier:(NSString *)identifier
                              text:(NSString *)text
                           tooltip:(NSString *)tooltip {
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.text = text;
        self.tooltip = tooltip;
    }
    return self;
}

- (instancetype)initWithIdentifier:(NSString *)identifier
                              text:(NSString *)text
                           tooltip:(NSString *)tooltip
                customResponseData:(NSDictionary *)customResponseData
            defaultStateProperties:(id <LYRUIChoiceProperties>)defaultStateProperties
           selectedStateProperties:(id <LYRUIChoiceProperties>)selectedStateProperties {
    self = [self initWithText:text tooltip:tooltip];
    if (self) {
        self.identifier = identifier;
        self.customResponseData = customResponseData;
        self.defaultStateProperties = defaultStateProperties;
        self.selectedStateProperties = selectedStateProperties;
    }
    return self;
}

- (NSString *)title {
    return self.text;
}

@end
