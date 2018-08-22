//
//  LYRUILargeFeedbackResponseMessageView.m
//  Pods
//
//  Created by Klemen Verdnik on 8/6/18.
//

#import "LYRUILargeFeedbackResponseMessageView.h"

static const CGFloat LYRUILargeFeedbackResponseMessageViewIndividualCornerRadius = 4.0f;
static const CGFloat LYRUILargeFeedbackResponseMessageViewVerticalPadding = 40.0f;
static const CGFloat LYRUILargeFeedbackResponseMessageViewHorizontalGap = 12.0;

@interface LYRUILargeFeedbackResponseMessageView () <LYRUIRatingViewDelegate>

@property (nonatomic, readonly, strong) UILabel *promptLabel;
@property (nonatomic, readonly, strong) UILabel *placeholderLabel;

@end

@implementation LYRUILargeFeedbackResponseMessageView

- (void)setupSubviews {
    [super setupSubviews];
    [self.container removeConstraints:self.container.constraints];
    [self.container.heightAnchor constraintGreaterThanOrEqualToAnchor:self.heightAnchor multiplier:0].active = YES;
    [self.container.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:(-LYRUILargeFeedbackResponseMessageViewVerticalPadding * 2)].active = YES;
    [self.container.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    self.container.spacing = LYRUILargeFeedbackResponseMessageViewHorizontalGap;

    _promptLabel = [[UILabel alloc] init];
    _promptLabel.textAlignment = NSTextAlignmentCenter;
    _promptLabel.font = [UIFont systemFontOfSize:11.0];
    _promptLabel.textColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
    [self.container insertArrangedSubview:_promptLabel atIndex:0];

    self.ratingContainer.backgroundColor = UIColor.whiteColor;
    self.ratingContainer.layer.cornerRadius = LYRUILargeFeedbackResponseMessageViewIndividualCornerRadius;
    self.ratingContainer.delegate = self;

    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.textAlignment = NSTextAlignmentCenter;
    _placeholderLabel.font = [UIFont systemFontOfSize:11.0];
    _placeholderLabel.textColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
    [self.container addArrangedSubview:_placeholderLabel];

    _commentTextView = [[UITextView alloc] init];
    _commentTextView.text = @"test comment";
    _commentTextView.translatesAutoresizingMaskIntoConstraints = NO;
    _commentTextView.textContainerInset = UIEdgeInsetsMake(10, 8, 10, 8);
    _commentTextView.layer.cornerRadius = LYRUILargeFeedbackResponseMessageViewIndividualCornerRadius;
    [_commentTextView.heightAnchor constraintGreaterThanOrEqualToConstant:100].active = YES;
    [self.container addArrangedSubview:_commentTextView];

    _sendButton = [[UIButton alloc] init];
    _sendButton.layer.cornerRadius = LYRUILargeFeedbackResponseMessageViewIndividualCornerRadius;
    [_sendButton setBackgroundColor:UIColor.whiteColor];
    [self.sendButton setTitleColor:[UIColor colorWithRed:16.0/255.0 green:148.0/255.0 blue:208.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor colorWithRed:(163.0/255.0) green:(168.0/255.0) blue:(178.0/255.0) alpha:1.0] forState:UIControlStateDisabled];
    [_sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [self.container addArrangedSubview:_sendButton];

    self.commentPlaceholderText = @"";
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    self.ratingContainer.userInteractionEnabled = enabled;
    self.ratingContainer.backgroundColor = enabled ? UIColor.whiteColor : [UIColor colorWithWhite:0.0 alpha:0.1];
    self.commentTextView.editable = enabled;
    self.commentTextView.backgroundColor = enabled ? UIColor.whiteColor : [UIColor colorWithWhite:0.0 alpha:0.1];
    self.commentTextView.textColor = enabled ? UIColor.blackColor : [UIColor colorWithRed:(163.0/255.0) green:(168.0/255.0) blue:(178.0/255.0) alpha:1.0];
    self.sendButton.enabled = (self.ratingContainer.rating != LYRUIRatingNotDefined) && enabled;
    self.sendButton.backgroundColor = enabled ? UIColor.whiteColor : [UIColor colorWithWhite:0.0 alpha:0.1];
}

- (void)setPromptText:(NSString *)promptText {
    _promptText = promptText;
    _promptLabel.text = promptText;
}

- (void)setCommentPlaceholderText:(NSString *)commentPlaceholderText {
    _commentPlaceholderText = commentPlaceholderText;
    _placeholderLabel.text = commentPlaceholderText;
}

#pragma mark - LYRUIRatingViewDelegate Implementation

- (void)ratingView:(LYRUIRatingView *)ratingView didSelectRating:(NSUInteger)rating {
    self.sendButton.enabled = rating != LYRUIRatingNotDefined;
}

@end
