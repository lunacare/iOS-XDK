//
//  LYRUIShapedViewDefaultShapeDrawer.h
//  Layer-XDK-UI-iOS
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

#import <UIKit/UIKit.h>
#import "LYRUIShapedView.h"

/**
 @abstract The `LYRUIShapedViewDefaultShapeDrawer` class is responsible for drawing a default circle shape on the `LYRUIShapedView`.
 */
@interface LYRUIShapedViewDefaultShapeDrawer : NSObject <LYRUIShapedViewShapeDrawing>

/**
 @abstract Draws a bezier path in current context, with given `fillColor`, `insideStrokeColor`, and `outsideStrokeColor`.
 @param path A `UIBezierPath` to draw in current context.
 @param fillColor The fill color of the rendered shape.
 @param insideStrokeColor The inside stroke color of the rendered shape.
 @param outsideStrokeColor The outside stroke color of the rendered shape.
 */
- (void)drawBezierPath:(UIBezierPath *)path
         withFillColor:(UIColor *)fillColor
     insideStrokeColor:(UIColor *)insideStrokeColor
    outsideStrokeColor:(UIColor *)outsideStrokeColor;

/**
 @abstract Provides an `UIBezierPath` that fits in given `size`, to be drawn in `LYRUIShapedView`.
 @param size The size to fit the bezier path in.
 @returns An `UIBezierPath` to draw in the `LYRUIShapedView`.
 */
- (UIBezierPath *)bezierPathForSize:(CGSize)size;

@end
