//
//  LYRUIReceiptMessageCompositeView.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 04.01.2018.
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

@interface LYRUIReceiptMessageCompositeView : LYRUIViewWithLayout <LYRUIViewReusing>

@property (nonatomic, readonly, weak) UIImageView *iconView;
@property (nonatomic, readonly, weak) UILabel *titleLabel;
@property (nonatomic, readonly, weak) UIStackView *productsStackView;
@property (nonatomic, readonly, weak) UILabel *paymentTitleLabel;
@property (nonatomic, readonly, weak) UILabel *paymentLabel;
@property (nonatomic, readonly, weak) UILabel *shippingTitleLabel;
@property (nonatomic, readonly, weak) UILabel *shippingAddressLabel;
@property (nonatomic, readonly, weak) UILabel *summaryTitleLabel;
@property (nonatomic, readonly, weak) UILabel *totalPriceLabel;

@end
