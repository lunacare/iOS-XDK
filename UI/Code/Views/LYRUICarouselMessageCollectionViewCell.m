//
//  LYRUICarouselMessageCollectionViewCell.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 25.01.2018.
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

#import "LYRUICarouselMessageCollectionViewCell.h"
#import "LYRUIMessageItemView.h"
#import "LYRUICarouselMessageViewLayout.h"

@implementation LYRUICarouselMessageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.messageView.layout = [[LYRUICarouselMessageViewLayout alloc] init];
        self.messageView.contentViewContainer.layer.cornerRadius = 0.0;
        self.messageView.contentViewContainer.layer.borderWidth = 0.0;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.messageView.layout = [[LYRUICarouselMessageViewLayout alloc] init];
        self.messageView.contentViewContainer.layer.cornerRadius = 0.0;
        self.messageView.contentViewContainer.layer.borderWidth = 0.0;
    }
    return self;
}

@end
