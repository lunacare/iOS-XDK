//
//  LYRUIFeedbackResponseMessagePresenter.h
//
//  Copyright © 2018 Layer, Inc. All rights reserved.
//

#import "LYRUIMessageItemContentBasePresenter.h"

NS_ASSUME_NONNULL_BEGIN     // {

@interface LYRUIFeedbackResponseMessagePresenter : LYRUIMessageItemContentBasePresenter

@property (nonatomic, strong, readwrite) UIImage *imageRatingHollow;

@property (nonatomic, strong, readwrite) UIImage *imageRatingFilled;

@end

NS_ASSUME_NONNULL_END       // }
