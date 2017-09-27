#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <Atlas/LYRUIConversationItemTitleFormatter.h>
#import <LayerKit/LayerKit.h>

@interface LYRUIConversationItemTitleFormatter (PrivateProperties)

@property (nonatomic, strong) LYRUIParticipantsFiltering participantsFilter;

@end

SpecBegin(LYRUIConversationItemTitleFormatter)

describe(@"LYRUIConversationItemTitleFormatter", ^{
    __block LYRUIConversationItemTitleFormatter *formatter;
    __block LYRUIParticipantsFiltering participantsFilterMock;
    __block NSSet *participantsFilterMockReturnValue;
    __block LYRConversation *conversationMock;
    
    beforeEach(^{
        participantsFilterMock = ^NSSet *(NSSet *identities) {
            return participantsFilterMockReturnValue;
        };
        formatter = [[LYRUIConversationItemTitleFormatter alloc] initWithParticipantsFilter:participantsFilterMock];
        conversationMock = mock([LYRConversation class]);
    });
    
    afterEach(^{
        formatter = nil;
        participantsFilterMockReturnValue = nil;
    });
    
    describe(@"titleForConversation:", ^{
        __block NSString *returnedString;
        
        context(@"for conversation with metadata containing title", ^{
            beforeEach(^{
                [given(conversationMock.metadata) willReturn:@{
                        @"conversationName" : @"test conversation title"
                }];
            });
            
            context(@"with empty participants set", ^{
                beforeEach(^{
                    [given(conversationMock.participants) willReturn:[NSSet new]];
                    participantsFilterMockReturnValue = [NSSet new];
                    
                    returnedString = [formatter titleForConversation:conversationMock];
                });
                
                it(@"should return the title from metadata", ^{
                    expect(returnedString).to.equal(@"test conversation title");
                });
            });
            
            context(@"with two participants", ^{
                beforeEach(^{
                    LYRIdentity *participantMock1 = mock([LYRIdentity class]);
                    [given(participantMock1.displayName) willReturn:@"Enzo Ferrari"];
                    LYRIdentity *participantMock2 = mock([LYRIdentity class]);
                    [given(participantMock2.displayName) willReturn:@"Ferdinand Porsche"];
                    
                    NSSet *participants = [NSSet setWithArray:@[
                            participantMock1,
                            participantMock2,
                    ]];
                    [given(conversationMock.participants) willReturn:participants];
                    participantsFilterMockReturnValue = participants;
                    
                    returnedString = [formatter titleForConversation:conversationMock];
                });
                
                it(@"should return the title from metadata", ^{
                    expect(returnedString).to.equal(@"test conversation title");
                });
            });
            
            context(@"with multiple participants", ^{
                beforeEach(^{
                    LYRIdentity *participantMock1 = mock([LYRIdentity class]);
                    [given(participantMock1.displayName) willReturn:@"Enzo Ferrari"];
                    LYRIdentity *participantMock2 = mock([LYRIdentity class]);
                    [given(participantMock2.displayName) willReturn:@"Ferdinand Porsche"];
                    LYRIdentity *participantMock3 = mock([LYRIdentity class]);
                    [given(participantMock3.displayName) willReturn:@"Henry Ford"];
                    LYRIdentity *participantMock4 = mock([LYRIdentity class]);
                    [given(participantMock4.displayName) willReturn:@"Walter Owen Bentley"];
                    
                    NSSet *participants = [NSSet setWithArray:@[
                            participantMock1,
                            participantMock2,
                            participantMock3,
                            participantMock4,
                    ]];
                    [given(conversationMock.participants) willReturn:participants];
                    participantsFilterMockReturnValue = participants;
                    
                    returnedString = [formatter titleForConversation:conversationMock];
                });
                
                it(@"should return the title from metadata", ^{
                    expect(returnedString).to.equal(@"test conversation title");
                });
            });
        });
        
        context(@"for conversation without title in metadata", ^{
            beforeEach(^{
                [given(conversationMock.metadata) willReturn:@{}];
            });
            
            context(@"with empty participants set", ^{
                beforeEach(^{
                    [given(conversationMock.participants) willReturn:[NSSet new]];
                    
                    returnedString = [formatter titleForConversation:conversationMock];
                });
                
                it(@"should return empty string", ^{
                    expect(returnedString).to.equal(@"");
                });
            });
            
            context(@"with one participant", ^{
                __block LYRIdentity *otherParticipantMock;
                
                beforeEach(^{
                    LYRIdentity *participantMock1 = mock([LYRIdentity class]);
                    [given(participantMock1.displayName) willReturn:@"Enzo Ferrari"];
                    otherParticipantMock = mock([LYRIdentity class]);
                    [given(otherParticipantMock.displayName) willReturn:@"Ferdinand Porsche Display Name"];
                    [given(otherParticipantMock.firstName) willReturn:@"Ferdinand"];
                    [given(otherParticipantMock.lastName) willReturn:@"Porsche"];
                    
                    NSSet *participants = [NSSet setWithArray:@[
                            participantMock1,
                            otherParticipantMock,
                    ]];
                    [given(conversationMock.participants) willReturn:participants];
                    NSSet *filteredParticipants = [NSSet setWithArray:@[
                            otherParticipantMock,
                    ]];
                    participantsFilterMockReturnValue = filteredParticipants;
                });

                context(@"when other user has both first name and last name set", ^{
                    beforeEach(^{
                        returnedString = [formatter titleForConversation:conversationMock];
                    });
                    
                    it(@"should return full name of the other participant", ^{
                        expect(returnedString).to.equal(@"Ferdinand Porsche");
                    });
                });
                
                context(@"when other user has only first name set", ^{
                    beforeEach(^{
                        [given(otherParticipantMock.lastName) willReturn:nil];
                        returnedString = [formatter titleForConversation:conversationMock];
                    });
                    
                    it(@"should return first name of the other participant", ^{
                        expect(returnedString).to.equal(@"Ferdinand");
                    });
                });
                
                context(@"when other user has only last name set", ^{
                    beforeEach(^{
                        [given(otherParticipantMock.firstName) willReturn:nil];
                        returnedString = [formatter titleForConversation:conversationMock];
                    });
                    
                    it(@"should return last name of the other participant", ^{
                        expect(returnedString).to.equal(@"Porsche");
                    });
                });
                
                context(@"when other user has only display name set", ^{
                    beforeEach(^{
                        [given(otherParticipantMock.firstName) willReturn:nil];
                        [given(otherParticipantMock.lastName) willReturn:nil];
                        returnedString = [formatter titleForConversation:conversationMock];
                    });
                    
                    it(@"should return display name of the other participant", ^{
                        expect(returnedString).to.equal(@"Ferdinand Porsche Display Name");
                    });
                });
                
                context(@"when other has no identifying information", ^{
                    beforeEach(^{
                        [given(otherParticipantMock.firstName) willReturn:nil];
                        [given(otherParticipantMock.lastName) willReturn:nil];
                        [given(otherParticipantMock.displayName) willReturn:nil];
                        returnedString = [formatter titleForConversation:conversationMock];
                    });
                    
                    it(@"should return empty string", ^{
                        expect(returnedString).to.equal(@"");
                    });
                });
            });
            
            context(@"with multiple participants", ^{
                beforeEach(^{
                    LYRIdentity *participantMock1 = mock([LYRIdentity class]);
                    [given(participantMock1.displayName) willReturn:@"Enzo Ferrari"];
                    LYRIdentity *participantMock2 = mock([LYRIdentity class]);
                    [given(participantMock2.firstName) willReturn:@"Ferdinand"];
                    LYRIdentity *participantMock3 = mock([LYRIdentity class]);
                    [given(participantMock3.lastName) willReturn:@"Ford"];
                    LYRIdentity *participantMock4 = mock([LYRIdentity class]);
                    [given(participantMock4.displayName) willReturn:@"Walter Owen Bentley"];
                    
                    NSSet *participants = [NSSet setWithArray:@[
                            participantMock1,
                            participantMock2,
                            participantMock3,
                            participantMock4,
                    ]];
                    [given(conversationMock.participants) willReturn:participants];
                    NSSet *filteredParticipants = [NSSet setWithArray:@[
                            participantMock2,
                            participantMock3,
                            participantMock4,
                    ]];
                    participantsFilterMockReturnValue = filteredParticipants;
                
                    returnedString = [formatter titleForConversation:conversationMock];
                });
                
                it(@"should return comma separated names of filtered participants", ^{
                    expect(returnedString).to.contain(@"Ferdinand");
                    expect(returnedString).to.contain(@"Ford");
                    expect(returnedString).to.contain(@"Walter Owen Bentley");
                });
                it(@"should return string without name of user removed from participants", ^{
                    expect(returnedString).notTo.contain(@"Enzo Ferrari");
                });
            });
        });
    });
});

SpecEnd
