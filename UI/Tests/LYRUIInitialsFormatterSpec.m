#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIInitialsFormatter.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIInitialsFormatter)

describe(@"LYRUIInitialsFormatter", ^{
    __block LYRUIInitialsFormatter *formatter;
    
    beforeEach(^{
        formatter = [[LYRUIInitialsFormatter alloc] init];
    });
    
    afterEach(^{
        formatter = nil;
    });
    
    
    describe(@"setupImageWithLettersView:withIdentity:", ^{
        __block LYRIdentity *identityMock;
        __block NSString *returnedInitials;
        
        beforeEach(^{
            identityMock = mock([LYRIdentity class]);
            [given(identityMock.firstName) willReturn:@"Nick"];
            [given(identityMock.lastName) willReturn:@"Cage"];
            [given(identityMock.displayName) willReturn:@"Nick Cage Display Name"];
        });
        
        context(@"when identity contains both first name and last name", ^{
            beforeEach(^{
                returnedInitials = [formatter initialsForIdentity:identityMock];
            });
            
            it(@"should return `NC` as initials", ^{
                expect(returnedInitials).to.equal(@"NC");
            });
        });
        
        context(@"when identity's first name and last name start with whitespaces", ^{
            beforeEach(^{
                [given(identityMock.firstName) willReturn:@"  \tNick"];
                [given(identityMock.lastName) willReturn:@"\t \nCage"];
                
                returnedInitials = [formatter initialsForIdentity:identityMock];
            });
            
            it(@"should return `NC` as initials", ^{
                expect(returnedInitials).to.equal(@"NC");
            });
        });
        
        context(@"when identity contains only first name", ^{
            beforeEach(^{
                [given(identityMock.lastName) willReturn:nil];
                
                returnedInitials = [formatter initialsForIdentity:identityMock];
            });
            
            it(@"should return `N` as initials", ^{
                expect(returnedInitials).to.equal(@"N");
            });
        });
        
        context(@"when identity contains only last name", ^{
            beforeEach(^{
                [given(identityMock.firstName) willReturn:nil];
                
                returnedInitials = [formatter initialsForIdentity:identityMock];
            });
            
            it(@"should return `C` as initials", ^{
                expect(returnedInitials).to.equal(@"C");
            });
        });
        
        context(@"when identity does not contain both first name and last name, but has display name", ^{
            beforeEach(^{
                [given(identityMock.firstName) willReturn:nil];
                [given(identityMock.lastName) willReturn:nil];
                
                returnedInitials = [formatter initialsForIdentity:identityMock];
            });
            
            it(@"should return first letters of first and last word of display name as initials", ^{
                expect(returnedInitials).to.equal(@"NN");
            });
        });
        
        context(@"when identity does not contain both first name and last name, but has display name with whitespaces at the beginning and the end", ^{
            beforeEach(^{
                [given(identityMock.firstName) willReturn:nil];
                [given(identityMock.lastName) willReturn:nil];
                [given(identityMock.displayName) willReturn:@" \t\nNick Cage Display Name\n\t "];
                
                returnedInitials = [formatter initialsForIdentity:identityMock];
            });
            
            it(@"should return first letters of first and last word of display name as initials", ^{
                expect(returnedInitials).to.equal(@"NN");
            });
        });
        
        context(@"when identity does not contain both first name and last name, but has display name without any whitespaces", ^{
            beforeEach(^{
                [given(identityMock.firstName) willReturn:nil];
                [given(identityMock.lastName) willReturn:nil];
                [given(identityMock.displayName) willReturn:@"Nicky"];
                
                returnedInitials = [formatter initialsForIdentity:identityMock];
            });
            
            it(@"should return first two letters of display name as initials", ^{
                expect(returnedInitials).to.equal(@"Ni");
            });
        });
        
        context(@"when identity does not contain both first name and last name, but has display name with single letter", ^{
            beforeEach(^{
                [given(identityMock.firstName) willReturn:nil];
                [given(identityMock.lastName) willReturn:nil];
                [given(identityMock.firstName) willReturn:@"S"];
                
                returnedInitials = [formatter initialsForIdentity:identityMock];
            });
            
            it(@"should return the display name as initials", ^{
                expect(returnedInitials).to.equal(@"S");
            });
        });
    });
});

SpecEnd
