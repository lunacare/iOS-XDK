//
//  LYRUIFeedbackResponseMessagePresenter.m
//
//  Copyright © 2018 Layer, Inc. All rights reserved.
//

#import "LYRUIFeedbackResponseMessagePresenter.h"
#import "LYRUIFeedbackResponseMessage.h"
#import "LYRUIFeedbackMessage.h"
#import "LYRUIReusableViewsQueue.h"
#import "LYRUIImageCreating.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIFeedbackResponseMessageView.h"

NS_ASSUME_NONNULL_BEGIN     // {

static const CGFloat LYRUIFeedbackResponseMessagePresenterHeight = 56.0;
static const CGFloat LYRUIFeedbackResponseMessagePresenterMaximumWidth = 290.0;
static NSString *const LYRUIFeedbackResponseMessagePresenterHollowStarImageName = @"Hollow";
static NSString *const LYRUIFeedbackResponseMessagePresenterFilledStarImageName = @"Filled";

@interface LYRUIFeedbackResponseMessagePresenter()

@property (nonatomic, strong) id<LYRUIImageCreating> imageFactory;

@end

@implementation LYRUIFeedbackResponseMessagePresenter

- (void)setLayerConfiguration:(nullable LYRUIConfiguration *)layerConfiguration {
    [super setLayerConfiguration:layerConfiguration];
    self.imageFactory = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIImageCreating)
                                                                   forClass:[self class]];
}

- (CGFloat)viewHeightForMessage:(LYRUIFeedbackResponseMessage *)message minWidth:(CGFloat)minWidth maxWidth:(CGFloat)maxWidth {
    CGFloat result = [super viewHeightForMessage:message minWidth:minWidth maxWidth:maxWidth];
    if (0.0 >= result) {
        result += LYRUIFeedbackResponseMessagePresenterHeight;
    }
    return result;
}

- (UIView *)viewForMessage:(LYRUIFeedbackResponseMessage *)message {
    UIView *result = [super viewForMessage:message];
    if (nil == result) {
        LYRUIFeedbackResponseMessageView *view = [self.reusableViewsQueue dequeueReusableViewOfType:[LYRUIFeedbackResponseMessageView class]];
        if (view == nil) {
            view = [[LYRUIFeedbackResponseMessageView alloc] initWithConfiguration:self.layerConfiguration];
        }
        [self setupViewConstraints:view];
        NSUInteger rating = [[message rating] unsignedIntegerValue];
        view.ratingContainer.rating = rating;
        if ((nil == [message rating]) && [[(LYRUIFeedbackMessage *)message.parentMessage enabledFor] containsObject:[[[[[self layerConfiguration] client] authenticatedUser] identifier] absoluteString]]) {
            view.enabled = YES;
        } else {
            view.enabled = NO;
        }
        result = view;
    }
    return result;
}

- (void)setupViewConstraints:(UIView *)view {
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // **FIXME** `-[super setupViewConstraints:view]` nukes the constraints on the view, so all the
    // work to set up the internal constraints on the content view container get blown away.  For
    // right now, this just puts the one constraint in place which the super method does.
    NSLayoutConstraint *constraint = [[view widthAnchor] constraintGreaterThanOrEqualToConstant:LYRUIMessageItemViewMinimumContentWidth];
    [constraint setPriority:(UILayoutPriorityRequired - 1.0)];
    [constraint setActive:YES];

    [view.heightAnchor constraintEqualToConstant:LYRUIFeedbackResponseMessagePresenterHeight];
    [[[view widthAnchor] constraintLessThanOrEqualToConstant:LYRUIFeedbackResponseMessagePresenterMaximumWidth] setActive:YES];
    
    [view setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [view setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

@end

NS_ASSUME_NONNULL_END       // }
