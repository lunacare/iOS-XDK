#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIMessageTextDefaultFormatter.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIMessageTextDefaultFormatter)

describe(@"LYRUIMessageTextDefaultFormatter", ^{
    __block LYRUIMessageTextDefaultFormatter *formatter;

    beforeEach(^{
        formatter = [[LYRUIMessageTextDefaultFormatter alloc] init];
    });

    afterEach(^{
        formatter = nil;
    });

    describe(@"stringForMessage:", ^{
        __block NSString *returnedString;
        __block LYRMessage *messageMock;
        __block LYRMessagePart *partMock;
        
        beforeEach(^{
            messageMock = mock([LYRMessage class]);
            partMock = mock([LYRMessagePart class]);
            [given(messageMock.parts) willReturn:@[partMock]];
        });
        
        context(@"when message type is text", ^{
            beforeEach(^{
                [given(partMock.MIMEType) willReturn:@"text/plain"];
                [given(partMock.data) willReturn:[@"test message" dataUsingEncoding:NSUTF8StringEncoding]];
                
                returnedString = [formatter stringForMessage:messageMock];
            });
            
            it(@"should return string created with message data", ^{
                expect(returnedString).to.equal(@"test message");
            });
        });
        
        context(@"when message type is image attachment", ^{
            beforeEach(^{
                [given(partMock.MIMEType) willReturn:@"image/png"];
                
                returnedString = [formatter stringForMessage:messageMock];
            });
            
            it(@"should return string with emoji showing an image", ^{
                expect(returnedString).to.equal(@"🏞");
            });
        });
        
        context(@"when message type is video attachment", ^{
            beforeEach(^{
                [given(partMock.MIMEType) willReturn:@"video/mp4"];
                
                returnedString = [formatter stringForMessage:messageMock];
            });
            
            it(@"should return string with emoji showing an video roll", ^{
                expect(returnedString).to.equal(@"🎞");
            });
        });
        
        context(@"when message type is unknown attachment", ^{
            beforeEach(^{
                [given(partMock.MIMEType) willReturn:@"any/other"];
                
                returnedString = [formatter stringForMessage:messageMock];
            });
            
            it(@"should return string with emoji showing an file", ^{
                expect(returnedString).to.equal(@"📄");
            });
        });
    });
});

SpecEnd
