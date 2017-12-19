#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIAvatarView.h>
#import <Atlas/LYRUIAvatarViewSingleLayout.h>
#import <Atlas/LYRUIAvatarViewMultiLayout.h>
#import <Atlas/LYRUIConfiguration+DependencyInjection.h>
#import <Atlas/LYRUIAvatarViewConfiguration.h>
#import <Atlas/LYRUIAvatarViewTheme.h>

SharedExamplesBegin(LYRUIAvatarView)

sharedExamplesFor(@"setting avatar view identities using view configuration", ^(NSDictionary *data) {
    __block LYRUIAvatarViewConfiguration *viewConfigurationMock;
    __block LYRUIAvatarView *avatarView;
    __block NSArray *identities;

    beforeEach(^{
        viewConfigurationMock = data[@"viewConfiguration"];
        avatarView = data[@"avatarView"];

        LYRIdentity *identityMock1 = mock([LYRIdentity class]);
        LYRIdentity *identityMock2 = mock([LYRIdentity class]);
        identities = @[identityMock1, identityMock2];
        avatarView.identities = identities;
    });

    it(@"should setup view using configuration", ^{
        [verify(viewConfigurationMock) setupAvatarView:avatarView withIdentities:identities];
    });
});

SharedExamplesEnd

SpecBegin(LYRUIAvatarView)

describe(@"LYRUIAvatarView", ^{
    __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
    __block NSObject<LYRUIAvatarViewTheme> *themeMock;
    __block LYRUIAvatarViewConfiguration *viewConfigurationMock;
    __block LYRUIAvatarView *view;
    __block NSMutableDictionary *sharedContext = [NSMutableDictionary new];
    
    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
        
        themeMock = mockObjectAndProtocol([NSObject class], @protocol(LYRUIAvatarViewTheme));
        [[given([(id<NSCopying>)themeMock copyWithZone:NSDefaultMallocZone()]) withMatcher:anything()] willReturn:themeMock];
        [given([injectorMock themeForViewClass:[LYRUIAvatarView class]]) willReturn:themeMock];
        
        viewConfigurationMock = mock([LYRUIAvatarViewConfiguration class]);
        [given([injectorMock configurationForViewClass:[LYRUIAvatarView class]]) willReturn:viewConfigurationMock];
        
        view = [[LYRUIAvatarView alloc] initWithConfiguration:configurationMock];
        
        sharedContext[@"viewConfiguration"] = viewConfigurationMock;
        sharedContext[@"avatarView"] = view;
    });
    
    afterEach(^{
        [sharedContext removeAllObjects];
        view = nil;
        viewConfigurationMock = nil;
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
        itShouldBehaveLike(@"setting avatar view identities using view configuration", sharedContext);
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
        
        context(@"when layer configuration was set after initialization from xib", ^{
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
            itShouldBehaveLike(@"setting avatar view identities using view configuration", sharedContext);
        });
    });
});

SpecEnd
