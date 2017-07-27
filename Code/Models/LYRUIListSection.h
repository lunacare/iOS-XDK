//
//  LYRUIListSection.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 27.07.2017.
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

#import "LYRUIListSectionHeader.h"

NS_ASSUME_NONNULL_BEGIN     // {
/**
 @abstract A set of items for single section to be used in list.
 */
@interface LYRUIListSection<ModelType> : NSObject

/**
 @abstract Additional data for section header view.
 */
@property (nonatomic, strong) id<LYRUIListSectionHeader> header;

/**
 @abstract Array of items in section.
 */
@property (nonatomic, strong) NSMutableArray<ModelType> *items;

/**
 @abstract Updates `header` property of section with `LYRUIListSectionHeader` instance, with given `title`.
 @param title Title to present in the header view in section.
 */
- (void)addHeaderWithTitle:(NSString *)title;

@end
NS_ASSUME_NONNULL_END       // }
