#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIAvatarViewProvider.h>
#import <Atlas/LYRUIAvatarView.h>
#import <LayerKit/LayerKit.h>
#import <Atlas/LYRUIParticipantsFiltering.h>
#import <Atlas/LYRUIParticipantsSorting.h>

@interface LYRUIAvatarViewProvider (PrivateProperties)

@property (nonatomic, strong) LYRUIParticipantsFiltering participantsFilter;

@end

SpecBegin(LYRUIIdentityItemAccessoryViewProvider)

describe(@"LYRUIAvatarViewProvider", ^{
    __block LYRUIAvatarViewProvider *provider;
    
    beforeEach(^{
        provider = [[LYRUIAvatarViewProvider alloc] init];
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
            participantsSorterMock = ^NSArray *(NSSet *identities) {
                return participants;
            };
            provider = [[LYRUIAvatarViewProvider alloc] initWithParticipantsFilter:participantsFilterMock
                                                                participantsSorter:participantsSorterMock];
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
            
            it(@"should return an `LYRUIAvatarView`", ^{
                expect(returnedView).to.beAKindOf([LYRUIAvatarView class]);
            });
            it(@"should disable translating autoresizing mask into constraints", ^{
                expect(returnedView.translatesAutoresizingMaskIntoConstraints).to.beFalsy();
            });
            it(@"should setup view with identities", ^{
                expect(returnedView.identities).to.equal(participants);
            });
        });
        
        describe(@"setupAccessoryView:forConversation:", ^{
            __block LYRUIAvatarView *view;
            
            beforeEach(^{
                view = [[LYRUIAvatarView alloc] init];
                [provider setupAccessoryView:view forConversation:conversationMock];
            });
            
            it(@"should setup view with identities", ^{
                expect(view.identities).to.equal(participants);
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
            
            it(@"should return an `LYRUIAvatarView`", ^{
                expect(returnedView).to.beAKindOf([LYRUIAvatarView class]);
            });
            it(@"should disable translating autoresizing mask into constraints", ^{
                expect(returnedView.translatesAutoresizingMaskIntoConstraints).to.beFalsy();
            });
            it(@"should setup view with identity", ^{
                expect(returnedView.identities).to.equal(@[identityMock]);
            });
        });
        
        describe(@"setupAccessoryView:forIdentity:", ^{
            __block LYRUIAvatarView *view;
            
            beforeEach(^{
                view = [[LYRUIAvatarView alloc] init];
                [provider setupAccessoryView:view forIdentity:identityMock];
            });
            
            it(@"should setup view with identity", ^{
                expect(view.identities).to.equal(@[identityMock]);
            });
        });
    });
    
    context(@"LYRUIMessageItemAccessoryViewProviding", ^{
        __block LYRMessage *messageMock;
        __block LYRIdentity *identityMock;
        
        beforeEach(^{
            messageMock = mock([LYRMessage class]);
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
            
            it(@"should return an `LYRUIAvatarView`", ^{
                expect(returnedView).to.beAKindOf([LYRUIAvatarView class]);
            });
            it(@"should disable translating autoresizing mask into constraints", ^{
                expect(returnedView.translatesAutoresizingMaskIntoConstraints).to.beFalsy();
            });
            it(@"should setup view with identity", ^{
                expect(returnedView.identities).to.equal(@[identityMock]);
            });
        });
        
        describe(@"setupAccessoryView:forMessage:", ^{
            __block LYRUIAvatarView *view;
            
            beforeEach(^{
                view = [[LYRUIAvatarView alloc] init];
                [provider setupAccessoryView:view forMessage:messageMock];
            });
            
            it(@"should setup view with identity", ^{
                expect(view.identities).to.equal(@[identityMock]);
            });
        });
    });
});

SpecEnd
