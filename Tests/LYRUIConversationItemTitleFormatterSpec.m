#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <Atlas/LYRUIConversationItemTitleFormatter.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIConversationItemTitleFormatter)

describe(@"LYRUIConversationItemTitleFormatter", ^{
    __block LYRUIConversationItemTitleFormatter *formatter;
    __block LYRConversation *conversationMock;
    __block LYRIdentity *currentUserMock;
    
    beforeEach(^{
        formatter = [[LYRUIConversationItemTitleFormatter alloc] init];
        conversationMock = mock([LYRConversation class]);
        currentUserMock = mock([LYRIdentity class]);
        [given(currentUserMock.userID) willReturn:@"test identifier"];
    });
    
    afterEach(^{
        formatter = nil;
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
            
            context(@"with two participants", ^{
                __block LYRIdentity *otherParticipantMock;
                
                beforeEach(^{
                    LYRIdentity *participantMock1 = mock([LYRIdentity class]);
                    [given(participantMock1.userID) willReturn:@"test identifier"];
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
                });
                    
                context(@"with current user set", ^{
                    beforeEach(^{
                        formatter = [[LYRUIConversationItemTitleFormatter alloc] initWithCurrentUser:currentUserMock];
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
                
                context(@"without current user", ^{
                    beforeEach(^{
                        returnedString = [formatter titleForConversation:conversationMock];
                    });
                    
                    it(@"should return comma separated names of participants", ^{
                        expect(returnedString).to.contain(@"Ferdinand");
                        expect(returnedString).to.contain(@"Enzo Ferrari");
                    });
                });
            });
            
            context(@"with multiple participants", ^{
                beforeEach(^{
                    LYRIdentity *participantMock1 = mock([LYRIdentity class]);
                    [given(participantMock1.userID) willReturn:@"test identifier"];
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
                });
                
                context(@"with current user set", ^{
                    beforeEach(^{
                        formatter = [[LYRUIConversationItemTitleFormatter alloc] initWithCurrentUser:currentUserMock];
                        returnedString = [formatter titleForConversation:conversationMock];
                    });
                    
                    it(@"should return comma separated names of other participants", ^{
                        expect(returnedString).to.contain(@"Ferdinand");
                        expect(returnedString).to.contain(@"Ford");
                        expect(returnedString).to.contain(@"Walter Owen Bentley");
                    });
                    it(@"should return string without name of current user", ^{
                        expect(returnedString).notTo.contain(@"Enzo Ferrari");
                    });
                });
                
                context(@"without current user", ^{
                    beforeEach(^{
                        returnedString = [formatter titleForConversation:conversationMock];
                    });
                    
                    it(@"should return comma separated names of all participants", ^{
                        expect(returnedString).to.contain(@"Ferdinand");
                        expect(returnedString).to.contain(@"Ford");
                        expect(returnedString).to.contain(@"Walter Owen Bentley");
                        expect(returnedString).to.contain(@"Enzo Ferrari");
                    });
                });
            });
        });
    });
});

SpecEnd
