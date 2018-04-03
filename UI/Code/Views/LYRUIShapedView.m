//
//  LYRUIShapedView.m
//  Layer-XDK-UI-iOS
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

#import "LYRUIShapedView.h"
#import "LYRUIShapedViewDefaultShapeDrawer.h"

NS_ASSUME_NONNULL_BEGIN     // {
@implementation LYRUIShapedView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self lyr_CommonInit];
    }
    return self;
}

- (nullable id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self lyr_CommonInit];
    }
    return self;
}

- (void)lyr_CommonInit {
    [self setDefaultColors];
    self.opaque = NO;
    self.shapeDrawer = [[LYRUIShapedViewDefaultShapeDrawer alloc] init];
}

- (void)setDefaultColors {
    self.backgroundColor = [UIColor clearColor];
    self.fillColor = [UIColor colorWithRed:(87.0/255.0) green:(191.0/255.0) blue:(70.0/255.0) alpha:1.0];
    self.insideStrokeColor = [UIColor clearColor];
    self.outsideStrokeColor = [UIColor clearColor];
}

#pragma mark - Layout and drawing

- (void)setBounds:(CGRect)bounds {
    if (!CGRectEqualToRect(bounds, self.bounds)) {
        [self setNeedsDisplay];
    }
    [super setBounds:bounds];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self.shapeDrawer drawInRect:rect
                   withFillColor:self.fillColor
               insideStrokeColor:self.insideStrokeColor
              outsideStrokeColor:self.outsideStrokeColor];
}

#pragma mark - Properties

- (void)setShapeDrawer:(id<LYRUIShapedViewShapeDrawing>)shapeDrawer {
    _shapeDrawer = shapeDrawer;
    [self setNeedsDisplay];
}

#pragma mark - Colors

- (void)setFillColor:(UIColor *)fillColor {
    if (![fillColor isEqual:self.fillColor]) {
        _fillColor = fillColor;
        [self setNeedsDisplay];
    }
}

- (void)setInsideStrokeColor:(UIColor *)insideStrokeColor {
    if (![insideStrokeColor isEqual:self.insideStrokeColor]) {
        _insideStrokeColor = insideStrokeColor;
        [self setNeedsDisplay];
    }
}

- (void)setOutsideStrokeColor:(UIColor *)outsideStrokeColor {
    if (![outsideStrokeColor isEqual:self.outsideStrokeColor]) {
        _outsideStrokeColor = outsideStrokeColor;
        [self setNeedsDisplay];
    }
}

- (void)updateWithFillColor:(UIColor *)fillColor
          insideStrokeColor:(UIColor *)insideStrokeColor
         outsideStrokeColor:(UIColor *)outsideStrokeColor {
    BOOL needsDisplay = (![fillColor isEqual:self.fillColor] ||
                         ![insideStrokeColor isEqual:self.insideStrokeColor] ||
                         ![outsideStrokeColor isEqual:self.outsideStrokeColor]);
    _fillColor = fillColor;
    _insideStrokeColor = insideStrokeColor;
    _outsideStrokeColor = outsideStrokeColor;
    if (needsDisplay) {
        [self setNeedsDisplay];
    }
}

#pragma mark - Bezier path

@end
NS_ASSUME_NONNULL_END       // }
