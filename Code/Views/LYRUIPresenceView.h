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
@protocol LYRUIPresenceViewShapeProviding <NSObject>

- (UIBezierPath *)shapeWithSize:(CGSize)size;

@end

IB_DESIGNABLE
@interface LYRUIPresenceView : UIView

@property (nonatomic, copy) IBInspectable UIColor *fillColor;
@property (nonatomic, copy) IBInspectable UIColor *insideStrokeColor;
@property (nonatomic, copy) IBInspectable UIColor *outsideStrokeColor;

@property (nonatomic, strong) IBOutlet id<LYRUIPresenceViewShapeProviding> shapeProvider;

- (void)updateWithFillColor:(UIColor *)fillColor
          insideStrokeColor:(UIColor *)insideStrokeColor
         outsideStrokeColor:(UIColor *)outsideStrokeColor;

@end
NS_ASSUME_NONNULL_END       // }
