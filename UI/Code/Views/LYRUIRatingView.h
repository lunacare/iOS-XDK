//
//  LYRUIRatingView.h
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 8/2/18.
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
#import "LYRUIConfigurable.h"

NS_ASSUME_NONNULL_BEGIN     // {

@protocol LYRUIRatingViewDelegate;

extern NSUInteger const LYRUIRatingNotDefined;

/**
 @abstract An interactable view with star icons representing the rating.
 @discussion The view is structured so that it draws rating points by
   horizontally distributing them across the width of the view.
 @code This is an approximation of the default constraints:

.-----------------------------------------------------.
|                                                     |
|↤ [ point ]↔︎[ point ]↔︎[ point ]↔︎[ point ]↔︎[ point ] ↦|
|                                                     |
'-----------------------------------------------------'
 */
@interface LYRUIRatingView : UIControl <LYRUIConfigurable>

/**
 @abstract The number of rating points that the view should draw.
 */
@property (nonatomic, assign, readwrite) NSUInteger maximumRating; // default 5

/**
 @abstract The current rating that can either set by selecting (touching)
   a rating point, or programatically.
 */
@property (nonatomic, assign, readwrite) NSUInteger rating; // default 0, which means it wasn't submitted yet

/**
 @abstract The optional delegate that handles the rating selections.
 */
@property (nonatomic, weak, nullable) id<LYRUIRatingViewDelegate> delegate;

@end

/**
 @abstract The @c LYRUIRatingView delegate protocol that informs of the rating
   changes made by UI touches.
 */
@protocol LYRUIRatingViewDelegate <NSObject>

@required

/**
 @abstract The method that the sender invokes to inform the delegate whenever
   the rating changes due to a UI event.
 */
- (void)ratingView:(LYRUIRatingView *)ratingView didSelectRating:(NSUInteger)rating;

@end

NS_ASSUME_NONNULL_END       // }
