//
//  UIView+LYRUIMessageConfiguration.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 03.11.2017.
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

#import "UIView+LYRUIMessageConfiguration.h"
#import "NSObject+LYRUIObjectAssociation.h"

static void *LYRUIMessageContentViewConfigurationContextId = &LYRUIMessageContentViewConfigurationContextId;

@implementation UIView (LYRUIMessageConfiguration)

- (NSString *)lyr_presentationContextId {
    return [self lyr_getAssociatedPropertyWithKey:LYRUIMessageContentViewConfigurationContextId];
}

- (void)setLyr_presentationContextId:(NSString *)lyr_configurationContextId {
    [self lyr_setAssociatedPropertyWithKey:LYRUIMessageContentViewConfigurationContextId object:lyr_configurationContextId];
}

- (BOOL)lyr_isOutOfContext:(NSString *)contextId {
    return ![self.lyr_presentationContextId isEqualToString:contextId];
}

@end
