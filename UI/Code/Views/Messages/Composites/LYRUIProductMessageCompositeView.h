//
//  LYRUIProductMessageCompositeView.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 02.01.2018.
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

#import "LYRUIViewWithLayout.h"
#import "LYRUIViewReusing.h"
@class LYRUIProductOptionView;

@interface LYRUIProductMessageCompositeView : LYRUIViewWithLayout <LYRUIViewReusing>

@property (nonatomic, readonly, weak) UIImageView *imageView;
@property (nonatomic, readonly, weak) UILabel *brandLabel;
@property (nonatomic, readonly, weak) UILabel *nameLabel;
@property (nonatomic, readonly, weak) UILabel *priceLabel;
@property (nonatomic, readonly, weak) UIStackView *optionsStackView;
@property (nonatomic, readonly, weak) UILabel *descriptionLabel;

- (void)setupWithOptions:(NSArray<LYRUIProductOptionView *> *)options;

@end
