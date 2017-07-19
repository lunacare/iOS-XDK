#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIPresenceViewDefaultTheme.h>

SpecBegin(LYRUIPresenceViewDefaultTheme)

describe(@"LYRUIPresenceViewDefaultTheme", ^{
    __block LYRUIPresenceViewDefaultTheme *theme;
    
    beforeEach(^{
        theme = [[LYRUIPresenceViewDefaultTheme alloc] init];
    });
    
    afterEach(^{
        theme = nil;
    });
    
    describe(@"fillColorForPresenceStatus:", ^{
        context(@"for LYRIdentityPresenceStatusOffline", ^{
            it(@"should return proper color", ^{
                UIColor *expectedColor = [UIColor colorWithRed:(219.0/255.0) green:(222.0/255.0) blue:(228.0/255.0) alpha:1.0];
                expect([theme fillColorForPresenceStatus:LYRIdentityPresenceStatusOffline]).to.equal(expectedColor);
            });
        });
        context(@"for LYRIdentityPresenceStatusAvailable", ^{
            it(@"should return proper color", ^{
                UIColor *expectedColor = [UIColor colorWithRed:(87.0/255.0) green:(191.0/255.0) blue:(70.0/255.0) alpha:1.0];
                expect([theme fillColorForPresenceStatus:LYRIdentityPresenceStatusAvailable]).to.equal(expectedColor);
            });
        });
        context(@"for LYRIdentityPresenceStatusBusy", ^{
            it(@"should return proper color", ^{
                UIColor *expectedColor = [UIColor colorWithRed:(234.0/255.0) green:(57.0/255.0) blue:(57.0/255.0) alpha:1.0];
                expect([theme fillColorForPresenceStatus:LYRIdentityPresenceStatusBusy]).to.equal(expectedColor);
            });
        });
        context(@"for LYRIdentityPresenceStatusAway", ^{
            it(@"should return proper color", ^{
                UIColor *expectedColor = [UIColor colorWithRed:(255.0/255.0) green:(213.0/255.0) blue:(36.0/255.0) alpha:1.0];
                expect([theme fillColorForPresenceStatus:LYRIdentityPresenceStatusAway]).to.equal(expectedColor);
            });
        });
        context(@"for LYRIdentityPresenceStatusInvisible", ^{
            it(@"should return proper color", ^{
                UIColor *expectedColor = [UIColor clearColor];
                expect([theme fillColorForPresenceStatus:LYRIdentityPresenceStatusInvisible]).to.equal(expectedColor);
            });
        });
    });
    
    describe(@"strokeColorForPresenceStatus:", ^{
        context(@"for LYRIdentityPresenceStatusOffline", ^{
            it(@"should return proper color", ^{
                UIColor *expectedColor = [UIColor clearColor];
                expect([theme strokeColorForPresenceStatus:LYRIdentityPresenceStatusOffline]).to.equal(expectedColor);
            });
        });
        context(@"for LYRIdentityPresenceStatusAvailable", ^{
            it(@"should return proper color", ^{
                UIColor *expectedColor = [UIColor clearColor];
                expect([theme strokeColorForPresenceStatus:LYRIdentityPresenceStatusAvailable]).to.equal(expectedColor);
            });
        });
        context(@"for LYRIdentityPresenceStatusBusy", ^{
            it(@"should return proper color", ^{
                UIColor *expectedColor = [UIColor clearColor];
                expect([theme strokeColorForPresenceStatus:LYRIdentityPresenceStatusBusy]).to.equal(expectedColor);
            });
        });
        context(@"for LYRIdentityPresenceStatusAway", ^{
            it(@"should return proper color", ^{
                UIColor *expectedColor = [UIColor clearColor];
                expect([theme strokeColorForPresenceStatus:LYRIdentityPresenceStatusAway]).to.equal(expectedColor);
            });
        });
        context(@"for LYRIdentityPresenceStatusInvisible", ^{
            it(@"should return proper color", ^{
                UIColor *expectedColor = [UIColor colorWithRed:(87.0/255.0) green:(191.0/255.0) blue:(70.0/255.0) alpha:1.0];
                expect([theme strokeColorForPresenceStatus:LYRIdentityPresenceStatusInvisible]).to.equal(expectedColor);
            });
        });
    });
});

SpecEnd
