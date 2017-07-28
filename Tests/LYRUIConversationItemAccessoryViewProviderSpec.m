#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIConversationItemAccessoryViewProvider.h>
#import <Atlas/LYRUIAvatarView.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIConversationItemAccessoryViewProvider)

describe(@"LYRUIConversationItemAccessoryViewProvider", ^{
    __block LYRUIConversationItemAccessoryViewProvider *provider;
    __block LYRConversation *conversationMock;
    __block NSArray<LYRIdentity *> *identities;
    
    beforeEach(^{
        provider = [[LYRUIConversationItemAccessoryViewProvider alloc] init];
        conversationMock = mock([LYRConversation class]);
        LYRIdentity *identityMock1 = mock([LYRIdentity class]);
        LYRIdentity *identityMock2 = mock([LYRIdentity class]);
        LYRIdentity *identityMock3 = mock([LYRIdentity class]);
        identities = @[identityMock1, identityMock2, identityMock3];
        [given(conversationMock.participants) willReturn:[NSSet setWithArray:identities]];
    });
    
    afterEach(^{
        provider = nil;
        conversationMock = nil;
        identities = nil;
    });
    
    describe(@"accessoryViewForConversation:", ^{
        __block LYRUIAvatarView *returnedView;
        
        beforeEach(^{
            returnedView = (LYRUIAvatarView *)[provider accessoryViewForConversation:conversationMock];
        });
        
        it(@"should return an `LYRUIAvatarView`", ^{
            expect(returnedView).to.beAKindOf([LYRUIAvatarView class]);
        });
        it(@"should disable translating autoresizing mask into constraints", ^{
            expect(returnedView.translatesAutoresizingMaskIntoConstraints).to.beFalsy();
        });
        it(@"should setup view with identities", ^{
            assertThat(returnedView.identities, containsInAnyOrderIn(identities));
        });
    });
    
    describe(@"setupAccessoryView:forConversation:", ^{
        __block LYRUIAvatarView *view;
        
        beforeEach(^{
            view = [[LYRUIAvatarView alloc] init];
            [provider setupAccessoryView:view forConversation:conversationMock];
        });
        
        it(@"should setup view with identities", ^{
            assertThat(view.identities, containsInAnyOrderIn(identities));
        });
    });
});

SpecEnd
