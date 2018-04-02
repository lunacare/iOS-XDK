//
//  LYRUIStandardMessageContainerViewLayout.m
//  Layer-XDK-UI-iOS
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

#import "LYRUIStandardMessageContainerViewLayout.h"

@interface LYRUIStandardMessageContainerViewLayout ()

@property (nonatomic, strong) NSMutableArray *constantConstraints;
@property (nonatomic, strong) NSMutableArray *contentConstraints;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *labelsVerticalMarginsConstraints;
@property (nonatomic, strong) NSMutableArray *labelsHorizontalMarginsConstraints;

@end

@implementation LYRUIStandardMessageContainerViewLayout

- (instancetype)init{
    self = [super init];
    if (self) {
        self.constantConstraints = [[NSMutableArray alloc] init];
        self.contentConstraints = [[NSMutableArray alloc] init];
        self.labelsVerticalMarginsConstraints = [[NSMutableArray alloc] init];
        self.labelsHorizontalMarginsConstraints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] init];
}

- (void)addConstraintsInView:(LYRUIStandardMessageContainerView *)view {
    [self setupCompressionResistanceInView:view];
    [self addConstantConstraintsInView:view];
    [self addContentViewConstraintsInView:view];
    [self addLabelsVerticalMarginsInView:view];
    [self addLabelsHorizontalMarginsInView:view];
}

- (void)updateConstraintsInView:(LYRUIStandardMessageContainerView *)view {
    [self removeConstraintsFromArray:self.labelsVerticalMarginsConstraints];
    [self addLabelsVerticalMarginsInView:view];
    [self removeConstraintsFromArray:self.labelsHorizontalMarginsConstraints];
    [self addLabelsHorizontalMarginsInView:view];
    for (NSLayoutConstraint *constraint in [self.contentConstraints copy]) {
        if (constraint.isActive == NO) {
            [self.contentConstraints removeObject:constraint];
        }
    }
    if (view.contentView != nil && self.contentConstraints.count == 0) {
        [self addContentViewConstraintsInView:view];
    }
}

- (void)removeConstraintsFromView:(LYRUIStandardMessageContainerView *)view {
    [self removeConstraintsFromArray:self.constantConstraints];
    [self removeConstraintsFromArray:self.contentConstraints];
    [self removeConstraintsFromArray:self.labelsVerticalMarginsConstraints];
    [self removeConstraintsFromArray:self.labelsHorizontalMarginsConstraints];
}

- (void)setupCompressionResistanceInView:(LYRUIStandardMessageContainerView *)view {
    [view.metadataContainer setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [view.descriptionLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [view.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [view.footerLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [view.descriptionLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [view.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [view.footerLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [view.disclosureIndicator setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [view.disclosureIndicator setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)addConstantConstraintsInView:(LYRUIStandardMessageContainerView *)view {
    view.contentViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    view.metadataContainer.translatesAutoresizingMaskIntoConstraints = NO;
    view.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    view.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    view.footerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    view.disclosureIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    
    [constraints addObject:[view.contentViewContainer.topAnchor constraintEqualToAnchor:view.topAnchor]];
    [constraints addObject:[view.contentViewContainer.leftAnchor constraintEqualToAnchor:view.leftAnchor]];
    [constraints addObject:[view.contentViewContainer.rightAnchor constraintEqualToAnchor:view.rightAnchor]];
    [constraints addObject:[view.contentViewContainer.bottomAnchor constraintEqualToAnchor:view.metadataContainer.topAnchor]];
    
    [constraints addObject:[view.metadataContainer.leftAnchor constraintEqualToAnchor:view.leftAnchor]];
    [constraints addObject:[view.metadataContainer.rightAnchor constraintEqualToAnchor:view.rightAnchor]];
    [constraints addObject:[view.metadataContainer.bottomAnchor constraintEqualToAnchor:view.bottomAnchor]];
    
    [constraints addObject:[view.titleLabel.leftAnchor constraintEqualToAnchor:view.metadataContainer.leftAnchor constant:12.0]];
    [constraints addObject:[view.descriptionLabel.leftAnchor constraintEqualToAnchor:view.metadataContainer.leftAnchor constant:12.0]];
    [constraints addObject:[view.footerLabel.leftAnchor constraintEqualToAnchor:view.metadataContainer.leftAnchor constant:12.0]];
    
    [constraints addObject:[view.disclosureIndicator.rightAnchor constraintEqualToAnchor:view.metadataContainer.rightAnchor constant:-12.0]];
    [constraints addObject:[view.disclosureIndicator.centerYAnchor constraintEqualToAnchor:view.metadataContainer.centerYAnchor]];
    [constraints addObject:[view.disclosureIndicator.widthAnchor constraintEqualToConstant:24.0]];
    [constraints addObject:[view.disclosureIndicator.heightAnchor constraintEqualToConstant:24.0]];
    
    [NSLayoutConstraint activateConstraints:constraints];
    [self.constantConstraints addObjectsFromArray:constraints];
}

- (void)addContentViewConstraintsInView:(LYRUIStandardMessageContainerView *)view {
    UIView *contentView = view.contentView;
    UIView *container = view.contentViewContainer;
    NSMutableArray *constraints = [NSMutableArray new];
    if (contentView != nil) {
        self.contentView = contentView;
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [constraints addObject:[contentView.leadingAnchor constraintEqualToAnchor:container.leadingAnchor]];
        [constraints addObject:[contentView.trailingAnchor constraintEqualToAnchor:container.trailingAnchor]];
        [constraints addObject:[contentView.topAnchor constraintEqualToAnchor:container.topAnchor]];
        [constraints addObject:[contentView.bottomAnchor constraintEqualToAnchor:container.bottomAnchor]];
        
        [NSLayoutConstraint activateConstraints:constraints];
        [self.contentConstraints addObjectsFromArray:constraints];
    }
}

- (void)addLabelsVerticalMarginsInView:(LYRUIStandardMessageContainerView *)view {
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    if (view.titleLabel.text.length > 0) {
        [constraints addObject:[view.titleLabel.topAnchor constraintEqualToAnchor:view.metadataContainer.topAnchor constant:8.0]];
        if (view.descriptionLabel.text.length > 0) {
            [constraints addObject:[view.descriptionLabel.topAnchor constraintEqualToAnchor:view.titleLabel.bottomAnchor constant:3.0]];
        } else if (view.footerLabel.text.length > 0) {
            [constraints addObject:[view.footerLabel.topAnchor constraintEqualToAnchor:view.titleLabel.bottomAnchor constant:8.0]];
        } else {
            [constraints addObject:[view.titleLabel.bottomAnchor constraintEqualToAnchor:view.metadataContainer.bottomAnchor constant:-9.0]];
        }
    }
    if (view.descriptionLabel.text.length > 0) {
        if (view.titleLabel.text.length == 0) {
            [constraints addObject:[view.descriptionLabel.topAnchor constraintEqualToAnchor:view.metadataContainer.topAnchor constant:8.0]];
        }
        if (view.footerLabel.text.length > 0) {
            [constraints addObject:[view.footerLabel.topAnchor constraintEqualToAnchor:view.descriptionLabel.bottomAnchor constant:8.0]];
        } else {
            [constraints addObject:[view.descriptionLabel.bottomAnchor constraintEqualToAnchor:view.metadataContainer.bottomAnchor constant:-9.0]];
        }
    }
    if (view.footerLabel.text.length > 0) {
        if (view.titleLabel.text.length == 0 && view.descriptionLabel.text.length == 0) {
            [constraints addObject:[view.footerLabel.topAnchor constraintEqualToAnchor:view.metadataContainer.topAnchor constant:8.0]];
        }
        [constraints addObject:[view.footerLabel.bottomAnchor constraintEqualToAnchor:view.metadataContainer.bottomAnchor constant:-9.0]];
    }
    
    [NSLayoutConstraint activateConstraints:constraints];
    [self.labelsVerticalMarginsConstraints addObjectsFromArray:constraints];
}

- (void)addLabelsHorizontalMarginsInView:(LYRUIStandardMessageContainerView *)view {
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    if (view.disclosureIndicator.hidden) {
        [constraints addObject:[view.titleLabel.rightAnchor constraintEqualToAnchor:view.metadataContainer.rightAnchor constant:-12.0]];
        [constraints addObject:[view.descriptionLabel.rightAnchor constraintEqualToAnchor:view.metadataContainer.rightAnchor constant:-12.0]];
        [constraints addObject:[view.footerLabel.rightAnchor constraintEqualToAnchor:view.metadataContainer.rightAnchor constant:-12.0]];
    } else {
        [constraints addObject:[view.titleLabel.rightAnchor constraintEqualToAnchor:view.disclosureIndicator.leftAnchor constant:-8.0]];
        [constraints addObject:[view.descriptionLabel.rightAnchor constraintEqualToAnchor:view.disclosureIndicator.leftAnchor constant:-8.0]];
        [constraints addObject:[view.footerLabel.rightAnchor constraintEqualToAnchor:view.disclosureIndicator.leftAnchor constant:-8.0]];
    }    
    [NSLayoutConstraint activateConstraints:constraints];
    [self.labelsHorizontalMarginsConstraints addObjectsFromArray:constraints];
}

- (void)removeConstraintsFromArray:(NSMutableArray *)constraints {
    [NSLayoutConstraint deactivateConstraints:constraints];
    [constraints removeAllObjects];
}

@end
