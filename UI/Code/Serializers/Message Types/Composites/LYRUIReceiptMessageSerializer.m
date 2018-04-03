//
//  LYRUIReceiptMessageSerializer.m
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

#import "LYRUIReceiptMessageSerializer.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRMessagePart+LYRUIHelpers.h"
#import "LYRUIReceiptDiscount.h"
#import "LYRUIReceiptOrder.h"
#import "LYRUIReceiptSummary.h"
#import "LYRUILocationMessage.h"
#import "LYRUIProductMessage.h"
#import "LYRUIMessageActionSerializer.h"

@interface LYRUIReceiptMessageSerializer ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation LYRUIReceiptMessageSerializer

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        self.dateFormatter = dateFormatter;
    }
    return self;
}

- (LYRUIReceiptMessage *)typedMessageWithMessagePart:(LYRMessagePart *)messagePart {
    NSDate *updatedAt;
    if (messagePart.properties[@"updated_at"] != nil) {
        updatedAt = [self.dateFormatter dateFromString:messagePart.properties[@"updated_at"]];
    }
    
    NSArray<LYRUIReceiptDiscount *> *discounts = [self discountsFromArray:messagePart.properties[@"discounts"]];
    
    LYRUIReceiptOrder *order = [self orderFromDictionary:messagePart.properties[@"order"]];
    
    LYRUIReceiptSummary *summary = [self summaryFromDictionary:messagePart.properties[@"summary"]];
    
    LYRMessagePart *shippingAddresPart = [messagePart childPartWithRole:@"shipping-address"];
    id<LYRUIMessageTypeSerializing> shippingAddressSerializer = [self.layerConfiguration.injector serializerForMessagePartMIMEType:shippingAddresPart.contentType];
    LYRUILocationMessage *shippingAddress = (LYRUILocationMessage *)[shippingAddressSerializer typedMessageWithMessagePart:shippingAddresPart];
    
    LYRMessagePart *billingAddresPart = [messagePart childPartWithRole:@"billing-address"];
    id<LYRUIMessageTypeSerializing> billingAddressSerializer = [self.layerConfiguration.injector serializerForMessagePartMIMEType:billingAddresPart.contentType];
    LYRUILocationMessage *billingAddress = (LYRUILocationMessage *)[billingAddressSerializer typedMessageWithMessagePart:billingAddresPart];
    
    NSMutableArray *products = [[NSMutableArray alloc] init];
    NSArray *productParts = [messagePart childPartsWithRole:@"product-items"];
    for (LYRMessagePart *productMessagePart in productParts) {
        id<LYRUIMessageTypeSerializing> productSerializer = [self.layerConfiguration.injector serializerForMessagePartMIMEType:productMessagePart.contentType];
        LYRUIMessageType *productMessage = [productSerializer typedMessageWithMessagePart:productMessagePart];
        if (productMessage != nil) {
            [products addObject:productMessage];
        }
    }

    return [[LYRUIReceiptMessage alloc] initWithCreatedAt:updatedAt
                                                 currency:messagePart.properties[@"currency"]
                                                discounts:discounts
                                                    order:order
                                            paymentMethod:messagePart.properties[@"payment_method"]
                                             orderSummary:summary
                                                    title:messagePart.properties[@"title"]
                                          shippingAddress:shippingAddress
                                           billingAddress:billingAddress
                                                 products:products
                                                   action:[self.actionSerializer actionFromProperties:messagePart.properties]
                                                   sender:messagePart.message.sender
                                                   sentAt:messagePart.message.sentAt
                                                   status:[self statusWithMessage:messagePart.message]];
}

- (nullable NSArray<LYRUIReceiptDiscount *> *)discountsFromArray:(NSArray *)array {
    if (array == nil || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray<LYRUIReceiptDiscount *> *discounts = [[NSMutableArray alloc] init];
    for (NSDictionary *discountDictionary in array) {
        LYRUIReceiptDiscount *discount = [[LYRUIReceiptDiscount alloc] initWithName:discountDictionary[@"name"]
                                                                             amount:[discountDictionary[@"amount"] doubleValue]];
        [discounts addObject:discount];
    }
    return [discounts copy];
}

- (nullable LYRUIReceiptOrder *)orderFromDictionary:(NSDictionary *)dictionary {
    if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return [[LYRUIReceiptOrder alloc] initWithNumber:dictionary[@"number"]
                                                 URL:[NSURL URLWithString:dictionary[@"url"]]];
}

- (nullable LYRUIReceiptSummary *)summaryFromDictionary:(NSDictionary *)dictionary {
    if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[LYRUIReceiptSummary alloc] initWithShippingCost:[dictionary[@"shipping_cost"] doubleValue]
                                                    subtotal:[dictionary[@"subtotal"] doubleValue]
                                                   totalCost:[dictionary[@"total_cost"] doubleValue]
                                                    totalTax:[dictionary[@"total_tax"] doubleValue]];
}

- (NSArray<NSURL *> *)imageURLsFromStrings:(NSArray<NSString *> *)imageURLStrings {
    if (imageURLStrings == nil || ![imageURLStrings isKindOfClass:[NSArray class]]) {
        return nil;
    }
    NSMutableArray *imageURLs = [[NSMutableArray alloc] init];
    for (NSString *imageURLString in imageURLStrings) {
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        if (imageURL != nil) {
            [imageURLs addObject:imageURL];
        }
    }
    return imageURLs;
}

- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUIProductMessage *)messageType
                                                    parentNodeId:(NSString *)parentNodeId
                                                            role:(NSString *)role
                                              MIMETypeAttributes:(NSDictionary *)MIMETypeAttributes {
    // TODO: implement
    return @[];
}

- (LYRMessageOptions *)messageOptionsForTypedMessage:(LYRUIMessageType *)messageType {
    LYRMessageOptions *messageOptions = [self defaultMessageOptionsWithPushNotificationText:@"sent you receipt message."];
    return messageOptions;
}

@end
