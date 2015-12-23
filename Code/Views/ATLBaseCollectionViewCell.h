//
//  ATLBaseCollectionViewCell.h
//  Pods
//
//  Created by Kevin Coleman on 12/22/15.
//
//

#import <UIKit/UIKit.h>
#import "ATLMessageBubbleView.h"
#import "ATLAvatarImageView.h"
#import "ATLmessagePresenting.h"

@import LayerKit;

typedef NS_ENUM(NSInteger, ATLCellType) {
    ATLOutgoingCellType,
    ATLIncomingCellType,
};

extern CGFloat const ATLMessageCellHorizontalMargin;
extern CGFloat const ATLAvatarImageLeadPadding;
extern CGFloat const ATLAvatarImageTailPadding;

@interface ATLBaseCollectionViewCell : UICollectionViewCell <ATLMessagePresenting>

@property (nonatomic) NSLayoutConstraint *bubbleWithAvatarLeadConstraint;
@property (nonatomic) NSLayoutConstraint *bubbleWithoutAvatarLeadConstraint;
@property (nonatomic) NSLayoutConstraint *bubbleViewWidthConstraint;

/**
 @abstract The background color for the bubble view displayed in the cell. Default is light gray.
 */
@property (nonatomic) UIColor *bubbleViewColor UI_APPEARANCE_SELECTOR;

/**
 @abstract The corner radius of the bubble view displayed in the cell. Default is 16.
 */
@property (nonatomic) CGFloat bubbleViewCornerRadius UI_APPEARANCE_SELECTOR;

/**
 @abstract The view that handles displaying the cell content.
 */
@property (nonatomic) ATLMessageBubbleView *bubbleView;

/**
 @abstract The optional avatar image view representing a user.
 */
@property (nonatomic) ATLAvatarImageView *avatarImageView;

/**
 @abstract The `LYRMessage` object passed in `ATLMessagePresenting` protocol `presentMessage:`.
 */
@property (nonatomic) LYRMessage *message;

- (void)updateBubbleWidth:(CGFloat)bubbleWidth;

- (void)configureCellForType:(ATLCellType)cellType;

@end
