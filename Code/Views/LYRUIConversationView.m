//
//  LYRUIConversationView.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 31.08.2017.
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

#import "LYRUIConversationView.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUIMessageListView.h"
#import "LYRUIComposeBar.h"
#import "LYRUIConversationViewLayout.h"
#import "LYRUIMessageSender.h"
#import <LayerKit/LayerKit.h>
#import "LYRUIConversationViewIBSetup.h"

@interface LYRUIConversationView ()

@property (nonatomic, weak, readwrite) LYRUIMessageListView *messageListView;
@property (nonatomic, weak, readwrite) LYRUIComposeBar *composeBar;

@end

@implementation LYRUIConversationView
@synthesize layerConfiguration = _layerConfiguration;
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

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        [self lyr_commonInit];
        self.layerConfiguration = configuration;
    }
    return self;
}

- (void)lyr_commonInit {
    LYRUIMessageListView *messageListView = [[LYRUIMessageListView alloc] init];
    [self addSubview:messageListView];
    self.messageListView = messageListView;
    
    LYRUIComposeBar *composeBar = [[LYRUIComposeBar alloc] init];
    [self addSubview:composeBar];
    self.composeBar = composeBar;
    
    __weak __typeof(self) weakSelf = self;
    self.composeBar.sendPressedBlock = ^(NSAttributedString *attributedText){
        [weakSelf.messageListView.messageSender sendMessageWithAttributedString:attributedText];
    };
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    self.messageListView.layerConfiguration = layerConfiguration;
    self.composeBar.layerConfiguration = layerConfiguration;
    if (self.layout == nil) {
        self.layout = [layerConfiguration.injector layoutForViewClass:[self class]];
    }
}

- (void)prepareForInterfaceBuilder {
    [[[LYRUIConversationViewIBSetup alloc] init] prepareConversationViewForInterfaceBuilder:self];
}

#pragma mark - Properties

- (LYRConversation *)conversation {
    return self.messageListView.conversation;
}

- (void)setConversation:(LYRConversation *)conversation {
    self.messageListView.conversation = conversation;
    self.composeBar.conversation = conversation;
}

- (LYRQueryController *)queryController {
    return self.messageListView.queryController;
}

- (void)setQueryController:(LYRQueryController *)queryController {
    self.messageListView.queryController = queryController;
    self.composeBar.conversation = self.messageListView.conversation;
    [queryController execute:nil];
}

@end
