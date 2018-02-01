//
//  LYRUIStatusMessageCollectionViewCell.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 09.01.2018.
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

NS_ASSUME_NONNULL_BEGIN     // {
@protocol LYRUIStatusMessageView <NSObject>

@property (nonatomic, weak, readonly) UITextView *textView;
@property (nonatomic, copy, nullable) NSString *text;

@end

@protocol LYRUIStatusMessageViewLayout <LYRUIViewLayout>

- (void)addConstraintsInView:(UIView<LYRUIStatusMessageView> *)view;
- (void)removeConstraintsFromView:(UIView<LYRUIStatusMessageView> *)view;
- (void)updateConstraintsInView:(UIView<LYRUIStatusMessageView> *)view;

@end

@interface LYRUIStatusMessageCollectionViewCell : UICollectionViewCell <LYRUIStatusMessageView>

/**
 @abstract Layout of the `LYRUIStatusMessageCollectionViewCell` subviews. Default is an `LYRUIStatusMessageCellLayout` instance.
 */
@property (nonatomic, copy) id<LYRUIStatusMessageViewLayout> layout;

@end
NS_ASSUME_NONNULL_END       // }
