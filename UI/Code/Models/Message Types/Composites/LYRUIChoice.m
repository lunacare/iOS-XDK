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
@property (nonatomic, strong, readwrite) NSString *selectedText;
@property (nonatomic, strong, readwrite) NSDictionary *customResponseData;

@end

@implementation LYRUIChoice

- (instancetype)initWithIdentifier:(NSString *)identifier
                              text:(NSString *)text
                      selectedText:(NSString *)selectedText
                customResponseData:(NSDictionary *)customResponseData{
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.text = text;
        self.selectedText = selectedText;
        self.customResponseData = customResponseData;
    }
    return self;
}

- (instancetype)initWithIdentifier:(NSString *)identifier
                              text:(NSString *)text {
    self = [self initWithIdentifier:identifier text:text selectedText:nil customResponseData:nil];
    return self;
}

- (NSString *)title {
    return self.text;
}

@end
