#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIConfiguration+DependencyInjection.h>
#import <LayerXDK/LYRUIORSetsCache.h>
#import <LayerXDK/LYRUIChoiceSet.h>
#import <LayerXDK/LYRUIORSet.h>
#import <LayerXDK/LYRUIFWWRegister.h>
#import <LayerXDK/LYRUILWWRegister.h>
#import <LayerXDK/LYRUILWWNRegister.h>
#import <LayerXDK/LYRUIORSetValuesStore.h>

SpecBegin(LYRUIORSetsCache)

describe(@"LYRUIORSetsCache", ^{
    __block LYRUIORSetsCache *selectionsCache;
    __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
    __block LYRUIORSetValuesStore *storeMock;
    __block id<LYRUIChoiceSet> choiceSetMock;

    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
        
        storeMock = mock([LYRUIORSetValuesStore class]);
        [given([injectorMock objectOfType:[LYRUIORSetValuesStore class]]) willReturn:storeMock];
        
        choiceSetMock = mockProtocol(@protocol(LYRUIChoiceSet));

        selectionsCache = [[LYRUIORSetsCache alloc] initWithConfiguration:configurationMock];
    });

    afterEach(^{
        selectionsCache = nil;
        storeMock = nil;
        configurationMock = nil;
    });

    describe(@"ORSetForChoiceSet:", ^{
        __block LYRUIORSet *returnedSet;
        
        context(@"always", ^{
            beforeEach(^{
                [selectionsCache ORSetForChoiceSet:choiceSetMock];
            });
            
            it(@"should try to retrieve stored operations", ^{
                [verify(storeMock) dictionaryForChoiceSet:choiceSetMock];
            });
        });
        
        context(@"for single selection set", ^{
            context(@"when there is no stored set for given choice set", ^{
                beforeEach(^{
                    [given([storeMock dictionaryForChoiceSet:choiceSetMock]) willReturn:nil];
                    returnedSet = [selectionsCache ORSetForChoiceSet:choiceSetMock];
                });
                
                it(@"should return set of `LYRUIFWWRegister` type", ^{
                    expect(returnedSet).to.beAKindOf([LYRUIFWWRegister class]);
                });
                it(@"should return set with no adds", ^{
                    expect(returnedSet.adds).to.haveCount(0);
                });
                it(@"should return set with no removes", ^{
                    expect(returnedSet.removes).to.haveCount(0);
                });
            });
            
            context(@"when there is set stored for given choice set", ^{
                beforeEach(^{
                    [given([storeMock dictionaryForChoiceSet:choiceSetMock]) willReturn:@{
                            @"adds": @[
                                    @{
                                            @"ids": @[@"id1"],
                                            @"value": @"selection1"
                                    },
                            ],
                            @"removes": @[@"id2", @"id3"]
                    }];
                    returnedSet = [selectionsCache ORSetForChoiceSet:choiceSetMock];
                });
                
                it(@"should return set of `LYRUIFWWRegister` type", ^{
                    expect(returnedSet).to.beAKindOf([LYRUIFWWRegister class]);
                });
                it(@"should return set with stored adds", ^{
                    expect(returnedSet.adds).to.haveCount(1);
                });
                it(@"should return set with stored removes", ^{
                    expect(returnedSet.removes).to.haveCount(2);
                });
            });
        });

        context(@"for single selection with reselection set", ^{
            beforeEach(^{
                [given(choiceSetMock.allowReselect) willReturnBool:YES];
            });

            context(@"when there is no stored set for given choice set", ^{
                beforeEach(^{
                    [given([storeMock dictionaryForChoiceSet:choiceSetMock]) willReturn:nil];
                    returnedSet = [selectionsCache ORSetForChoiceSet:choiceSetMock];
                });

                it(@"should return set of `LYRUILWWRegister` type", ^{
                    expect(returnedSet).to.beAKindOf([LYRUILWWRegister class]);
                });
                it(@"should return set with no adds", ^{
                    expect(returnedSet.adds).to.haveCount(0);
                });
                it(@"should return set with no removes", ^{
                    expect(returnedSet.removes).to.haveCount(0);
                });
            });

            context(@"when there is set stored for given choice set", ^{
                beforeEach(^{
                    [given([storeMock dictionaryForChoiceSet:choiceSetMock]) willReturn:@{
                            @"adds": @[
                                    @{
                                            @"ids": @[@"id1"],
                                            @"value": @"selection1"
                                    },
                            ],
                            @"removes": @[@"id2", @"id3"]
                    }];
                    returnedSet = [selectionsCache ORSetForChoiceSet:choiceSetMock];
                });

                it(@"should return set of `LYRUILWWRegister` type", ^{
                    expect(returnedSet).to.beAKindOf([LYRUILWWRegister class]);
                });
                it(@"should return set with stored adds", ^{
                    expect(returnedSet.adds).to.haveCount(1);
                });
                it(@"should return set with stored removes", ^{
                    expect(returnedSet.removes).to.haveCount(2);
                });
            });
        });

        context(@"for single selection with deselection set", ^{
            beforeEach(^{
                [given(choiceSetMock.allowDeselect) willReturnBool:YES];
            });

            context(@"when there is no stored set for given choice set", ^{
                beforeEach(^{
                    [given([storeMock dictionaryForChoiceSet:choiceSetMock]) willReturn:nil];
                    returnedSet = [selectionsCache ORSetForChoiceSet:choiceSetMock];
                });

                it(@"should return set of `LYRUILWWNRegister` type", ^{
                    expect(returnedSet).to.beAKindOf([LYRUILWWNRegister class]);
                });
                it(@"should return set with no adds", ^{
                    expect(returnedSet.adds).to.haveCount(0);
                });
                it(@"should return set with no removes", ^{
                    expect(returnedSet.removes).to.haveCount(0);
                });
            });

            context(@"when there is set stored for given choice set", ^{
                beforeEach(^{
                    [given([storeMock dictionaryForChoiceSet:choiceSetMock]) willReturn:@{
                            @"adds": @[
                                    @{
                                            @"ids": @[@"id1"],
                                            @"value": @"selection1"
                                    },
                            ],
                            @"removes": @[@"id2", @"id3"]
                    }];
                    returnedSet = [selectionsCache ORSetForChoiceSet:choiceSetMock];
                });

                it(@"should return set of `LYRUILWWNRegister` type", ^{
                    expect(returnedSet).to.beAKindOf([LYRUILWWNRegister class]);
                });
                it(@"should return set with stored adds", ^{
                    expect(returnedSet.adds).to.haveCount(1);
                });
                it(@"should return set with stored removes", ^{
                    expect(returnedSet.removes).to.haveCount(2);
                });
            });
        });

        context(@"for multiselection set", ^{
            beforeEach(^{
                [given(choiceSetMock.allowMultiselect) willReturnBool:YES];
            });

            context(@"when there is no stored set for given choice set", ^{
                beforeEach(^{
                    [given([storeMock dictionaryForChoiceSet:choiceSetMock]) willReturn:nil];
                    returnedSet = [selectionsCache ORSetForChoiceSet:choiceSetMock];
                });

                it(@"should return set of `LYRUIORSet` type", ^{
                    expect(returnedSet).to.beAKindOf([LYRUIORSet class]);
                });
                it(@"should return set with no adds", ^{
                    expect(returnedSet.adds).to.haveCount(0);
                });
                it(@"should return set with no removes", ^{
                    expect(returnedSet.removes).to.haveCount(0);
                });
            });

            context(@"when there is set stored for given choice set", ^{
                beforeEach(^{
                    [given([storeMock dictionaryForChoiceSet:choiceSetMock]) willReturn:@{
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
                    }];
                    returnedSet = [selectionsCache ORSetForChoiceSet:choiceSetMock];
                });

                it(@"should return set of `LYRUIORSet` type", ^{
                    expect(returnedSet).to.beAKindOf([LYRUIORSet class]);
                });
                it(@"should return set with stored adds", ^{
                    expect(returnedSet.adds).to.haveCount(3);
                });
                it(@"should return set with stored removes", ^{
                    expect(returnedSet.removes).to.haveCount(2);
                });
            });
        });
    });


    describe(@"storeORSet:forChoiceSet:", ^{
        beforeEach(^{
            LYRUIORSet *newSet = [[LYRUIORSet alloc] initWithPropertyName:@"test property name" dictionary:@{
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
            }];
            [selectionsCache storeORSet:newSet forChoiceSet:choiceSetMock];
        });

        it(@"should store the set", ^{
            [verify(storeMock) setDictionary:anything() forChoiceSet:choiceSetMock];
        });
        context(@"stored dictionary", ^{
            __block NSDictionary *storedDictionary;

            beforeEach(^{
                HCArgumentCaptor *dictionaryArgument = [HCArgumentCaptor new];
                [verify(storeMock) setDictionary:(NSDictionary *)dictionaryArgument forChoiceSet:choiceSetMock];
                storedDictionary = dictionaryArgument.value;
            });

            it(@"should contain `selection1` in adds", ^{
                NSDictionary *selection1Dict = @{@"ids": @[@"id1"], @"value": @"selection1"};
                expect(storedDictionary[@"adds"]).to.contain(selection1Dict);
            });
            it(@"should contain `selection2` in adds", ^{
                NSDictionary *selection2Dict = @{@"ids": @[@"id2"], @"value": @"selection2"};
                expect(storedDictionary[@"adds"]).to.contain(selection2Dict);
            });
            it(@"should contain `selection3` in adds", ^{
                NSDictionary *selection3Dict = @{@"ids": @[@"id3"], @"value": @"selection3"};
                expect(storedDictionary[@"adds"]).to.contain(selection3Dict);
            });
            it(@"should contain `id4`, and `id5` in adds", ^{
                NSArray *removesArray = @[@"id4", @"id5"];
                expect(storedDictionary[@"removes"]).to.equal(removesArray);
            });
        });
    });
});

SpecEnd
