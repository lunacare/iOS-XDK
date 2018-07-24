//
//  LYRUIProductMessageCompositeViewPresenter.m
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

#import "LYRUIProductMessageCompositeViewPresenter.h"
#import "LYRUIProductMessage.h"
#import "LYRUIProductMessageCompositeView.h"
#import "LYRUIProductOptionView.h"
#import "LYRUIMessageItemContentPresentersProvider.h"
#import "LYRUIDispatcher.h"
#import "LYRUIImageFetcher.h"
#import "NSCache+LYRUIImageCaching.h"
#import "UIView+LYRUIMessageConfiguration.h"
#import "LYRUIChoiceMessage.h"
#import "LYRUIReusableViewsQueue.h"

@interface LYRUIProductMessageCompositeViewPresenter ()

@property (nonatomic, strong) LYRUIProductMessageCompositeView *sizingProductView;

@end

@implementation LYRUIProductMessageCompositeViewPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sizingProductView = [[LYRUIProductMessageCompositeView alloc] init];
    }
    return self;
}

- (UIView *)viewForMessage:(LYRUIProductMessage *)message {
    LYRUIProductMessageCompositeView *productCompositeView = [self.reusableViewsQueue dequeueReusableViewOfType:[LYRUIProductMessageCompositeView class]];
    if (productCompositeView == nil) {
        productCompositeView = [[LYRUIProductMessageCompositeView alloc] init];
    }
    [self setupImageView:productCompositeView.imageView withMessage:message];
    [self setupLabelsInProductView:productCompositeView withMessage:message];
    [self setupOptionsInProductView:productCompositeView withMessage:message];
    return productCompositeView;
}

- (void)setupImageView:(__weak UIImageView *)imageView withMessage:(LYRUIProductMessage *)message {
    NSString *contextId = [NSUUID UUID].UUIDString;
    imageView.lyr_presentationContextId = contextId;
    [self fetchAndPresentImageWithURL:message.imageURLs.firstObject inImageView:imageView contextId:contextId completion:nil];
}

- (void)setupLabelsInProductView:(LYRUIProductMessageCompositeView *)productView
                     withMessage:(LYRUIProductMessage *)message {
    productView.brandLabel.text = message.brand;
    productView.nameLabel.text = message.name;
    productView.priceLabel.text = [self stringForPrice:message.price withCurrency:message.currency];
    productView.descriptionLabel.text = message.productDescription;
}

- (NSString *)stringForPrice:(NSNumber *)price withCurrency:(NSString *)currency {
    NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
    [priceFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    priceFormatter.currencyCode = currency;
    NSString *priceString = [priceFormatter stringFromNumber:price];
    return priceString;
}

- (void)setupOptionsInProductView:(LYRUIProductMessageCompositeView *)productView
                      withMessage:(LYRUIProductMessage *)message {
    NSMutableArray *options = [[NSMutableArray alloc] init];
    for (LYRUIChoiceMessage *option in message.options) {
        LYRUIProductOptionView *optionView = [[LYRUIProductOptionView alloc] init];
        optionView.titleLabel.text = [NSString stringWithFormat:@"%@:", option.label];
        optionView.valueLabel.text = [self choiceMessageSelectedText:option];
        [options addObject:optionView];
    }
    [productView setupWithOptions:options];
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

- (CGFloat)viewHeightForMessage:(LYRUIProductMessage *)message minWidth:(CGFloat)minWidth maxWidth:(CGFloat)maxWidth {
    CGFloat textMaxWidth = maxWidth - 24.0;
    
    LYRUIProductMessageCompositeView *view = self.sizingProductView;
    [self setupLabelsInProductView:view withMessage:message];
    
    CGFloat labelsHeight = 0.0;
    
    NSArray *labels = @[view.brandLabel, view.nameLabel, view.priceLabel, view.descriptionLabel];
    for (UILabel *label in labels) {
        CGSize labelSize = [self textSizeInLabel:label withMaxWidth:textMaxWidth];
        labelsHeight += ceil(labelSize.height);
        minWidth = MAX(minWidth, labelSize.width + 24.0);
    }
    
    CGSize imageSize = [self sizeOfImageWithURL:message.imageURLs.firstObject];
    CGFloat imageHeight = [self heightForSize:imageSize withMinWidth:minWidth maxWidth:maxWidth];
    imageHeight = 236.0;
    
    CGFloat buttonsHeight = MAX((message.options.count * 22.0) - 5.0, 0.0);
    return imageHeight + buttonsHeight + labelsHeight + 34.0;
}

@end
