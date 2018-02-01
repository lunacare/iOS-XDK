#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIParticipantsFiltering.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIParticipantsDefaultFilterWithCurrentUser)

describe(@"LYRUIParticipantsDefaultFilterWithCurrentUser", ^{
    __block LYRUIParticipantsFiltering participantsFilter;
    __block NSSet *returnedParticipants;
    
    __block LYRIdentity *participantMock1;
    __block LYRIdentity *participantMock2;
    __block LYRIdentity *participantMock3;
    __block LYRIdentity *participantMock4;
    
    beforeEach(^{
        participantMock1 = mock([LYRIdentity class]);
        [given(participantMock1.userID) willReturn:@"user 1"];
        participantMock2 = mock([LYRIdentity class]);
        [given(participantMock2.userID) willReturn:@"user 2"];
        participantMock3 = mock([LYRIdentity class]);
        [given(participantMock3.userID) willReturn:@"user 3"];
        participantMock4 = mock([LYRIdentity class]);
        [given(participantMock4.userID) willReturn:@"user 4"];
    });
    
    context(@"when current user is passed", ^{
        beforeEach(^{
            LYRIdentity *currentUserMock = mock([LYRIdentity class]);
            [given(currentUserMock.userID) willReturn:@"user 3"];
            
            NSArray *participantsArray = @[
                    participantMock1,
                    participantMock2,
                    participantMock3,
                    participantMock4,
            ];
            participantsFilter = LYRUIParticipantsDefaultFilterWithCurrentUser(currentUserMock);
            returnedParticipants = participantsFilter([NSSet setWithArray:participantsArray]);
        });
        
        it(@"should return set with 3 participants", ^{
            expect(returnedParticipants.count).to.equal(3);
        });
        it(@"should return set without the currently logged in user", ^{
            expect(returnedParticipants).notTo.contain(participantMock3);
        });
    });
    
    context(@"when current user is not passed", ^{
        beforeEach(^{
            LYRIdentity *nilIdentity = nil;
            participantsFilter = LYRUIParticipantsDefaultFilterWithCurrentUser(nilIdentity);
        });
        
        it(@"should be nil", ^{
            expect(participantsFilter).to.beNil();
        });
    });
});

SpecEnd
