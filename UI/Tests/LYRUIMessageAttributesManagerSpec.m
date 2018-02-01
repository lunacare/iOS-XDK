#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIMessageAttributesManager.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIMessageAttributesManager)

describe(@"LYRUIMessageAttributesManager", ^{
    __block LYRUIMessageAttributesManager *attributesManager;
    __block LYRMessagePart *messagePartMock1;
    __block LYRMessagePart *messagePartMock2;
    __block LYRMessagePart *messagePartMock3;
    __block LYRMessagePart *messagePartMock4;
    __block LYRMessage *messageMock;

    beforeEach(^{
        attributesManager = [[LYRUIMessageAttributesManager alloc] init];
        
        messagePartMock1 = mock([LYRMessagePart class]);
        [given(messagePartMock1.identifier) willReturn:[NSURL URLWithString:@"layer:///message/message1"]];
        messagePartMock2 = mock([LYRMessagePart class]);
        [given(messagePartMock2.identifier) willReturn:[NSURL URLWithString:@"layer:///message/message2"]];
        messagePartMock3 = mock([LYRMessagePart class]);
        [given(messagePartMock3.identifier) willReturn:[NSURL URLWithString:@"layer:///message/message3"]];
        messagePartMock4 = mock([LYRMessagePart class]);
        [given(messagePartMock4.identifier) willReturn:[NSURL URLWithString:@"layer:///message/message4"]];
        
        NSArray *parts = @[messagePartMock1, messagePartMock2, messagePartMock3, messagePartMock4];
        
        messageMock = mock([LYRMessage class]);
        [given(messageMock.parts) willReturn:parts];
        
        [given(messagePartMock1.message) willReturn:messageMock];
        [given(messagePartMock2.message) willReturn:messageMock];
        [given(messagePartMock3.message) willReturn:messageMock];
        [given(messagePartMock4.message) willReturn:messageMock];
    });

    afterEach(^{
        attributesManager = nil;
    });

    describe(@"messageRootPart:", ^{
        __block LYRMessagePart *returnValue;
        
        context(@"when there are no parts with role `root`", ^{
            beforeEach(^{
                returnValue = [attributesManager messageRootPart:messageMock];
            });
            
            it(@"should return nil", ^{
                expect(returnValue).to.beNil();
            });
        });
        context(@"when only one part has role `root`", ^{
            beforeEach(^{
                [given(messagePartMock3.MIMEType) willReturn:@"test.mime.type; role=root"];
                
                returnValue = [attributesManager messageRootPart:messageMock];
            });
            
            it(@"should return the part with role `root`", ^{
                expect(returnValue).to.equal(messagePartMock3);
            });
        });
        context(@"when multiple part have role `root`", ^{
            beforeEach(^{
                [given(messagePartMock1.MIMEType) willReturn:@"test.mime.type; role=root"];
                [given(messagePartMock3.MIMEType) willReturn:@"test.mime.type; role=root"];
                
                returnValue = [attributesManager messageRootPart:messageMock];
            });
            
            it(@"should return first found part with role `root`", ^{
                expect(returnValue).to.equal(messagePartMock1);
            });
        });
    });
    
    describe(@"messageProperties:", ^{
        __block NSDictionary *returnValue;
        
        context(@"when there are no parts with role `root`", ^{
            beforeEach(^{
                returnValue = [attributesManager messageProperties:messageMock];
            });
            
            it(@"should return nil", ^{
                expect(returnValue).to.beNil();
            });
        });
        context(@"when only one part has role `root`", ^{
            context(@"but it's not a json type part", ^{
                beforeEach(^{
                    [given(messagePartMock3.MIMEType) willReturn:@"test.mime.type; role=root"];
                    
                    returnValue = [attributesManager messageProperties:messageMock];
                });
                
                it(@"should return nil", ^{
                    expect(returnValue).to.beNil();
                });
            });
            context(@"and it's a json type part", ^{
                __block NSDictionary *json;
                
                beforeEach(^{
                    [given(messagePartMock3.MIMEType) willReturn:@"test.mime.json; role=root"];
                    json = @{ @"test" : @"json" };
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
                    [given(messagePartMock3.data) willReturn:jsonData];
                    
                    returnValue = [attributesManager messageProperties:messageMock];
                });
                
                it(@"should return the json deserialized from message part `data`", ^{
                    expect(returnValue).to.equal(json);
                });
            });
        });
    });
    
    describe(@"messagePartContentType:", ^{
        __block NSString *returnValue;
        
        context(@"when mime type is nil", ^{
            beforeEach(^{
                returnValue = [attributesManager messagePartContentType:messagePartMock1];
            });
            
            it(@"should return nil", ^{
                expect(returnValue).to.beNil();
            });
        });
        context(@"when mime type is empty string", ^{
            beforeEach(^{
                [given(messagePartMock1.MIMEType) willReturn:@""];
                returnValue = [attributesManager messagePartContentType:messagePartMock1];
            });
            
            it(@"should return empty string", ^{
                expect(returnValue).to.equal(@"");
            });
        });
        context(@"when mime type has no attributes", ^{
            beforeEach(^{
                [given(messagePartMock1.MIMEType) willReturn:@"test.mime.json"];
                returnValue = [attributesManager messagePartContentType:messagePartMock1];
            });
            
            it(@"should return `test.mime.json`", ^{
                expect(returnValue).to.equal(@"test.mime.json");
            });
        });
        context(@"when mime type contains attributes", ^{
            beforeEach(^{
                [given(messagePartMock1.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1"];
                returnValue = [attributesManager messagePartContentType:messagePartMock1];
            });
            
            it(@"should return `test.mime.json`", ^{
                expect(returnValue).to.equal(@"test.mime.json");
            });
        });
    });
    
    describe(@"messagePartMIMETypeAttributes:", ^{
        __block NSDictionary *returnValue;
        
        context(@"when mime type is nil", ^{
            beforeEach(^{
                returnValue = [attributesManager messagePartMIMETypeAttributes:messagePartMock1];
            });
            
            it(@"should return empty dictionary", ^{
                expect(returnValue).to.equal(@{});
            });
        });
        context(@"when mime type is empty string", ^{
            beforeEach(^{
                [given(messagePartMock1.MIMEType) willReturn:@""];
                returnValue = [attributesManager messagePartMIMETypeAttributes:messagePartMock1];
            });
            
            it(@"should return empty dictionary", ^{
                expect(returnValue).to.equal(@{});
            });
        });
        context(@"when mime type has no attributes", ^{
            beforeEach(^{
                [given(messagePartMock1.MIMEType) willReturn:@"test.mime.json"];
                returnValue = [attributesManager messagePartMIMETypeAttributes:messagePartMock1];
            });
            
            it(@"should return empty dictionary", ^{
                expect(returnValue).to.equal(@{});
            });
        });
        context(@"when mime type contains one attribute", ^{
            beforeEach(^{
                [given(messagePartMock1.MIMEType) willReturn:@"test.mime.json; test1=value"];
                returnValue = [attributesManager messagePartMIMETypeAttributes:messagePartMock1];
            });
            
            it(@"should return dictionary with attributes", ^{
                expect(returnValue).to.equal(@{ @"test1": @"value" });
            });
        });
        context(@"when mime type contains multiple attributes", ^{
            beforeEach(^{
                [given(messagePartMock1.MIMEType) willReturn:@"test.mime.json; test1=value; test2=value"];
                returnValue = [attributesManager messagePartMIMETypeAttributes:messagePartMock1];
            });
            
            it(@"should return dictionary with attributes", ^{
                expect(returnValue).to.equal(@{ @"test1": @"value", @"test2": @"value" });
            });
        });
        context(@"when mime type contains multiple attributes with ending semicolon", ^{
            beforeEach(^{
                [given(messagePartMock1.MIMEType) willReturn:@"test.mime.json; test1=value; test2=value;"];
                returnValue = [attributesManager messagePartMIMETypeAttributes:messagePartMock1];
            });
            
            it(@"should return dictionary with attributes", ^{
                expect(returnValue).to.equal(@{ @"test1": @"value", @"test2": @"value" });
            });
        });
        context(@"when mime type contains multiple attributes without whitespaces", ^{
            beforeEach(^{
                [given(messagePartMock1.MIMEType) willReturn:@"test.mime.json;test1=value;test2=value"];
                returnValue = [attributesManager messagePartMIMETypeAttributes:messagePartMock1];
            });
            
            it(@"should return dictionary with attributes", ^{
                expect(returnValue).to.equal(@{ @"test1": @"value", @"test2": @"value" });
            });
        });
    });
    
    describe(@"messagePartNodeId:", ^{
        __block NSString *returnValue;
        
        beforeEach(^{
            returnValue = [attributesManager messagePartNodeId:messagePartMock1];
        });
        
        it(@"should return last part of message part `identifier`", ^{
            expect(returnValue).to.equal(@"message1");
        });
    });
    
    describe(@"messagePartParentNodeId:", ^{
        __block NSString *returnValue;
        
        context(@"when mime type is nil", ^{
            beforeEach(^{
                returnValue = [attributesManager messagePartParentNodeId:messagePartMock1];
            });
            
            it(@"should return nil", ^{
                expect(returnValue).to.beNil();
            });
        });
        context(@"when mime type is empty string", ^{
            beforeEach(^{
                [given(messagePartMock1.MIMEType) willReturn:@""];
                returnValue = [attributesManager messagePartParentNodeId:messagePartMock1];
            });
            
            it(@"should return nil", ^{
                expect(returnValue).to.beNil();
            });
        });
        context(@"when mime type has no attributes", ^{
            beforeEach(^{
                [given(messagePartMock1.MIMEType) willReturn:@"test.mime.json"];
                returnValue = [attributesManager messagePartParentNodeId:messagePartMock1];
            });
            
            it(@"should return nil", ^{
                expect(returnValue).to.beNil();
            });
        });
        context(@"when mime type contains attributes without parent-node-id", ^{
            beforeEach(^{
                [given(messagePartMock1.MIMEType) willReturn:@"test.mime.json; test1=value"];
                returnValue = [attributesManager messagePartParentNodeId:messagePartMock1];
            });
            
            it(@"should return nil", ^{
                expect(returnValue).to.beNil();
            });
        });
        context(@"when mime type contains attributes with parent-node-id", ^{
            beforeEach(^{
                [given(messagePartMock1.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1"];
                returnValue = [attributesManager messagePartParentNodeId:messagePartMock1];
            });
            
            it(@"should return `message1`", ^{
                expect(returnValue).to.equal(@"message1");
            });
        });
    });
    
    describe(@"messagePartRole:", ^{
        __block NSString *returnValue;
        
        context(@"when mime type is nil", ^{
            beforeEach(^{
                returnValue = [attributesManager messagePartRole:messagePartMock1];
            });
            
            it(@"should return nil", ^{
                expect(returnValue).to.beNil();
            });
        });
        context(@"when mime type is empty string", ^{
            beforeEach(^{
                [given(messagePartMock1.MIMEType) willReturn:@""];
                returnValue = [attributesManager messagePartRole:messagePartMock1];
            });
            
            it(@"should return nil", ^{
                expect(returnValue).to.beNil();
            });
        });
        context(@"when mime type has no attributes", ^{
            beforeEach(^{
                [given(messagePartMock1.MIMEType) willReturn:@"test.mime.json"];
                returnValue = [attributesManager messagePartRole:messagePartMock1];
            });
            
            it(@"should return nil", ^{
                expect(returnValue).to.beNil();
            });
        });
        context(@"when mime type contains attributes without role", ^{
            beforeEach(^{
                [given(messagePartMock1.MIMEType) willReturn:@"test.mime.json; test1=value"];
                returnValue = [attributesManager messagePartRole:messagePartMock1];
            });
            
            it(@"should return nil", ^{
                expect(returnValue).to.beNil();
            });
        });
        context(@"when mime type contains attributes with role", ^{
            beforeEach(^{
                [given(messagePartMock1.MIMEType) willReturn:@"test.mime.json; role=root"];
                returnValue = [attributesManager messagePartRole:messagePartMock1];
            });
            
            it(@"should return `root`", ^{
                expect(returnValue).to.equal(@"root");
            });
        });
    });
    
    describe(@"messagePartChildParts:", ^{
        __block NSArray *returnValue;
        
        context(@"when there are no message child parts for the part", ^{
            beforeEach(^{
                returnValue = [attributesManager messagePartChildParts:messagePartMock1];
            });
            
            it(@"should return empty array", ^{
                expect(returnValue).to.equal(@[]);
            });
        });
        context(@"when there's one message child part for the part", ^{
            beforeEach(^{
                [given(messagePartMock3.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1"];
                returnValue = [attributesManager messagePartChildParts:messagePartMock1];
            });
            
            it(@"should return array with one message part", ^{
                expect(returnValue).to.equal(@[messagePartMock3]);
            });
        });
        context(@"when there are multiple message child parts for the part", ^{
            beforeEach(^{
                [given(messagePartMock2.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1"];
                [given(messagePartMock3.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1"];
                [given(messagePartMock4.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1"];
                returnValue = [attributesManager messagePartChildParts:messagePartMock1];
            });
        
            it(@"should return array with three message parts", ^{
                expect(returnValue).to.equal(@[messagePartMock2, messagePartMock3, messagePartMock4]);
            });
        });
    });
    
    describe(@"messagePart:childPartWithMIMEType:", ^{
        __block LYRMessagePart *returnValue;
        
        context(@"when there are no message child parts for the part", ^{
            beforeEach(^{
                returnValue = [attributesManager messagePart:messagePartMock1 childPartWithMIMEType:@"test.mime.json"];
            });
            
            it(@"should return nil", ^{
                expect(returnValue).to.beNil();
            });
        });
        context(@"when there's one message child part for the part", ^{
            beforeEach(^{
                [given(messagePartMock2.MIMEType) willReturn:@"test.mime.text; parent-node-id=message1"];
                [given(messagePartMock3.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1"];
                [given(messagePartMock4.MIMEType) willReturn:@"test.mime.text; parent-node-id=message1"];
                returnValue = [attributesManager messagePart:messagePartMock1 childPartWithMIMEType:@"test.mime.json"];
            });
            
            it(@"should return message part with given mime type", ^{
                expect(returnValue).to.equal(messagePartMock3);
            });
        });
        context(@"when there are multiple message child parts for the part", ^{
            beforeEach(^{
                [given(messagePartMock2.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1"];
                [given(messagePartMock3.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1"];
                [given(messagePartMock4.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1"];
                returnValue = [attributesManager messagePart:messagePartMock1 childPartWithMIMEType:@"test.mime.json"];
            });
            
            it(@"should return first found message part with given mime type", ^{
                expect(returnValue).to.equal(messagePartMock2);
            });
        });
    });
    
    describe(@"messagePart:childPartWithMIMEType:", ^{
        __block LYRMessagePart *returnValue;
        
        context(@"when there are no message child parts for the part", ^{
            beforeEach(^{
                returnValue = [attributesManager messagePart:messagePartMock1 childPartWithRole:@"test-role"];
            });
            
            it(@"should return nil", ^{
                expect(returnValue).to.beNil();
            });
        });
        context(@"when there's one message child part for the part", ^{
            beforeEach(^{
                [given(messagePartMock2.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1"];
                [given(messagePartMock3.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1; role=test-role"];
                [given(messagePartMock4.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1"];
                returnValue = [attributesManager messagePart:messagePartMock1 childPartWithRole:@"test-role"];
            });
            
            it(@"should return message part with given mime type", ^{
                expect(returnValue).to.equal(messagePartMock3);
            });
        });
        context(@"when there are multiple message child parts for the part", ^{
            beforeEach(^{
                [given(messagePartMock2.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1; role=test-role"];
                [given(messagePartMock3.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1; role=test-role"];
                [given(messagePartMock4.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1; role=test-role"];
                returnValue = [attributesManager messagePart:messagePartMock1 childPartWithRole:@"test-role"];
            });
            
            it(@"should return first found message part with given mime type", ^{
                expect(returnValue).to.equal(messagePartMock2);
            });
        });
    });
    
    describe(@"messagePart:childPartsWithMIMEType:", ^{
        __block NSArray *returnValue;
        
        context(@"when there are no message child parts for the part", ^{
            beforeEach(^{
                returnValue = [attributesManager messagePart:messagePartMock1 childPartsWithRole:@"test-role"];
            });
            
            it(@"should return empty array", ^{
                expect(returnValue).to.equal(@[]);
            });
        });
        context(@"when there's one message child part for the part", ^{
            beforeEach(^{
                [given(messagePartMock2.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1"];
                [given(messagePartMock3.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1; role=test-role"];
                [given(messagePartMock4.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1"];
                returnValue = [attributesManager messagePart:messagePartMock1 childPartsWithRole:@"test-role"];
            });
            
            it(@"should return array with message part with given role", ^{
                expect(returnValue).to.equal(@[messagePartMock3]);
            });
        });
        context(@"when there are multiple message child parts for the part", ^{
            beforeEach(^{
                [given(messagePartMock2.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1; role=test-role"];
                [given(messagePartMock3.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1; role=test-role"];
                [given(messagePartMock4.MIMEType) willReturn:@"test.mime.json; parent-node-id=message1; role=test-role"];
                returnValue = [attributesManager messagePart:messagePartMock1 childPartsWithRole:@"test-role"];
            });
            
            it(@"should return array with all message parts with given role", ^{
                expect(returnValue).to.equal(@[messagePartMock2, messagePartMock3, messagePartMock4]);
            });
        });
    });
    
    describe(@"messagePartProperties:", ^{
        __block NSDictionary *returnValue;
        
        context(@"when part is not a json type part", ^{
            beforeEach(^{
                [given(messagePartMock1.MIMEType) willReturn:@"test.mime.type; role=root"];
                NSDictionary *json = @{ @"test" : @"json" };
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
                [given(messagePartMock1.data) willReturn:jsonData];
                
                returnValue = [attributesManager messagePartProperties:messagePartMock1];
            });
            
            it(@"should return nil", ^{
                expect(returnValue).to.beNil();
            });
        });
        context(@"when part is a json type part", ^{
            context(@"but doesn't contain json `data`", ^{
                __block NSDictionary *json;
                
                beforeEach(^{
                    [given(messagePartMock1.MIMEType) willReturn:@"test.mime.json; role=root"];
                    
                    returnValue = [attributesManager messagePartProperties:messagePartMock1];
                });
                
                it(@"should return the json deserialized from message part `data`", ^{
                    expect(returnValue).to.equal(json);
                });
            });
            context(@"and contains json `data`", ^{
                __block NSDictionary *json;
                
                beforeEach(^{
                    [given(messagePartMock1.MIMEType) willReturn:@"test.mime.json; role=root"];
                    json = @{ @"test" : @"json" };
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
                    [given(messagePartMock1.data) willReturn:jsonData];
                    
                    returnValue = [attributesManager messagePartProperties:messagePartMock1];
                });
                
                it(@"should return the json deserialized from message part `data`", ^{
                    expect(returnValue).to.equal(json);
                });
            });
        });
    });
});

SpecEnd
