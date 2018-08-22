//
//  LYRUIFeedbackResponseMessage.m
//  XDK Messenger
//
//  Created by Jeremy Wyld on 6/29/18.
//  Copyright © 2018 Layer, Inc. All rights reserved.
//

#import "LYRUIFeedbackResponseMessage.h"

NS_ASSUME_NONNULL_BEGIN     // {

@implementation LYRUIFeedbackResponseMessage

- (instancetype)initWithRating:(nullable NSNumber *)rating
                       comment:(nullable NSString *)comment
                        rateAt:(nullable NSDate *)ratedAt
            customResponseData:(nullable NSDictionary *)customResponseData
                        action:(nullable LYRUIMessageAction *)action
                        sender:(nullable LYRIdentity *)sender
                        sentAt:(nullable NSDate *)sentAt
                        status:(nullable LYRUIMessageTypeStatus *)status
                   messagePart:(nullable LYRMessagePart *)messagePart
{
    if ((self = [super initWithAction:action sender:sender sentAt:sentAt status:status messagePart:messagePart])) {
        _rating = rating;
        _comment = [comment copy];
        _ratedAt = ratedAt;
        _customResponseData = [customResponseData copy];
    }
    
    return self;
}

+ (NSString *)MIMEType {
    return @"application/vnd.layer.feedback-rating+json";
}

- (nullable LYRUIMessageMetadata *)metadata {
    return [[self parentMessage] metadata];
}

@end

NS_ASSUME_NONNULL_END       // }
