//
//  ATLPresenceStatusView.h
//  Pods
//
//  Created by JP McGlone on 4/5/17.
//
//

@import UIKit;

typedef NS_ENUM(NSInteger, ATLMPresenceStatusViewMode) {
    ATLMPresenceStatusViewModeFill,
    ATLMPresenceStatusViewModeBordered
};

@interface ATLPresenceStatusView : UIView

/**
 @abstract Sets the color of the presence status fill or border. Default is [UIColor lightGrayColor]
 */
@property (nonatomic) UIColor *statusColor;

/**
 @abstract Sets the color of the presence status background color. Default is [UIColor whiteColor]
 */
@property (nonatomic) UIColor *statusBackgroundColor;

/**
 @abstract Sets the mode for the ATLMPresenceStatusView. Default is ATLMPresenceStatusViewModeFill
 */
@property (nonatomic) ATLMPresenceStatusViewMode mode;

/**
 @abstract Initialize with a color and mode
 */
-(instancetype)initWithFrame:(CGRect)rect statusColor:(UIColor *)statusColor mode:(ATLMPresenceStatusViewMode)mode;

@end
