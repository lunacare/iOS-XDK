//
//  LYRUIChoiceSet.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 18.01.2018.
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

#import <Foundation/Foundation.h>
@class LYRUIChoice;
@class LYRUIORSet;

NS_ASSUME_NONNULL_BEGIN     // {
@protocol LYRUIChoiceSet <NSObject>

@property (nonatomic, copy, readonly) NSArray<LYRUIChoice *> *choices;

@property (nonatomic, readonly) BOOL allowReselect;
@property (nonatomic, readonly) BOOL allowDeselect;
@property (nonatomic, readonly) BOOL allowMultiselect;

@property (nonatomic, copy, readonly, nullable) NSString *name;
@property (nonatomic, copy, readonly, nullable) NSString *responseName;
@property (nonatomic, copy, readonly, nullable) NSDictionary *customResponseData;
@property (nonatomic, copy, readonly) NSSet<NSString *> *enabledFor;
@property (nonatomic, readonly, nullable) LYRUIORSet *initialResponseState;
@property (nonatomic, readonly, nullable) LYRUIORSet *selectionsSet;

@property (nonatomic, readonly, nonnull) NSString *responseMessageId;
@property (nonatomic, readonly, nonnull) NSString *responseNodeId;

@end
NS_ASSUME_NONNULL_END       // }
