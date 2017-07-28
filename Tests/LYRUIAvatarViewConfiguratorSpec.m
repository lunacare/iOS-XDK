#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIAvatarViewConfigurator.h>
#import <Atlas/LYRUIAvatarView+PrivateProperties.h>
#import <Atlas/LYRUIAvatarViewSingleLayout.h>
#import <Atlas/LYRUIAvatarViewMultiLayout.h>
#import <Atlas/LYRUIImageWithLettersView.h>
#import <Atlas/LYRUIImageWithLettersViewConfigurator.h>
#import <Atlas/LYRUIPresenceView.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIAvatarViewConfigurator)

describe(@"LYRUIAvatarViewConfigurator", ^{
    __block LYRUIAvatarViewConfigurator *configurator;
    __block LYRUIImageWithLettersView *primaryAvatarViewMock;
    __block LYRUIImageWithLettersView *secondaryAvatarViewMock;
    __block LYRUIPresenceView *presenceViewMock;
    __block LYRUIImageWithLettersViewConfigurator *avatarViewConfiguratorMock;
    __block LYRUIAvatarView *viewMock;
    
    beforeEach(^{
        viewMock = mock([LYRUIAvatarView class]);
        primaryAvatarViewMock = mock([LYRUIImageWithLettersView class]);
        [given(viewMock.primaryAvatarView) willReturn:primaryAvatarViewMock];
        secondaryAvatarViewMock = mock([LYRUIImageWithLettersView class]);
        [given(viewMock.secondaryAvatarView) willReturn:secondaryAvatarViewMock];
        presenceViewMock = mock([LYRUIPresenceView class]);
        [given(viewMock.presenceView) willReturn:presenceViewMock];
        avatarViewConfiguratorMock = mock([LYRUIImageWithLettersViewConfigurator class]);
        configurator = [[LYRUIAvatarViewConfigurator alloc] initWithAvatarViewConfigurator:avatarViewConfiguratorMock];
    });
    
    afterEach(^{
        configurator = nil;
        avatarViewConfiguratorMock = nil;
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
                [configurator setupAvatarView:viewMock withIdentities:@[identityMock1]];
            });
            
            it(@"should configure primary avatar view with the identity", ^{
                [verify(avatarViewConfiguratorMock) setupImageWithLettersView:primaryAvatarViewMock withIdentity:identityMock1];
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
                [configurator setupAvatarView:viewMock withIdentities:@[identityMock1, identityMock2]];
            });
            
            it(@"should configure primary avatar view with the first identity", ^{
                [verify(avatarViewConfiguratorMock) setupImageWithLettersView:primaryAvatarViewMock withIdentity:identityMock1];
            });
            it(@"should configure secondary avatar view with the first identity", ^{
                [verify(avatarViewConfiguratorMock) setupImageWithLettersView:secondaryAvatarViewMock withIdentity:identityMock2];
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
                [configurator setupAvatarView:viewMock withIdentities:@[identityMock1, identityMock2, identityMock3]];
            });
            
            it(@"should configure primary avatar view with the first identity", ^{
                [verify(avatarViewConfiguratorMock) setupImageWithLettersView:primaryAvatarViewMock withIdentity:identityMock1];
            });
            it(@"should configure secondary avatar view with the multiple participants icon", ^{
                [verify(avatarViewConfiguratorMock) setupImageWithLettersViewWithMultipleParticipantsIcon:secondaryAvatarViewMock];
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
