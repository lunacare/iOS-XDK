//
//  LYRUIDotsBubbleView.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 18.09.2017.
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

#import "LYRUIDotsBubbleView.h"
#import "LYRUIAnimator.h"

static CGFloat const LYRUIDotsBubbleViewAnimationDuration = 1.0;

@interface LYRUIDotsBubbleView ()

@property (nonatomic, strong) NSMutableArray<UIView *> *dots;
@property (nonatomic, weak) NSLayoutConstraint *rightMarginConstraint;

@end

@implementation LYRUIDotsBubbleView

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
    self.animator = [[LYRUIAnimator alloc] init];
    self.dots = [[NSMutableArray alloc] init];
    self.clipsToBounds = YES;
    self.cornerRadius = 16.0;
    self.backgroundColor = [UIColor colorWithWhite:242.0/255.0 alpha:1.0];
    self.dotsColor = [UIColor colorWithRed:84.0/255.0 green:99.0/255.0 blue:109.0/255.0 alpha:1.0];
    self.numberOfDots = 3;
}

- (void)addDot {
    UIView *dot = [[UIView alloc] init];
    dot.translatesAutoresizingMaskIntoConstraints = NO;
    dot.backgroundColor = self.dotsColor;
    dot.clipsToBounds = YES;
    dot.layer.cornerRadius = 4.0;
    [self addSubview:dot];
    [self.dots addObject:dot];
    if (self.dots.count > 1) {
        NSUInteger previousDotIndex = self.dots.count - 2;
        UIView *previousDot = self.dots[previousDotIndex];
        [dot.leftAnchor constraintEqualToAnchor:previousDot.rightAnchor constant:4.0].active = YES;
    } else {
        [dot.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:17.0].active = YES;
    }
    [dot.topAnchor constraintEqualToAnchor:self.topAnchor constant:14.0].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:dot.bottomAnchor constant:13.0].active = YES;
    [dot.widthAnchor constraintEqualToConstant:8.0].active = YES;
    [dot.heightAnchor constraintEqualToConstant:8.0].active = YES;
}

#pragma mark - Properties

- (void)setNumberOfDots:(NSUInteger)numberOfDots {
    _numberOfDots = numberOfDots;
    [self stopAnimating];
    if (numberOfDots < self.dots.count) {
        NSRange rangeOfDotsToRemove = NSMakeRange(numberOfDots - 1, self.dots.count - numberOfDots);
        NSArray *dotsToRemove = [self.dots subarrayWithRange:rangeOfDotsToRemove];
        for (UIView *dot in dotsToRemove) {
            [dot removeFromSuperview];
            [self.dots removeObject:dot];
        }
        [self updateRightMargin];
    } else {
        NSUInteger numberOfDotsToAdd = numberOfDots - self.dots.count;
        for (NSUInteger i = 0; i < numberOfDotsToAdd; i += 1) {
            [self addDot];
        }
        [self updateRightMargin];
    }
}

- (void)setDotsColor:(UIColor *)dotsColor {
    _dotsColor = dotsColor;
    [self stopAnimating];
    for (UIView *dot in self.dots) {
        dot.backgroundColor = dotsColor;
    }
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (void)setAnimating:(BOOL)animating {
    if (self.animating == animating) {
        return;
    }
    _animating = animating;
    if (animating) {
        [self startAnimating];
    } else {
        [self stopAnimating];
    }
}

#pragma mark - Animations

- (void)startAnimating {
    CGFloat delayStep = LYRUIDotsBubbleViewAnimationDuration / (CGFloat)(self.dots.count - 1);
    CGFloat delay = 0.0;
    for (UIView *dot in self.dots) {
        [self.animator animateWithDuration:LYRUIDotsBubbleViewAnimationDuration
                                     delay:delay
                                   options:(UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction)
                                animations:^{
                                    dot.alpha = 0.3;
                                } completion:nil];
        delay += delayStep;
    }
}

- (void)stopAnimating {
    for (UIView *dot in self.dots) {
        [dot.layer removeAllAnimations];
        dot.alpha = 1.0;
    }
}

#pragma mark - Layout

- (void)updateRightMargin {
    if (self.rightMarginConstraint) {
        self.rightMarginConstraint.active = NO;
    }
    NSLayoutConstraint *rightMarginConstraint = [self.rightAnchor constraintEqualToAnchor:self.dots.lastObject.rightAnchor constant:17.0];
    rightMarginConstraint.active = YES;
    self.rightMarginConstraint = rightMarginConstraint;
}

@end
