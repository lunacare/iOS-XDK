#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <Atlas/LYRUIConfiguration+DependencyInjection.h>
#import <Atlas/LYRUIConversationItemTitleFormatter.h>
#import <Atlas/LYRUIParticipantsFiltering.h>
#import <Atlas/LYRUIParticipantsSorting.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIConversationItemTitleFormatter)

describe(@"LYRUIConversationItemTitleFormatter", ^{
    __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
    __block LYRUIConversationItemTitleFormatter *formatter;
    __block LYRUIParticipantsFiltering participantsFilterMock;
    __block NSSet *participantsFilterMockReturnValue;
    __block LYRUIParticipantsSorting participantsSorterMock;
    __block NSArray *participantsSorterMockReturnValue;
    __block id<LYRUIIdentityNameFormatting> nameFormatterMock;
    __block LYRConversation *conversationMock;
    
    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
        
        participantsFilterMock = ^NSSet *(NSSet *identities) {
            return participantsFilterMockReturnValue;
        };
        [given(configurationMock.participantsFilter) willReturn:participantsFilterMock];
        
        participantsSorterMock = ^NSArray *(NSSet *identities) {
            return participantsSorterMockReturnValue;
        };
        [given(configurationMock.participantsSorter) willReturn:participantsSorterMock];
        
        nameFormatterMock = mockProtocol(@protocol(LYRUIIdentityNameFormatting));
        [given([injectorMock protocolImplementation:@protocol(LYRUIIdentityNameFormatting)
                                                forClass:[LYRUIConversationItemTitleFormatter class]])
         willReturn:nameFormatterMock];
        
        formatter = [[LYRUIConversationItemTitleFormatter alloc] initWithConfiguration:configurationMock];
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
                    
                    NSArray *participantsArray = @[
                            participantMock1,
                            participantMock2,
                    ];
                    NSSet *participantsSet = [NSSet setWithArray:participantsArray];
                    [given(conversationMock.participants) willReturn:participantsSet];
                    participantsFilterMockReturnValue = participantsSet;
                    participantsSorterMockReturnValue = participantsArray;
                    
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
                    
                    NSArray *participantsArray = @[
                            participantMock1,
                            participantMock2,
                            participantMock3,
                            participantMock4,
                    ];
                    NSSet *participantsSet = [NSSet setWithArray:participantsArray];
                    [given(conversationMock.participants) willReturn:participantsSet];
                    participantsFilterMockReturnValue = participantsSet;
                    participantsSorterMockReturnValue = participantsArray;
                    
                    returnedString = [formatter titleForConversation:conversationMock];
                });
                
                it(@"should return the title from metadata", ^{
                    expect(returnedString).to.equal(@"test conversation title");
                });
            });
        });
        
        context(@"for conversation with empty string in metadata", ^{
            __block LYRIdentity *otherParticipantMock;
            beforeEach(^{
                [given(conversationMock.metadata) willReturn:@{
                        @"conversationName" : @""
                }];

                otherParticipantMock = mock([LYRIdentity class]);
                [given([nameFormatterMock nameForIdentity:otherParticipantMock]) willReturn:@"Ferdinand Porsche"];
                
                NSSet *participants = [NSSet setWithArray:@[
                        otherParticipantMock,
                ]];
                [given(conversationMock.participants) willReturn:participants];
                NSSet *filteredParticipants = [NSSet setWithArray:@[
                        otherParticipantMock,
                ]];
                participantsFilterMockReturnValue = filteredParticipants;
                
                returnedString = [formatter titleForConversation:conversationMock];
            });

            it(@"should not use metadata title and return name of the other participant", ^{
                expect(returnedString).to.equal(@"Ferdinand Porsche");
            });
        });
        
        context(@"for conversation with string containing only whitechars in metadata", ^{
            __block LYRIdentity *otherParticipantMock;
            beforeEach(^{
                [given(conversationMock.metadata) willReturn:@{
                        @"conversationName" : @"\t\n "
                }];
                
                otherParticipantMock = mock([LYRIdentity class]);
                [given([nameFormatterMock nameForIdentity:otherParticipantMock]) willReturn:@"Ferdinand Porsche"];
                
                NSSet *participants = [NSSet setWithArray:@[
                        otherParticipantMock,
                ]];
                [given(conversationMock.participants) willReturn:participants];
                NSSet *filteredParticipants = [NSSet setWithArray:@[
                        otherParticipantMock,
                ]];
                participantsFilterMockReturnValue = filteredParticipants;
                
                returnedString = [formatter titleForConversation:conversationMock];
            });
            
            it(@"should not use metadata title and return name of the other participant", ^{
                expect(returnedString).to.equal(@"Ferdinand Porsche");
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
                    [given([nameFormatterMock nameForIdentity:otherParticipantMock]) willReturn:@"Ferdinand Porsche"];
                    
                    NSArray *participantsArray = @[
                            otherParticipantMock,
                    ];
                    NSSet *participantsSet = [NSSet setWithArray:participantsArray];
                    [given(conversationMock.participants) willReturn:participantsSet];
                    participantsFilterMockReturnValue = participantsSet;
                    participantsSorterMockReturnValue = participantsArray;
                    
                    returnedString = [formatter titleForConversation:conversationMock];
                });
                
                it(@"should return full name of the other participant", ^{
                    expect(returnedString).to.equal(@"Ferdinand Porsche");
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
                    NSArray *participantsArray = @[
                            participantMock2,
                            participantMock3,
                            participantMock4,
                    ];
                    NSSet *participantsSet = [NSSet setWithArray:participantsArray];
                    participantsFilterMockReturnValue = participantsSet;
                    participantsSorterMockReturnValue = participantsArray;
                    
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
