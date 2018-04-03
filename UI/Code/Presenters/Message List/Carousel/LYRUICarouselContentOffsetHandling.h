//
//  LYRUICarouselContentOffsetHandling.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 12.02.2018.
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
@class LYRUICarouselMessageListView;

@protocol LYRUICarouselContentOffsetHandling <NSObject>

/**
 @abstract The identifier of carousel message, for which the content offset should be handled.
 */
@property (nonatomic, copy) NSString *messageIdentifier;

/**
 @abstract Stores the content offset of `carousel` view.
 @param carousel An `LYRUICarouselMessageListView` for which the content offset should be stored.
 */
- (void)storeContentOffsetFromCarousel:(LYRUICarouselMessageListView *)carousel;

/**
 @abstract Restores the content offset of `carousel` view.
 @param carousel An `LYRUICarouselMessageListView` for which the content offset should be restored.
 */
- (void)restoreContentOffsetInCarousel:(LYRUICarouselMessageListView *)carousel;

@end
