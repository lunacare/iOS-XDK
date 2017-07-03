//
//  LUIPresenceView.m
//  Layer-UI-iOS
//
//  Created by Jeremy Wyld on 03.07.2017.
//  Copyright (c) 2017 Layer. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#if 0
#pragma mark Imports
#endif

#import "LYRUIPresenceView.h"
#import "ATLMessagingUtilities.h"

NS_ASSUME_NONNULL_BEGIN     // {


#if 0
#pragma mark -
#endif

static const CGFloat LYRUIPresenceViewStrokeWidth = 2.0;


#if 0
#pragma mark -
#endif

@interface LYRUIPresenceView ()

@property (nonatomic, copy, readonly) NSMutableDictionary<NSNumber *, UIColor *> *fillColors;
@property (nonatomic, copy, readonly) NSMutableDictionary<NSNumber *, UIColor *> *strokeColors;

@property (nonatomic, assign, readwrite) CGRect lastScale;
@property (nonatomic, copy, readonly) NSMutableDictionary<NSNumber *, UIBezierPath *> *bezierPaths;
@property (nonatomic, copy, readonly) NSMutableDictionary<NSNumber *, UIBezierPath *> *scaledBezierPaths;

- (void)lyr_CommonInit;

- (nullable UIBezierPath *)bezierPathForPresenceStatus:(LYRIdentityPresenceStatus)status;

- (void)setBezierPath:(nullable UIBezierPath *)path forPresenceStatus:(LYRIdentityPresenceStatus)status UI_APPEARANCE_SELECTOR;

@end


#if 0
#pragma mark -
#endif

@implementation LYRUIPresenceView

- (id)initWithFrame:(CGRect)frame {

    if ((self = [super initWithFrame:frame])) {
        [self lyr_CommonInit];
    }
    
    return self;
}

- (nullable id)initWithCoder:(NSCoder *)aDecoder {

    if ((self = [super initWithCoder:aDecoder])) {
        [self lyr_CommonInit];
    }
    
    return self;
}

- (void)lyr_CommonInit {
    
    _fillColors = [[NSMutableDictionary alloc] initWithCapacity:5];
    _strokeColors = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    _lastScale = CGRectNull;
    
    _bezierPaths = [[NSMutableDictionary alloc] initWithCapacity:5];
    _scaledBezierPaths = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setOpaque:NO];
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    LYRIdentityPresenceStatus status = [self presenceStatus];
    NSNumber *boxedStatus = @(status);

    NSMutableDictionary<NSNumber *, UIBezierPath *> *scaledBezierPaths = [self scaledBezierPaths];
    
    // Get the scaled path
    UIBezierPath *path = [scaledBezierPaths objectForKey:boxedStatus];
    
    // If a scaled path doesn't exist...
    if (nil != path) {
        
        // Get the regular path
        path = [self bezierPathForPresenceStatus:status];
        
        // Make last scale equal to bounds.
        CGRect bounds = [self bounds];
        [self setLastScale:bounds];

        // If no regular path, create a default with bounds.
        if (nil == path) {
            path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
                                                  radius:((CGRectGetWidth(bounds) / 2.0) - LYRUIPresenceViewStrokeWidth)
                                              startAngle:ATLDegreeToRadians(0.0)
                                                endAngle:ATLDegreeToRadians(360.0)
                                               clockwise:YES];
            [path setLineWidth:LYRUIPresenceViewStrokeWidth];
        }
        
        // Create scaled path and save it.
        else {
            path = [path copy];

            CGRect pathBounds = [path bounds];
            CGFloat scale = ((CGRectGetHeight(bounds) / CGRectGetWidth(bounds)) / (CGRectGetHeight(pathBounds) / CGRectGetWidth(pathBounds)));
            
            [path applyTransform:CGAffineTransformScale(CGAffineTransformIdentity, scale, scale)];
        }

        [scaledBezierPaths setObject:path forKey:boxedStatus];
    }
    
    // **FIXME** "Invisible" is supposed to be drawn using an inside stroke!
    
    // Get fill color.
    UIColor *color = [[self fillColors] objectForKey:boxedStatus];

    // If no fill color, get default fill color.
    if (nil == color) {
        switch (status) {
            case LYRIdentityPresenceStatusAvailable:
                color = [UIColor colorWithRed:(87.0/255.0) green:(191.0/255.0) blue:(70.0/255.0) alpha:1.0];
                break;
            case LYRIdentityPresenceStatusBusy:
                color = [UIColor colorWithRed:(234.0/255.0) green:(57.0/255.0) blue:(57.0/255.0) alpha:1.0];
                break;
            case LYRIdentityPresenceStatusAway:
                color = [UIColor colorWithRed:(255.0/255.0) green:(213.0/255.0) blue:(36.0/255.0) alpha:1.0];
                break;
            case LYRIdentityPresenceStatusInvisible:
                color = [UIColor clearColor];
                break;
            case LYRIdentityPresenceStatusOffline:
            default:
                color = [UIColor colorWithRed:(219.0/255.0) green:(222.0/255.0) blue:(228.0/255.0) alpha:1.0];
                break;
        }
    }
    
    // Fill path.
    [color set];
    [path fill];

    if (0.0 < [path lineWidth]) {
        
        // Get stroke color.
        color = [[self strokeColors] objectForKey:boxedStatus];
        
        // If no stroke color, get default stroke color.
        if (nil == color) {
            switch (status) {
                case LYRIdentityPresenceStatusInvisible:
                    color = [UIColor colorWithRed:(87.0/255.0) green:(191.0/255.0) blue:(70.0/255.0) alpha:1.0];
                    break;
                case LYRIdentityPresenceStatusOffline:
                case LYRIdentityPresenceStatusAvailable:
                case LYRIdentityPresenceStatusBusy:
                case LYRIdentityPresenceStatusAway:
                default:
                    color = [UIColor clearColor];
                    break;
            }
        }
        
        // Stroke path.
        [color set];
        [path stroke];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
   
    CGRect lastScale = [self lastScale];
    if (!CGRectIsNull(lastScale) && !CGRectEqualToRect(lastScale, [self bounds])) {
        [self setLastScale:CGRectNull];
        [[self scaledBezierPaths] removeAllObjects];
        [self setNeedsDisplay];
    }
}

- (nullable UIBezierPath *)bezierPathForPresenceStatus:(LYRIdentityPresenceStatus)status {
    return [[self scaledBezierPaths] objectForKey:@(status)];
}

- (void)setBezierPath:(nullable UIBezierPath *)path forPresenceStatus:(LYRIdentityPresenceStatus)status {
    
    NSNumber *boxedStatus = @(status);
    if (nil != path) {
        [[self bezierPaths] setObject:path forKey:boxedStatus];
    }
    else {
        [[self bezierPaths] removeObjectForKey:boxedStatus];
    }
    
    [[self scaledBezierPaths] removeObjectForKey:boxedStatus];
    
    [self setNeedsDisplay];
}

- (void)setPresenceStatus:(LYRIdentityPresenceStatus)presenceStatus {

    if (presenceStatus != [self presenceStatus]) {
    
        _presenceStatus = presenceStatus;
        
        [self setNeedsDisplay];
    }
}

- (nullable UIColor *)fillColorForPresenceStatus:(LYRIdentityPresenceStatus)status {
    return [[self fillColors] objectForKey:@(status)];
}

- (nullable UIColor *)strokeColorForPresenceStatus:(LYRIdentityPresenceStatus)status {
    return [[self strokeColors] objectForKey:@(status)];
}

- (void)setFillColor:(nullable UIColor *)color forPresenceStatus:(LYRIdentityPresenceStatus)status {
    
    if (nil != color) {
        [[self fillColors] setObject:color forKey:@(status)];
    }
    else {
        [[self fillColors] removeObjectForKey:@(status)];
    }
    
    [self setNeedsDisplay];
}

- (void)setStrokeColor:(nullable UIColor *)color forPresenceStatus:(LYRIdentityPresenceStatus)status {
    
    if (nil != color) {
        [[self strokeColors] setObject:color forKey:@(status)];
    }
    else {
        [[self strokeColors] removeObjectForKey:@(status)];
    }
    
    [self setNeedsDisplay];
}
    
@end

NS_ASSUME_NONNULL_END       // }
