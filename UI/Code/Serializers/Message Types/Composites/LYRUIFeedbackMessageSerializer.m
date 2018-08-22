//
//  LYRUIFeedbackMessageSerializer.m
//
//  Copyright © 2018 Layer, Inc. All rights reserved.
//

#import "LYRUIFeedbackMessageSerializer.h"
#import "LYRUIMessageActionSerializer.h"
#import "LYRUIFeedbackResponseMessage.h"
#import "LYRUIMessageType+PrivateProperties.h"
#import "LYRUIFWWRegister.h"
#import "LYRMessagePart+LYRUIHelpers.h"

NS_ASSUME_NONNULL_BEGIN     // {

static NSString * const LYRUIFeedbackMessageSerializingTitleKey = @"title";
static NSString * const LYRUIFeedbackMessageSerializingPromptKey = @"prompt";
static NSString * const LYRUIFeedbackMessageSerializingPromptWaitKey = @"prompt_wait";
static NSString * const LYRUIFeedbackMessageSerializingPlaceholderKey = @"placeholder";
static NSString * const LYRUIFeedbackMessageSerializingEnabledForKey = @"enabled_for";

static NSString * const LYRUIFeedbackMessageSerializingResponseRatingKey = @"rating";
static NSString * const LYRUIFeedbackMessageSerializingResponseCommentKey = @"comment";
static NSString * const LYRUIFeedbackMessageSerializingResponseSentAtKey = @"sent_at";
static NSString * const LYRUIFeedbackMessageSerializingResponseCustomDataKey = @"custom_response_data";

static NSString * const LYRUIFeedbackMessageSerializingResponseSummaryRole = @"response_summary";

static NSString * const LYRUIFeedbackMessageSerializingDefaultAction = @"layer-open-expanded-view";

@implementation LYRUIFeedbackMessageSerializer

- (LYRUIFeedbackMessage *)typedMessageWithMessagePart:(LYRMessagePart *)messagePart {

    LYRUIFeedbackMessage *result = [super typedMessageWithMessagePart:messagePart];
    
    if (nil == result) {
        
        // Start unpacking the properties.
        NSDictionary *properties = [messagePart properties];
        
        NSString *title = [properties objectForKey:LYRUIFeedbackMessageSerializingTitleKey];
        if (![title isKindOfClass:[NSString class]]) {
            title = nil;
        }
        
        // **FIXME** What does this get filled with if `enabled_for` is not valid?
        NSSet<NSString *> *enabledFor = nil;
        id value = [properties objectForKey:LYRUIFeedbackMessageSerializingEnabledForKey];
        if ([value isKindOfClass:[NSString class]]) {
            enabledFor = [NSSet setWithObject:value];
        } else if ([value isKindOfClass:[NSArray class]]) {
            enabledFor = [NSSet setWithArray:value];
        }

        // Unpack the `action` with a default action of opening the message.
        LYRUIMessageAction *action = [[self actionSerializer] actionFromProperties:properties
                                                                  withDefaultEvent:LYRUIFeedbackMessageSerializingDefaultAction];
        if (!action) {
            // Only assign an action if it's enabled for the authenticated user.
            action = [[LYRUIMessageAction alloc] initWithEvent:LYRUIFeedbackMessageSerializingDefaultAction data:@{ @"message_part_id" : messagePart.identifier }];
        }
        NSNumber *rating = nil;
        NSString *comment = nil;
        NSDate *ratedAt = nil;
        NSDictionary *customResponseData = nil;
        
        LYRMessagePart *responseSummaryPart = [messagePart childPartWithRole:LYRUIFeedbackMessageSerializingResponseSummaryRole];
        NSDictionary *responseSummary = [responseSummaryPart properties];
        if (nil != responseSummary) {
            
            NSDictionary *answers = [responseSummary objectForKey:[enabledFor anyObject]];
            
            LYRUIFWWRegister<NSNumber *> *ratingReg = [[LYRUIFWWRegister alloc] initWithPropertyName:LYRUIFeedbackMessageSerializingResponseRatingKey
                                                                                          dictionary:[answers objectForKey:LYRUIFeedbackMessageSerializingResponseRatingKey]];
            id value = [[ratingReg selectedValues] firstObject];
            if ([value isKindOfClass:[NSNumber class]]) {
                rating = value;
            }
            
            LYRUIFWWRegister<NSString *> *commentReg = [[LYRUIFWWRegister alloc] initWithPropertyName:LYRUIFeedbackMessageSerializingResponseCommentKey
                                                                                           dictionary:[answers objectForKey:LYRUIFeedbackMessageSerializingResponseCommentKey]];
            value = [[commentReg selectedValues] firstObject];
            if ([value isKindOfClass:[NSString class]]) {
                comment = value;
            }

            ratedAt = messagePart.message.sentAt;
            
            LYRUIFWWRegister<NSDictionary *> *customDataReg = [[LYRUIFWWRegister alloc] initWithPropertyName:LYRUIFeedbackMessageSerializingResponseCustomDataKey
                                                                                                  dictionary:[answers objectForKey:LYRUIFeedbackMessageSerializingResponseCustomDataKey]];
            value = [[customDataReg selectedValues] firstObject];
            if ([value isKindOfClass:[NSDictionary class]]) {
                customResponseData = value;
            }
        }

        LYRMessage *message = [messagePart message];
        LYRIdentity *sender = [message sender];
        NSDate *sentAt = [message sentAt];
        LYRUIMessageTypeStatus *status = [self statusWithMessage:message];

        LYRUIFeedbackResponseMessage *response = [[LYRUIFeedbackResponseMessage alloc] initWithRating:rating
                                                                                              comment:comment
                                                                                               rateAt:ratedAt
                                                                                   customResponseData:customResponseData
                                                                                               action:action
                                                                                               sender:sender
                                                                                               sentAt:sentAt
                                                                                               status:status
                                                                                          messagePart:messagePart];

        result = [[LYRUIFeedbackMessage alloc] initWithTitle:title
                                              promptTemplate:properties[LYRUIFeedbackMessageSerializingPromptKey]
                                          promptWaitTemplate:properties[LYRUIFeedbackMessageSerializingPromptWaitKey]
                                             summaryTemplate:nil
                                     responseMessageTemplate:nil
                                                 placeholder:properties[LYRUIFeedbackMessageSerializingPlaceholderKey]
                                                    response:response
                                                  enabledFor:enabledFor
                                                      action:action
                                                      sender:sender
                                                      sentAt:sentAt
                                                      status:status
                                           responseMessageId:messagePart.message.identifier.absoluteString
                                              responseNodeId:messagePart.nodeId
                                                 messagePart:messagePart];

        [response setParentMessage:result];
    }
    
    return result;
}

- (NSArray<LYRMessagePart *> *)layerMessagePartsWithTypedMessage:(LYRUIFeedbackMessage *)message
                                                    parentNodeId:(nullable NSString *)parentNodeId
                                                            role:(nullable NSString *)role
                                              MIMETypeAttributes:(nullable NSDictionary *)MIMETypeAttributes
{
    NSArray<LYRMessagePart *> *result = [super layerMessagePartsWithTypedMessage:message
                                                                    parentNodeId:parentNodeId
                                                                            role:role
                                                              MIMETypeAttributes:MIMETypeAttributes];
    
    if (0 == [result count]) {
        
        NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
        
        // Pack the properties.
        NSString *str = [message title];
        if (0 != [str length]) {
            [json setObject:str forKey:LYRUIFeedbackMessageSerializingTitleKey];
        }
        
        // **FIXME** Pack all the other fields!
        
        // Add the `action` property after serializing it.
        [json addEntriesFromDictionary:[self.actionSerializer propertiesForAction:[message action]]];
        
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
        if (error) {
            // **FIXME** This should likely throw.  There's no real reason for failure here.
            NSLog(@"Failed to serialize message JSON object: %@", error);
            return nil;
        }
        
        NSString *mime = [self MIMETypeForContentType:[message MIMEType]
                                         parentNodeId:parentNodeId
                                                 role:role
                                           attributes:MIMETypeAttributes];
        LYRMessagePart *part = [LYRMessagePart messagePartWithMIMEType:mime data:data];
        result = @[part];
    }
    
    return result;
}

- (LYRMessageOptions *)messageOptionsForTypedMessage:(LYRUIFeedbackMessage *)message {

    LYRMessageOptions *result = [super messageOptionsForTypedMessage:message];
    
    if (nil == result) {
        // **FIXME** Need to give it push text
        result = [self defaultMessageOptionsWithPushNotificationText:@""];
    }
    
    return result;
}

@end

NS_ASSUME_NONNULL_END       // }
