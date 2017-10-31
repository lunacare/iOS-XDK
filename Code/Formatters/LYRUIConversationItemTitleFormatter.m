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
#import "LYRUIIdentityNameFormatter.h"
#import "LYRUIParticipantsSorting.h"
#import <LayerKit/LayerKit.h>

static NSString *const LYRUIConversationItemTitleMetadataKey = @"conversationName";

@interface LYRUIConversationItemTitleFormatter ()

@property (nonatomic, strong, nonnull) id<LYRUIIdentityNameFormatting> participantNameFormatter;

@end

@implementation LYRUIConversationItemTitleFormatter
@synthesize participantsFilter = _participantsFilter,
            participantsSorter = _participantsSorter;

- (instancetype)init {
    self = [self initWithParticipantsFilter:nil participantsSorter:nil nameFormatter:nil];
    return self;
}

- (instancetype)initWithParticipantsFilter:(LYRUIParticipantsFiltering)participantsFilter {
    self = [self initWithParticipantsFilter:participantsFilter participantsSorter:nil nameFormatter:nil];
    return self;
}

- (instancetype)initWithParticipantsFilter:(LYRUIParticipantsFiltering)participantsFilter
                        participantsSorter:(LYRUIParticipantsSorting)participantsSorter
                             nameFormatter:(id<LYRUIIdentityNameFormatting>)nameFormatter {
    self = [super init];
    if (self) {
        self.participantsFilter = participantsFilter;
        if (participantsSorter == nil) {
            participantsSorter = LYRUIParticipantsDefaultSorter();
        }
        self.participantsSorter = participantsSorter;
        if (nameFormatter == nil) {
            nameFormatter = [[LYRUIIdentityNameFormatter alloc] init];
        }
        self.participantNameFormatter = nameFormatter;
    }
    return self;
}

#pragma mark - LYRUIConversationItemTitleFormatting method

- (NSString *)titleForConversation:(LYRConversation *)conversation {
    NSString *metadataTitle = [self metadataTitleForConversation:conversation];
    if (metadataTitle && metadataTitle.length > 0) {
        return metadataTitle;
    }
    
    if (conversation.participants.count == 0) {
        return @"";
    }
    
    NSSet<LYRIdentity *> *participants = conversation.participants;
    if (self.participantsFilter) {
        participants = self.participantsFilter(conversation.participants);
    }
    if (participants.count == 1) {
        return [self.participantNameFormatter nameForIdentity:participants.anyObject];
    }
    
    NSArray *sortedParticipants = self.participantsSorter(participants);
    return [self titleWithParticipantsNames:sortedParticipants];
}

#pragma mark - Title formatting

- (nullable NSString *)metadataTitleForConversation:(nonnull LYRConversation *)conversation {
    NSCharacterSet *charactersToTrim = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *metadataTitle = conversation.metadata[LYRUIConversationItemTitleMetadataKey];
    return [metadataTitle stringByTrimmingCharactersInSet:charactersToTrim];
}

- (nonnull NSString *)titleWithParticipantsNames:(nonnull NSArray<LYRIdentity *> *)participants {
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
