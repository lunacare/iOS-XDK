//
//  LYRUIPresenceViewConfigurator.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 21.07.2017.
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

#import "LYRUIPresenceViewConfigurator.h"
#import "LYRUIPresenceView+PrivateProperties.h"
#import "LYRUIShapedView.h"
#import "LYRUINumberBadgeView.h"
#import "LYRUIPresenceIndicatorTheme.h"
#import "LYRUIParticipantsCountViewTheme.h"
#import <LayerKit/LayerKit.h>

@implementation LYRUIPresenceViewConfigurator

- (void)setupPresenceView:(LYRUIPresenceView *)presenceView
           withIdentities:(NSArray<LYRIdentity *> *)identities
               usingTheme:(id<LYRUIParticipantsCountViewTheme, LYRUIPresenceIndicatorTheme>)theme {
    BOOL singleParticipant = (identities.count == 1);
    if (singleParticipant) {
        LYRIdentityPresenceStatus presenceStatus = identities.firstObject.presenceStatus;
        [self setupPresenceIndicator:presenceView.presenceIndicator
                   forPresenceStatus:presenceStatus
                          usingTheme:theme];
    } else {
        [self setupParticipantsCountView:presenceView.participantsCountView
                              withNumber:identities.count
                              usingTheme:theme];
    }
    presenceView.presenceIndicator.hidden = !singleParticipant;
    presenceView.participantsCountView.hidden = singleParticipant;
}

- (void)setupPresenceIndicator:(LYRUIShapedView *)presenceIndicator
             forPresenceStatus:(LYRIdentityPresenceStatus)status
                    usingTheme:(id<LYRUIPresenceIndicatorTheme>)theme {
    [presenceIndicator updateWithFillColor:[theme fillColorForPresenceStatus:status]
                         insideStrokeColor:[theme insideStrokeColorForPresenceStatus:status]
                        outsideStrokeColor:[theme outsideStrokeColorForPresenceStatus:status]];
}

- (void)setupParticipantsCountView:(LYRUINumberBadgeView *)participantsCountView
                        withNumber:(NSUInteger)number
                        usingTheme:(id<LYRUIParticipantsCountViewTheme>)theme {
    participantsCountView.number = number;
    participantsCountView.textColor = theme.participantsCountColor;
    participantsCountView.borderColor = theme.participantsCountColor;
}

@end
