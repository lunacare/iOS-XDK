#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIConfiguration+DependencyInjection.h>
#import <LayerXDK/LYRUIChoiceSelectionsCache.h>
#import <LayerXDK/LYRUIChoiceSet.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIChoiceSelectionsCache)

describe(@"LYRUIChoiceSelectionsCache", ^{
    __block LYRUIChoiceSelectionsCache *selectionsCache;
    __block LYRUIConfiguration *configurationMock;
    __block LYRClient *clientMock;
    __block LYRMessage *messageMock;
    __block id<LYRUIChoiceSet> choiceSetMock;

    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        
        clientMock = mock([LYRClient class]);
        [given(configurationMock.client) willReturn:clientMock];
        
        messageMock = mock([LYRMessage class]);
        [given([clientMock executeQuery:anything() error:nil]) willReturn:[NSOrderedSet orderedSetWithObject:messageMock]];
        
        choiceSetMock = mockProtocol(@protocol(LYRUIChoiceSet));
        [given(choiceSetMock.responseMessageId) willReturn:@"/test/identifier"];
        [given(choiceSetMock.responseNodeId) willReturn:@"test_node_id"];
        [given(choiceSetMock.responseName) willReturn:@"test_response_name"];

        selectionsCache = [[LYRUIChoiceSelectionsCache alloc] initWithConfiguration:configurationMock];
    });

    afterEach(^{
        selectionsCache = nil;
        clientMock = nil;
        configurationMock = nil;
    });

    describe(@"selectionsForChoiceSet:", ^{
        __block NSOrderedSet<NSString *> *returnedSelections;
        
        context(@"always", ^{
            beforeEach(^{
                [selectionsCache selectionsForChoiceSet:choiceSetMock];
            });
            
            it(@"should fetch message from client", ^{
                [verify(clientMock) executeQuery:anything() error:nil];
            });
            
            context(@"executed query", ^{
                __block LYRQuery *query;
                
                beforeEach(^{
                    HCArgumentCaptor *queryArgument = [HCArgumentCaptor new];
                    [verify(clientMock) executeQuery:(LYRQuery *)queryArgument error:nil];
                    query = queryArgument.value;
                });
                
                it(@"should have proper queryable class set", ^{
                    expect(query.queryableClass).to.equal([LYRMessage class]);
                });
                it(@"should have proper limit set", ^{
                    expect(query.limit).to.equal(1);
                });
                
                context(@"predicate", ^{
                    __block LYRPredicate *predicate;
                    
                    beforeEach(^{
                        predicate = query.predicate;
                    });
                    
                    it(@"should have proper property set", ^{
                        expect(predicate.property).to.equal(@"identifier");
                    });
                    it(@"should have proper predicate operator set", ^{
                        expect(predicate.predicateOperator).to.equal(LYRPredicateOperatorIsEqualTo);
                    });
                    it(@"should have proper value set", ^{
                        expect(predicate.value).to.equal([NSURL URLWithString:@"/test/identifier"]);
                    });
                });
            });
        });
        
        context(@"when message with given identifier exists", ^{
            context(@"contains cached responses", ^{
                context(@"with responses for given node id", ^{
                    context(@"and given response name", ^{
                        beforeEach(^{
                            NSDictionary *cachedResponses = @{
                                    @"test_node_id": @{
                                            @"test_response_name": @[
                                                    @"selection1",
                                                    @"selection2"
                                            ]
                                    }
                            };
                            NSData *data = [NSJSONSerialization dataWithJSONObject:cachedResponses options:0 error:nil];
                            [given(messageMock.localData) willReturn:data];
                            
                            returnedSelections = [selectionsCache selectionsForChoiceSet:choiceSetMock];
                        });

                        it(@"should return set of selected identifiers", ^{
                            expect(returnedSelections).to.equal([NSOrderedSet orderedSetWithArray:@[ @"selection1", @"selection2" ]]);
                        });
                    });
                    
                    context(@"but not for given response name", ^{
                        beforeEach(^{
                            NSDictionary *cachedResponses = @{
                                    @"test_node_id": @{
                                            @"other_response_name": @[
                                                    @"selection1",
                                                    @"selection2"
                                            ]
                                    }
                            };
                            NSData *data = [NSJSONSerialization dataWithJSONObject:cachedResponses options:0 error:nil];
                            [given(messageMock.localData) willReturn:data];
                            
                            returnedSelections = [selectionsCache selectionsForChoiceSet:choiceSetMock];
                        });
                        
                        it(@"should return nil", ^{
                            expect(returnedSelections).to.beNil();
                        });
                    });
                });
                
                context(@"without responses for given node id", ^{
                    beforeEach(^{
                        NSDictionary *cachedResponses = @{
                                @"other_node_id": @{
                                        @"test_response_name": @[
                                                @"selection1",
                                                @"selection2"
                                        ]
                                }
                        };
                        NSData *data = [NSJSONSerialization dataWithJSONObject:cachedResponses options:0 error:nil];
                        [given(messageMock.localData) willReturn:data];
                        
                        returnedSelections = [selectionsCache selectionsForChoiceSet:choiceSetMock];
                    });
                    
                    it(@"should return nil", ^{
                        expect(returnedSelections).to.beNil();
                    });
                });
            });
            
            context(@"but doesn't contain cached responses", ^{
                beforeEach(^{
                    returnedSelections = [selectionsCache selectionsForChoiceSet:choiceSetMock];
                });
                
                it(@"should return nil", ^{
                    expect(returnedSelections).to.beNil();
                });
            });
        });
        
        context(@"when there is no message with given identifier", ^{
            beforeEach(^{
                [given([clientMock executeQuery:anything() error:nil]) willReturn:[NSOrderedSet orderedSet]];
                
                returnedSelections = [selectionsCache selectionsForChoiceSet:choiceSetMock];
            });
            
            it(@"should return nil", ^{
                expect(returnedSelections).to.beNil();
            });
        });
    });
    
    
    describe(@"setSelections:forChoiceSet:", ^{
        __block NSOrderedSet<NSString *> *newSelections;
        
        beforeEach(^{
            newSelections = [NSOrderedSet orderedSetWithArray:@[ @"selection1", @"selection2", @"selection3" ]];
        });
        
        context(@"always", ^{
            beforeEach(^{
                [selectionsCache setSelections:newSelections forChoiceSet:choiceSetMock];
            });
            
            it(@"should fetch message from client", ^{
                [verify(clientMock) executeQuery:anything() error:nil];
            });
            
            context(@"executed query", ^{
                __block LYRQuery *query;
                
                beforeEach(^{
                    HCArgumentCaptor *queryArgument = [HCArgumentCaptor new];
                    [verify(clientMock) executeQuery:(LYRQuery *)queryArgument error:nil];
                    query = queryArgument.value;
                });
                
                it(@"should have proper queryable class set", ^{
                    expect(query.queryableClass).to.equal([LYRMessage class]);
                });
                it(@"should have proper limit set", ^{
                    expect(query.limit).to.equal(1);
                });
                
                context(@"predicate", ^{
                    __block LYRPredicate *predicate;
                    
                    beforeEach(^{
                        predicate = query.predicate;
                    });
                    
                    it(@"should have proper property set", ^{
                        expect(predicate.property).to.equal(@"identifier");
                    });
                    it(@"should have proper predicate operator set", ^{
                        expect(predicate.predicateOperator).to.equal(LYRPredicateOperatorIsEqualTo);
                    });
                    it(@"should have proper value set", ^{
                        expect(predicate.value).to.equal([NSURL URLWithString:@"/test/identifier"]);
                    });
                });
            });
        });
        
        context(@"when message with given identifier exists", ^{
            context(@"contains cached responses", ^{
                context(@"with responses for given node id", ^{
                    context(@"and given response name", ^{
                        beforeEach(^{
                            NSDictionary *cachedResponses = @{
                                    @"test_node_id": @{
                                            @"test_response_name": @[
                                                    @"selection1",
                                                    @"selection2"
                                            ]
                                    }
                            };
                            NSData *data = [NSJSONSerialization dataWithJSONObject:cachedResponses options:0 error:nil];
                            [given(messageMock.localData) willReturn:data];
                            
                            [selectionsCache setSelections:newSelections forChoiceSet:choiceSetMock];
                        });
                        
                        it(@"should update selected identifiers", ^{
                            NSDictionary *cachedResponses = @{
                                    @"test_node_id": @{
                                            @"test_response_name": @[
                                                    @"selection1",
                                                    @"selection2",
                                                    @"selection3"
                                            ]
                                    }
                            };
                            NSData *data = [NSJSONSerialization dataWithJSONObject:cachedResponses options:0 error:nil];
                            [[verify(messageMock) withMatcher:anything() forArgument:1] setLocalData:data error:NULL];
                        });
                    });
                    
                    context(@"but not for given response name", ^{
                        beforeEach(^{
                            NSDictionary *cachedResponses = @{
                                    @"test_node_id": @{
                                            @"other_response_name": @[
                                                    @"selection1",
                                                    @"selection2"
                                            ]
                                    }
                            };
                            NSData *data = [NSJSONSerialization dataWithJSONObject:cachedResponses options:0 error:nil];
                            [given(messageMock.localData) willReturn:data];
                            
                            [selectionsCache setSelections:newSelections forChoiceSet:choiceSetMock];
                        });
                        
                        it(@"should add selected identifiers for new response name", ^{
                            NSDictionary *cachedResponses = @{
                                    @"test_node_id": @{
                                            @"other_response_name": @[
                                                    @"selection1",
                                                    @"selection2"
                                            ],
                                            @"test_response_name": @[
                                                    @"selection1",
                                                    @"selection2",
                                                    @"selection3"
                                            ]
                                    }
                            };
                            NSData *data = [NSJSONSerialization dataWithJSONObject:cachedResponses options:0 error:nil];
                            [[verify(messageMock) withMatcher:anything() forArgument:1] setLocalData:data error:NULL];
                        });
                    });
                });
                
                context(@"without responses for given node id", ^{
                    beforeEach(^{
                        NSDictionary *cachedResponses = @{
                                @"other_node_id": @{
                                        @"test_response_name": @[
                                                @"selection1",
                                                @"selection2"
                                        ]
                                }
                        };
                        NSData *data = [NSJSONSerialization dataWithJSONObject:cachedResponses options:0 error:nil];
                        [given(messageMock.localData) willReturn:data];
                        
                        [selectionsCache setSelections:newSelections forChoiceSet:choiceSetMock];
                    });
                    
                    it(@"should add selected identifiers for new node id", ^{
                        NSDictionary *cachedResponses = @{
                                @"other_node_id": @{
                                        @"test_response_name": @[
                                                @"selection1",
                                                @"selection2"
                                        ]
                                },
                                @"test_node_id": @{
                                        @"test_response_name": @[
                                                @"selection1",
                                                @"selection2",
                                                @"selection3"
                                        ]
                                }
                        };
                        NSData *data = [NSJSONSerialization dataWithJSONObject:cachedResponses options:0 error:nil];
                        [[verify(messageMock) withMatcher:anything() forArgument:1] setLocalData:data error:NULL];
                    });
                });
            });
            
            context(@"but doesn't contain cached responses", ^{
                beforeEach(^{
                    [selectionsCache setSelections:newSelections forChoiceSet:choiceSetMock];
                });
                
                it(@"should save new cached responses with selected identifiers for proper node id and response name", ^{
                    NSDictionary *cachedResponses = @{
                            @"test_node_id": @{
                                    @"test_response_name": @[
                                            @"selection1",
                                            @"selection2",
                                            @"selection3"
                                    ]
                            }
                    };
                    NSData *data = [NSJSONSerialization dataWithJSONObject:cachedResponses options:0 error:nil];
                    [[verify(messageMock) withMatcher:anything() forArgument:1] setLocalData:data error:NULL];
                });
            });
        });
        
        context(@"when there is no message with given identifier", ^{
            beforeEach(^{
                [given([clientMock executeQuery:anything() error:nil]) willReturn:[NSOrderedSet orderedSet]];
                
                [selectionsCache setSelections:newSelections forChoiceSet:choiceSetMock];
            });
            
            it(@"should not save anything", ^{
                [[verifyCount(messageMock, never()) withMatcher:anything() forArgument:1] setLocalData:anything() error:NULL];
            });
        });
    });
});

SpecEnd
