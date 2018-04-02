//
//  LYRUIResponseMessage.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 05.12.2017.
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

#import "LYRUIResponseMessage.h"

@interface LYRUIResponseMessage ()

@property (nonatomic, copy, readwrite) NSString *responseTo;
@property (nonatomic, copy, readwrite) NSString *responseToNodeId;
@property (nonatomic, copy, readwrite) NSDictionary *participantData;
@property (nonatomic, copy, readwrite) NSArray *changes;
@property (nonatomic, copy, readwrite) NSString *text;

@end

@implementation LYRUIResponseMessage

- (instancetype)initWithResponseTo:(NSString *)responseTo
                  responseToNodeId:(NSString *)responseToNodeId
                   participantData:(NSDictionary *)participantData
                           changes:(NSArray *)changes
                              text:(NSString *)text
                            action:(LYRUIMessageAction *)action
                            sender:(LYRIdentity *)sender
                            sentAt:(NSDate *)sentAt
                            status:(LYRUIMessageTypeStatus *)status {
    self = [super initWithAction:action sender:sender sentAt:sentAt status:status];
    if (self) {
        self.responseTo = responseTo;
        self.responseToNodeId = responseToNodeId;
        self.participantData = participantData;
        self.changes = changes;
        self.text = text;
    }
    return self;
}

- (instancetype)initWithResponseTo:(NSString *)responseTo
                  responseToNodeId:(NSString *)responseToNodeId
                   participantData:(NSDictionary *)participantData
                           changes:(NSArray *)changes
                              text:(NSString *)text {
    self = [super init];
    if (self) {
        self.responseTo = responseTo;
        self.responseToNodeId = responseToNodeId;
        self.participantData = participantData;
        self.changes = changes;
        self.text = text;
    }
    return self;
}

+ (NSString *)MIMEType {
    return @"application/vnd.layer.response-v2+json";
}

- (NSString *)summary {
    return @"Response";
}

@end
