#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIPresenceViewConfigurator.h>
#import <Atlas/LYRUIPresenceViewDefaultTheme.h>
#import <Atlas/LYRUIPresenceView.h>

SpecBegin(LYRUIPresenceViewConfigurator)

describe(@"LYRUIPresenceViewConfigurator", ^{
    __block LYRUIPresenceViewConfigurator *configurator;
    __block id<LYRUIPresenceViewTheming> themeMock;
    
    beforeEach(^{
        themeMock = mockProtocol(@protocol(LYRUIPresenceViewTheming));
        [[given([themeMock copyWithZone:NSDefaultMallocZone()]) withMatcher:anything()] willReturn:themeMock];
        configurator = [[LYRUIPresenceViewConfigurator alloc] initWithTheme:themeMock];
    });
    
    afterEach(^{
        configurator = nil;
    });
    
    describe(@"after initialization", ^{
        it(@"should have the theme set to passed instance", ^{
            expect(configurator.theme).to.equal(themeMock);
        });
    });
    
    describe(@"after initialization with designated initializer", ^{
        beforeEach(^{
            configurator = [[LYRUIPresenceViewConfigurator alloc] init];
        });
        
        it(@"should have default outside stroke color set to clear color", ^{
            expect(configurator.outsideStrokeColor).to.equal([UIColor clearColor]);
        });
        it(@"should have default theme set to instance of `LYRUIPresenceViewDefaultTheme`", ^{
            expect(configurator.theme).to.beAKindOf([LYRUIPresenceViewDefaultTheme class]);
        });
    });
    
    describe(@"setupPresenceView:forPresenceStatus:", ^{
        __block LYRUIPresenceView *viewMock;
        __block UIColor *fillColorMock;
        __block UIColor *strokeColorMock;
        __block UIColor *outsideStrokeColorMock;
        
        beforeEach(^{
            viewMock = mock([LYRUIPresenceView class]);
            
            fillColorMock = mock([UIColor class]);
            strokeColorMock = mock([UIColor class]);
            outsideStrokeColorMock = mock([UIColor class]);
            
            [[given([themeMock fillColorForPresenceStatus:0]) withMatcher:anything()] willReturn:fillColorMock];
            [[given([themeMock strokeColorForPresenceStatus:0]) withMatcher:anything()] willReturn:strokeColorMock];
            configurator.outsideStrokeColor = outsideStrokeColorMock;
            
            [configurator setupPresenceView:viewMock forPresenceStatus:LYRIdentityPresenceStatusAvailable];
        });
        
        it(@"should get proper fill color from theme", ^{
            [verify(themeMock) fillColorForPresenceStatus:LYRIdentityPresenceStatusAvailable];
        });
        it(@"should get proper stroke color from theme", ^{
            [verify(themeMock) strokeColorForPresenceStatus:LYRIdentityPresenceStatusAvailable];
        });
        it(@"should set colors of the view with proper values", ^{
            [verify(viewMock) updateWithFillColor:fillColorMock
                                insideStrokeColor:strokeColorMock
                               outsideStrokeColor:outsideStrokeColorMock];
        });
    });
});

SpecEnd
