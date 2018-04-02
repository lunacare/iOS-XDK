#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIConfiguration+DependencyInjection.h>
#import <LayerXDK/LYRUIORSetValuesStore.h>
#import <LayerXDK/LYRUIChoiceSet.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIORSetValuesStore)

describe(@"LYRUIORSetValuesStore", ^{
    __block LYRUIORSetValuesStore *selectionsStore;
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
        
        selectionsStore = [[LYRUIORSetValuesStore alloc] initWithConfiguration:configurationMock];
    });
    
    afterEach(^{
        selectionsStore = nil;
        clientMock = nil;
        configurationMock = nil;
    });

    describe(@"dictionaryForChoiceSet:", ^{
        __block NSDictionary *returnedDictionary;

        context(@"always", ^{
            beforeEach(^{
                [selectionsStore dictionaryForChoiceSet:choiceSetMock];
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
                                            @"test_response_name": @{
                                                    @"adds": @[
                                                            @{
                                                                    @"ids": @[@"id1"],
                                                                    @"value": @"selection1"
                                                            }
                                                    ],
                                                    @"removes": @[@"id2"]
                                            }
                                    }
                            };
                            NSData *data = [NSJSONSerialization dataWithJSONObject:cachedResponses options:0 error:nil];
                            [given(messageMock.localData) willReturn:data];

                            returnedDictionary = [selectionsStore dictionaryForChoiceSet:choiceSetMock];
                        });

                        it(@"should return set of selected identifiers", ^{
                            NSDictionary *expectedDictionary = @{
                                    @"adds": @[
                                            @{
                                                    @"ids": @[@"id1"],
                                                    @"value": @"selection1"
                                            }
                                    ],
                                    @"removes": @[@"id2"]
                            };
                            expect(returnedDictionary).to.equal(expectedDictionary);
                        });
                    });

                    context(@"but not for given response name", ^{
                        beforeEach(^{
                            NSDictionary *cachedResponses = @{
                                    @"test_node_id": @{
                                            @"other_response_name": @{
                                                    @"adds": @[
                                                            @{
                                                                    @"ids": @[@"id1"],
                                                                    @"value": @"selection1"
                                                            }
                                                    ],
                                                    @"removes": @[@"id2"]
                                            }
                                    }
                            };
                            NSData *data = [NSJSONSerialization dataWithJSONObject:cachedResponses options:0 error:nil];
                            [given(messageMock.localData) willReturn:data];

                            returnedDictionary = [selectionsStore dictionaryForChoiceSet:choiceSetMock];
                        });

                        it(@"should return nil", ^{
                            expect(returnedDictionary).to.beNil();
                        });
                    });
                });

                context(@"without responses for given node id", ^{
                    beforeEach(^{
                        NSDictionary *cachedResponses = @{
                                @"other_node_id": @{
                                        @"test_response_name": @{
                                                @"adds": @[
                                                        @{
                                                                @"ids": @[@"id1"],
                                                                @"value": @"selection1"
                                                        }
                                                ],
                                                @"removes": @[@"id2"]
                                        }
                                }
                        };
                        NSData *data = [NSJSONSerialization dataWithJSONObject:cachedResponses options:0 error:nil];
                        [given(messageMock.localData) willReturn:data];

                        returnedDictionary = [selectionsStore dictionaryForChoiceSet:choiceSetMock];
                    });

                    it(@"should return nil", ^{
                        expect(returnedDictionary).to.beNil();
                    });
                });
            });

            context(@"but doesn't contain cached responses", ^{
                beforeEach(^{
                    returnedDictionary = [selectionsStore dictionaryForChoiceSet:choiceSetMock];
                });

                it(@"should return nil", ^{
                    expect(returnedDictionary).to.beNil();
                });
            });
        });

        context(@"when there is no message with given identifier", ^{
            beforeEach(^{
                [given([clientMock executeQuery:anything() error:nil]) willReturn:[NSOrderedSet orderedSet]];

                returnedDictionary = [selectionsStore dictionaryForChoiceSet:choiceSetMock];
            });

            it(@"should return nil", ^{
                expect(returnedDictionary).to.beNil();
            });
        });
    });


    describe(@"setDictionary:forChoiceSet:", ^{
        __block NSDictionary *newSelections;

        beforeEach(^{
            newSelections = @{
                    @"adds": @[
                            @{
                                    @"ids": @[@"id1"],
                                    @"value": @"selection1"
                            },
                            @{
                                    @"ids": @[@"id2"],
                                    @"value": @"selection2"
                            },
                            @{
                                    @"ids": @[@"id3"],
                                    @"value": @"selection3"
                            }
                    ],
                    @"removes": @[@"id4", @"id5"]
            };
        });

        context(@"always", ^{
            beforeEach(^{
                [selectionsStore setDictionary:newSelections forChoiceSet:choiceSetMock];
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
                                            @"test_response_name": @{
                                                    @"adds": @[
                                                            @{
                                                                    @"ids": @[@"id1"],
                                                                    @"value": @"selection1"
                                                            }
                                                    ],
                                                    @"removes": @[@"id2"]
                                            }
                                    }
                            };
                            NSData *data = [NSJSONSerialization dataWithJSONObject:cachedResponses options:0 error:nil];
                            [given(messageMock.localData) willReturn:data];

                            [selectionsStore setDictionary:newSelections forChoiceSet:choiceSetMock];
                        });

                        it(@"should update selected identifiers", ^{
                            NSDictionary *cachedResponses = @{
                                    @"test_node_id": @{
                                            @"test_response_name": @{
                                                    @"adds": @[
                                                            @{
                                                                    @"ids": @[@"id1"],
                                                                    @"value": @"selection1"
                                                            },
                                                            @{
                                                                    @"ids": @[@"id2"],
                                                                    @"value": @"selection2"
                                                            },
                                                            @{
                                                                    @"ids": @[@"id3"],
                                                                    @"value": @"selection3"
                                                            }
                                                    ],
                                                    @"removes": @[@"id4", @"id5"]
                                            }
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
                                            @"other_response_name": @{
                                                    @"adds": @[
                                                            @{
                                                                    @"ids": @[@"id1"],
                                                                    @"value": @"selection1"
                                                            }
                                                    ],
                                                    @"removes": @[@"id2"]
                                            }
                                    }
                            };
                            NSData *data = [NSJSONSerialization dataWithJSONObject:cachedResponses options:0 error:nil];
                            [given(messageMock.localData) willReturn:data];

                            [selectionsStore setDictionary:newSelections forChoiceSet:choiceSetMock];
                        });

                        it(@"should add selected identifiers for new response name", ^{
                            NSDictionary *cachedResponses = @{
                                    @"test_node_id": @{
                                            @"other_response_name": @{
                                                    @"adds": @[
                                                            @{
                                                                    @"ids": @[@"id1"],
                                                                    @"value": @"selection1"
                                                            }
                                                    ],
                                                    @"removes": @[@"id2"]
                                            },
                                            @"test_response_name": @{
                                                    @"adds": @[
                                                            @{
                                                                    @"ids": @[@"id1"],
                                                                    @"value": @"selection1"
                                                            },
                                                            @{
                                                                    @"ids": @[@"id2"],
                                                                    @"value": @"selection2"
                                                            },
                                                            @{
                                                                    @"ids": @[@"id3"],
                                                                    @"value": @"selection3"
                                                            }
                                                    ],
                                                    @"removes": @[@"id4", @"id5"]
                                            }
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
                                        @"test_response_name": @{
                                                @"adds": @[
                                                        @{
                                                                @"ids": @[@"id1"],
                                                                @"value": @"selection1"
                                                        }
                                                ],
                                                @"removes": @[@"id2"]
                                        }
                                }
                        };
                        NSData *data = [NSJSONSerialization dataWithJSONObject:cachedResponses options:0 error:nil];
                        [given(messageMock.localData) willReturn:data];

                        [selectionsStore setDictionary:newSelections forChoiceSet:choiceSetMock];
                    });

                    it(@"should add selected identifiers for new node id", ^{
                        NSDictionary *cachedResponses = @{
                                @"other_node_id": @{
                                        @"test_response_name": @{
                                                @"adds": @[
                                                        @{
                                                                @"ids": @[@"id1"],
                                                                @"value": @"selection1"
                                                        }
                                                ],
                                                @"removes": @[@"id2"]
                                        }
                                },
                                @"test_node_id": @{
                                        @"test_response_name": @{
                                                @"adds": @[
                                                        @{
                                                                @"ids": @[@"id1"],
                                                                @"value": @"selection1"
                                                        },
                                                        @{
                                                                @"ids": @[@"id2"],
                                                                @"value": @"selection2"
                                                        },
                                                        @{
                                                                @"ids": @[@"id3"],
                                                                @"value": @"selection3"
                                                        }
                                                ],
                                                @"removes": @[@"id4", @"id5"]
                                        }
                                }
                        };
                        NSData *data = [NSJSONSerialization dataWithJSONObject:cachedResponses options:0 error:nil];
                        [[verify(messageMock) withMatcher:anything() forArgument:1] setLocalData:data error:NULL];
                    });
                });
            });

            context(@"but doesn't contain cached responses", ^{
                beforeEach(^{
                    [selectionsStore setDictionary:newSelections forChoiceSet:choiceSetMock];
                });

                it(@"should save new cached responses with selected identifiers for proper node id and response name", ^{
                    NSDictionary *cachedResponses = @{
                            @"test_node_id": @{
                                    @"test_response_name": @{
                                            @"adds": @[
                                                    @{
                                                            @"ids": @[@"id1"],
                                                            @"value": @"selection1"
                                                    },
                                                    @{
                                                            @"ids": @[@"id2"],
                                                            @"value": @"selection2"
                                                    },
                                                    @{
                                                            @"ids": @[@"id3"],
                                                            @"value": @"selection3"
                                                    }
                                            ],
                                            @"removes": @[@"id4", @"id5"]
                                    }
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

                [selectionsStore setDictionary:newSelections forChoiceSet:choiceSetMock];
            });

            it(@"should not save anything", ^{
                [[verifyCount(messageMock, never()) withMatcher:anything() forArgument:1] setLocalData:anything() error:NULL];
            });
        });
    });
});

SpecEnd

