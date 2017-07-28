#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIIdentityItemAccessoryViewProvider.h>
#import <Atlas/LYRUIAvatarView.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIIdentityItemAccessoryViewProvider)

describe(@"LYRUIIdentityItemAccessoryViewProvider", ^{
    __block LYRUIIdentityItemAccessoryViewProvider *provider;
    __block LYRIdentity *identityMock;
    
    beforeEach(^{
        provider = [[LYRUIIdentityItemAccessoryViewProvider alloc] init];
        identityMock = mock([LYRIdentity class]);
    });
    
    afterEach(^{
        provider = nil;
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

SpecEnd
