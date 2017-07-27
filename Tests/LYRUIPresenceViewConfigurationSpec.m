#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIPresenceViewConfiguration.h>
#import <Atlas/LYRUIPresenceViewDefaultTheme.h>
#import <Atlas/LYRUIPresenceView+PrivateProperties.h>
#import <Atlas/LYRUIPresenceIndicatorTheme.h>
#import <Atlas/LYRUIParticipantsCountViewTheme.h>
#import <Atlas/LYRUIShapedView.h>

SpecBegin(LYRUIPresenceViewConfiguration)

describe(@"LYRUIPresenceViewConfiguration", ^{
    __block LYRUIPresenceViewConfiguration *configuration;
    __block id<LYRUIPresenceIndicatorTheme, LYRUIParticipantsCountViewTheme> themeMock;
    __block LYRUIPresenceView *viewMock;
    
    beforeEach(^{
        viewMock = mock([LYRUIPresenceView class]);
        themeMock = mockProtocol(@protocol(LYRUIPresenceIndicatorTheme));
        [[given([themeMock copyWithZone:NSDefaultMallocZone()]) withMatcher:anything()] willReturn:themeMock];
        configuration = [[LYRUIPresenceViewConfiguration alloc] init];
    });
    
    afterEach(^{
        configuration = nil;
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
            
            [configuration setupPresenceView:viewMock withIdentities:@[identityMock] usingTheme:themeMock];
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
