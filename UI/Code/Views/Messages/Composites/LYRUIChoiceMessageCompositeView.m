//
//  LYRUIChoiceMessageCompositeView.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 16.01.2018.
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

#import "LYRUIChoiceMessageCompositeView.h"
#import "LYRUIChoiceMessageCompositeViewLayout.h"
#import "UIImage+LYRUIColorImage.h"
#import "UIButton+LYRUIBlockAction.h"
#import "LYRUIChoice.h"
#import "LYRUIChoiceMessage.h"
#import "LYRUIMessageAction.h"
#import "LYRUIChoiceMessage.h"
#import "LYRUIChoiceView.h"

@interface LYRUIChoiceMessageCompositeView ()

@property (nonatomic, weak, readwrite) UIView *contentViewContainer;
@property (nonatomic, weak, readwrite) LYRUIChoiceView *choiceView;

@end

@implementation LYRUIChoiceMessageCompositeView
@synthesize contentView = _contentView;
@dynamic layout;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (void)lyr_commonInit {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.contentViewContainer = [self addView];
    self.choiceView = [self addChoiceView];
    
    self.layout = [[LYRUIChoiceMessageCompositeViewLayout alloc] init];
}

- (UIView *)addView {
    UIView *view = [[UIView alloc] init];
    view.clipsToBounds = YES;
    [self addSubview:view];
    return view;
}

- (LYRUIChoiceView *)addChoiceView {
    LYRUIChoiceView *choiceView = [[LYRUIChoiceView alloc] init];
    choiceView.axis = LYRUIChoiceViewAxisVertical;
    [self addSubview:choiceView];
    return choiceView;
}

#pragma mark - Properties

- (void)setContentView:(UIView *)contentView {
    if (self.contentView != nil) {
        [self.contentView removeFromSuperview];
    }
    if (contentView != nil) {
        [self.contentViewContainer addSubview:contentView];
        contentView.backgroundColor = self.contentViewContainer.backgroundColor;
    }
    _contentView = contentView;
    [self setNeedsUpdateConstraints];
}

#pragma mark - LYRUIViewsReusing

- (void)lyr_prepareForReuse {
    self.actionHandler = nil;
    self.choiceView.selectionHandler = nil;
}

@end
