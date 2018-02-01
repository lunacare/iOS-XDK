#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIConfiguration+DependencyInjection.h>
#import <Atlas/LYRUIMessageListPaginationController.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIMessageListPaginationController)

describe(@"LYRUIMessageListPaginationController", ^{
    __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
    __block LYRUIMessageListPaginationController *paginationController;
    __block LYRQueryController *queryControllerMock;
    __block LYRConversation *conversationMock;
    __block NSNotificationCenter *notificationCenterMock;
    __block id observerMock;

    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
        
        notificationCenterMock = mock([NSNotificationCenter class]);
        [given([injectorMock objectOfType:[NSNotificationCenter class]]) willReturn:notificationCenterMock];
        
        paginationController = [[LYRUIMessageListPaginationController alloc] initWithConfiguration:configurationMock];
        
        queryControllerMock = mock([LYRQueryController class]);
        conversationMock = mock([LYRConversation class]);
        LYRPredicate *predicateMock = mock([LYRPredicate class]);
        [given(predicateMock.property) willReturn:@"conversation"];
        [given(predicateMock.value) willReturn:conversationMock];
        LYRQuery *queryMock = mock([LYRQuery class]);
        [given(queryMock.predicate) willReturn:predicateMock];
        [given(queryControllerMock.query) willReturn:queryMock];
        
        observerMock = [NSObject new];
        [given([notificationCenterMock addObserverForName:LYRConversationDidFinishSynchronizingNotification
                                                   object:conversationMock
                                                    queue:nil
                                               usingBlock:anything()])
         willReturn:observerMock];
        
        [[[given([conversationMock synchronizeMoreMessages:0 error:NULL])
           withMatcher:anything()]
          withMatcher:anything() forArgument:1]
         willReturnBool:YES];
    });

    afterEach(^{
        paginationController = nil;
    });

    describe(@"queryController", ^{
        describe(@"setter", ^{
            beforeEach(^{
                paginationController.queryController = queryControllerMock;
            });
            
            it(@"should update query controller to passed value", ^{
                expect(paginationController.queryController).to.equal(queryControllerMock);
            });
            it(@"should update conversation to value extracted from query predicate", ^{
                expect(paginationController.conversation).to.equal(conversationMock);
            });
        });
    });
    
    describe(@"loadNextPageWithCallback:", ^{
        __block void(^callback)(BOOL);
        __block BOOL callbackCalled;
        __block BOOL capturedCanLoadMore;
        
        beforeEach(^{
            paginationController.queryController = queryControllerMock;
            callbackCalled = NO;
            callback = ^(BOOL canLoadMore) {
                callbackCalled = YES;
                capturedCanLoadMore = canLoadMore;
            };
        });
        
        context(@"when one more page of messages is available locally", ^{
            context(@"when there is exactly one page to load", ^{
                beforeEach(^{
                    [given(conversationMock.totalNumberOfMessages) willReturnUnsignedInteger:60];
                    [given(queryControllerMock.paginationWindow) willReturnInteger:-30];
                    [given(queryControllerMock.totalNumberOfObjects) willReturnUnsignedInteger:60];
                    [given(queryControllerMock.count) willReturnUnsignedInteger:30];
                    
                    [paginationController loadNextPageWithCallback:callback];
                });
                
                it(@"should expand pagination window", ^{
                    [verify(queryControllerMock) setPaginationWindow:-60];
                });
                it(@"should call the callback", ^{
                    expect(callbackCalled).to.beTruthy();
                });
                it(@"should pass NO to callback", ^{
                    expect(capturedCanLoadMore).to.beFalsy();
                });
            });
            
            context(@"when there is more than one page to load", ^{
                beforeEach(^{
                    [given(conversationMock.totalNumberOfMessages) willReturnUnsignedInteger:120];
                    [given(queryControllerMock.paginationWindow) willReturnInteger:-30];
                    [given(queryControllerMock.totalNumberOfObjects) willReturnUnsignedInteger:100];
                    [given(queryControllerMock.count) willReturnUnsignedInteger:30];
                    
                    [paginationController loadNextPageWithCallback:callback];
                });
                
                it(@"should expand pagination window", ^{
                    [verify(queryControllerMock) setPaginationWindow:-60];
                });
                it(@"should call the callback", ^{
                    expect(callbackCalled).to.beTruthy();
                });
                it(@"should pass YES to callback", ^{
                    expect(capturedCanLoadMore).to.beTruthy();
                });
            });
        });
        
        context(@"when there's less than one page of messages available locally", ^{
            context(@"and there are no more messages available remotely", ^{
                beforeEach(^{
                    [given(conversationMock.totalNumberOfMessages) willReturnUnsignedInteger:50];
                    [given(queryControllerMock.paginationWindow) willReturnInteger:-30];
                    [given(queryControllerMock.totalNumberOfObjects) willReturnUnsignedInteger:50];
                    [given(queryControllerMock.count) willReturnUnsignedInteger:30];
                    
                    [paginationController loadNextPageWithCallback:callback];
                });
                
                it(@"should expand pagination window", ^{
                    [verify(queryControllerMock) setPaginationWindow:-50];
                });
                it(@"should call the callback", ^{
                    expect(callbackCalled).to.beTruthy();
                });
                it(@"should pass NO to callback", ^{
                    expect(capturedCanLoadMore).to.beFalsy();
                });
            });
            
            context(@"and there are more messages available remotely", ^{
                context(@"less than one more page of messages total", ^{
                    beforeEach(^{
                        [given(conversationMock.totalNumberOfMessages) willReturnUnsignedInteger:55];
                        [given(queryControllerMock.paginationWindow) willReturnInteger:-30];
                        [given(queryControllerMock.totalNumberOfObjects) willReturnUnsignedInteger:50];
                        [given(queryControllerMock.count) willReturnUnsignedInteger:30];
                        
                        [paginationController loadNextPageWithCallback:callback];
                    });
                    
                    it(@"should add observer for LYRConversationDidFinishSynchronizingNotification", ^{
                        [verify(notificationCenterMock) addObserverForName:LYRConversationDidFinishSynchronizingNotification
                                                                    object:conversationMock
                                                                     queue:nil
                                                                usingBlock:anything()];
                    });
                    it(@"should synchronize more messages", ^{
                        [[verify(conversationMock)
                          withMatcher:anything() forArgument:1]
                         synchronizeMoreMessages:5 error:NULL];
                    });
                    
                    context(@"and LYRConversationDidFinishSynchronizingNotification is called", ^{
                        beforeEach(^{
                            [given(queryControllerMock.totalNumberOfObjects) willReturnUnsignedInteger:55];
                            HCArgumentCaptor *blockArgument = [HCArgumentCaptor new];
                            [verify(notificationCenterMock) addObserverForName:LYRConversationDidFinishSynchronizingNotification
                                                                        object:conversationMock
                                                                         queue:nil
                                                                    usingBlock:(id)blockArgument];
                            void(^observerBlock)(NSNotification *) = blockArgument.value;
                            observerBlock(nil);
                        });
                        
                        it(@"should remove observer from notification center", ^{
                            [verify(notificationCenterMock) removeObserver:observerMock];
                        });
                        it(@"should expand pagination window", ^{
                            [verify(queryControllerMock) setPaginationWindow:-55];
                        });
                        it(@"should call the callback", ^{
                            expect(callbackCalled).to.beTruthy();
                        });
                        it(@"should pass NO to callback", ^{
                            expect(capturedCanLoadMore).to.beFalsy();
                        });
                    });
                });
                
                context(@"exactly one more page of messages total", ^{
                    beforeEach(^{
                        [given(conversationMock.totalNumberOfMessages) willReturnUnsignedInteger:60];
                        [given(queryControllerMock.paginationWindow) willReturnInteger:-30];
                        [given(queryControllerMock.totalNumberOfObjects) willReturnUnsignedInteger:50];
                        [given(queryControllerMock.count) willReturnUnsignedInteger:30];
                        
                        [paginationController loadNextPageWithCallback:callback];
                    });
                    
                    it(@"should add observer for LYRConversationDidFinishSynchronizingNotification", ^{
                        [verify(notificationCenterMock) addObserverForName:LYRConversationDidFinishSynchronizingNotification
                                                                    object:conversationMock
                                                                     queue:nil
                                                                usingBlock:anything()];
                    });
                    it(@"should synchronize more messages", ^{
                        [[verify(conversationMock)
                          withMatcher:anything() forArgument:1]
                         synchronizeMoreMessages:10 error:NULL];
                    });
                    
                    context(@"and LYRConversationDidFinishSynchronizingNotification is called", ^{
                        beforeEach(^{
                            [given(queryControllerMock.totalNumberOfObjects) willReturnUnsignedInteger:60];
                            HCArgumentCaptor *blockArgument = [HCArgumentCaptor new];
                            [verify(notificationCenterMock) addObserverForName:LYRConversationDidFinishSynchronizingNotification
                                                                        object:conversationMock
                                                                         queue:nil
                                                                    usingBlock:(id)blockArgument];
                            void(^observerBlock)(NSNotification *) = blockArgument.value;
                            observerBlock(nil);
                        });
                        
                        it(@"should remove observer from notification center", ^{
                            [verify(notificationCenterMock) removeObserver:observerMock];
                        });
                        it(@"should expand pagination window", ^{
                            [verify(queryControllerMock) setPaginationWindow:-60];
                        });
                        it(@"should call the callback", ^{
                            expect(callbackCalled).to.beTruthy();
                        });
                        it(@"should pass NO to callback", ^{
                            expect(capturedCanLoadMore).to.beFalsy();
                        });
                    });
                });
                
                context(@"more than one more page of messages total", ^{
                    beforeEach(^{
                        [given(conversationMock.totalNumberOfMessages) willReturnUnsignedInteger:100];
                        [given(queryControllerMock.paginationWindow) willReturnInteger:-30];
                        [given(queryControllerMock.totalNumberOfObjects) willReturnUnsignedInteger:50];
                        [given(queryControllerMock.count) willReturnUnsignedInteger:30];
                        
                        [paginationController loadNextPageWithCallback:callback];
                    });
                    
                    it(@"should add observer for LYRConversationDidFinishSynchronizingNotification", ^{
                        [verify(notificationCenterMock) addObserverForName:LYRConversationDidFinishSynchronizingNotification
                                                                    object:conversationMock
                                                                     queue:nil
                                                                usingBlock:anything()];
                    });
                    it(@"should synchronize more messages", ^{
                        [[verify(conversationMock)
                          withMatcher:anything() forArgument:1]
                         synchronizeMoreMessages:10 error:NULL];
                    });
                    
                    context(@"and LYRConversationDidFinishSynchronizingNotification is called", ^{
                        beforeEach(^{
                            [given(queryControllerMock.totalNumberOfObjects) willReturnUnsignedInteger:60];
                            HCArgumentCaptor *blockArgument = [HCArgumentCaptor new];
                            [verify(notificationCenterMock) addObserverForName:LYRConversationDidFinishSynchronizingNotification
                                                                        object:conversationMock
                                                                         queue:nil
                                                                    usingBlock:(id)blockArgument];
                            void(^observerBlock)(NSNotification *) = blockArgument.value;
                            observerBlock(nil);
                        });
                        
                        it(@"should remove observer from notification center", ^{
                            [verify(notificationCenterMock) removeObserver:observerMock];
                        });
                        it(@"should expand pagination window", ^{
                            [verify(queryControllerMock) setPaginationWindow:-60];
                        });
                        it(@"should call the callback", ^{
                            expect(callbackCalled).to.beTruthy();
                        });
                        it(@"should pass YES to callback", ^{
                            expect(capturedCanLoadMore).to.beTruthy();
                        });
                    });
                });
                
                context(@"and synchronization fails", ^{
                    beforeEach(^{
                        [[[given([conversationMock synchronizeMoreMessages:0 error:NULL])
                           withMatcher:anything()]
                          withMatcher:anything() forArgument:1]
                         willReturnBool:NO];
                        
                        [given(conversationMock.totalNumberOfMessages) willReturnUnsignedInteger:100];
                        [given(queryControllerMock.paginationWindow) willReturnInteger:-30];
                        [given(queryControllerMock.totalNumberOfObjects) willReturnUnsignedInteger:50];
                        [given(queryControllerMock.count) willReturnUnsignedInteger:30];
                        
                        [paginationController loadNextPageWithCallback:callback];
                    });
                    
                    it(@"should add observer for LYRConversationDidFinishSynchronizingNotification", ^{
                        [verify(notificationCenterMock) addObserverForName:LYRConversationDidFinishSynchronizingNotification
                                                                    object:conversationMock
                                                                     queue:nil
                                                                usingBlock:anything()];
                    });
                    it(@"should try to synchronize more messages", ^{
                        [[verify(conversationMock)
                          withMatcher:anything() forArgument:1]
                         synchronizeMoreMessages:10 error:NULL];
                    });
                    it(@"should remove observer from notification center", ^{
                        [verify(notificationCenterMock) removeObserver:observerMock];
                    });
                });
            });
        });
    });
});

SpecEnd
