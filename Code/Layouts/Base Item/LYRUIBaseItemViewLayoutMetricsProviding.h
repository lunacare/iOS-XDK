//
//  LYRUIBaseItemViewLayoutMetrics.h
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

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LYRUIBaseItemViewLayoutSizeTiny,
    LYRUIBaseItemViewLayoutSizeSmall,
    LYRUIBaseItemViewLayoutSizeMedium,
    LYRUIBaseItemViewLayoutSizeLarge,
} LYRUIBaseItemViewLayoutSize;

@protocol LYRUIBaseItemViewLayoutMetricsDelegate <NSObject>

- (LYRUIBaseItemViewLayoutSize)baseItemViewLayoutMetricsCurrentLayoutSize;

@end

@protocol LYRUIBaseItemViewLayoutMetricsProviding <NSObject>

@property(nonatomic, weak) id <LYRUIBaseItemViewLayoutMetricsDelegate> delegate;

@property (nonatomic, readonly) CGFloat horizontalMarginSize;
@property (nonatomic, readonly) CGFloat horizontalVariableMarginSize;
@property (nonatomic, readonly) CGFloat verticalMarginSize;
@property (nonatomic, readonly) CGFloat topGuideShift;
@property (nonatomic, readonly) CGFloat labelsVerticalMargin;
@property (nonatomic, readonly) CGFloat accessoryViewContainerMaxSize;
@property (nonatomic, readonly) CGFloat conversationTitleFontSize;
@property (nonatomic, readonly) CGFloat dateFontSize;

- (LYRUIBaseItemViewLayoutSize)laytoutSizeForViewHeight:(CGFloat)viewHeight;

@end
