//
//  LYRUIShapedViewDefaultShapeDrawer.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 18.07.2017.
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

#import "LYRUIShapedViewDefaultShapeDrawer.h"
#import "ATLMessagingUtilities.h"

static CGFloat const LYRUIShapedViewDefaultShapeOutsideStrokeWidth = 2.0;
static CGFloat const LYRUIShapedViewDefaultShapeStrokeWidth = 4.0;

@interface LYRUIShapedViewDefaultShapeDrawer ()

@property (nonatomic) CGSize storedPathSize;
@property (nonatomic, strong) UIBezierPath *storedPath;

@end

@implementation LYRUIShapedViewDefaultShapeDrawer

- (void)drawInRect:(CGRect)rect
     withFillColor:(UIColor *)fillColor
 insideStrokeColor:(UIColor *)insideStrokeColor
outsideStrokeColor:(UIColor *)outsideStrokeColor {
    UIBezierPath *path = [self bezierPathForSize:rect.size];
    [self drawWithBezierPath:path
               withFillColor:fillColor
           insideStrokeColor:insideStrokeColor
          outsideStrokeColor:outsideStrokeColor];
}

- (void)drawWithBezierPath:(UIBezierPath *)path
             withFillColor:(UIColor *)fillColor
         insideStrokeColor:(UIColor *)insideStrokeColor
        outsideStrokeColor:(UIColor *)outsideStrokeColor {
    if (path.lineWidth > 0.0 && outsideStrokeColor && outsideStrokeColor != [UIColor clearColor]) {
        [outsideStrokeColor setStroke];
        [path stroke];
    }
    
    if (fillColor && fillColor != [UIColor clearColor]) {
        [fillColor setFill];
        [path fill];
    }
    
    if (path.lineWidth > 0.0 && insideStrokeColor && insideStrokeColor != [UIColor clearColor]) {
        [insideStrokeColor setStroke];
        [path addClip];
        [path stroke];
    }
}

- (UIBezierPath *)bezierPathForSize:(CGSize)size {
    if (self.storedPath && CGSizeEqualToSize(self.storedPathSize, size)) {
        return self.storedPath;
    }

    CGPoint arcCenter = CGPointMake(size.width / 2.0, size.height / 2.0);
    CGFloat shorterSide = MIN(size.width, size.height);
    CGFloat radius = round((shorterSide - (2.0 * LYRUIShapedViewDefaultShapeOutsideStrokeWidth)) / 2.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                        radius:radius
                                                    startAngle:ATLDegreeToRadians(0.0)
                                                      endAngle:ATLDegreeToRadians(360.0)
                                                     clockwise:YES];
    path.lineWidth = LYRUIShapedViewDefaultShapeStrokeWidth;
    self.storedPath = path;
    self.storedPathSize = size;
    return path;
};

@end
