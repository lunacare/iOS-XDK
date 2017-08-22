//
//  LYRUIMessageItemView.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 11.08.2017.
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

#import "LYRUIMessageItemView.h"
#import "LYRUIMessageItemViewLayout.h"
#import "LYRUIMessageItemIBSetup.h"

static CGFloat const LYRUIMessageItemViewContentDefaultCornerRadius = 16.0;

@interface LYRUIMessageItemView ()

@property (nonatomic, weak, readwrite) UIView *primaryAccessoryViewContainer;
@property (nonatomic, weak, readwrite) UIView *contentViewContainer;
@property (nonatomic, weak, readwrite) UIView *secondaryAccessoryViewContainer;

@end

@implementation LYRUIMessageItemView
@synthesize primaryAccessoryView = _primaryAccessoryView,
            contentView = _contentView,
            secondaryAccessoryView = _secondaryAccessoryView;
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

- (instancetype)initWithLayout:(id<LYRUIMessageItemViewLayout>)layout {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        [self lyr_commonInit];
        self.layout = layout;
    }
    return self;
}

- (void)lyr_commonInit {
    self.updateConstraintsOnWidthChange = YES;
    self.primaryAccessoryViewContainer = [self addView];
    self.contentViewContainer = [self addView];
    self.contentViewContainer.layer.cornerRadius = LYRUIMessageItemViewContentDefaultCornerRadius;
    self.contentViewContainer.backgroundColor = [UIColor colorWithWhite:242.0/255.0 alpha:1.0];
    self.secondaryAccessoryViewContainer = [self addView];
    self.layout = [[LYRUIMessageItemViewLayout alloc] initWithLayoutDirection:LYRUIMessageItemViewLayoutDirectionLeft];
}

- (UIView *)addView {
    return [self addViewIn:self];
}

- (UIView *)addViewIn:(UIView *)superview {
    UIView *view = [[UIView alloc] init];
    view.clipsToBounds = YES;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [superview addSubview:view];
    return view;
}

- (void)prepareForInterfaceBuilder {
    [[[LYRUIMessageItemIBSetup alloc] init] prepareMessageItemForInterfaceBuilder:self];
}

#pragma mark - Properties

- (void)setPrimaryAccessoryView:(UIView *)primaryAccessoryView {
    if (self.primaryAccessoryView != nil) {
        [self.primaryAccessoryView removeFromSuperview];
    }
    if (primaryAccessoryView != nil) {
        [self.primaryAccessoryViewContainer addSubview:primaryAccessoryView];
    }
    _primaryAccessoryView = primaryAccessoryView;
    [self setNeedsUpdateConstraints];
}

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

- (void)setSecondaryAccessoryView:(UIView *)secondaryAccessoryView {
    if (self.secondaryAccessoryView != nil) {
        [self.secondaryAccessoryView removeFromSuperview];
    }
    if (secondaryAccessoryView != nil) {
        [self.secondaryAccessoryViewContainer addSubview:secondaryAccessoryView];
    }
    _secondaryAccessoryView = secondaryAccessoryView;
    [self setNeedsUpdateConstraints];
}

- (LYRUIMessageItemViewLayoutDirection)layoutDirection {
    return self.layout.layoutDirection;
}

@end
