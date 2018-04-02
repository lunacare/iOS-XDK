//
//  LYRUIReceiptMessageCompositeViewPresenter.m
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

#import "LYRUIReceiptMessageCompositeViewPresenter.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIReceiptMessage.h"
#import "LYRUIReceiptSummary.h"
#import "LYRUIReceiptMessageCompositeView.h"
#import "LYRUIMessageItemContentPresentersProvider.h"
#import "UIView+LYRUIMessageConfiguration.h"
#import "LYRUILocationMessage.h"
#import "LYRUIProductMessage.h"
#import "LYRUIChoiceMessage.h"
#import "LYRUIReusableViewsQueue.h"
#import "LYRUIReceiptProductView.h"
#import "LYRUIImageCreating.h"

@interface LYRUIReceiptMessageCompositeViewPresenter ()

@property (nonatomic, strong) LYRUIReceiptMessageCompositeView *sizingReceiptView;
@property (nonatomic, strong) id<LYRUIImageCreating> imageFactory;

@end

@implementation LYRUIReceiptMessageCompositeViewPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sizingReceiptView = [[LYRUIReceiptMessageCompositeView alloc] init];
    }
    return self;
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    [super setLayerConfiguration:layerConfiguration];
    self.imageFactory = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIImageCreating)
                                                                   forClass:[self class]];
}

- (UIView *)viewForMessage:(LYRUIReceiptMessage *)message {
    LYRUIReceiptMessageCompositeView *receiptCompositeView = [self.reusableViewsQueue dequeueReusableViewOfType:[LYRUIReceiptMessageCompositeView class]];
    if (receiptCompositeView == nil) {
        receiptCompositeView = [[LYRUIReceiptMessageCompositeView alloc] init];
    }
    
    [self setupIconInReceiptView:receiptCompositeView];
    [self setupLabelsInReceiptView:receiptCompositeView withMessage:message];
    [self setupProductsInReceiptView:receiptCompositeView withMessage:message];
    return receiptCompositeView;
}

- (void)setupIconInReceiptView:(LYRUIReceiptMessageCompositeView *)receiptView {
    receiptView.iconView.image = [self.imageFactory imageNamed:@"Receipt"];
}

- (void)setupLabelsInReceiptView:(LYRUIReceiptMessageCompositeView *)receiptView
                     withMessage:(LYRUIReceiptMessage *)message {
    receiptView.titleLabel.text = @"Order confirmation";
    
    receiptView.paymentTitleLabel.text = @"Paid with";
    receiptView.paymentLabel.text = message.paymentMethod;
    
    receiptView.shippingTitleLabel.text = @"Ship to";
    LYRUILocationMessage *address = message.shippingAddress;
    NSMutableString *addressString = [[NSMutableString alloc] init];
    [addressString appendString:address.street1 ?: @""];
    if (address.street2 != nil) {
        if (addressString.length > 0) {
            [addressString appendString:@"\n"];
        }
        [addressString appendString:address.street2];
    }
    if (address.city != nil || address.postalCode != nil) {
        if (addressString.length > 0) {
            [addressString appendString:@"\n"];
        }
        [addressString appendString:address.city ?: @""];
        if (address.city != nil && address.postalCode != nil) {
            [addressString appendString:@", "];
        }
        [addressString appendString:address.postalCode ?: @""];
    }
    receiptView.shippingAddressLabel.text = addressString;
    
    receiptView.summaryTitleLabel.text = @"Total";
    receiptView.totalPriceLabel.text = [self stringForPrice:message.orderSummary.totalCost withCurrency:message.currency];
}

- (NSString *)stringForPrice:(double)price withCurrency:(NSString *)currency {
    NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
    [priceFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    priceFormatter.currencyCode = currency;
    NSString *priceString = [priceFormatter stringFromNumber:@(price)];
    return priceString;
}

- (void)setupProductsInReceiptView:(LYRUIReceiptMessageCompositeView *)receiptView
                       withMessage:(LYRUIReceiptMessage *)message {
    for (LYRUIProductMessage *product in message.products) {
        LYRUIReceiptProductView *productView = [[LYRUIReceiptProductView alloc] init];
        [self setupImageView:productView.imageView withProductMessage:product];
        productView.nameLabel.text = product.name;
        NSString *options = [self optionsStringForProduct:product];
        if (options != nil) {
            productView.optionsLabel.text = options;
        } else {
            [productView.optionsLabel removeFromSuperview];
        }
        if (product.quantity > 0) {
            productView.quantityLabel.text = [NSString stringWithFormat:@"Quantity: %lu", (unsigned long)product.quantity];
        } else {
            [productView.quantityLabel removeFromSuperview];
        }
        [receiptView.productsStackView addArrangedSubview:productView];
    }
}

- (nullable NSString *)optionsStringForProduct:(LYRUIProductMessage *)product {
    NSMutableString *optionsString = [[NSMutableString alloc] init];
    for (LYRUIChoiceMessage *option in product.options) {
        NSString *optionValue = [self choiceMessageSelectedText:option];
        if (optionValue != nil) {
            if (optionsString.length == 0) {
                [optionsString appendString:@"Options: "];
            } else {
                [optionsString appendString:@", "];
            }
            [optionsString appendString:optionValue];
        }
    }
    if (optionsString.length == 0) {
        return nil;
    }
    return optionsString;
}

- (nullable NSString *)choiceMessageSelectedText:(LYRUIChoiceMessage *)choiceMessage {
    if (choiceMessage.initialResponseState == nil) {
        return nil;
    }
    for (LYRUIChoice *choice in choiceMessage.choices) {
        if ([choice.identifier isEqualToString:choiceMessage.initialResponseState.selectedValues.firstObject]) {
            return choice.text;
        }
    }
    return nil;
}

- (void)setupImageView:(__weak UIImageView *)imageView withProductMessage:(LYRUIProductMessage *)productMessage {
    NSString *contextId = [NSUUID UUID].UUIDString;
    imageView.lyr_presentationContextId = contextId;
    [self fetchAndPresentImageWithURL:productMessage.imageURLs.firstObject inImageView:imageView contextId:contextId completion:nil];
}

- (CGFloat)viewHeightForMessage:(LYRUIReceiptMessage *)message minWidth:(CGFloat)minWidth maxWidth:(CGFloat)maxWidth {
    CGFloat maxTextWidth = maxWidth - 24.0;
    [self setupLabelsInReceiptView:self.sizingReceiptView withMessage:message];
    
    CGFloat titleHeight = 40.0;
    
    CGFloat productsHeight = (message.products.count * 74.0) + MAX((message.products.count - 1), 0);
    
    CGSize paymentTitleSize = [self textSizeInLabel:self.sizingReceiptView.paymentTitleLabel withMaxWidth:maxTextWidth];
    CGSize paymentSize = [self textSizeInLabel:self.sizingReceiptView.paymentLabel withMaxWidth:maxTextWidth];
    CGFloat paymentHeight = ceil(paymentTitleSize.height) + ceil(paymentSize.height) + 21.0;
    
    CGSize shippingTitleSize = [self textSizeInLabel:self.sizingReceiptView.shippingTitleLabel withMaxWidth:maxTextWidth];
    CGSize shippingAddressSize = [self textSizeInLabel:self.sizingReceiptView.shippingAddressLabel withMaxWidth:maxTextWidth];
    CGFloat shippingHeight = ceil(shippingTitleSize.height) + ceil(shippingAddressSize.height) + 21.0;
    
    CGFloat summaryHeight = 33.0;
    
    return titleHeight + productsHeight + paymentHeight + shippingHeight + summaryHeight + 4.0;
}

@end
