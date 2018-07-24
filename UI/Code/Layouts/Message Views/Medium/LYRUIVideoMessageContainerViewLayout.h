//
//  LYRUIVideoMessageContainerViewLayout.h
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 6/12/18.
//  Copyright (c) 2018 Layer. All rights reserved.
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

#import "LYRUIPlayableMediaMessageContainerViewLayout.h"

NS_ASSUME_NONNULL_BEGIN     // {

/**
 @abstract The video media message container view layout based on the
 playable message container view layout, but it also configures a play button
 layout, so that the play button is located at the center of the preview image
 container.
 */
@interface LYRUIVideoMessageContainerViewLayout : LYRUIPlayableMediaMessageContainerViewLayout

@end

NS_ASSUME_NONNULL_END       // }
