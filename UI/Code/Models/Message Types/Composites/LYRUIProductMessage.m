//
//  LYRUIProductMessage.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 21.12.2017.
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

#import "LYRUIProductMessage.h"
#import "LYRUIChoiceMessage.h"

@interface LYRUIProductMessage ()

@property (nonatomic, readwrite) NSString *brand;
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSString *productDescription;
@property (nonatomic, readwrite) NSArray<NSURL *> *imageURLs;
@property (nonatomic, readwrite) NSNumber *price;
@property (nonatomic, readwrite) NSUInteger quantity;
@property (nonatomic, readwrite) NSString *currency;
@property (nonatomic, readwrite) NSArray<LYRUIChoiceMessage *> *options;

@end

@implementation LYRUIProductMessage

- (instancetype)initWithBrand:(NSString *)brand
                         name:(NSString *)name
           productDescription:(NSString *)productDescription
                    imageURLs:(NSArray<NSURL *> *)imageURLs
                        price:(NSNumber *)price
                     quantity:(NSUInteger)quantity
                     currency:(NSString *)currency
                      options:(NSArray<LYRUIChoiceMessage *> *)options
                       action:(LYRUIMessageAction *)action
                       sender:(LYRIdentity *)sender
                       sentAt:(NSDate *)sentAt
                       status:(LYRUIMessageTypeStatus *)status {
    self = [super initWithAction:action
                          sender:sender
                          sentAt:sentAt
                          status:status];
    if (self) {
        self.brand = brand;
        self.name = name;
        self.productDescription = productDescription;
        self.imageURLs = imageURLs;
        self.price = price;
        self.quantity = quantity;
        self.currency = currency;
        self.options = options;
    }
    return self;
}

+ (NSString *)MIMEType {
    return @"application/vnd.layer.product+json";
}

- (NSString *)summary {
    return @"Product";
}

@end
