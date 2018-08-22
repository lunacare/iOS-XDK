//
//  LYRUIFeedbackResponseMessage.h
//  XDK Messenger
//
//  Created by Jeremy Wyld on 6/29/18.
//  Copyright © 2018 Layer, Inc. All rights reserved.
//

#import "LYRUIMessageType.h"

NS_ASSUME_NONNULL_BEGIN     // {

@interface LYRUIFeedbackResponseMessage : LYRUIMessageType

@property (nonatomic, copy, readonly, nullable) NSNumber *rating;
@property (nonatomic, copy, readonly, nullable) NSString *comment;
@property (nonatomic, strong, readonly, nullable) NSDate *ratedAt;
@property (nonatomic, copy, readonly, nullable) NSDictionary *customResponseData;

- (instancetype)initWithRating:(nullable NSNumber *)rating
                       comment:(nullable NSString *)comment
                        rateAt:(nullable NSDate *)ratedAt
            customResponseData:(nullable NSDictionary *)customResponseData
                        action:(nullable LYRUIMessageAction *)action
                        sender:(nullable LYRIdentity *)sender
                        sentAt:(nullable NSDate *)sentAt
                        status:(nullable LYRUIMessageTypeStatus *)status
                   messagePart:(nullable LYRMessagePart *)messagePart;

@end

NS_ASSUME_NONNULL_END       // }
