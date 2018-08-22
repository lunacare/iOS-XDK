//
//  LYRUILargeFeedbackResponseMessageView.h
//  Pods
//
//  Created by Klemen Verdnik on 8/6/18.
//

#import "LYRUIFeedbackResponseMessageView.h"

@interface LYRUILargeFeedbackResponseMessageView : LYRUIFeedbackResponseMessageView <LYRUIViewReusing, LYRUIConfigurable>

@property (nonatomic, strong, readonly) UITextView *commentTextView;
@property (nonatomic, strong, readonly) UIButton *sendButton;
@property (nonatomic, assign, readwrite) NSUInteger rating;
@property (nonatomic, readwrite, nullable, copy) NSString *promptText;
@property (nonatomic, readwrite, nullable, copy) NSString *commentPlaceholderText;

@end
