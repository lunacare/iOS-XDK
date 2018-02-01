//
//  LYRUIChoice.h
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

#import "LYRUIButtonsMessageActionButton.h"
#import "LYRUIChoice.h"

NS_ASSUME_NONNULL_BEGIN     // {
@protocol LYRUIChoiceProperties <NSObject>

@property (nonatomic, strong, readonly, nullable) NSString *text;
@property (nonatomic, strong, readonly, nullable) NSString *tooltip;

@end

@interface LYRUIChoice : LYRUIButtonsMessageActionButton <LYRUIChoiceProperties>

@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly, nullable) NSDictionary *customResponseData;

@property (nonatomic, strong, readonly, nullable) id<LYRUIChoiceProperties> defaultStateProperties;
@property (nonatomic, strong, readonly, nullable) id<LYRUIChoiceProperties> selectedStateProperties;

- (instancetype)initWithText:(nullable NSString *)text
                     tooltip:(nullable NSString *)tooltip;

- (instancetype)initWithIdentifier:(NSString *)identifier
                              text:(NSString *)text
                           tooltip:(nullable NSString *)tooltip;

- (instancetype)initWithIdentifier:(NSString *)identifier
                              text:(NSString *)text
                           tooltip:(nullable NSString *)tooltip
                customResponseData:(nullable NSDictionary *)customResponseData
            defaultStateProperties:(nullable id<LYRUIChoiceProperties>)defaultStateProperties
           selectedStateProperties:(nullable id<LYRUIChoiceProperties>)selectedStateProperties;

@end
NS_ASSUME_NONNULL_END       // }
