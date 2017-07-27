//
//  LYRUIPresenceView.h
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

#import <UIKit/UIKit.h>
#import <LayerKit/LayerKit.h>

NS_ASSUME_NONNULL_BEGIN     // {
/**
 @abstract Objects conforming to the `LYRUIPresenceViewShapeProviding` protocol will be used to provide an `UIBezierPath` shapes to the `LYRUIPresenceView`.
 */
@protocol LYRUIPresenceViewShapeProviding <NSObject>

/**
 @abstract Returns an `UIBezierPath` shape for a given `size` which will be rendered by the `LYRUIPresenceView`.
 @param size The size to fit the shape in.
 @return Returns an `UIBezierPath` instance with the shape for `LYRUIPresenceView`.
 */
- (UIBezierPath *)shapeWithSize:(CGSize)size;

@end

IB_DESIGNABLE
/**
 @abstract The `LYRUIPresenceView` displays a colored shape representing the status of Identity's presence.
 */
@interface LYRUIPresenceView : UIView

/**
 @abstract The fill color of the rendered shape. Default is green color.
 */
@property (nonatomic, copy) IBInspectable UIColor *fillColor;

/**
 @abstract The inside stroke color of the rendered shape. Default is clear color.
 */
@property (nonatomic, copy) IBInspectable UIColor *insideStrokeColor;

/**
 @abstract The outside stroke color of the rendered shape. Default is clear color.
 */
@property (nonatomic, copy) IBInspectable UIColor *outsideStrokeColor;

/**
 @abstract Provides the shape of the presence view. Default is an `LYRUIPresenceViewDefaultShapeProvider` instance.
 */
@property (nonatomic, strong) IBOutlet id<LYRUIPresenceViewShapeProviding> shapeProvider;

/**
 @abstract Sets the colors of the rendered shape.
 @param fillColor The fill color of the rendered shape.
 @param insideStrokeColor The inside stroke color of the rendered shape.
 @param outsideStrokeColor The outside stroke color of the rendered shape.
 */
- (void)updateWithFillColor:(UIColor *)fillColor
          insideStrokeColor:(UIColor *)insideStrokeColor
         outsideStrokeColor:(UIColor *)outsideStrokeColor;

@end
NS_ASSUME_NONNULL_END       // }
