//
//  LYRUIPanelTypingIndicatorView.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 14.09.2017.
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

#import "LYRUIPanelTypingIndicatorView.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIIdentityShortNameFormatter.h"

NSString *(^LYRUIPanelTypingIndicatorViewDefaultTitleFotmatting)(NSArray<LYRIdentity *> *) = ^ NSString * (NSArray<LYRIdentity *> *identities) {
    id<LYRUIIdentityNameFormatting> nameFormatter = [[LYRUIIdentityShortNameFormatter alloc] init];
    switch (identities.count) {
        case 0:
            return nil;
        case 1:
            return [NSString localizedStringWithFormat:
                    NSLocalizedString(@"%@ is typing", @"Single person is typing in the conversation"),
                    [nameFormatter nameForIdentity:identities.firstObject]];
        case 2:
            return [NSString localizedStringWithFormat:
                    NSLocalizedString(@"%@ and %@ are typing", @"Two persons are typing in the conversation"),
                    [nameFormatter nameForIdentity:identities[0]],
                    [nameFormatter nameForIdentity:identities[1]]];
        default:
            return [NSString localizedStringWithFormat:
                    NSLocalizedString(@"%@, %@ and %d other(s) are typing", @"Multiple persons are typing in the conversation"),
                    [nameFormatter nameForIdentity:identities[0]],
                    [nameFormatter nameForIdentity:identities[1]],
                    (identities.count - 2)];
    }
};

@interface LYRUIPanelTypingIndicatorView ()

@property (nonatomic, weak, readwrite) UILabel *label;

@end

@implementation LYRUIPanelTypingIndicatorView
@synthesize layerConfiguration = _layerConfiguration;

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

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        [self lyr_commonInit];
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)lyr_commonInit {
    self.backgroundColor = [UIColor whiteColor];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightBold];
    label.textColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
    [self addSubview:label];
    self.label = label;
    self.titleFotmatting = LYRUIPanelTypingIndicatorViewDefaultTitleFotmatting;
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    self.layout = [layerConfiguration.injector layoutForViewClass:[self class]];
}

#pragma mark - Properties

- (void)setIdentities:(NSSet<LYRIdentity *> *)identities {
    _identities = [identities copy];
    NSSet<LYRIdentity *> *filteredIdentities = identities;
    if (self.layerConfiguration.participantsFilter) {
        filteredIdentities = self.layerConfiguration.participantsFilter(identities);
    }
    NSArray<LYRIdentity *> *sortedIdentities = self.layerConfiguration.participantsSorter(filteredIdentities);
    NSString *typingIndicatorText = self.titleFotmatting(sortedIdentities);
    self.label.text = typingIndicatorText;
}

#pragma mark - Layout

- (void)setLayout:(id<LYRUIPanelTypingIndicatorViewLayout>)layout {
    if ([self.layout isEqual:layout]) {
        return;
    }
    if (self.layout != nil) {
        [self.layout removeConstraintsFromView:self];
    }
    _layout = [layout copyWithZone:nil];
    [self.layout addConstraintsInView:self];
}

- (void)updateConstraints {
    [self.layout updateConstraintsInView:self];
    [super updateConstraints];
}

@end
