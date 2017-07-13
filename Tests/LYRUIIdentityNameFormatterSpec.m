#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <Atlas/LYRUIIdentityNameFormatter.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIIdentityNameFormatter)

describe(@"LYRUIIdentityNameFormatter", ^{
    __block LYRUIIdentityNameFormatter *formatter;
    __block LYRIdentity *identityMock;
    
    beforeEach(^{
        formatter = [[LYRUIIdentityNameFormatter alloc] init];
        
        identityMock = mock([LYRIdentity class]);
        [given(identityMock.displayName) willReturn:@"Ferdinand Porsche Display Name"];
        [given(identityMock.firstName) willReturn:@"Ferdinand"];
        [given(identityMock.lastName) willReturn:@"Porsche"];
    });
    
    afterEach(^{
        formatter = nil;
        identityMock = nil;
    });
    
    describe(@"nameForIdentity:", ^{
        __block NSString *returnedString;
        
        context(@"when identity has both first name and last name set", ^{
            beforeEach(^{
                returnedString = [formatter nameForIdentity:identityMock];
            });
            
            it(@"should return full name of the other participant", ^{
                expect(returnedString).to.equal(@"Ferdinand Porsche");
            });
        });
        
        context(@"when identity has only first name set", ^{
            beforeEach(^{
                [given(identityMock.lastName) willReturn:nil];
                returnedString = [formatter nameForIdentity:identityMock];
            });
            
            it(@"should return first name of the other participant", ^{
                expect(returnedString).to.equal(@"Ferdinand");
            });
        });
        
        context(@"when identity has only last name set", ^{
            beforeEach(^{
                [given(identityMock.firstName) willReturn:nil];
                returnedString = [formatter nameForIdentity:identityMock];
            });
            
            it(@"should return last name of the other participant", ^{
                expect(returnedString).to.equal(@"Porsche");
            });
        });
        
        context(@"when identity has only display name set", ^{
            beforeEach(^{
                [given(identityMock.firstName) willReturn:nil];
                [given(identityMock.lastName) willReturn:nil];
                returnedString = [formatter nameForIdentity:identityMock];
            });
            
            it(@"should return display name of the other participant", ^{
                expect(returnedString).to.equal(@"Ferdinand Porsche Display Name");
            });
        });
        
        context(@"when other has no identifying information", ^{
            beforeEach(^{
                [given(identityMock.firstName) willReturn:nil];
                [given(identityMock.lastName) willReturn:nil];
                [given(identityMock.displayName) willReturn:nil];
                returnedString = [formatter nameForIdentity:identityMock];
            });
            
            it(@"should return empty string", ^{
                expect(returnedString).to.equal(@"");
            });
        });
    });
});

SpecEnd
