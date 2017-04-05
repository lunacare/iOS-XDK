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
    self = [self initWithFrame:rect];
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
        _mode = ATLMPresenceStatusViewModeFill;
        
        self.backgroundColor = [UIColor clearColor];
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
        {
            // Fill the circle
            CGContextSetFillColorWithColor(context, _color.CGColor);
            CGContextAddArc(context, center.x, center.y, radius, 0.0, M_PI*2, YES);
            CGContextFillPath(context);
            break;
        }
        case ATLMPresenceStatusViewModeBordered:
        {
            // Set width to 1/6 the circle width
            CGFloat borderWidth = diameter * 0.166;
            
            // Inset the radius
            CGContextAddArc(context, center.x, center.y, radius - borderWidth, 0.0, M_PI*2, YES);

            CGContextSetLineWidth(context, borderWidth);
            CGContextSetStrokeColorWithColor(context, _color.CGColor);
            CGContextStrokePath(context);
            break;
        }
    }
    
}

@end
