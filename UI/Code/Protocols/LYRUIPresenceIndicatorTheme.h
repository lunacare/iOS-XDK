//
//  LYRUIParticipantViewTheme.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 21.07.2017.
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
#import <LayerKit/LayerKit.h>

/**
 @abstract Objects conforming to the `LYRUIPresenceIndicatorTheme` protocol will be used to provide colors for the presence indicator view.
 */
@protocol LYRUIPresenceIndicatorTheme <NSObject, NSCopying>

/**
 @abstract Provides the fill color to use in shaped Presence Indicator, to represent given presence `status`.
 @param status The `LYRIdentityPresenceStatus` to be represented by the presence indicator.
 @return An `UIColor` to use as the fill color of the shaped view.
 */
- (UIColor *)fillColorForPresenceStatus:(LYRIdentityPresenceStatus)status;
/**
 @abstract Provides the inside stroke color to use in shaped Presence Indicator, to represent given presence `status`.
 @param status The `LYRIdentityPresenceStatus` to be represented by the presence indicator.
 @return An `UIColor` to use as the inside stroke color of the shaped view.
 */
- (UIColor *)insideStrokeColorForPresenceStatus:(LYRIdentityPresenceStatus)status;
/**
 @abstract Provides the outside stroke color to use in shaped Presence Indicator, to represent given presence `status`.
 @param status The `LYRIdentityPresenceStatus` to be represented by the presence indicator.
 @return An `UIColor` to use as the outside stroke color of the shaped view.
 */
- (UIColor *)outsideStrokeColorForPresenceStatus:(LYRIdentityPresenceStatus)status;

@end
