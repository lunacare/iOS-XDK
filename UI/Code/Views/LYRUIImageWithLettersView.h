//
//  LYRUIImageWithLettersView.h
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
 @abstract The `LYRUIImageWithLettersView` displays a circle view with image and text representing the profile photo or initials of `Identity`.
 */
@interface LYRUIImageWithLettersView : UIView

/**
 @abstract The image to present in the view.
 */
@property (nonatomic, copy, nullable) IBInspectable UIImage *image;
/**
 @abstract The letters to present in the view.
 */
@property (nonatomic, copy, nullable) IBInspectable NSString *letters;

/**
 @name Appearance customization.
 */

/**
 @abstract The text color of the view. Default is white color.
 */
@property (nonatomic, copy) IBInspectable UIColor *lettersColor;
/**
 @abstract The border color of the view. Default is clear color.
 */
@property (nonatomic, copy) IBInspectable UIColor *borderColor;
/**
 @abstract The border width of the view. Default is 0.0.
 */
@property (nonatomic) IBInspectable CGFloat borderWidth;
/**
 @abstract The background color of the circle view. Default is light gray color.
 */
@property (nonatomic, copy) IBInspectable UIColor *avatarBackgroundColor;
/**
 @abstract The font of initials presented in view. Default is system font.
 @warning Size of the font is changed by layout when view is resized.
 */
@property (nonatomic, copy) UIFont *font;

/**
 @name Asynchronous image download
 */

/**
 @abstract The associated download task of the image to present in view.
 @warning Old task should be canceled when the view is reused to prevent from asynchronously updating view with wrong image, in download task callback.
 */
@property (nonatomic, strong, nullable) NSURLSessionDownloadTask *imageFetchTask;

@end
NS_ASSUME_NONNULL_END       // }
