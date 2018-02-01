#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIPresenceViewPresenter.h>
#import <LayerXDK/LYRUIPresenceViewDefaultTheme.h>
#import <LayerXDK/LYRUIPresenceView+PrivateProperties.h>
#import <LayerXDK/LYRUIPresenceIndicatorTheme.h>
#import <LayerXDK/LYRUIParticipantsCountViewTheme.h>
#import <LayerXDK/LYRUIShapedView.h>

SpecBegin(LYRUIPresenceViewPresenter)

describe(@"LYRUIPresenceViewPresenter", ^{
    __block LYRUIPresenceViewPresenter *presenter;
    __block id<LYRUIPresenceIndicatorTheme, LYRUIParticipantsCountViewTheme> themeMock;
    __block LYRUIPresenceView *viewMock;
    
    beforeEach(^{
        viewMock = mock([LYRUIPresenceView class]);
        themeMock = mockProtocol(@protocol(LYRUIPresenceIndicatorTheme));
        [[given([themeMock copyWithZone:NSDefaultMallocZone()]) withMatcher:anything()] willReturn:themeMock];
        presenter = [[LYRUIPresenceViewPresenter alloc] init];
    });
    
    afterEach(^{
        presenter = nil;
    });
    
    describe(@"setupPresenceView:forPresenceStatus:", ^{
        __block UIColor *fillColorMock;
        __block UIColor *insideStrokeColorMock;
        __block UIColor *outsideStrokeColorMock;
        
        beforeEach(^{
            [given(viewMock.presenceIndicator) willReturn:mock([LYRUIShapedView class])];
            
            fillColorMock = mock([UIColor class]);
            insideStrokeColorMock = mock([UIColor class]);
            outsideStrokeColorMock = mock([UIColor class]);
            
            [[given([themeMock fillColorForPresenceStatus:0]) withMatcher:anything()] willReturn:fillColorMock];
            [[given([themeMock insideStrokeColorForPresenceStatus:0]) withMatcher:anything()] willReturn:insideStrokeColorMock];
            [[given([themeMock outsideStrokeColorForPresenceStatus:0]) withMatcher:anything()] willReturn:outsideStrokeColorMock];

            LYRIdentity *identityMock = mock([LYRIdentity class]);
            [given(identityMock.presenceStatus) willReturnInteger:LYRIdentityPresenceStatusAvailable];
            
            [presenter setupPresenceView:viewMock withIdentities:@[identityMock] usingTheme:themeMock];
        });
        
        it(@"should get proper fill color from theme", ^{
            [verify(themeMock) fillColorForPresenceStatus:LYRIdentityPresenceStatusAvailable];
        });
        it(@"should get proper inside stroke color from theme", ^{
            [verify(themeMock) insideStrokeColorForPresenceStatus:LYRIdentityPresenceStatusAvailable];
        });
        it(@"should get proper outside stroke color from theme", ^{
            [verify(themeMock) outsideStrokeColorForPresenceStatus:LYRIdentityPresenceStatusAvailable];
        });
        it(@"should set colors of the view with proper values", ^{
            [verify(viewMock.presenceIndicator) updateWithFillColor:fillColorMock
                                                  insideStrokeColor:insideStrokeColorMock
                                                 outsideStrokeColor:outsideStrokeColorMock];
        });
    });
});

SpecEnd
