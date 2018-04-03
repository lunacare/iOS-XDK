//
//  LYRUIReceiptMessage.m
//  Layer-XDK-UI-iOS
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

#import "LYRUIReceiptMessage.h"
#import "LYRUIReceiptDiscount.h"
#import "LYRUIReceiptOrder.h"
#import "LYRUIReceiptSummary.h"
#import "LYRUILocationMessage.h"
#import "LYRUIProductMessage.h"

@interface LYRUIReceiptMessage ()

@property (nonatomic, readwrite, nullable) NSDate *createdAt;
@property (nonatomic, readwrite, nullable) NSString *currency;
@property (nonatomic, readwrite, nullable) NSArray<LYRUIReceiptDiscount *> *discounts;
@property (nonatomic, readwrite, nullable) LYRUIReceiptOrder *order;
@property (nonatomic, readwrite, nullable) NSString *paymentMethod;
@property (nonatomic, readwrite, nullable) LYRUIReceiptSummary *orderSummary;
@property (nonatomic, readwrite, nullable) NSString *title;
@property (nonatomic, readwrite, nullable) LYRUILocationMessage *shippingAddress;
@property (nonatomic, readwrite, nullable) LYRUILocationMessage *billingAddress;
@property (nonatomic, readwrite, nullable) NSArray<LYRUIProductMessage *> *products;

@end

@implementation LYRUIReceiptMessage

- (instancetype)initWithCreatedAt:(NSDate *)createdAt
                         currency:(NSString *)currency
                        discounts:(NSArray<LYRUIReceiptDiscount *> *)discounts
                            order:(LYRUIReceiptOrder *)order
                    paymentMethod:(NSString *)paymentMethod
                     orderSummary:(LYRUIReceiptSummary *)orderSummary
                            title:(NSString *)title
                  shippingAddress:(LYRUILocationMessage *)shippingAddress
                   billingAddress:(LYRUILocationMessage *)billingAddress
                         products:(NSArray<LYRUIProductMessage *> *)products
                           action:(LYRUIMessageAction *)action
                           sender:(LYRIdentity *)sender
                           sentAt:(NSDate *)sentAt
                           status:(LYRUIMessageTypeStatus *)status {
    self = [super initWithAction:action
                          sender:sender
                          sentAt:sentAt
                          status:status];
    if (self) {
        self.createdAt = createdAt;
        self.currency = currency;
        self.discounts = discounts;
        self.order = order;
        self.paymentMethod = paymentMethod;
        self.orderSummary = orderSummary;
        self.title = title;
        self.shippingAddress = shippingAddress;
        self.billingAddress = billingAddress;
        self.products = products;
    }
    return self;
}

+ (NSString *)MIMEType {
    return @"application/vnd.layer.receipt+json";
}

- (NSString *)summary {
    return @"Receipt";
}

@end
