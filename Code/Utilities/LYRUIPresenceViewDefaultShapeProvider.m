//
//  LYRUIPresenceViewDefaultShapeProvider.m
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

#import "LYRUIPresenceViewDefaultShapeProvider.h"
#import "ATLMessagingUtilities.h"

static CGFloat const LYRUIPresenceViewDefaultShapeOutsideStrokeWidth = 2.0;
static CGFloat const LYRUIPresenceViewDefaultShapeStrokeWidth = 4.0;

@interface LYRUIPresenceViewDefaultShapeProvider ()

@property (nonatomic) CGSize storedPathSize;
@property (nonatomic, strong) UIBezierPath *storedPath;

@end

@implementation LYRUIPresenceViewDefaultShapeProvider

- (nonnull UIBezierPath *)shapeWithSize:(CGSize)size {
    if (self.storedPath && CGSizeEqualToSize(self.storedPathSize, size)) {
        return self.storedPath;
    }
    
    CGPoint arcCenter = CGPointMake(size.width / 2.0, size.height / 2.0);
    CGFloat shorterSide = MIN(size.width, size.height);
    CGFloat radius = round((shorterSide - (2.0 * LYRUIPresenceViewDefaultShapeOutsideStrokeWidth)) / 2.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                        radius:radius
                                                    startAngle:ATLDegreeToRadians(0.0)
                                                      endAngle:ATLDegreeToRadians(360.0)
                                                     clockwise:YES];
    path.lineWidth = LYRUIPresenceViewDefaultShapeStrokeWidth;
    self.storedPath = path;
    self.storedPathSize = size;
    return path;
}

@end
