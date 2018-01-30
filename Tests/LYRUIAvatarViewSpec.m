#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIAvatarView.h>
#import <Atlas/LYRUIAvatarViewSingleLayout.h>
#import <Atlas/LYRUIAvatarViewMultiLayout.h>
#import <Atlas/LYRUIConfiguration+DependencyInjection.h>
#import <Atlas/LYRUIAvatarViewPresenter.h>
#import <Atlas/LYRUIAvatarViewTheme.h>

SharedExamplesBegin(LYRUIAvatarView)

sharedExamplesFor(@"setting avatar view identities using view presenter", ^(NSDictionary *data) {
    __block LYRUIAvatarViewPresenter *viewPresenterMock;
    __block LYRUIAvatarView *avatarView;
    __block NSArray *identities;

    beforeEach(^{
        viewPresenterMock = data[@"viewPresenter"];
        avatarView = data[@"avatarView"];

        LYRIdentity *identityMock1 = mock([LYRIdentity class]);
        LYRIdentity *identityMock2 = mock([LYRIdentity class]);
        identities = @[identityMock1, identityMock2];
        avatarView.identities = identities;
    });

    it(@"should setup view using presenter", ^{
        [verify(viewPresenterMock) setupAvatarView:avatarView withIdentities:identities];
    });
});

SharedExamplesEnd

SpecBegin(LYRUIAvatarView)

describe(@"LYRUIAvatarView", ^{
    __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
    __block NSObject<LYRUIAvatarViewTheme> *themeMock;
    __block LYRUIAvatarViewPresenter *viewPresenterMock;
    __block LYRUIAvatarView *view;
    __block NSMutableDictionary *sharedContext = [NSMutableDictionary new];
    
    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
        
        themeMock = mockObjectAndProtocol([NSObject class], @protocol(LYRUIAvatarViewTheme));
        [[given([(id<NSCopying>)themeMock copyWithZone:NSDefaultMallocZone()]) withMatcher:anything()] willReturn:themeMock];
        [given([injectorMock themeForViewClass:[LYRUIAvatarView class]]) willReturn:themeMock];
        
        viewPresenterMock = mock([LYRUIAvatarViewPresenter class]);
        [given([injectorMock presenterForViewClass:[LYRUIAvatarView class]]) willReturn:viewPresenterMock];
        
        view = [[LYRUIAvatarView alloc] initWithConfiguration:configurationMock];
        
        sharedContext[@"viewPresenter"] = viewPresenterMock;
        sharedContext[@"avatarView"] = view;
    });
    
    afterEach(^{
        [sharedContext removeAllObjects];
        view = nil;
        viewPresenterMock = nil;
        themeMock = nil;
        configurationMock = nil;
    });
    
    describe(@"after initialization", ^{
        it(@"should have layout set to nil", ^{
            expect(view.layout).to.beNil();
        });
        it(@"should have proper theme set", ^{
            expect(view.theme).to.equal(themeMock);
        });
        itShouldBehaveLike(@"setting avatar view identities using view presenter", sharedContext);
    });
    
    describe(@"after initialization from xib", ^{
        context(@"with layout outlet connected to single layout object", ^{
            beforeEach(^{
                NSBundle *bundle = [NSBundle bundleForClass:[self class]];
                NSArray<LYRUIAvatarView *> *xibViews = [bundle loadNibNamed:@"LYRUIAvatarView" owner:self options:nil];
                view = [xibViews objectAtIndex:2];
            });
            
            it(@"should have layout set to object connected via IB outlet", ^{
                expect(view.layout).to.beAKindOf([LYRUIAvatarViewSingleLayout class]);
            });
        });
        
        context(@"with layout outlet connected to multi layout object", ^{
            beforeEach(^{
                NSBundle *bundle = [NSBundle bundleForClass:[self class]];
                NSArray<LYRUIAvatarView *> *xibViews = [bundle loadNibNamed:@"LYRUIAvatarView" owner:self options:nil];
                view = [xibViews objectAtIndex:3];
            });
            
            it(@"should have layout set to object connected via IB outlet", ^{
                expect(view.layout).to.beAKindOf([LYRUIAvatarViewMultiLayout class]);
            });
        });
        
        context(@"when layer presenter was set after initialization from xib", ^{
            beforeEach(^{
                NSBundle *bundle = [NSBundle bundleForClass:[self class]];
                NSArray<LYRUIAvatarView *> *xibViews = [bundle loadNibNamed:@"LYRUIAvatarView" owner:self options:nil];
                view = [xibViews objectAtIndex:2];
                view.layerConfiguration = configurationMock;
                sharedContext[@"avatarView"] = view;
            });
            it(@"should have proper theme set", ^{
                expect(view.theme).to.equal(themeMock);
            });
            itShouldBehaveLike(@"setting avatar view identities using view presenter", sharedContext);
        });
    });
});

SpecEnd
