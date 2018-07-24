//
//  LYRUIMediaMessageContentViewPresenter.h
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 5/30/18.
//  Copyright (c) 2018 Layer. All rights reserved.
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

#import "LYRUIFileMessageContentViewPresenter.h"
#import "LYRUIMediaMessage.h"

NS_ASSUME_NONNULL_BEGIN     // {

extern CGFloat const LYRUIMediaItemViewMaxHeight; // Media image's maximum height constant.
extern CGFloat const LYRUIMediaItemVIewMinHeight; // Media image's minimum height constant.

/**
 @abstract The media message content view presenter, based on the file message
   content view presenter, but also capable of displaying preview images.
 */
@interface LYRUIMediaMessageContentViewPresenter : LYRUIFileMessageContentViewPresenter

/**
 @abstract Called after the presenter generates a view for the message, to
   setup the constraints based on the image size.
 @param view The view the presenter just generated.
 @param size The original size of the image.
 */
- (void)setupViewConstraints:(UIView *)view forImageSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END       // }
