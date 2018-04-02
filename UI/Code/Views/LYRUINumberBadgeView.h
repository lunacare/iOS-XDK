//
//  LYRUINumberBadgeView.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 20.07.2017.
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

NS_ASSUME_NONNULL_BEGIN     // {
IB_DESIGNABLE
/**
 @abstract The `LYRUINumberBadgeView` displays a badge with number representing the count of Identities in a conversation.
 */
@interface LYRUINumberBadgeView : UIView

/**
 @abstract The number to present in the badge.
 */
@property (nonatomic) IBInspectable NSUInteger number;

/**
 @name Appearance customization.
 */

/**
 @abstract The text color of presented number. Default is gray color.
 */
@property (nonatomic, copy) IBInspectable UIColor *textColor;
/**
 @abstract The border color of the badge. Default is gray color.
 */
@property (nonatomic, copy) IBInspectable UIColor *borderColor;
/**
 @abstract The border width of the badge. Default is 1.0.
 */
@property (nonatomic) IBInspectable CGFloat borderWidth;
/**
 @abstract The corner radius of the badge. Default is 4.0.
 */
@property (nonatomic) IBInspectable CGFloat cornerRadius;
/**
 @abstract The font of presented number. Default is system font of size 9.0.
 */
@property (nonatomic, copy) UIFont *font;

@end
NS_ASSUME_NONNULL_END       // }
