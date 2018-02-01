//
//  LYRUIReceiptMessage.h
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 03.01.2018.
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

#import "LYRUIMessageType.h"
@class LYRUIReceiptDiscount;
@class LYRUIReceiptOrder;
@class LYRUIReceiptSummary;
@class LYRUILocationMessage;
@class LYRUIProductMessage;

NS_ASSUME_NONNULL_BEGIN     // {
@interface LYRUIReceiptMessage : LYRUIMessageType

@property (nonatomic, readonly, nullable) NSDate *createdAt;
@property (nonatomic, readonly) NSString *currency;
@property (nonatomic, readonly, nullable) NSArray<LYRUIReceiptDiscount *> *discounts;
@property (nonatomic, readonly, nullable) LYRUIReceiptOrder *order;
@property (nonatomic, readonly, nullable) NSString *paymentMethod;
@property (nonatomic, readonly) LYRUIReceiptSummary *orderSummary;
@property (nonatomic, readonly, nullable) NSString *title;
@property (nonatomic, readonly, nullable) LYRUILocationMessage *shippingAddress;
@property (nonatomic, readonly, nullable) LYRUILocationMessage *billingAddress;
@property (nonatomic, readonly, nullable) NSArray<LYRUIProductMessage *> *products;

- (instancetype)initWithCreatedAt:(nullable NSDate *)createdAt
                         currency:(NSString *)currency
                        discounts:(nullable NSArray<LYRUIReceiptDiscount *> *)discounts
                            order:(nullable LYRUIReceiptOrder *)order
                    paymentMethod:(nullable NSString *)paymentMethod
                     orderSummary:(LYRUIReceiptSummary *)orderSummary
                            title:(nullable NSString *)title
                  shippingAddress:(nullable LYRUILocationMessage *)shippingAddress
                   billingAddress:(nullable LYRUILocationMessage *)billingAddress
                         products:(NSArray<LYRUIProductMessage *> *)products
                           action:(nullable LYRUIMessageAction *)action
                           sender:(nullable LYRIdentity *)sender
                           sentAt:(nullable NSDate *)sentAt
                           status:(nullable LYRUIMessageTypeStatus *)status;

@end
NS_ASSUME_NONNULL_END       // }
