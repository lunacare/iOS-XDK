//
//  LYRUIRatingView.m
//  Pods
//
//  Created by Klemen Verdnik on 8/2/18.
//

#import "LYRUIRatingView.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIImageCreating.h"

NSUInteger const LYRUIRatingNotDefined = 0;
static const CGFloat LYRUIRatingViewStarHeight = 24.0;
static const CGFloat LYRUIRatingViewStarWidth = 24.0;
static const CGFloat LYRUIRatingViewStarGap = 12.0;
static const CGFloat LYRUIRatingViewContainerHorizontalGap = 12.0;
static const CGFloat LYRUIRatingViewContainerMinimumWidth = (LYRUIRatingViewStarWidth * 5);
static const CGFloat LYRUIRatingViewContainerMaximumWidth = (LYRUIRatingViewContainerMinimumWidth + (LYRUIRatingViewStarGap * 4));
static const NSUInteger LYRUIRatingViewDefaultMaximumRating = 5;
static NSString *const LYRUIRatingViewHollowStarImageName = @"Hollow";
static NSString *const LYRUIRatingViewFilledStarImageName = @"Filled";

@interface LYRUIRatingView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong, readonly) UIStackView *ratingContainer;
@property (nonatomic, readonly, strong) id<LYRUIImageCreating> imageFactory;
@property (nonatomic, readonly) UIImage *imageHollowRatingPoint;
@property (nonatomic, readonly) UIImage *imageFilledRatingPoint;
@property (nonatomic, readonly) UIPanGestureRecognizer *gestureRecognizer;

@end

@implementation LYRUIRatingView

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
    _gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    _gestureRecognizer.delegate = self;

    _ratingContainer = [[UIStackView alloc] init];
    _ratingContainer.userInteractionEnabled = YES;
    [_ratingContainer setAxis:(UILayoutConstraintAxisHorizontal)];
    [_ratingContainer setDistribution:(UIStackViewDistributionEqualSpacing)];
    [_ratingContainer setAlignment:(UIStackViewAlignmentCenter)];
    [_ratingContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_ratingContainer];

    [[[_ratingContainer heightAnchor] constraintEqualToAnchor:self.heightAnchor] setActive:YES];
    [[[_ratingContainer widthAnchor] constraintGreaterThanOrEqualToConstant:LYRUIRatingViewContainerMinimumWidth] setActive:YES];
    [[[_ratingContainer widthAnchor] constraintLessThanOrEqualToConstant:LYRUIRatingViewContainerMaximumWidth] setActive:YES];
    [[[_ratingContainer centerYAnchor] constraintEqualToAnchor:[self centerYAnchor]] setActive:YES];
    [[[_ratingContainer centerXAnchor] constraintEqualToAnchor:[self centerXAnchor]] setActive:YES];
    [[[_ratingContainer leftAnchor] constraintGreaterThanOrEqualToAnchor:[self leftAnchor]
                                                         constant:LYRUIRatingViewContainerHorizontalGap] setActive:YES];
    [[[_ratingContainer rightAnchor] constraintGreaterThanOrEqualToAnchor:[self rightAnchor]
                                                          constant:LYRUIRatingViewContainerHorizontalGap] setActive:YES];
    [_ratingContainer addGestureRecognizer:self.gestureRecognizer];

    self.maximumRating = LYRUIRatingViewDefaultMaximumRating;
    _rating = LYRUIRatingNotDefined;
}

- (void)setMaximumRating:(NSUInteger)maximumRating {
    _maximumRating = MAX(maximumRating, 1);
    for (UIImageView *existingRatingPointView in self.ratingContainer.arrangedSubviews.copy) {
        [self.ratingContainer removeArrangedSubview:existingRatingPointView];
    }
    for (size_t i = 0; i < self.maximumRating; i++) {
        UIImageView *iv = [[UIImageView alloc] init];
        iv.userInteractionEnabled = YES;
        // Encoding the index of the star, so that we don't have to lookup
        // the view's location in an array, while performing a hit test.
        iv.tag = i + 1;
        [iv setContentMode:(UIViewContentModeScaleAspectFit)];
        [self.ratingContainer addArrangedSubview:iv];
        [[[iv heightAnchor] constraintEqualToConstant:LYRUIRatingViewStarHeight] setActive:YES];
        [[[iv widthAnchor] constraintEqualToConstant:LYRUIRatingViewStarWidth] setActive:YES];
    }
}

- (void)setRating:(NSUInteger)rating {
    _rating = MIN(self.maximumRating, rating);
    [self.ratingContainer.arrangedSubviews.copy enumerateObjectsUsingBlock:^(UIImageView *ratingPointImageView, NSUInteger idx, BOOL * _Nonnull stop) {
        [ratingPointImageView setImage:idx >= rating ? self.imageHollowRatingPoint : self.imageFilledRatingPoint];
    }];
}

- (void)tintColorDidChange {
    [self.ratingContainer.arrangedSubviews.copy enumerateObjectsUsingBlock:^(UIImageView *ratingPointImageView, NSUInteger idx, BOOL * _Nonnull stop) {
        ratingPointImageView.tintColor = self.tintColor;
    }];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    self.tintColor = enabled ? [UIColor colorWithRed:16.0/255.0 green:148.0/255.0 blue:208.0/255.0 alpha:1.0] : [UIColor colorWithRed:(163.0/255.0) green:(168.0/255.0) blue:(178.0/255.0) alpha:1.0];
}

#pragma mark - Gesture Recognition

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint touchLocation = [gestureRecognizer locationInView:self];
    [self hitTestAtPoint:touchLocation];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint touchLocation = [touch locationInView:self];
    [self hitTestAtPoint:touchLocation];
    return YES;
}

- (void)hitTestAtPoint:(CGPoint)point {
    UIView *view = [self hitTest:point withEvent:nil];
    NSUInteger newRating = LYRUIRatingNotDefined;
    if ([view isKindOfClass:UIImageView.class]) {
        // Grab the tag value we've encoded into the view, when we created
        // the image views for each individual star.
        newRating = view.tag;
    } else {
        // In case the point hit a gap beteween the stars, figure out
        // the location based on the percentage of the width of the view.
        float x = point.x - self.ratingContainer.frame.origin.x;
        float percentage = MAX(1, x) / MAX(1, self.ratingContainer.frame.size.width);
        newRating = (NSUInteger)((float)(self.maximumRating - 1) * percentage) + 1;
    }
    if (self.rating == newRating) {
        return;
    }
    // Rating changed due to the UI event.
    self.rating = newRating;
    if ([self.delegate respondsToSelector:@selector(ratingView:didSelectRating:)]) {
        [self.delegate ratingView:self didSelectRating:self.rating];
    }
}

#pragma mark - LYRUIConfigurable Implementation

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    _imageFactory = [self.layerConfiguration.injector protocolImplementation:@protocol(LYRUIImageCreating) forClass:[self class]];
    _imageHollowRatingPoint = [[self.imageFactory imageNamed:LYRUIRatingViewHollowStarImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _imageFilledRatingPoint = [[self.imageFactory imageNamed:LYRUIRatingViewFilledStarImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

@end
