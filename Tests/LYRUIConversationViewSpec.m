#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIConfiguration+DependencyInjection.h>
#import <Atlas/LYRUIConversationView.h>
#import <Atlas/LYRUIMessageListView.h>
#import <Atlas/LYRUIComposeBar.h>
#import <Atlas/LYRUIMessageSender.h>
#import <LayerKit/LayerKit.h>
#import <Atlas/LYRUIMessageListQueryControllerDelegate.h>
#import <Atlas/LYRUIMessageListPaginationController.h>

SpecBegin(LYRUIConversationView)

describe(@"LYRUIConversationView", ^{
    __block LYRUIConversationView *conversationView;
    __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
    __block LYRUIMessageSender *messageSenderMock;
    __block LYRClient *clientMock;

    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
        
        messageSenderMock = mock([LYRUIMessageSender class]);
        [given([injectorMock objectOfType:[LYRUIMessageSender class]]) willReturn:messageSenderMock];
        
        clientMock = mock([LYRClient class]);
        [given(configurationMock.client) willReturn:clientMock];
        
        conversationView = [[LYRUIConversationView alloc] initWithConfiguration:configurationMock];
    });

    afterEach(^{
        conversationView = nil;
    });

    describe(@"after initialization", ^{
        it(@"should have message list set", ^{
            expect(conversationView.messageListView).to.beAKindOf([LYRUIMessageListView class]);
        });
        it(@"should have message list added as a subview", ^{
            expect(conversationView.messageListView.superview).to.equal(conversationView);
        });
        it(@"should have compose bar set", ^{
            expect(conversationView.composeBar).to.beAKindOf([LYRUIComposeBar class]);
        });
        it(@"should have compose bar added as a subview", ^{
            expect(conversationView.composeBar.superview).to.equal(conversationView);
        });
        it(@"should have message sender set", ^{
            expect(conversationView.messageSender).to.equal(messageSenderMock);
        });
    });
    
    describe(@"setConversation:", ^{
        __block LYRConversation *conversationMock;
        __block LYRQueryController *queryControllerMock;
        
        beforeEach(^{
            conversationMock = mock([LYRConversation class]);
            queryControllerMock = mock([LYRQueryController class]);
            
            [[given([clientMock queryControllerWithQuery:anything() error:nil])
              withMatcher:anything() forArgument:1]
             willReturn:queryControllerMock];
            
            [[given([queryControllerMock execute:nil]) withMatcher:anything()] willReturnBool:YES];
            
            conversationView.conversation = conversationMock;
        });
        
        it(@"should set up the message list view with provided conversation", ^{
            expect(conversationView.messageListView.conversation).to.equal(conversationMock);
        });
        it(@"should set up the message list view's query controller", ^{
            expect(conversationView.messageListView.queryController).to.equal(queryControllerMock);
        });
        it(@"should set query controller's delegate", ^{
            [verify(queryControllerMock) setDelegate:isNot(nil)];
        });
        it(@"should set up message sender with provided conversation", ^{
            [verify(messageSenderMock) setConversation:conversationMock];
        });
    });
    
    describe(@"setupWithQueryController:client:", ^{
        __block LYRQueryController *queryControllerMock;
        __block LYRConversation *conversationMock;
        __block LYRUIMessageListQueryControllerDelegate *queryControllerDelegateMock;
        __block LYRUIMessageListPaginationController *paginationControllerMock;
        
        beforeEach(^{
            queryControllerMock = mock([LYRQueryController class]);
            
            LYRQuery *queryMock = mock([LYRQuery class]);
            [given(queryControllerMock.query) willReturn:queryMock];
            
            LYRPredicate *predicateMock = mock([LYRPredicate class]);
            [given(queryMock.predicate) willReturn:predicateMock];
            
            conversationMock = mock([LYRConversation class]);
            [given(predicateMock.property) willReturn:@"conversation"];
            [given(predicateMock.value) willReturn:conversationMock];
            
            queryControllerDelegateMock = mock([LYRUIMessageListQueryControllerDelegate class]);
            [given([injectorMock objectOfType:[LYRUIMessageListQueryControllerDelegate class]])
             willReturn:queryControllerDelegateMock];
            
            paginationControllerMock = mock([LYRUIMessageListPaginationController class]);
            [given([injectorMock objectOfType:[LYRUIMessageListPaginationController class]])
             willReturn:paginationControllerMock];
            [given(paginationControllerMock.conversation) willReturn:conversationMock];
            
            conversationView.queryController = queryControllerMock;
        });
        
        it(@"should set message list view's query controller", ^{
            expect(conversationView.messageListView.queryController).to.equal(queryControllerMock);
        });
        it(@"should set query controller's delegate", ^{
            [verify(queryControllerMock) setDelegate:queryControllerDelegateMock];
        });
        it(@"should extract conversation from query controller's query predicate, and set in message list", ^{
            expect(conversationView.messageListView.conversation).to.equal(conversationMock);
        });
        it(@"should extract conversation from query controller's query predicate, and set in message list", ^{
            [verify(messageSenderMock) setConversation:conversationMock];
        });
        it(@"should execute the query controller", ^{
            [verify(queryControllerMock) execute:nil];
        });
    });
});

SpecEnd
