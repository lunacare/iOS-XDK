//
//  LYRUIMessageViewController.h
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 6/12/18.
//  Copyright (c) 2018 Layer. All rights reserved.
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
#import "LYRUIMessageType.h"
#import "LYRUIConfigurable.h"

NS_ASSUME_NONNULL_BEGIN     // {

/**
 @abstract A full screen view controller capable of presenting large
   message variants.
 */
@interface LYRUIMessageViewController : UIViewController <LYRUIConfigurable>

/**
 @abstract The native (LayerKit) message part identifier, contating the
   message data which will be deserialized and presented in full screen.
 */
@property (nonatomic, strong, readwrite) NSURL *messagePartID;

/**
 @abstract The default initializer.
 */
- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration;

+ (nullable instancetype)new NS_UNAVAILABLE;
- (nullable instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END       // }
