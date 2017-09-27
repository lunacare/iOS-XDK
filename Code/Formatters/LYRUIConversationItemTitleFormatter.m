//
//  LYRUIConversationItemTitleFormatter.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 06.07.2017.
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

#import "LYRUIConversationItemTitleFormatter.h"
#import <LayerKit/LayerKit.h>

static NSString *const LYRUIConversationItemTitleMetadataKey = @"conversationName";

@implementation LYRUIConversationItemTitleFormatter
@synthesize participantsFilter = _participantsFilter;

- (instancetype)init {
    self = [self initWithParticipantsFilter:nil];
    return self;
}

- (instancetype)initWithParticipantsFilter:(LYRUIParticipantsFiltering)participantsFilter {
    self = [super init];
    if (self) {
        self.participantsFilter = participantsFilter;
    }
    return self;
}

#pragma mark - LYRUIConversationItemTitleFormatting method

- (NSString *)titleForConversation:(LYRConversation *)conversation {
    NSString *metadataTitle = [self metadataTitleForConversation:conversation];
    if (metadataTitle && metadataTitle.length > 0) {
        return metadataTitle;
    }
    
    NSSet<LYRIdentity *> *participants = conversation.participants;
    if (self.participantsFilter) {
        participants = self.participantsFilter(conversation.participants);
    }
    if (participants.count == 1) {
        return [self participantName:participants.anyObject];
    }
    
    // TODO: Add other participants sorting
    
    return [self titleWithParticipantsNames:participants];
}

#pragma mark - Title formatting

- (nullable NSString *)metadataTitleForConversation:(nonnull LYRConversation *)conversation {
    return conversation.metadata[LYRUIConversationItemTitleMetadataKey];
}

- (nonnull NSString *)participantName:(nonnull LYRIdentity *)participant {
    if (participant.firstName == nil && participant.lastName == nil) {
        return participant.displayName ?: @"";
    }
    return [NSString stringWithFormat:@"%@%@%@",
            participant.firstName ?: @"",
            participant.firstName && participant.lastName ? @" " : @"",
            participant.lastName ?: @""];
}

- (nonnull NSString *)titleWithParticipantsNames:(nonnull NSSet<LYRIdentity *> *)participants {
    NSMutableString *title = [[NSMutableString alloc] init];
    for (LYRIdentity *participant in participants) {
        NSString *participantName = [self participantShortName:participant];
        if (participantName != nil) {
            if (title.length != 0) {
                [title appendString:@", "];
            }
            [title appendString:participantName];
        }
    }
    return title;
}

- (nullable NSString *)participantShortName:(nonnull LYRIdentity *)participant {
    if (participant.firstName && participant.firstName.length > 0) {
        return participant.firstName;
    } else if (participant.lastName && participant.lastName.length > 0) {
        return participant.lastName;
    }
    return participant.displayName;
}

@end
