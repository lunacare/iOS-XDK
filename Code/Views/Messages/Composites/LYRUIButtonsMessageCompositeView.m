//
//  LYRUIButtonsMessageCompositeView.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 12.10.2017.
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

#import "LYRUIButtonsMessageCompositeView.h"
#import "LYRUIButtonsMessageCompositeViewLayout.h"
#import "LYRUIChoice.h"
#import "LYRUIButtonsMessage.h"
#import "LYRUIMessageAction.h"
#import "LYRUIMessageListActionHandlingDelegate.h"

@interface LYRUIButtonsMessageCompositeView ()

@property (nonatomic, weak, readwrite) UIView *contentViewContainer;
@property (nonatomic, weak, readwrite) UIStackView *buttonsStackView;

@end

@implementation LYRUIButtonsMessageCompositeView
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
    self.buttonsStackView = [self addStackView];
    
    self.layout = [[LYRUIButtonsMessageCompositeViewLayout alloc] init];
}

- (UIView *)addView {
    UIView *view = [[UIView alloc] init];
    view.clipsToBounds = YES;
    [self addSubview:view];
    return view;
}

- (UIStackView *)addStackView {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.spacing = 1.0;
    [self addSubview:stackView];
    return stackView;
}

#pragma mark - Properties

- (void)setContentView:(UIView *)contentView {
    if (self.contentView != nil) {
        [self.contentView removeFromSuperview];
    }
    if (contentView != nil) {
        [self.contentViewContainer addSubview:contentView];
    }
    _contentView = contentView;
    [self setNeedsUpdateConstraints];
}

#pragma mark - LYRUIViewsReusing

- (void)lyr_prepareForReuse {
    self.actionHandlingDelegate = nil;
}

@end
