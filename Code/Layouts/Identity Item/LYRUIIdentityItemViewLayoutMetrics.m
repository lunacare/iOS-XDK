//
//  LYRUIIdentityItemViewLayoutMetrics.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 13.07.2017.
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

#import "LYRUIIdentityItemViewLayoutMetrics.h"

@implementation LYRUIIdentityItemViewLayoutMetrics
@synthesize delegate;

- (LYRUIBaseItemViewLayoutSize)layoutSize {
    return [self.delegate baseItemViewLayoutMetricsCurrentLayoutSize];
}

#pragma mark - Margins

- (CGFloat)horizontalMarginSize {
    return 12.0;
}

- (CGFloat)horizontalVariableMarginSize {
    switch (self.layoutSize) {
        case LYRUIBaseItemViewLayoutSizeTiny:
            return 8.0;
        case LYRUIBaseItemViewLayoutSizeSmall:
        case LYRUIBaseItemViewLayoutSizeMedium:
            return 12.0;
            
        default:
            return 0.0;
    }
}

- (CGFloat)verticalMarginSize {
    switch (self.layoutSize) {
        case LYRUIBaseItemViewLayoutSizeTiny:
        case LYRUIBaseItemViewLayoutSizeSmall:
            return 8.0;
        case LYRUIBaseItemViewLayoutSizeMedium:
            return 10.0;
            
        default:
            return 0.0;
    }
}

- (CGFloat)topGuideShift {
    return 2.0;
}

- (CGFloat)labelsVerticalMargin {
    return 4.0;
}

#pragma mark - Accessory view

- (CGFloat)accessoryViewContainerMaxSize {
    switch (self.layoutSize) {
        case LYRUIBaseItemViewLayoutSizeTiny:
            return 12.0;
        case LYRUIBaseItemViewLayoutSizeSmall:
            return 32.0;
        case LYRUIBaseItemViewLayoutSizeMedium:
            return 40.0;
            
        default:
            return 0.0;
    }
}

#pragma mark - Fonts

- (CGFloat)conversationTitleFontSize {
    switch (self.layoutSize) {
        case LYRUIBaseItemViewLayoutSizeTiny:
        case LYRUIBaseItemViewLayoutSizeSmall:
            return 14.0;
        case LYRUIBaseItemViewLayoutSizeMedium:
            return 16.0;
            
        default:
            return 0.0;
    }
}

- (CGFloat)dateFontSize {
    switch (self.layoutSize) {
        case LYRUIBaseItemViewLayoutSizeTiny:
        case LYRUIBaseItemViewLayoutSizeSmall:
            return 10.0;
        case LYRUIBaseItemViewLayoutSizeMedium:
            return 12.0;
            
        default:
            return 0.0;
    }
}

#pragma mark - Layout

- (LYRUIBaseItemViewLayoutSize)laytoutSizeForViewHeight:(CGFloat)viewHeight {
    if (viewHeight < 48.0) {
        return LYRUIBaseItemViewLayoutSizeTiny;
    } else if (viewHeight < 60.0) {
        return LYRUIBaseItemViewLayoutSizeSmall;
    } else {
        return LYRUIBaseItemViewLayoutSizeMedium;
    }
}

@end
