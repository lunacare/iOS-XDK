//
//  LYRUIStandardMessageContainerViewLayout.h
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

#import "LYRUIStandardMessageContainerView.h"

@interface LYRUIStandardMessageContainerViewLayout : NSObject <LYRUIStandardMessageContainerViewLayout>

/**
 @abstract Generates content view constraints and returns then in a form
   of an @c NSArray.
 @param view The parent view that includes the child view the constraints are
   generated for.
 @return The array containing the content view's constraints.
 */
- (NSArray<NSLayoutConstraint *> *)contentViewConstraintsForView:(LYRUIStandardMessageContainerView *)view;

/**
 @abstract Generates metadata container view constraints and returns then in a
   form of an @c NSArray.
 @param view The parent view that includes the child view the constraints are
   generated for.
 @return The array containing the metadata container view's constraints.
 */
- (NSArray<NSLayoutConstraint *> *)metadataContainerConstraintsForView:(LYRUIStandardMessageContainerView *)view;

/**
 @abstract Generates disclosure button constraints and returns then in a form
   of an @c NSArray.
 @param view The parent view that includes the child view the constraints are
   generated for.
 @return The array containing the child view's constraints.
 */
- (NSArray<NSLayoutConstraint *> *)additionalConstraintsForView:(LYRUIStandardMessageContainerView *)view;

@end
