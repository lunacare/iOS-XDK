#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIConfiguration+DependencyInjection.h>
#import <LayerXDK/LYRUIAvatarViewProvider.h>
#import <LayerXDK/LYRUIAvatarView.h>
#import <LayerKit/LayerKit.h>
#import <LayerXDK/LYRUIParticipantsFiltering.h>
#import <LayerXDK/LYRUIParticipantsSorting.h>
#import <LayerXDK/LYRUIMessageType.h>

@interface LYRUIAvatarViewProvider (PrivateProperties)

@property (nonatomic, strong) LYRUIParticipantsFiltering participantsFilter;

@end

SpecBegin(LYRUIIdentityItemAccessoryViewProvider)

describe(@"LYRUIAvatarViewProvider", ^{
    __block LYRUIAvatarViewProvider *provider;
    __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
    __block LYRUIAvatarView *avatarViewMock;
    
    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
        
        avatarViewMock = mock([LYRUIAvatarView class]);
        [given([injectorMock objectOfType:[LYRUIAvatarView class]]) willReturn:avatarViewMock];
        
        provider = [[LYRUIAvatarViewProvider alloc] initWithConfiguration:configurationMock];
    });
    
    afterEach(^{
        provider = nil;
    });
    
    context(@"LYRUIConversationItemAccessoryViewProviding", ^{
        __block LYRUIParticipantsFiltering participantsFilterMock;
        __block LYRUIParticipantsSorting participantsSorterMock;
        __block LYRConversation *conversationMock;
        __block NSArray<LYRIdentity *> *participants;
        
        beforeEach(^{
            LYRIdentity *identityMock1 = mock([LYRIdentity class]);
            LYRIdentity *identityMock2 = mock([LYRIdentity class]);
            LYRIdentity *identityMock3 = mock([LYRIdentity class]);
            participants = @[identityMock1, identityMock2, identityMock3];
            NSSet *participantsSet = [NSSet setWithArray:participants];
            
            participantsFilterMock = ^NSSet *(NSSet *identities) {
                return participantsSet;
            };
            [given(configurationMock.participantsFilter) willReturn:participantsFilterMock];
            participantsSorterMock = ^NSArray *(NSSet *identities) {
                return participants;
            };
            [given(configurationMock.participantsSorter) willReturn:participantsSorterMock];
            
            conversationMock = mock([LYRConversation class]);
            [given(conversationMock.participants) willReturn:participantsSet];
        });
        
        afterEach(^{
            provider = nil;
            conversationMock = nil;
            participants = nil;
        });
        
        describe(@"accessoryViewForConversation:", ^{
            __block LYRUIAvatarView *returnedView;
            
            beforeEach(^{
                returnedView = (LYRUIAvatarView *)[provider accessoryViewForConversation:conversationMock];
            });
            
            it(@"should return an `LYRUIAvatarView` from injector", ^{
                expect(returnedView).to.equal(avatarViewMock);
            });
            it(@"should setup view with identities", ^{
                [verify(avatarViewMock) setIdentities:participants];
            });
        });
        
        describe(@"setupAccessoryView:forConversation:", ^{
            beforeEach(^{
                [provider setupAccessoryView:avatarViewMock forConversation:conversationMock];
            });
            
            it(@"should setup view with identities", ^{
                [verify(avatarViewMock) setIdentities:participants];
            });
        });
    });
    
    context(@"LYRUIIdentityItemAccessoryViewProviding", ^{
        __block LYRIdentity *identityMock;
        
        beforeEach(^{
            identityMock = mock([LYRIdentity class]);
        });
        
        afterEach(^{
            identityMock = nil;
        });
        
        describe(@"accessoryViewForIdentity:", ^{
            __block LYRUIAvatarView *returnedView;
            
            beforeEach(^{
                returnedView = (LYRUIAvatarView *)[provider accessoryViewForIdentity:identityMock];
            });
            
            it(@"should return an `LYRUIAvatarView` from injector", ^{
                expect(returnedView).to.equal(avatarViewMock);
            });
            it(@"should setup view with identities", ^{
                [verify(avatarViewMock) setIdentities:@[identityMock]];
            });
        });
        
        describe(@"setupAccessoryView:forIdentity:", ^{
            beforeEach(^{
                [provider setupAccessoryView:avatarViewMock forIdentity:identityMock];
            });
            
            it(@"should setup view with identities", ^{
                [verify(avatarViewMock) setIdentities:@[identityMock]];
            });
        });
    });
    
    context(@"LYRUIMessageItemAccessoryViewProviding", ^{
        __block LYRUIMessageType *messageMock;
        __block LYRIdentity *identityMock;
        
        beforeEach(^{
            messageMock = mock([LYRUIMessageType class]);
            identityMock = mock([LYRIdentity class]);
            [given(messageMock.sender) willReturn:identityMock];
        });
        
        afterEach(^{
            identityMock = nil;
        });
        
        describe(@"accessoryViewForMessage:", ^{
            __block LYRUIAvatarView *returnedView;
            
            beforeEach(^{
                returnedView = (LYRUIAvatarView *)[provider accessoryViewForMessage:messageMock];
            });
            
            it(@"should return an `LYRUIAvatarView` from injector", ^{
                expect(returnedView).to.equal(avatarViewMock);
            });
            it(@"should setup view with identities", ^{
                [verify(avatarViewMock) setIdentities:@[identityMock]];
            });
        });
        
        describe(@"setupAccessoryView:forMessage:", ^{
            beforeEach(^{
                [provider setupAccessoryView:avatarViewMock forMessage:messageMock];
            });
            
            it(@"should setup view with identities", ^{
                [verify(avatarViewMock) setIdentities:@[identityMock]];
            });
        });
    });
});

SpecEnd
