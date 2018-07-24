//
//  LYRUIMessageOpenMessageActionHandler.h
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 6/11/18.
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

#import "LYRUIActionHandling.h"
#import "LYRUIConfigurable.h"

NS_ASSUME_NONNULL_BEGIN     // {

/**
 @abstract An action handler in charge of presenting a large message variant
   in full screen.
 */
@interface LYRUIMessageOpenMessageActionHandler : NSObject <LYRUIActionHandling, LYRUIConfigurable>

@end

NS_ASSUME_NONNULL_END       // }
