#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIConfiguration+DependencyInjection.h>
#import <Atlas/LYRUIMessageSender.h>
#import <CoreLocation/CoreLocation.h>
#import <LayerKit/LayerKit.h>
#import <Atlas/ATLMediaAttachment.h>

SpecBegin(LYRUIMessageSender)

describe(@"LYRUIMessageSender", ^{
    __block LYRUIMessageSender *messageSender;
    __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
    __block LYRClient *clientMock;
    __block LYRConversation *conversationMock;
    __block LYRIdentity *authenticatedUserMock;
    __block NSMutableArray *messageMocks;

    beforeAll(^{
        messageMocks = [[NSMutableArray alloc] init]; // Fix for crashing MKTInvocation dealloc
    });
    
    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
        
        messageSender = [[LYRUIMessageSender alloc] initWithConfiguration:configurationMock];
        
        clientMock = mock([LYRClient class]);
        [[given([clientMock newMessageWithParts:anything() options:anything() error:NULL])
          withMatcher:anything() forArgument:2]
         willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
             LYRMessage *message = mock([LYRMessage class]);
             [messageMocks addObject:message];
             return message;
         }];
        [given(configurationMock.client) willReturn:clientMock];
        authenticatedUserMock = mock([LYRIdentity class]);
        [given(authenticatedUserMock.displayName) willReturn:@"Sender Name"];
        [given(clientMock.authenticatedUser) willReturn:authenticatedUserMock];
        conversationMock = mock([LYRConversation class]);
        messageSender.conversation = conversationMock;
        [[given([conversationMock sendMessage:anything() error:NULL]) withMatcher:anything() forArgument:1]
         willReturnBool:YES];
    });

    afterEach(^{
        messageSender = nil;
        clientMock = nil;
        conversationMock = nil;
    });
    
    describe(@"sendMessageWithAttributedString:", ^{
        __block ATLMediaAttachment *attachment;
        
        beforeEach(^{
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"some text\n"];
            NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
            UIImage *image = [UIImage imageNamed:@"test-logo" inBundle:testBundle compatibleWithTraitCollection:nil];
            attachment = [ATLMediaAttachment mediaAttachmentWithImage:image metadata:nil thumbnailSize:50];
            [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
            [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\nsome more text"]];
            
            [messageSender sendMessageWithAttributedString:attributedString];
        });
        
        it(@"should send message in conversation", ^{
            [[verifyCount(conversationMock, times(3)) withMatcher:anything() forArgument:1] sendMessage:anything() error:NULL];
        });
        
        context(@"first message", ^{
            __block NSArray *messageParts;
            __block LYRMessageOptions *messageOptions;
            
            beforeEach(^{
                HCArgumentCaptor *messagePartsArgument = [HCArgumentCaptor new];
                HCArgumentCaptor *messageOptionsArgument = [HCArgumentCaptor new];
                [[verifyCount(clientMock, times(3)) withMatcher:anything() forArgument:2] newMessageWithParts:(id)messagePartsArgument
                                                                                       options:(id)messageOptionsArgument
                                                                                         error:NULL];
                messageParts = messagePartsArgument.allValues[0];
                messageOptions = messageOptionsArgument.allValues[0];
            });
            
            context(@"parts", ^{
                it(@"should contain one message part", ^{
                    expect(messageParts).to.haveCount(1);
                });
                
                context(@"first part", ^{
                    __block LYRMessagePart *messagePart;
                    
                    beforeEach(^{
                        messagePart = messageParts[0];
                    });
                    
                    it(@"should have text/plain mime type", ^{
                        expect(messagePart.MIMEType).to.equal(@"text/plain");
                    });
                    it(@"should contain message text converted to data", ^{
                        NSData *expectedData = [@"some text" dataUsingEncoding:NSUTF8StringEncoding];
                        expect(messagePart.data).to.equal(expectedData);
                    });
                });
            });
            
            context(@"options", ^{
                it(@"should have proper push notification alert set", ^{
                    expect(messageOptions.pushNotificationConfiguration.alert).to.equal(@"Sender Name: some text");
                });
            });
        });
        
        context(@"second message", ^{
            __block NSArray *messageParts;
            __block LYRMessageOptions *messageOptions;
            
            beforeEach(^{
                HCArgumentCaptor *messagePartsArgument = [HCArgumentCaptor new];
                HCArgumentCaptor *messageOptionsArgument = [HCArgumentCaptor new];
                [[verifyCount(clientMock, times(3)) withMatcher:anything() forArgument:2] newMessageWithParts:(id)messagePartsArgument
                                                                                                      options:(id)messageOptionsArgument
                                                                                                        error:NULL];
                messageParts = messagePartsArgument.allValues[1];
                messageOptions = messageOptionsArgument.allValues[1];
            });
            
            context(@"parts", ^{
                it(@"should contain three message part", ^{
                    expect(messageParts).to.haveCount(3);
                });
                
                context(@"first part", ^{
                    __block LYRMessagePart *messagePart;
                    
                    beforeEach(^{
                        messagePart = messageParts[0];
                    });
                    
                    it(@"should have image/jpeg mime type", ^{
                        expect(messagePart.MIMEType).to.equal(@"image/jpeg");
                    });
                    it(@"should have input stream set to attachment's media input stream", ^{
                        expect(messagePart.inputStream).to.equal(attachment.mediaInputStream);
                    });
                });
                
                context(@"second part", ^{
                    __block LYRMessagePart *messagePart;
                    
                    beforeEach(^{
                        messagePart = messageParts[1];
                    });
                    
                    it(@"should have image/jpeg+preview mime type", ^{
                        expect(messagePart.MIMEType).to.equal(@"image/jpeg+preview");
                    });
                    it(@"should have input stream set to attachment's thumbnail input stream", ^{
                        expect(messagePart.inputStream).to.equal(attachment.thumbnailInputStream);
                    });
                });
                
                context(@"third part", ^{
                    __block LYRMessagePart *messagePart;
                    
                    beforeEach(^{
                        messagePart = messageParts[2];
                    });
                    
                    it(@"should have application/json+imageSize mime type", ^{
                        expect(messagePart.MIMEType).to.equal(@"application/json+imageSize");
                    });
                    it(@"should have input stream set to attachment's metadata input stream", ^{
                        expect(messagePart.inputStream).to.equal(attachment.metadataInputStream);
                    });
                });
            });
            
            context(@"options", ^{
                it(@"should have proper push notification alert set", ^{
                    expect(messageOptions.pushNotificationConfiguration.alert).to.equal(@"Sender Name sent you a photo.");
                });
            });
        });
        
        context(@"third message", ^{
            __block NSArray *messageParts;
            __block LYRMessageOptions *messageOptions;
            
            beforeEach(^{
                HCArgumentCaptor *messagePartsArgument = [HCArgumentCaptor new];
                HCArgumentCaptor *messageOptionsArgument = [HCArgumentCaptor new];
                [[verifyCount(clientMock, times(3)) withMatcher:anything() forArgument:2] newMessageWithParts:(id)messagePartsArgument
                                                                                                      options:(id)messageOptionsArgument
                                                                                                        error:NULL];
                messageParts = messagePartsArgument.allValues[2];
                messageOptions = messageOptionsArgument.allValues[2];
            });
            
            context(@"parts", ^{
                it(@"should contain one message part", ^{
                    expect(messageParts).to.haveCount(1);
                });
                
                context(@"first part", ^{
                    __block LYRMessagePart *messagePart;
                    
                    beforeEach(^{
                        messagePart = messageParts[0];
                    });
                    
                    it(@"should have text/plain mime type", ^{
                        expect(messagePart.MIMEType).to.equal(@"text/plain");
                    });
                    it(@"should contain message text converted to data", ^{
                        NSData *expectedData = [@"some more text" dataUsingEncoding:NSUTF8StringEncoding];
                        expect(messagePart.data).to.equal(expectedData);
                    });
                });
            });
            
            context(@"options", ^{
                it(@"should have proper push notification alert set", ^{
                    expect(messageOptions.pushNotificationConfiguration.alert).to.equal(@"Sender Name: some more text");
                });
            });
        });
    });
});

SpecEnd
