#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIParticipantsFilter.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIParticipantsFilter)

describe(@"LYRUIParticipantsFilter", ^{
    __block LYRUIParticipantsFilter *filter;

    beforeEach(^{
        filter = [[LYRUIParticipantsFilter alloc] init];
    });

    afterEach(^{
        filter = nil;
    });

    describe(@"filteredParticipants:", ^{
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
        
        context(@"when current user is set", ^{
            beforeEach(^{
                LYRIdentity *currentUserMock = mock([LYRIdentity class]);
                [given(currentUserMock.userID) willReturn:@"user 3"];
                filter.currentUser = currentUserMock;
                
                NSArray *participantsArray = @[
                        participantMock1,
                        participantMock2,
                        participantMock3,
                        participantMock4,
                ];
                returnedParticipants = [filter filteredParticipants:[NSSet setWithArray:participantsArray]];
            });
            
            it(@"should return set with 3 participants", ^{
                expect(returnedParticipants.count).to.equal(3);
            });
            it(@"should return set without the currently logged in user", ^{
                expect(returnedParticipants).notTo.contain(participantMock3);
            });
        });
        
        context(@"when current user is not set", ^{
            beforeEach(^{
                NSArray *participantsArray = @[
                        participantMock1,
                        participantMock2,
                        participantMock3,
                        participantMock4,
                ];
                returnedParticipants = [filter filteredParticipants:[NSSet setWithArray:participantsArray]];
            });
            
            it(@"should return set with all 4 participants", ^{
                expect(returnedParticipants.count).to.equal(4);
            });
        });
    });
});

SpecEnd
