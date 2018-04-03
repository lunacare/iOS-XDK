//
//  LYRUIIdentityCollectionViewCell.h
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 27.07.2017.
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
@class LYRUIIdentityItemView;

/**
 @abstract A collection view cell to present `LYRIdentity` item inside the `LYRUIIdentityListView`.
 */
@interface LYRUIIdentityCollectionViewCell : UICollectionViewCell

/**
 @abstract Contained `LYRUIIdentityItemView` which will be filled with data from `LYRIdentity` instance.
 */
@property (nonatomic, weak) LYRUIIdentityItemView *identityView;

@end
