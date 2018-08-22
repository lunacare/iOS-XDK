//
//  LYRUIFeedbackMessageView.h
//
//  Copyright © 2018 Layer, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYRUIMessageViewContainer.h"

NS_ASSUME_NONNULL_BEGIN     // {

@interface LYRUIFeedbackMessageContainerView : UIView <LYRUIMessageViewContainer>

@property (nonatomic, weak, readonly) UIView *contentViewContainer;

@end

NS_ASSUME_NONNULL_END       // }
