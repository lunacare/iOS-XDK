#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIConfiguration+DependencyInjection.h>
#import <LayerXDK/LYRUIAvatarViewPresenter.h>
#import <LayerXDK/LYRUIAvatarView+PrivateProperties.h>
#import <LayerXDK/LYRUIAvatarViewSingleLayout.h>
#import <LayerXDK/LYRUIAvatarViewMultiLayout.h>
#import <LayerXDK/LYRUIImageWithLettersView.h>
#import <LayerXDK/LYRUIImageWithLettersViewPresenter.h>
#import <LayerXDK/LYRUIPresenceView.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIAvatarViewPresenter)

describe(@"LYRUIAvatarViewPresenter", ^{
    __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
    __block LYRUIAvatarViewPresenter *presenter;
    __block LYRUIImageWithLettersView *primaryAvatarViewMock;
    __block LYRUIImageWithLettersView *secondaryAvatarViewMock;
    __block LYRUIPresenceView *presenceViewMock;
    __block LYRUIImageWithLettersViewPresenter *avatarViewPresenterMock;
    __block LYRUIAvatarView *viewMock;
    
    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
        
        viewMock = mock([LYRUIAvatarView class]);
        primaryAvatarViewMock = mock([LYRUIImageWithLettersView class]);
        [given(viewMock.primaryAvatarView) willReturn:primaryAvatarViewMock];
        secondaryAvatarViewMock = mock([LYRUIImageWithLettersView class]);
        [given(viewMock.secondaryAvatarView) willReturn:secondaryAvatarViewMock];
        presenceViewMock = mock([LYRUIPresenceView class]);
        [given(viewMock.presenceView) willReturn:presenceViewMock];
        
        avatarViewPresenterMock = mock([LYRUIImageWithLettersViewPresenter class]);
        [given([injectorMock presenterForViewClass:[LYRUIImageWithLettersView class]]) willReturn:avatarViewPresenterMock];
        
        presenter = [[LYRUIAvatarViewPresenter alloc] initWithConfiguration:configurationMock];
    });
    
    afterEach(^{
        presenter = nil;
        avatarViewPresenterMock = nil;
        viewMock = nil;
    });
    
    describe(@"setupAvatarView:withIdentities:", ^{
        __block LYRIdentity *identityMock1;
        __block LYRIdentity *identityMock2;
        __block LYRIdentity *identityMock3;
        
        beforeEach(^{
            identityMock1 = mock([LYRIdentity class]);
            identityMock2 = mock([LYRIdentity class]);
            identityMock3 = mock([LYRIdentity class]);
        });
        
        context(@"with single identity", ^{
            beforeEach(^{
                [presenter setupAvatarView:viewMock withIdentities:@[identityMock1]];
            });
            
            it(@"should configure primary avatar view with the identity", ^{
                [verify(avatarViewPresenterMock) setupImageWithLettersView:primaryAvatarViewMock withIdentity:identityMock1];
            });
            it(@"should configure presence view with the identity", ^{
                [verify(viewMock.presenceView) setIdentities:@[identityMock1]];
            });
            it(@"should set primary avatar view border width to 0", ^{
                [verify(viewMock.primaryAvatarView) setBorderWidth:0.0];
            });
            it(@"should update view layout to single avatar layout", ^{
                [verify(viewMock) setLayout:isA([LYRUIAvatarViewSingleLayout class])];
            });
        });
        
        context(@"with two identities", ^{
            beforeEach(^{
                [presenter setupAvatarView:viewMock withIdentities:@[identityMock1, identityMock2]];
            });
            
            it(@"should configure primary avatar view with the first identity", ^{
                [verify(avatarViewPresenterMock) setupImageWithLettersView:primaryAvatarViewMock withIdentity:identityMock1];
            });
            it(@"should configure secondary avatar view with the first identity", ^{
                [verify(avatarViewPresenterMock) setupImageWithLettersView:secondaryAvatarViewMock withIdentity:identityMock2];
            });
            it(@"should configure presence view with the identities", ^{
                [verify(viewMock.presenceView) setIdentities:@[identityMock1, identityMock2]];
            });
            it(@"should set primary avatar view border width to 2", ^{
                [verify(viewMock.primaryAvatarView) setBorderWidth:2.0];
            });
            it(@"should update view layout to multiple avatar layout", ^{
                [verify(viewMock) setLayout:isA([LYRUIAvatarViewMultiLayout class])];
            });
        });
        
        context(@"with more than two identities", ^{
            beforeEach(^{
                [presenter setupAvatarView:viewMock withIdentities:@[identityMock1, identityMock2, identityMock3]];
            });
            
            it(@"should configure primary avatar view with the first identity", ^{
                [verify(avatarViewPresenterMock) setupImageWithLettersView:primaryAvatarViewMock withIdentity:identityMock1];
            });
            it(@"should configure secondary avatar view with the multiple participants icon", ^{
                [verify(avatarViewPresenterMock) setupImageWithLettersViewWithMultipleParticipantsIcon:secondaryAvatarViewMock];
            });
            it(@"should configure presence view with the identities", ^{
                [verify(viewMock.presenceView) setIdentities:@[identityMock1, identityMock2, identityMock3]];
            });
            it(@"should set primary avatar view border width to 2", ^{
                [verify(viewMock.primaryAvatarView) setBorderWidth:2.0];
            });
            it(@"should update view layout to multiple avatar layout", ^{
                [verify(viewMock) setLayout:isA([LYRUIAvatarViewMultiLayout class])];
            });
        });
    });
});

SpecEnd
