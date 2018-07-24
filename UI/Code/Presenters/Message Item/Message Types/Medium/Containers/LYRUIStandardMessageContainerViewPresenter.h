//
//  LYRUIStandardMessageContainerViewPresenter.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 12.10.2017.
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

#import <Foundation/Foundation.h>
#import "LYRUIConfigurable.h"
#import "LYRUIMessageItemContentContainerPresenting.h"
@class LYRUIStandardMessageContainerView;
@class LYRUIMessageItemContentPresentersProvider;
@class LYRUIMessageType;
@protocol LYRUIMessageViewContainer;
@protocol LYRUIStandardMessageContainerViewTheme;
@protocol LYRUIConfigurable;

@interface LYRUIStandardMessageContainerViewPresenter : NSObject <LYRUIMessageItemContentContainerPresenting, LYRUIConfigurable>

@property (nonatomic, strong) LYRUIStandardMessageContainerView *sizingContainerView;

/**
 @abstract Override this class method when subclassing the class in case
   the view requires a different layout or a different presented (view-model).
 @return Return the class of the view this presenter should vend.
 */
+ (Class<LYRUIMessageViewContainer, LYRUIStandardMessageContainerViewTheme, LYRUIConfigurable>)containerViewClass;

/**
 @abstract Sets up all the labels the main view content (metadata).
 @param view The view containing the content view and metadata view.
 @param message The message data the view should be populated with.
 */
- (void)setupStandardMessageContainerView:(LYRUIStandardMessageContainerView *)view withMessage:(LYRUIMessageType *)message;

@end
