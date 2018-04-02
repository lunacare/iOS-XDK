//
//  UIScrollView+LYRUIAdjustedContentInset.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 25.01.2018.
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

#import <UIKit/UIKit.h>

@interface UIScrollView (LYRUIAdjustedContentInset)

/**
 @abstract Returns `adjustedContentInset` when used on iOS 11 and nower. Otherwise returns `contentInset`.
 */
@property (nonatomic, readonly) UIEdgeInsets lyr_adjustedContentInset;

/**
 @abstract Used for storing original content inset before maintining it.
 */
@property (nonatomic, strong) NSString *lyr_serializedOriginalContentInset;

@end
