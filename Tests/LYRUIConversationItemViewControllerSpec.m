#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIConversationItemViewController.h>
#import <Atlas/LYRUIConversationItemView.h>
#import <Atlas/LYRUIMessageTimeDefaultFormatter.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIConversationItemViewController)

describe(@"LYRUIConversationItemViewController", ^{
    __block LYRUIConversationItemViewController *viewController;
    __block id<LYRUIConversationItemAccessoryViewProviding> accessoryViewProviderMock;
    __block id<LYRUIConversationItemTitleFormatting> titleFormatterMock;
    __block id<LYRUIConversationItemLastMessageFormatting> lastMessageFormatterMock;
    __block id<LYRUIMessageTimeFormatting> messageTimeFormatterMock;
    
    beforeEach(^{
        accessoryViewProviderMock = mockProtocol(@protocol(LYRUIConversationItemAccessoryViewProviding));
        titleFormatterMock = mockProtocol(@protocol(LYRUIConversationItemTitleFormatting));
        lastMessageFormatterMock = mockProtocol(@protocol(LYRUIConversationItemLastMessageFormatting));
        messageTimeFormatterMock = mockProtocol(@protocol(LYRUIMessageTimeFormatting));
        
        viewController = [[LYRUIConversationItemViewController alloc] initWithAccessoryViewProvider:accessoryViewProviderMock
                                                                                     titleFormatter:titleFormatterMock
                                                                               lastMessageFormatter:lastMessageFormatterMock
                                                                                      messageTimeFormatter:messageTimeFormatterMock];
    });
    
    afterEach(^{
        viewController = nil;
    });
    
    describe(@"after initialization with convenience initializer", ^{
        beforeEach(^{
            viewController = [[LYRUIConversationItemViewController alloc] init];
        });
        
        it(@"should have default message time formatter set", ^{
            expect(viewController.messageTimeFormatter).to.beAKindOf([LYRUIMessageTimeDefaultFormatter class]);
        });
    });
    
    describe(@"setupConversationItemView:withConversation:", ^{
        __block LYRUIConversationItemView *view;
        __block LYRConversation *conversationMock;
        __block UIView *accessoryView;
        
        beforeEach(^{
            view = [[LYRUIConversationItemView alloc] init];
            conversationMock = mock([LYRConversation class]);
            LYRMessage *lastMessageMock = mock([LYRMessage class]);
            [given(conversationMock.lastMessage) willReturn:lastMessageMock];
            NSDate *lastMessageTimeMock = mock([NSDate class]);
            [given(lastMessageMock.sentAt) willReturn:lastMessageTimeMock];
            accessoryView = [[UIView alloc] init];
            
            [given([accessoryViewProviderMock accessoryViewForConversation:conversationMock]) willReturn:accessoryView];
            [given([titleFormatterMock titleForConversation:conversationMock]) willReturn:@"test title"];
            [given([lastMessageFormatterMock stringForConversationLastMessage:lastMessageMock]) willReturn:@"test last message"];
            [given([messageTimeFormatterMock stringForMessageTime:lastMessageTimeMock
                                                  withCurrentTime:anything()]) willReturn:@"test time description"];
            
            [viewController setupConversationItemView:view
                                     withConversation:conversationMock];
        });
        
        it(@"should set the text of conversationTitleLabel", ^{
            expect(view.conversationTitleLabel.text).to.equal(@"test title");
        });
        it(@"should set the text of lastMessageLabel", ^{
            expect(view.lastMessageLabel.text).to.equal(@"test last message");
        });
        it(@"should set the text of dateLabel", ^{
            expect(view.dateLabel.text).to.equal(@"test time description");
        });
        it(@"should set the accessory view", ^{
            expect(view.accessoryView).to.equal(accessoryView);
        });
        it(@"should add the accessory view as a subview of conversation item view", ^{
            expect(accessoryView.superview).to.equal(view);
        });
    });
});

SpecEnd
