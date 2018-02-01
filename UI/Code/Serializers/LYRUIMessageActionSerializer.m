//
//  LYRUIMessageActionSerializer.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 31.01.2018.
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

#import "LYRUIMessageActionSerializer.h"
#import "LYRUIMessageAction.h"

static NSString *const LYRUIMessageActionPropertiesKey = @"action";
static NSString *const LYRUIMessageActionEventKey = @"event";
static NSString *const LYRUIMessageActionDataKey = @"data";

@implementation LYRUIMessageActionSerializer

- (LYRUIMessageAction *)actionFromProperties:(NSDictionary *)properties {
    return [self actionFromProperties:properties withDefaultEvent:nil];
}

- (LYRUIMessageAction *)actionFromProperties:(NSDictionary *)properties
                            withDefaultEvent:(NSString *)event {
    NSDictionary *actionProperties = properties[LYRUIMessageActionPropertiesKey];
    if (actionProperties == nil || ![actionProperties isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    if (actionProperties[LYRUIMessageActionEventKey] != nil) {
        event = actionProperties[LYRUIMessageActionEventKey];
    }
    if (event == nil || ![event isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSDictionary *data = actionProperties[LYRUIMessageActionDataKey];
    if (data == nil || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[LYRUIMessageAction alloc] initWithEvent:event data:data];
}

- (LYRUIMessageAction *)actionFromProperties:(NSDictionary *)properties
                            overridingAction:(LYRUIMessageAction *)baseAction {
    NSDictionary *actionProperties = properties[LYRUIMessageActionPropertiesKey];
    if (actionProperties == nil || ![actionProperties isKindOfClass:[NSDictionary class]]) {
        return baseAction;
    }
    
    NSString *event = actionProperties[LYRUIMessageActionEventKey] ?: baseAction.event;
    if (event == nil || ![event isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSDictionary *data = actionProperties[LYRUIMessageActionDataKey] ?: baseAction.data;
    if (data == nil || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[LYRUIMessageAction alloc] initWithEvent:event data:data];
}

- (NSDictionary *)propertiesForAction:(LYRUIMessageAction *)action {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    if (action) {
        NSMutableDictionary *actionProperties = [[NSMutableDictionary alloc] init];
        actionProperties[LYRUIMessageActionEventKey] = action.event;
        actionProperties[LYRUIMessageActionDataKey] = action.data;
        properties[LYRUIMessageActionPropertiesKey] = [actionProperties copy];
    }
    return [properties copy];
}

@end
