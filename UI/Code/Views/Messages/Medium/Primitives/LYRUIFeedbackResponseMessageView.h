//
//  LYRMFeedbackResponseMessageView.h
//  Pods
//
//  Created by Klemen Verdnik on 7/26/18.
//

#import <UIKit/UIKit.h>
#import "LYRUIViewReusing.h"
#import "LYRUIConfigurable.h"
#import "LYRUIRatingView.h"

NS_ASSUME_NONNULL_BEGIN     // {

@interface LYRUIFeedbackResponseMessageView : UIView <LYRUIViewReusing, LYRUIConfigurable>

@property (nonatomic, strong, readonly) UIStackView *container;
@property (nonatomic, strong, readonly) LYRUIRatingView *ratingContainer;
@property (nonatomic, assign, readwrite, getter=isEnabled) BOOL enabled;

- (void)setupSubviews;

@end

NS_ASSUME_NONNULL_END       // }
