//
//  LYRUIConversationItemViewLayoutMetrics.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 11.07.2017.
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

#import "LYRUIConversationItemViewLayoutMetrics.h"

@implementation LYRUIConversationItemViewLayoutMetrics

- (LYRUIConversationItemViewLayoutSize)layoutSize {
    return [self.delegate conversationItemViewLayoutMetricsCurrentLayoutSize];
}

#pragma mark - Margins

- (CGFloat)horizontalMarginSize {
    return 12.0;
}

- (CGFloat)horizontalVariableMarginSize {
    switch (self.layoutSize) {
        case LYRUIConversationItemViewLayoutSizeTiny:
            return 8.0;
        case LYRUIConversationItemViewLayoutSizeSmall:
        case LYRUIConversationItemViewLayoutSizeMedium:
        case LYRUIConversationItemViewLayoutSizeLarge:
            return 12.0;
    }
}

- (CGFloat)verticalMarginSize {
    switch (self.layoutSize) {
        case LYRUIConversationItemViewLayoutSizeTiny:
        case LYRUIConversationItemViewLayoutSizeSmall:
            return 8.0;
        case LYRUIConversationItemViewLayoutSizeMedium:
            return 10.0;
        case LYRUIConversationItemViewLayoutSizeLarge:
            return 12.0;
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
        case LYRUIConversationItemViewLayoutSizeTiny:
            return 12.0;
        case LYRUIConversationItemViewLayoutSizeSmall:
            return 32.0;
        case LYRUIConversationItemViewLayoutSizeMedium:
            return 40.0;
        case LYRUIConversationItemViewLayoutSizeLarge:
            return 48.0;
    }
}

#pragma mark - Fonts

- (CGFloat)conversationTitleFontSize {
    switch (self.layoutSize) {
        case LYRUIConversationItemViewLayoutSizeTiny:
        case LYRUIConversationItemViewLayoutSizeSmall:
            return 14.0;
        case LYRUIConversationItemViewLayoutSizeMedium:
        case LYRUIConversationItemViewLayoutSizeLarge:
            return 16.0;
    }
}

- (CGFloat)dateFontSize {
    switch (self.layoutSize) {
        case LYRUIConversationItemViewLayoutSizeTiny:
        case LYRUIConversationItemViewLayoutSizeSmall:
            return 10.0;
        case LYRUIConversationItemViewLayoutSizeMedium:
        case LYRUIConversationItemViewLayoutSizeLarge:
            return 12.0;
    }
}

#pragma mark - Layout

- (LYRUIConversationItemViewLayoutSize)laytoutSizeForViewHeight:(CGFloat)viewHeight {
    if (viewHeight < 48.0) {
        return LYRUIConversationItemViewLayoutSizeTiny;
    } else if (viewHeight < 60.0) {
        return LYRUIConversationItemViewLayoutSizeSmall;
    } else if (viewHeight < 72.0) {
        return LYRUIConversationItemViewLayoutSizeMedium;
    } else {
        return LYRUIConversationItemViewLayoutSizeLarge;
    }
}

@end
