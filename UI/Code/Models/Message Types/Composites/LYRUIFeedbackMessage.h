//
//  LYRUIFeedbackMessage.h
//
//  Copyright © 2018 Layer, Inc. All rights reserved.
//

#import "LYRUIMessageType.h"
#import "LYRUIFeedbackResponseMessage.h"

NS_ASSUME_NONNULL_BEGIN     // {

@interface LYRUIFeedbackMessage : LYRUIMessageType

@property (nonatomic, copy, readonly, nullable) NSString *title;
@property (nonatomic, copy, readonly, nullable) NSString *promptTemplate;
@property (nonatomic, copy, readonly, nullable) NSString *promptWaitTemplate;
@property (nonatomic, copy, readonly, nullable) NSString *summaryTemplate;
@property (nonatomic, copy, readonly, nullable) NSString *responseMessageTemplate;
@property (nonatomic, copy, readonly, nullable) NSString *placeholder;
@property (nonatomic, copy, readonly) NSSet<NSString *> *enabledFor;
@property (nonatomic, copy, readonly, nonnull) NSString *responseMessageId;
@property (nonatomic, copy, readonly, nonnull) NSString *responseNodeId;

@property (nonatomic, strong, readonly) LYRUIFeedbackResponseMessage *response;

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
                  messagePart:(nullable LYRMessagePart *)messagePart NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END       // }
