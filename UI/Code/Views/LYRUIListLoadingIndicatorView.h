//
//  LYRUIListLoadingIndicatorView.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 29.08.2017.
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

NS_ASSUME_NONNULL_BEGIN     // {
/**
 @abstract View used as a loading indicator in `LYRUIListView` with paging.
 */
@interface LYRUIListLoadingIndicatorView : UICollectionReusableView
/**
 @abstract Activity indicator spinned used as a loading indicator.
 */
@property (nonatomic, weak, readonly) UIActivityIndicatorView *activityIndicator;

@end
NS_ASSUME_NONNULL_END       // }
