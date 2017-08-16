#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIComposeBarConfigurator.h>
#import <Atlas/LYRUIComposeBar.h>

@interface LYRUIComposeBarConfigurator (PrivateProperties)

@property (nonatomic) BOOL placeholderVisible;
- (void)sendButtonPressed:(UIButton *)sendButton;

@end

SpecBegin(LYRUIComposeBarConfigurator)

describe(@"LYRUIComposeBarConfigurator", ^{
    __block LYRUIComposeBarConfigurator *configurator;
    __block NSNotificationCenter *notificationCenterMock;
    __block LYRUIComposeBar *composeBarMock;
    __block UITextView *textViewMock;
    __block UIButton *sendButtonMock;

    beforeEach(^{
        notificationCenterMock = mock([NSNotificationCenter class]);
        configurator = [[LYRUIComposeBarConfigurator alloc] initWithNotificationCenter:notificationCenterMock];
        
        composeBarMock = mock([LYRUIComposeBar class]);
        textViewMock = mock([UITextView class]);
        [given(composeBarMock.inputTextView) willReturn:textViewMock];
        sendButtonMock = mock([UIButton class]);
        [given(composeBarMock.sendButton) willReturn:sendButtonMock];
    });

    afterEach(^{
        configurator = nil;
        notificationCenterMock = nil;
        composeBarMock = nil;
        sendButtonMock = nil;
        textViewMock = nil;
    });

    describe(@"configure", ^{
        beforeEach(^{
            [configurator configureComposeBar:composeBarMock];
        });
        
        it(@"should add target/action to the send buttong", ^{
            [verify(sendButtonMock) addTarget:configurator
                                       action:@selector(sendButtonPressed:)
                             forControlEvents:UIControlEventTouchUpInside];
        });
        it(@"should add observer for UITextViewTextDidBeginEditingNotification of text view", ^{
            [verify(notificationCenterMock) addObserverForName:UITextViewTextDidBeginEditingNotification
                                                        object:textViewMock
                                                         queue:nil
                                                    usingBlock:anything()];
        });
        it(@"should add observer for UITextViewTextDidChangeNotification of text view", ^{
            [verify(notificationCenterMock) addObserverForName:UITextViewTextDidChangeNotification
                                                        object:textViewMock
                                                         queue:nil
                                                    usingBlock:anything()];
        });
        it(@"should add observer for UITextViewTextDidEndEditingNotification of text view", ^{
            [verify(notificationCenterMock) addObserverForName:UITextViewTextDidEndEditingNotification
                                                        object:textViewMock
                                                         queue:nil
                                                    usingBlock:anything()];
        });
    });
    
    describe(@"cleanup", ^{
        __block NSObject *observer1;
        __block NSObject *observer2;
        __block NSObject *observer3;
        
        beforeEach(^{
            observer1 = mock([NSObject class]);
            observer2 = mock([NSObject class]);
            observer3 = mock([NSObject class]);
            
            [given([notificationCenterMock addObserverForName:UITextViewTextDidBeginEditingNotification
                                                       object:textViewMock
                                                        queue:nil
                                                   usingBlock:anything()]) willReturn:observer1];
            [given([notificationCenterMock addObserverForName:UITextViewTextDidChangeNotification
                                                       object:textViewMock
                                                        queue:nil
                                                   usingBlock:anything()]) willReturn:observer2];
            [given([notificationCenterMock addObserverForName:UITextViewTextDidEndEditingNotification
                                                       object:textViewMock
                                                        queue:nil
                                                   usingBlock:anything()]) willReturn:observer3];
            
            [configurator configureComposeBar:composeBarMock];
            
            [configurator cleanup];
        });
        
        it(@"should remove target/action from send button", ^{
            [verify(sendButtonMock) removeTarget:configurator
                                          action:@selector(sendButtonPressed:)
                                forControlEvents:UIControlEventTouchUpInside];
        });
        it(@"should remove observer for UITextViewTextDidBeginEditingNotification", ^{
            [verify(notificationCenterMock) removeObserver:observer1];
        });
        it(@"should remove observer for UITextViewTextDidChangeNotification", ^{
            [verify(notificationCenterMock) removeObserver:observer2];
        });
        it(@"should remove observer for UITextViewTextDidEndEditingNotification", ^{
            [verify(notificationCenterMock) removeObserver:observer3];
        });
    });
    
    describe(@"UITextViewTextDidBeginEditingNotification observer block", ^{
        __block void(^block)(NSNotification *);
        
        beforeEach(^{
            [configurator configureComposeBar:composeBarMock];
            HCArgumentCaptor *blockArgument = [HCArgumentCaptor new];
            [verify(notificationCenterMock) addObserverForName:UITextViewTextDidBeginEditingNotification
                                                        object:textViewMock
                                                         queue:nil
                                                    usingBlock:(id)blockArgument];
            block = blockArgument.value;
            
            [given(composeBarMock.textColor) willReturn:[UIColor magentaColor]];
        });
        
        context(@"when placeholder is visible", ^{
            beforeEach(^{
                configurator.placeholderVisible = YES;
                block(mock([NSNotification class]));
            });
            
            it(@"should update placeholder visible property to NO", ^{
                expect(configurator.placeholderVisible).to.beFalsy();
            });
            it(@"should set text view's text color to compose bar text color", ^{
                [verify(textViewMock) setTextColor:[UIColor magentaColor]];
            });
            it(@"should update text view's text to nil", ^{
                [verify(textViewMock) setText:nil];
            });
        });
        
        context(@"when placeholder is not visible", ^{
            beforeEach(^{
                configurator.placeholderVisible = NO;
                block(mock([NSNotification class]));
            });
            
            it(@"should not change placeholder visible property value", ^{
                expect(configurator.placeholderVisible).to.beFalsy();
            });
            it(@"should not set text view's text color", ^{
                [verifyCount(textViewMock, never()) setTextColor:anything()];
            });
            it(@"should not update text view's text", ^{
                [verifyCount(textViewMock, never()) setText:anything()];
            });
        });
    });
    
    describe(@"UITextViewTextDidChangeNotification observer block", ^{
        __block void(^block)(NSNotification *);
        
        beforeEach(^{
            [configurator configureComposeBar:composeBarMock];
            HCArgumentCaptor *blockArgument = [HCArgumentCaptor new];
            [verify(notificationCenterMock) addObserverForName:UITextViewTextDidChangeNotification
                                                        object:textViewMock
                                                         queue:nil
                                                    usingBlock:(id)blockArgument];
            block = blockArgument.value;
        });
        
        context(@"when placeholder is visible", ^{
            beforeEach(^{
                configurator.placeholderVisible = YES;
                block(mock([NSNotification class]));
            });
            
            it(@"should not update send button's enabled property", ^{
                [[verifyCount(sendButtonMock, never()) withMatcher:anything()] setEnabled:YES];
            });
        });
        
        context(@"when placeholder is not visible", ^{
            beforeEach(^{
                configurator.placeholderVisible = NO;
            });
            
            context(@"when text view text is nil", ^{
                beforeEach(^{
                    [given(textViewMock.text) willReturn:nil];
                    block(mock([NSNotification class]));
                });
                
                it(@"should set send button's enabled property to NO", ^{
                    [verify(sendButtonMock) setEnabled:NO];
                });
            });
            
            context(@"when text view text is empty string", ^{
                beforeEach(^{
                    [given(textViewMock.text) willReturn:@""];
                    block(mock([NSNotification class]));
                });
                
                it(@"should set send button's enabled property to NO", ^{
                    [verify(sendButtonMock) setEnabled:NO];
                });
            });
            
            context(@"when text view text is non empty string", ^{
                beforeEach(^{
                    [given(textViewMock.text) willReturn:@"1"];
                    block(mock([NSNotification class]));
                });
                
                it(@"should set send button's enabled property to YES", ^{
                    [verify(sendButtonMock) setEnabled:YES];
                });
            });
        });
    });
    
    describe(@"UITextViewTextDidEndEditingNotification observer block", ^{
        __block void(^block)(NSNotification *);
        
        beforeEach(^{
            [configurator configureComposeBar:composeBarMock];
            HCArgumentCaptor *blockArgument = [HCArgumentCaptor new];
            [verify(notificationCenterMock) addObserverForName:UITextViewTextDidEndEditingNotification
                                                        object:textViewMock
                                                         queue:nil
                                                    usingBlock:(id)blockArgument];
            block = blockArgument.value;
            
            configurator.placeholderVisible = NO;
            [given(composeBarMock.placeholderColor) willReturn:[UIColor purpleColor]];
            [given(composeBarMock.placeholder) willReturn:@"test placeholder"];
        });
        
        context(@"when text view text is nil", ^{
            beforeEach(^{
                [given(textViewMock.text) willReturn:nil];
                block(mock([NSNotification class]));
            });
            
            it(@"should update placeholder visible property to YES", ^{
                expect(configurator.placeholderVisible).to.beTruthy();
            });
            it(@"should set text view's text color to compose bar placeholder color", ^{
                [verify(textViewMock) setTextColor:[UIColor purpleColor]];
            });
            it(@"should update text view's text to placeholder", ^{
                [verify(textViewMock) setText:@"test placeholder"];
            });
        });
        
        context(@"when text view text is empty string", ^{
            beforeEach(^{
                [given(textViewMock.text) willReturn:@""];
                block(mock([NSNotification class]));
            });
            
            it(@"should update placeholder visible property to YES", ^{
                expect(configurator.placeholderVisible).to.beTruthy();
            });
            it(@"should set text view's text color to compose bar placeholder color", ^{
                [verify(textViewMock) setTextColor:[UIColor purpleColor]];
            });
            it(@"should update text view's text to placeholder", ^{
                [verify(textViewMock) setText:@"test placeholder"];
            });
        });
        
        context(@"when text view text is non empty string", ^{
            beforeEach(^{
                [given(textViewMock.text) willReturn:@"1"];
                block(mock([NSNotification class]));
            });
            
            it(@"should not change placeholder visible property value", ^{
                expect(configurator.placeholderVisible).to.beFalsy();
            });
            it(@"should not set text view's text color", ^{
                [verifyCount(textViewMock, never()) setTextColor:anything()];
            });
            it(@"should not update text view's text", ^{
                [verifyCount(textViewMock, never()) setText:anything()];
            });
        });
    });
    
    describe(@"sendButtonPressed:", ^{
        __block BOOL callbackCalled;
        __block NSAttributedString *capturedString;
        
        beforeEach(^{
            callbackCalled = NO;
            [given(composeBarMock.sendButtonPressedCallback) willReturn:^(NSAttributedString *string) {
                callbackCalled = YES;
                capturedString = string;
            }];
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"test text"];
            [given(textViewMock.attributedText) willReturn:attributedString];
            [configurator configureComposeBar:composeBarMock];
        });
        
        afterEach(^{
            capturedString = nil;
        });
        
        context(@"when placeholder is visible", ^{
            beforeEach(^{
                configurator.placeholderVisible = YES;
                [configurator sendButtonPressed:sendButtonMock];
            });
            
            it(@"should not call the callback", ^{
                expect(callbackCalled).to.beFalsy();
            });
        });
        
        context(@"when placeholder is not visible", ^{
            beforeEach(^{
                configurator.placeholderVisible = NO;
                [configurator sendButtonPressed:sendButtonMock];
            });
            
            it(@"should call the callback", ^{
                expect(callbackCalled).to.beTruthy();
            });
            it(@"should call the callback with attributed text of text view", ^{
                NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"test text"];
                expect(capturedString).to.equal(attributedString);
            });
            it(@"should set text view's text to nil", ^{
                [verify(textViewMock) setText:nil];
            });
        });
    });
    
    describe(@"placeholderUpdated", ^{
        beforeEach(^{
            [given(composeBarMock.placeholder) willReturn:@"test placeholder"];
            [configurator configureComposeBar:composeBarMock];
        });
        
        context(@"when placeholder is visible", ^{
            beforeEach(^{
                configurator.placeholderVisible = YES;
                [configurator placeholderUpdated];
            });
            
            it(@"should not change value of placeholder visible property", ^{
                expect(configurator.placeholderVisible).to.beTruthy();
            });
            it(@"should update text view's text with placeholder", ^{
                [verify(textViewMock) setText:@"test placeholder"];
            });
        });
        
        context(@"when placeholder is not visible", ^{
            beforeEach(^{
                configurator.placeholderVisible = NO;
                [configurator placeholderUpdated];
            });
            
            it(@"should not change value of placeholder visible property", ^{
                expect(configurator.placeholderVisible).to.beFalsy();
            });
            it(@"should not update text view's text with placeholder", ^{
                [verifyCount(textViewMock, never()) setText:anything()];
            });
        });
    });
    
    describe(@"colorsUpdated", ^{
        beforeEach(^{
            [given(composeBarMock.placeholderColor) willReturn:[UIColor magentaColor]];
            [given(composeBarMock.textColor) willReturn:[UIColor purpleColor]];
            [configurator configureComposeBar:composeBarMock];
        });
        
        context(@"when placeholder is visible", ^{
            beforeEach(^{
                configurator.placeholderVisible = YES;
                [configurator colorsUpdated];
            });
            
            it(@"should update text view's text color with compose bar's placeholder color", ^{
                [verify(textViewMock) setTextColor:[UIColor magentaColor]];
            });
        });
        
        context(@"when placeholder is not visible", ^{
            beforeEach(^{
                configurator.placeholderVisible = NO;
                [configurator colorsUpdated];
            });
            
            it(@"should update text view's text color with compose bar's text color", ^{
                [verify(textViewMock) setTextColor:[UIColor purpleColor]];
            });
        });
    });
    
    describe(@"messageText", ^{
        beforeEach(^{
            [given(textViewMock.text) willReturn:@"test text"];
            [configurator configureComposeBar:composeBarMock];
        });
        
        context(@"getter", ^{
            context(@"when placeholder is visible", ^{
                beforeEach(^{
                    configurator.placeholderVisible = YES;
                });
                
                it(@"should return nil", ^{
                    expect(configurator.messageText).to.beNil();
                });
            });
            
            context(@"when placeholder is not visible", ^{
                beforeEach(^{
                    configurator.placeholderVisible = NO;
                });
                
                it(@"should return text view's text", ^{
                    expect(configurator.messageText).to.equal(@"test text");
                });
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                [given(composeBarMock.textColor) willReturn:[UIColor purpleColor]];
                [given(composeBarMock.placeholderColor) willReturn:[UIColor magentaColor]];
                [given(composeBarMock.placeholder) willReturn:@"test placeholder"];
            });
            
            context(@"when message text is nil", ^{
                beforeEach(^{
                    configurator.placeholderVisible = NO;
                    configurator.messageText = nil;
                });
                
                it(@"should update placeholder visible property to YES", ^{
                    expect(configurator.placeholderVisible).to.beTruthy();
                });
                it(@"should set text view's text color to compose bar placeholder color", ^{
                    [verify(textViewMock) setTextColor:[UIColor magentaColor]];
                });
                it(@"should update text view's text to placeholder", ^{
                    [verify(textViewMock) setText:@"test placeholder"];
                });
            });
            
            context(@"when message text is empty string", ^{
                beforeEach(^{
                    configurator.placeholderVisible = NO;
                    configurator.messageText = @"";
                });
                
                it(@"should update placeholder visible property to YES", ^{
                    expect(configurator.placeholderVisible).to.beTruthy();
                });
                it(@"should set text view's text color to compose bar placeholder color", ^{
                    [verify(textViewMock) setTextColor:[UIColor magentaColor]];
                });
                it(@"should update text view's text to placeholder", ^{
                    [verify(textViewMock) setText:@"test placeholder"];
                });
            });
            
            context(@"when message text is non empty string", ^{
                beforeEach(^{
                    configurator.placeholderVisible = YES;
                    configurator.messageText = @"1";
                });
                
                it(@"should update placeholder visible property to NO", ^{
                    expect(configurator.placeholderVisible).to.beFalsy();
                });
                it(@"should set text view's text color to compose bar text color", ^{
                    [verify(textViewMock) setTextColor:[UIColor purpleColor]];
                });
                it(@"should update text view's text to passed string", ^{
                    [verify(textViewMock) setText:@"1"];
                });
            });
        });
    });
    
    describe(@"attributedMessageText", ^{
        beforeEach(^{
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"test text"];
            [given(textViewMock.attributedText) willReturn:attributedString];
            [configurator configureComposeBar:composeBarMock];
        });
        
        context(@"getter", ^{
            context(@"when placeholder is visible", ^{
                beforeEach(^{
                    configurator.placeholderVisible = YES;
                });
                
                it(@"should return nil", ^{
                    expect(configurator.attributedMessageText).to.beNil();
                });
            });
            
            context(@"when placeholder is not visible", ^{
                beforeEach(^{
                    configurator.placeholderVisible = NO;
                });
                
                it(@"should return text view's attributed text", ^{
                    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"test text"];
                    expect(configurator.attributedMessageText).to.equal(attributedString);
                });
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                [given(composeBarMock.textColor) willReturn:[UIColor purpleColor]];
                [given(composeBarMock.placeholderColor) willReturn:[UIColor magentaColor]];
                [given(composeBarMock.placeholder) willReturn:@"test placeholder"];
            });
            
            context(@"when message text is nil", ^{
                beforeEach(^{
                    configurator.placeholderVisible = NO;
                    configurator.attributedMessageText = nil;
                });
                
                it(@"should update placeholder visible property to YES", ^{
                    expect(configurator.placeholderVisible).to.beTruthy();
                });
                it(@"should set text view's text color to compose bar placeholder color", ^{
                    [verify(textViewMock) setTextColor:[UIColor magentaColor]];
                });
                it(@"should update text view's text to placeholder", ^{
                    [verify(textViewMock) setText:@"test placeholder"];
                });
            });
            
            context(@"when message text is empty attributed string", ^{
                beforeEach(^{
                    configurator.placeholderVisible = NO;
                    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@""];
                    configurator.attributedMessageText = attributedString;
                });
                
                it(@"should update placeholder visible property to YES", ^{
                    expect(configurator.placeholderVisible).to.beTruthy();
                });
                it(@"should set text view's text color to compose bar placeholder color", ^{
                    [verify(textViewMock) setTextColor:[UIColor magentaColor]];
                });
                it(@"should update text view's text to placeholder", ^{
                    [verify(textViewMock) setText:@"test placeholder"];
                });
            });
            
            context(@"when message text is non empty attributed string", ^{
                beforeEach(^{
                    configurator.placeholderVisible = YES;
                    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"1"];
                    configurator.attributedMessageText = attributedString;
                });
                
                it(@"should update placeholder visible property to NO", ^{
                    expect(configurator.placeholderVisible).to.beFalsy();
                });
                it(@"should set text view's text color to compose bar text color", ^{
                    [verify(textViewMock) setTextColor:[UIColor purpleColor]];
                });
                it(@"should update text view's attributed text to passed string", ^{
                    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"1"];
                    [verify(textViewMock) setAttributedText:attributedString];
                });
            });
        });
    });
});

SpecEnd
