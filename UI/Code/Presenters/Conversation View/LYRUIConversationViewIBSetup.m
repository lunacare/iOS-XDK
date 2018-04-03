//
//  LYRUIConversationViewIBSetup.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 30.01.2018.
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

#import "LYRUIConversationViewIBSetup.h"
#import "LYRUIConversationView.h"
#import "LYRUIConversationViewLayout.h"
#import "LYRUIMessageListIBSetup.h"
#import "LYRUIComposeBarIBSetup.h"
#import "LYRUIConfiguration.h"

@implementation LYRUIConversationViewIBSetup

- (void)prepareConversationViewForInterfaceBuilder:(LYRUIConversationView *)conversationView {
    conversationView.layout = [[LYRUIConversationViewLayout alloc] init];
    [[[LYRUIMessageListIBSetup alloc] init] prepareMessageListForInterfaceBuilder:conversationView.messageListView];
    [[[LYRUIComposeBarIBSetup alloc] init] prepareComposeBarForInterfaceBuilder:conversationView.composeBar];
}

@end
