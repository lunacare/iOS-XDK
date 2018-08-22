//
//  LYRUIFeedbackMessageView.m
//
//  Copyright © 2018 Layer, Inc. All rights reserved.
//

#import "LYRUIFeedbackMessageContainerView.h"

NS_ASSUME_NONNULL_BEGIN     // {

@implementation LYRUIFeedbackMessageContainerView

@synthesize contentView=_contentView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (void)lyr_commonInit {
    
    UIView *contentViewContainer = [[UIView alloc] init];

    [contentViewContainer setTranslatesAutoresizingMaskIntoConstraints:NO];

    [contentViewContainer setClipsToBounds:YES];
    [self addSubview:contentViewContainer];
    
    _contentViewContainer = contentViewContainer;
    
    [[[contentViewContainer leftAnchor] constraintEqualToAnchor:[self leftAnchor]] setActive:YES];
    [[[contentViewContainer rightAnchor] constraintEqualToAnchor:[self rightAnchor]] setActive:YES];
    [[[contentViewContainer topAnchor] constraintEqualToAnchor:[self topAnchor]] setActive:YES];
    [[[contentViewContainer bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]] setActive:YES];
}

- (void)setContentView:(UIView *)contentView {
    
    UIView *existing = [self contentView];
    if (existing != contentView) {
        
        [existing removeFromSuperview];
        
        _contentView = contentView;
        
        if (nil != contentView) {
            
            UIView *container = [self contentViewContainer];
            [container addSubview:contentView];
            
            [[[contentView leftAnchor] constraintEqualToAnchor:[container leftAnchor]] setActive:YES];
            [[[contentView rightAnchor] constraintEqualToAnchor:[container rightAnchor]] setActive:YES];
            [[[contentView topAnchor] constraintEqualToAnchor:[container topAnchor]] setActive:YES];
            [[[contentView bottomAnchor] constraintEqualToAnchor:[container bottomAnchor]] setActive:YES];
        }
        
        [self setNeedsUpdateConstraints];
    }
}

@end

NS_ASSUME_NONNULL_END       // }
