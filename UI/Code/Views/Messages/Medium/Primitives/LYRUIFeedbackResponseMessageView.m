//
//  LYRMFeedbackResponseMessageView.m
//  Pods
//
//  Created by Klemen Verdnik on 7/26/18.
//

#import "LYRUIFeedbackResponseMessageView.h"
#import "LYRUIConfiguration+DependencyInjection.h"

static const CGFloat LYRUIFeedbackResponseMessageViewRatingContainerHeight = 48.f;
static const CGFloat LYRUIFeedbackResponseMessageViewHorizontalGap = 12.0;

@interface LYRUIFeedbackResponseMessageView ()

@end

@implementation LYRUIFeedbackResponseMessageView

@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self lyr_commonInitWithCoder:nil frame:CGRectZero];
        self.layerConfiguration = configuration;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self lyr_commonInitWithCoder:nil frame:frame];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self lyr_commonInitWithCoder:aDecoder frame:CGRectZero];
    }
    return self;
}

- (void)lyr_commonInitWithCoder:(NSCoder *)coder frame:(CGRect)frame {
    [self setTintColor:[UIColor colorWithRed:16.0/255.0 green:148.0/255.0 blue:208.0/255.0 alpha:1.0]];
    UIStackView *container = [[UIStackView alloc] init];
    [container setAxis:UILayoutConstraintAxisVertical];
    [container setDistribution:UIStackViewDistributionFill];
    [container setAlignment:UIStackViewAlignmentFill];
    [container setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [container setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [container setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:container];
    _container = container;

    [container.heightAnchor constraintGreaterThanOrEqualToAnchor:self.heightAnchor multiplier:0].active = YES;
    [container.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:0].active = YES;
    [container.topAnchor constraintEqualToAnchor:self.topAnchor constant:LYRUIFeedbackResponseMessageViewHorizontalGap].active = YES;
    [container.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-LYRUIFeedbackResponseMessageViewHorizontalGap].active = YES;
    [container.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;

    [self setupSubviews];
}

- (void)setupSubviews {
    _ratingContainer = [[LYRUIRatingView alloc] initWithConfiguration:self.layerConfiguration];
    _ratingContainer.enabled = NO;
    [_ratingContainer.heightAnchor constraintEqualToConstant:LYRUIFeedbackResponseMessageViewRatingContainerHeight].active = YES;
    [self.container addArrangedSubview:_ratingContainer];
}

- (void)lyr_prepareForReuse {
    // No-op
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    self.ratingContainer.enabled = enabled;
    self.ratingContainer.userInteractionEnabled = NO;
}

#pragma mark - LYRUIConfigurable Implementation

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    _ratingContainer.layerConfiguration = layerConfiguration;
}

@end
