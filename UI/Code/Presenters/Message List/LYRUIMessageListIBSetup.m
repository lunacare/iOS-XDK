//
//  LYRUIMessageListIBSetup.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 18.08.2017.
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

#import "LYRUIMessageListIBSetup.h"
#import "LYRUIMessageListView.h"
#import "LYRUIListDataSource.h"
#import "LYRUIMessageListDelegate.h"
#import "LYRUIListSection.h"
#import <LayerKit/LayerKit.h>
#import "LYRUIMessageCollectionViewCell.h"
#import "LYRUIAvatarView.h"
#import "LYRUIMessageItemIBSetup.h"
#import "LYRUIMessageItemView.h"
#import "LYRUIListHeaderView.h"
#import "LYRUIMessageListLayout.h"
#import "LYRUIMessageCellPresenter.h"
#import "LYRUIMessageListStatusSupplementaryViewPresenter.h"
#import "LYRUIConfiguration.h"

@interface LYRUIMessage : NSObject

@property (nonatomic, strong) LYRIdentity *sender;
@property (nonatomic, readonly, nullable) NSDictionary<NSString *, NSNumber *> *recipientStatusByUserID;
@property (nonatomic, readonly, nullable) NSDate *sentAt;
@property (nonatomic, nonnull) NSArray<LYRMessagePart *> *parts;

+ (instancetype)newWithSender:(LYRIdentity *)sender text:(NSString *)text;

@end

@implementation LYRUIMessage

+ (instancetype)newWithSender:(LYRIdentity *)sender text:(NSString *)text {
    LYRUIMessage *message = [LYRUIMessage new];
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithText:text];
    message.parts = @[messagePart];
    message.sender = sender;
    return message;
}

- (NSDictionary<NSString *,NSNumber *> *)recipientStatusByUserID {
    return @{ @"other user id": @3 };
}

- (NSDate *)sentAt {
    return [NSDate dateWithTimeIntervalSinceReferenceDate:0];
}

@end

@interface LYRUIIdentity : NSObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, readonly, nullable) NSURL *avatarImageURL;
@property (nonatomic, readonly, nullable) NSString *displayName;
@property (nonatomic, readonly, nullable) NSString *firstName;
@property (nonatomic, readonly, nullable) NSString *lastName;
@property (nonatomic, assign, readonly) LYRIdentityPresenceStatus presenceStatus;
@end

@implementation LYRUIIdentity
@end

@interface LYRUITestMessageCellPresenter : LYRUIMessageCellPresenter
@property (nonatomic, strong) LYRUIConfiguration *layerConfiguration;
@property (nonatomic, strong) LYRIdentity *currentUser;
@end

@implementation LYRUITestMessageCellPresenter
@synthesize layerConfiguration = _layerConfiguration;

- (NSSet<Class> *)handledItemTypes {
    return [NSSet setWithObject:[LYRUIMessage class]];
}

- (BOOL)isOutgoingMessage:(LYRMessage *)message {
    NSString *currentUserId = self.currentUser.userID;
    return [message.sender.userID isEqualToString:currentUserId];
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    [super setLayerConfiguration:layerConfiguration];
}

@end

@implementation LYRUIMessageListIBSetup

- (void)prepareMessageListForInterfaceBuilder:(LYRUIMessageListView *)messageList {
    LYRUIConfiguration *presenter = [[LYRUIConfiguration alloc] init];
    messageList.layerConfiguration = presenter;
    
    LYRUITestMessageCellPresenter *cellPresenter = [[LYRUITestMessageCellPresenter alloc] initWithConfiguration:presenter];
    
    LYRUIListDataSource *dataSource = messageList.dataSource;
    [dataSource registerCellPresenter:cellPresenter];
    
    LYRUIListDelegate *delegate = (LYRUIListDelegate *)messageList.delegate;
    [delegate registerCellSizeCalculation:cellPresenter];
    
    NSArray<NSString *> *texts = @[
            @"Lorem ipsum dolor sit amet, ne duo posse senserit, in per hinc everti. Paulo delicata ne vim. Sit tota repudiare at, an putant pertinacia nam.",

            @"Et cum vidit conceptam.",

            @"No mel mutat indoctum, no usu labore aliquip adolescens.",
            
            @"Cu aliquip aliquam electram cum.",

            @"Ut qui congue singulis, cu nec cibo magna percipitur. Et ius option voluptatum.",

            @"Autem placerat mel in, pro alterum perfecto cu, sint nonumes eu per. Ex nec aperiri assueverit, clita nominavi sed eu. Sed cu doming rationibus voluptatum, qui in possit labitur recteque. Vis nullam aliquam ut, eos id agam sale utroque. Vel ut dicit scripserit persequeris.",

            @"Vim vide facete et, ei posse torquatos eum. Vel an fastidii oportere appellantur. Vis ea nulla propriae dissentias, ius sint cibo animal eu. Duis convenire persecuti sed ex, ea eos everti scribentur dissentiunt, assueverit theophrastus ea usu.",
    ];
    
    LYRUIIdentity *currentUser = [LYRUIIdentity new];
    currentUser.userID = @"user id";
    
    presenter.participantsFilter = LYRUIParticipantsDefaultFilterWithCurrentUser((LYRIdentity *)currentUser);
    cellPresenter.currentUser = (LYRIdentity *)currentUser;
    
    LYRUIIdentity *otherUser = [LYRUIIdentity new];
    otherUser.userID = @"other user id";
    
    LYRUIListSection *section = [[LYRUIListSection<LYRConversation *> alloc] init];
    section.items = [@[
            [LYRUIMessage newWithSender:(LYRIdentity *)otherUser text:texts[0]],
            [LYRUIMessage newWithSender:(LYRIdentity *)otherUser text:texts[1]],
            [LYRUIMessage newWithSender:(LYRIdentity *)otherUser text:texts[2]],
            [LYRUIMessage newWithSender:(LYRIdentity *)currentUser text:texts[3]],
            [LYRUIMessage newWithSender:(LYRIdentity *)currentUser text:texts[4]],
            [LYRUIMessage newWithSender:(LYRIdentity *)currentUser text:texts[5]],
            [LYRUIMessage newWithSender:(LYRIdentity *)currentUser text:texts[6]],
    ] mutableCopy];
    
    dataSource.sections = [@[section] mutableCopy];
    [messageList.collectionView reloadData];
}

@end
