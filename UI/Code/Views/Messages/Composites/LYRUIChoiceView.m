//
//  LYRUIChoiceView.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 15.01.2018.
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

#import "LYRUIChoiceView.h"
#import "UIButton+LYRUIBlockAction.h"

@interface LYRUIChoiceView ()

@property (nonatomic, weak) UIStackView *stackView;
@property (nonatomic, strong, readwrite) NSMutableArray<LYRUIChoiceButton *> *buttons;

@end

@implementation LYRUIChoiceView

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
    self.buttons = [[NSMutableArray alloc] init];
    self.stackView = [self addStackView];
}

- (UIStackView *)addStackView {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentFill;
    self.axis = LYRUIChoiceViewAxisVertical;
    stackView.spacing = 1.0;
    [self addSubview:stackView];
    [stackView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [stackView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [stackView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    return stackView;
}

- (void)setAxis:(LYRUIChoiceViewAxis)axis {
    _axis = axis;
    switch (axis) {
        case LYRUIChoiceViewAxisVertical:
            self.stackView.axis = UILayoutConstraintAxisVertical;
            break;
        case LYRUIChoiceViewAxisHorizontal:
            self.stackView.axis = UILayoutConstraintAxisHorizontal;
            break;
    }
}

- (void)setNumberOfButtons:(NSUInteger)numberOfButtons {
    _numberOfButtons = numberOfButtons;
    for (LYRUIChoiceButton *button in self.buttons) {
        button.enabled = YES;
        button.selected = NO;
    }
    if (numberOfButtons < self.buttons.count) {
        NSRange rangeOfButtonsToRemove = NSMakeRange(numberOfButtons - 1, self.buttons.count - numberOfButtons);
        NSArray *buttonsToRemove = [self.buttons subarrayWithRange:rangeOfButtonsToRemove];
        for (LYRUIChoiceButton *button in buttonsToRemove) {
            [button removeFromSuperview];
            [self.buttons removeObject:button];
        }
    } else {
        NSUInteger numberOfButtonsToAdd = numberOfButtons - self.buttons.count;
        for (NSUInteger i = 0; i < numberOfButtonsToAdd; i += 1) {
            [self addButton];
        }
    }
    self.selectionHandler.buttons = self.buttons;
}

- (void)setSelectionHandler:(id<LYRUIChoiceSelectionHandling>)selectionHandler {
    _selectionHandler = selectionHandler;
    selectionHandler.buttons = self.buttons;
}

- (void)addButton {
    LYRUIChoiceButton *button = [[LYRUIChoiceButton alloc] init];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button.heightAnchor constraintEqualToConstant:48.0].active = YES;
    
    __weak __typeof(self) weakSelf = self;
    button.lyr_actionHandler = ^(UIButton *button) {
        [weakSelf.selectionHandler buttonTapped:(LYRUIChoiceButton *)button];
    };
    
    [self.stackView addArrangedSubview:button];
    [self.buttons addObject:button];
}

@end
