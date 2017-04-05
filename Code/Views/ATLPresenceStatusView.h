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
 @abstract Sets the color of the presence status fill or border. Default is [UIColor lightGray]
 */
@property (nonatomic) UIColor *color;

/**
 @abstract Sets the mode for the ATLMPresenceStatusView. Default is ATLMPresenceStatusViewModeFill
 */
@property (nonatomic) ATLMPresenceStatusViewMode mode;

/**
 @abstract Initialize with a color and mode
 */
-(instancetype)initWithFrame:(CGRect)rect Color:(UIColor *)color mode:(ATLMPresenceStatusViewMode)mode;

@end
