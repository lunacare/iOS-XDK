//
//  LYRUIFeedbackMessagePresenter.m
//
//  Copyright © 2018 Layer, Inc. All rights reserved.
//

#import "LYRUIFeedbackMessagePresenter.h"
#import "LYRUIFeedbackMessage.h"
#import "LYRUIFeedbackMessageContainerView.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIImageCreating.h"
#import "LYRUITitledMessageContainerViewPresenter.h"
#import "LYRUIMessageItemContentPresentersProvider.h"

NS_ASSUME_NONNULL_BEGIN     // {

@interface LYRUIFeedbackMessagePresenter ()

@property (nonatomic, strong, readwrite, nullable) LYRUITitledMessageContainerViewPresenter *titlePresenter;

@end

@implementation LYRUIFeedbackMessagePresenter

- (void)setLayerConfiguration:(nullable LYRUIConfiguration *)layerConfiguration {
    [super setLayerConfiguration:layerConfiguration];
    
    id<LYRUIImageCreating> imageFactory = [layerConfiguration.injector protocolImplementation:@protocol(LYRUIImageCreating)
                                                                                     forClass:[self class]];
    UIImage *icon = [[imageFactory imageNamed:@"FeedbackTitle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    LYRUITitledMessageContainerViewPresenter *titlePresenter = [layerConfiguration.injector objectOfType:[LYRUITitledMessageContainerViewPresenter class]];
    [[titlePresenter presentersProvider] setLayerConfiguration:layerConfiguration];
    [titlePresenter setIconImage:icon];
    titlePresenter.actionHandlingDelegate = self.actionHandlingDelegate;
    [self setTitlePresenter:titlePresenter];
}

- (void)setPresentersProvider:(LYRUIMessageItemContentPresentersProvider *)presentersProvider {
    
    [super setPresentersProvider:presentersProvider];
    
    // If this is being overridden, it needs to be pumped into the title presenter as well otherwise
    // it will miss out on having the presenters provider.
    [[self titlePresenter] setPresentersProvider:presentersProvider];
}

- (CGFloat)viewHeightForMessage:(LYRUIFeedbackMessage *)message minWidth:(CGFloat)minWidth maxWidth:(CGFloat)maxWidth {
    
    CGFloat result = [super viewHeightForMessage:message minWidth:minWidth maxWidth:maxWidth];
    
    if (0.0 >= result) {
        result += [[self titlePresenter] viewHeightForMessage:[message response] minWidth:minWidth maxWidth:maxWidth];
    }
    
    return result;
    }

- (UIView *)viewForMessage:(LYRUIFeedbackMessage *)message {

    UIView *result = [super viewForMessage:message];
    
    if (nil == result) {

        LYRUIFeedbackMessageContainerView *view = [[LYRUIFeedbackMessageContainerView alloc] init];
        LYRUITitledMessageContainerViewPresenter *presenter = [self titlePresenter];
        presenter.actionHandlingDelegate = self.actionHandlingDelegate;
        UIView *titled = [presenter viewForMessage:[message response]];
        [view setContentView:titled];
        
        UIView *cv = [view contentView];
        [titled setTintColor:[UIColor colorWithRed:(163.0/255.0) green:(168.0/255.0) blue:(178.0/255.0) alpha:1.0]];
        
        // **FIXME** These colors should be coming from a theme in the configuration
        if ((nil == [[message response] rating]) && [[message enabledFor] containsObject:[[[[[self layerConfiguration] client] authenticatedUser] identifier] absoluteString]])
        {
            [cv setTintColor:[UIColor colorWithRed:16.0/255.0 green:148.0/255.0 blue:208.0/255.0 alpha:1.0]];
        }
        else {
            [cv setTintColor:[UIColor colorWithRed:(163.0/255.0) green:(168.0/255.0) blue:(178.0/255.0) alpha:1.0]];
        }
        cv.backgroundColor = [self contentViewBackgroundColorForMessage:message];
        [self setupViewConstraints:view];
        result = view;
    }
    
    return result;
}

- (UIColor *)contentViewBackgroundColorForMessage:(LYRUIFeedbackMessage *)message {
    if ((nil == [[message response] rating]) && [[message enabledFor] containsObject:[[[[[self layerConfiguration] client] authenticatedUser] identifier] absoluteString]]) {
        return UIColor.whiteColor;
    } else {
        return UIColor.clearColor;
    }
}

- (void)setupViewConstraints:(UIView *)view {
    
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // **FIXME** `-[super setupViewConstraints:view]` nukes the constraints on the view, so all the
    // work to set up the internal constraints on the content view container get blown away.  For
    // right now, this just puts the one constraint in place which the super method does.
    [view.widthAnchor constraintGreaterThanOrEqualToConstant:LYRUIMessageItemViewMinimumContentWidth].active = YES;
    
    [view setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [view setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [view setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [view setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
}

@end

NS_ASSUME_NONNULL_END       // }
