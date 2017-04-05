//
//  ATLPresenceStatusView.m
//  Pods
//
//  Created by JP McGlone on 4/5/17.
//
//

#import "ATLPresenceStatusView.h"

@import CoreGraphics;
@implementation ATLPresenceStatusView

# pragma mark - Initialize

-(instancetype)initWithFrame:(CGRect)rect Color:(UIColor *)color mode:(ATLMPresenceStatusViewMode)mode
{
    self = [super initWithFrame:rect];
    if (self) {
        _color = color;
        _mode = mode;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _color = [UIColor lightGrayColor];
        _mode = ATLMPresenceStatusViewModeBordered;
    }
    return self;
}

# pragma mark - Setters

- (void)setMode:(ATLMPresenceStatusViewMode)mode
{
    _mode = mode;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self setNeedsDisplay];
}

# pragma mark - Drawing
// Draw a circle in the center of the view using the color and mode of this ATLPresenceStatusView
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    
    // We are drawing a circle to fit the bounds, so we need the smallest side
    CGFloat diameter = MIN(self.bounds.size.width, self.bounds.size.height);
    CGFloat radius = diameter * 0.5;
    
    CGContextSaveGState(context);
    
    switch (_mode) {
        case ATLMPresenceStatusViewModeFill:
            // Fill the circle
            CGContextSetFillColorWithColor(context, _color.CGColor);
            break;
        case ATLMPresenceStatusViewModeBordered:
            // Set width to 1/4 the circle width
            CGContextSetLineWidth(context, diameter * 0.25);
            CGContextSetStrokeColorWithColor(context, _color.CGColor);
            break;
    }
    
    CGContextAddArc(context, center.x, center.y, radius, 0.0, M_2_PI, YES);
    CGContextStrokePath(context);
}

@end
