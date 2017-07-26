//
//  LYRUIImageWithLettersView.h
//  Layer-UI-iOS
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
@interface LYRUIImageWithLettersView : UIView

@property (nonatomic, copy, nullable) IBInspectable UIImage *image;
@property (nonatomic, copy, nullable) IBInspectable NSString *letters;
@property (nonatomic, copy) IBInspectable UIColor *lettersColor;
@property (nonatomic, copy) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic, copy) IBInspectable UIColor *avatarBackgroundColor;
@property (nonatomic, copy) UIFont *font;

@property (nonatomic, strong) NSURLSessionDownloadTask *imageFetchTask;

@end
NS_ASSUME_NONNULL_END       // }
