//
//  LYRUIFeedbackMessage.m
//
//  Copyright © 2018 Layer, Inc. All rights reserved.
//

#import "LYRUIFeedbackMessage.h"

NS_ASSUME_NONNULL_BEGIN     // {

@implementation LYRUIFeedbackMessage

- (instancetype)initWithTitle:(nullable NSString *)title
               promptTemplate:(nullable NSString *)promptTemplate
           promptWaitTemplate:(nullable NSString *)promptWaitTemplate
              summaryTemplate:(nullable NSString *)summaryTemplate
      responseMessageTemplate:(nullable NSString *)responseMessageTemplate
                  placeholder:(nullable NSString *)placeholder
                     response:(LYRUIFeedbackResponseMessage *)response
                   enabledFor:(NSSet<NSString *> *)enabledFor
                       action:(nullable LYRUIMessageAction *)action
                       sender:(nullable LYRIdentity *)sender
                       sentAt:(nullable NSDate *)sentAt
                       status:(nullable LYRUIMessageTypeStatus *)status
            responseMessageId:(nonnull NSString *)responseMessageId
               responseNodeId:(nonnull NSString *)responseNodeId
                  messagePart:(nullable LYRMessagePart *)messagePart
{
    if (nil == action) {
        // **FIXME** Set up the default action
    }
    
    if ((self = [super initWithAction:action sender:sender sentAt:sentAt status:status messagePart:messagePart])) {
        _title = [title copy];
        _promptTemplate = [promptTemplate copy];
        _promptWaitTemplate = [promptWaitTemplate copy];
        _summaryTemplate = [summaryTemplate copy];
        _responseMessageTemplate = [responseMessageTemplate copy];
        _placeholder = [placeholder copy];
        _enabledFor = [enabledFor copy];
        _response = response;
        _responseMessageId = responseMessageId;
        _responseNodeId = responseNodeId;
    }
    
    return self;
}

+ (NSString *)MIMEType {
    return @"application/vnd.layer.feedback+json";
}

- (NSString *)summary {
    
    // Try to use the title if provided, otherwise fall back to a static constant.
    NSString *result = [self title];
    
    if (0 == [result length]) {
        result = @"Rate your experience 1-5 stars";
    }
    
    return result;
}

- (nullable LYRUIMessageMetadata *)metadata {
    
    LYRUIMessageMetadata *result = [super metadata];
    
    if (nil == result) {
        
        NSString *title = [self title];
        if (0 == [title length]) {
            title = @"Experience Rating";
        }
        
        result = [[LYRUIMessageMetadata alloc] initWithDescription:nil title:title footer:nil];
    }
    
    return result;
}

@end

NS_ASSUME_NONNULL_END       // }
