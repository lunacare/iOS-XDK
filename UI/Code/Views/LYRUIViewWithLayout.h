//
//  LYRUIViewWithLayout.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 04.07.2017.
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
#import "LYRUIViewLayout.h"

/**
 @abstract The `LYRUIViewWithLayout` is a UIView subclass that manages adding, removing, and updating AutoLayout constraints using the `layout` object passed to the view.
 */
@interface LYRUIViewWithLayout : UIView

/**
 @abstract Layout of the view's subviews.
 */
@property(nonatomic, copy, nullable) id<LYRUIViewLayout> layout;

/**
 @abstract Flag used to determine if constraints should be updated on view width change.
 */
@property (nonatomic) BOOL updateConstraintsOnWidthChange;

/**
 @abstract Flag used to determine if constraints should be updated on view height change.
 */
@property (nonatomic) BOOL updateConstraintsOnHeightChange;

@end
