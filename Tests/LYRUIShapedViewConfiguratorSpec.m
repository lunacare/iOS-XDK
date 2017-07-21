#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIShapedViewConfigurator.h>
#import <Atlas/LYRUIShapedViewDefaultTheme.h>
#import <Atlas/LYRUIShapedView.h>

SpecBegin(LYRUIShapedViewConfigurator)

describe(@"LYRUIShapedViewConfigurator", ^{
    __block LYRUIShapedViewConfigurator *configurator;
    __block id<LYRUIShapedViewTheming> themeMock;
    
    beforeEach(^{
        themeMock = mockProtocol(@protocol(LYRUIShapedViewTheming));
        [[given([themeMock copyWithZone:NSDefaultMallocZone()]) withMatcher:anything()] willReturn:themeMock];
        configurator = [[LYRUIShapedViewConfigurator alloc] initWithTheme:themeMock];
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
            configurator = [[LYRUIShapedViewConfigurator alloc] init];
        });
        
        it(@"should have default outside stroke color set to clear color", ^{
            expect(configurator.outsideStrokeColor).to.equal([UIColor clearColor]);
        });
        it(@"should have default theme set to instance of `LYRUIShapedViewDefaultTheme`", ^{
            expect(configurator.theme).to.beAKindOf([LYRUIShapedViewDefaultTheme class]);
        });
    });
    
    describe(@"setupShapedView:forPresenceStatus:", ^{
        __block LYRUIShapedView *viewMock;
        __block UIColor *fillColorMock;
        __block UIColor *strokeColorMock;
        __block UIColor *outsideStrokeColorMock;
        
        beforeEach(^{
            viewMock = mock([LYRUIShapedView class]);
            
            fillColorMock = mock([UIColor class]);
            strokeColorMock = mock([UIColor class]);
            outsideStrokeColorMock = mock([UIColor class]);
            
            [[given([themeMock fillColorForPresenceStatus:0]) withMatcher:anything()] willReturn:fillColorMock];
            [[given([themeMock strokeColorForPresenceStatus:0]) withMatcher:anything()] willReturn:strokeColorMock];
            configurator.outsideStrokeColor = outsideStrokeColorMock;

            [configurator setupShapedView:viewMock forPresenceStatus:LYRIdentityPresenceStatusAvailable];
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
