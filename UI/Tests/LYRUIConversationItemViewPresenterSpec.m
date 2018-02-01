#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIConfiguration+DependencyInjection.h>
#import <LayerXDK/LYRUIConversationItemViewPresenter.h>
#import <LayerXDK/LYRUIConversationItemView.h>
#import <LayerXDK/LYRUITimeFormatting.h>
#import <LayerXDK/LYRUIConversationItemTitleFormatting.h>
#import <LayerXDK/LYRUIConversationItemAccessoryViewProviding.h>
#import <LayerXDK/LYRUIMessageSerializer.h>
#import <LayerXDK/LYRUIMessageType.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIConversationItemViewPresenter)

describe(@"LYRUIConversationItemViewPresenter", ^{
    __block LYRUIConversationItemViewPresenter *viewPresenter;
    __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
    __block id<LYRUIConversationItemAccessoryViewProviding> accessoryViewProviderMock;
    __block id<LYRUIConversationItemTitleFormatting> titleFormatterMock;
    __block id<LYRUITimeFormatting> messageTimeFormatterMock;
    __block LYRUIMessageSerializer *messageSerializerMock;
    
    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
        
        accessoryViewProviderMock = mockProtocol(@protocol(LYRUIConversationItemAccessoryViewProviding));
        [given([injectorMock protocolImplementation:@protocol(LYRUIConversationItemAccessoryViewProviding)
                                                forClass:[LYRUIConversationItemViewPresenter class]])
         willReturn:accessoryViewProviderMock];
        
        titleFormatterMock = mockProtocol(@protocol(LYRUIConversationItemTitleFormatting));
        [given([injectorMock protocolImplementation:@protocol(LYRUIConversationItemTitleFormatting)
                                                forClass:[LYRUIConversationItemViewPresenter class]])
         willReturn:titleFormatterMock];
        
        messageTimeFormatterMock = mockProtocol(@protocol(LYRUITimeFormatting));
        [given([injectorMock protocolImplementation:@protocol(LYRUITimeFormatting)
                                                forClass:[LYRUIConversationItemViewPresenter class]])
         willReturn:messageTimeFormatterMock];
        
        messageSerializerMock = mock([LYRUIMessageSerializer class]);
        [given([injectorMock objectOfType:[LYRUIMessageSerializer class]]) willReturn:messageSerializerMock];
        
        viewPresenter = [[LYRUIConversationItemViewPresenter alloc] initWithConfiguration:configurationMock];
    });
    
    afterEach(^{
        viewPresenter = nil;
    });
    
    describe(@"setupConversationItemView:withConversation:", ^{
        __block LYRUIConversationItemView *view;
        __block LYRConversation *conversationMock;
        __block UIView *accessoryView;
        
        beforeEach(^{
            view = [[LYRUIConversationItemView alloc] init];
            conversationMock = mock([LYRConversation class]);
        });
        
        context(@"with nil 'view' argument", ^{
            it(@"should throw a NSInvalidArgumentException with proper reason", ^{
                void(^callWithNil)() = ^{
                    view = nil;
                    [viewPresenter setupConversationItemView:view
                                             withConversation:conversationMock];
                };
                NSString *exceptionReason = @"Cannot setup Conversation Item View with nil `view` argument.";
                expect(callWithNil).to.raiseWithReason(NSInvalidArgumentException, exceptionReason);
            });
        });
        
        context(@"with nil 'conversation' argument", ^{
            it(@"should throw a NSInvalidArgumentException with proper reason", ^{
                void(^callWithNil)() = ^{
                    conversationMock = nil;
                    [viewPresenter setupConversationItemView:view
                                             withConversation:conversationMock];
                };
                NSString *exceptionReason = @"Cannot setup Conversation Item View with nil `conversation` argument.";
                expect(callWithNil).to.raiseWithReason(NSInvalidArgumentException, exceptionReason);
            });
        });
        
        context(@"with both arguments passed", ^{
            beforeEach(^{
                LYRMessage *lastMessageMock = mock([LYRMessage class]);
                [given(conversationMock.lastMessage) willReturn:lastMessageMock];
                NSDate *lastMessageTimeMock = mock([NSDate class]);
                [given(lastMessageMock.sentAt) willReturn:lastMessageTimeMock];
                accessoryView = [[UIView alloc] init];
                
                LYRUIMessageType *messageMock = mock([LYRUIMessageType class]);
                [given(messageMock.summary) willReturn:@"test last message"];
                [given([messageSerializerMock typedMessageWithLayerMessage:lastMessageMock]) willReturn:messageMock];
                
                [given([accessoryViewProviderMock accessoryViewForConversation:conversationMock]) willReturn:accessoryView];
                [given([titleFormatterMock titleForConversation:conversationMock]) willReturn:@"test title"];
                [given([messageTimeFormatterMock stringForTime:lastMessageTimeMock
                                               withCurrentTime:anything()]) willReturn:@"test time description"];
                
                [viewPresenter setupConversationItemView:view
                                            withConversation:conversationMock];
            });
            
            it(@"should setup view with presenter", ^{
                expect(view.layerConfiguration).to.equal(configurationMock);
            });
            it(@"should set the text of titleLabel", ^{
                expect(view.titleLabel.text).to.equal(@"test title");
            });
            it(@"should set the text of messageLabel", ^{
                expect(view.subtitleLabel.text).to.equal(@"test last message");
            });
            it(@"should set the text of timeLabel", ^{
                expect(view.detailLabel.text).to.equal(@"test time description");
            });
            it(@"should set the accessory view", ^{
                expect(view.accessoryView).to.equal(accessoryView);
            });
            it(@"should add the accessory view as a subview of conversation item view", ^{
                expect(accessoryView.superview).to.equal(view.accessoryViewContainer);
            });
        });
    });
});

SpecEnd
