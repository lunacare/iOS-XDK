#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIConfiguration+DependencyInjection.h>
#import <Atlas/LYRUIComposeBarConfiguration.h>
#import <Atlas/LYRUIComposeBar.h>

@interface LYRUIComposeBarConfiguration (PrivateProperties)

@property (nonatomic) BOOL placeholderVisible;

@end

SpecBegin(LYRUIComposeBarConfiguration)

describe(@"LYRUIComposeBarConfiguration", ^{
    __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
    __block LYRUIComposeBarConfiguration *configuration;
    __block NSNotificationCenter *notificationCenterMock;
    __block LYRUIComposeBar *composeBarMock;
    __block UITextView *textViewMock;
    __block UIButton *sendButtonMock;

    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
        
        notificationCenterMock = mock([NSNotificationCenter class]);
        [given([injectorMock objectOfType:[NSNotificationCenter class]]) willReturn:notificationCenterMock];
        
        configuration = [[LYRUIComposeBarConfiguration alloc] initWithConfiguration:configurationMock];
        
        composeBarMock = mock([LYRUIComposeBar class]);
        textViewMock = mock([UITextView class]);
        [given(textViewMock.text) willReturn:@"test message text"];
        [given(composeBarMock.inputTextView) willReturn:textViewMock];
        sendButtonMock = mock([UIButton class]);
        [given(composeBarMock.sendButton) willReturn:sendButtonMock];
    });

    afterEach(^{
        configuration = nil;
        notificationCenterMock = nil;
        composeBarMock = nil;
        sendButtonMock = nil;
        textViewMock = nil;
    });

    describe(@"configure", ^{
        context(@"always", ^{
            beforeEach(^{
                [configuration configureComposeBar:composeBarMock];
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
            it(@"should add observer for keypath `placeholder`", ^{
                [verify(composeBarMock) addObserver:configuration forKeyPath:@"placeholder" options:NSKeyValueObservingOptionNew context:NULL];
            });
            it(@"should add observer for keypath `textColor`", ^{
                [verify(composeBarMock) addObserver:configuration forKeyPath:@"textColor" options:NSKeyValueObservingOptionNew context:NULL];
            });
            it(@"should add observer for keypath `placeholderColor`", ^{
                [verify(composeBarMock) addObserver:configuration forKeyPath:@"placeholderColor" options:NSKeyValueObservingOptionNew context:NULL];
            });
        });
        
        context(@"when input text view contains text", ^{
            beforeEach(^{
                [given(textViewMock.text) willReturn:@"test message text"];
                [configuration configureComposeBar:composeBarMock];
            });
            
            it(@"should not set text view text color", ^{
                [verifyCount(textViewMock, never()) setTextColor:anything()];
            });
            it(@"should not update text view text", ^{
                [verifyCount(textViewMock, never()) setText:anything()];
            });
            it(@"should not disable send button", ^{
                [verifyCount(sendButtonMock, never()) setEnabled:NO];
            });
        });
        
        context(@"when input text view text is nil", ^{
            beforeEach(^{
                [given(textViewMock.text) willReturn:nil];
                [given(composeBarMock.placeholder) willReturn:@"test placeholder"];
                [given(composeBarMock.placeholderColor) willReturn:[UIColor purpleColor]];
                [configuration configureComposeBar:composeBarMock];
            });
            
            it(@"should set text view text color to compose bar placeholder color", ^{
                [verify(textViewMock) setTextColor:[UIColor purpleColor]];
            });
            it(@"should update text view text to compose bar placeholder", ^{
                [verify(textViewMock) setText:@"test placeholder"];
            });
            it(@"should disable send button", ^{
                [verify(sendButtonMock) setEnabled:NO];
            });
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
            
            [configuration configureComposeBar:composeBarMock];
            
            [configuration cleanup];
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
        it(@"should remove observer for keypath `placeholder`", ^{
            [verify(composeBarMock) removeObserver:configuration forKeyPath:@"placeholder"];
        });
        it(@"should remove observer for keypath `textColor`", ^{
            [verify(composeBarMock) removeObserver:configuration forKeyPath:@"textColor"];
        });
        it(@"should remove observer for keypath `placeholderColor`", ^{
            [verify(composeBarMock) removeObserver:configuration forKeyPath:@"placeholderColor"];
        });
    });
    
    describe(@"UITextViewTextDidBeginEditingNotification observer block", ^{
        __block void(^block)(NSNotification *);
        
        beforeEach(^{
            [configuration configureComposeBar:composeBarMock];
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
                configuration.placeholderVisible = YES;
                block(mock([NSNotification class]));
            });
            
            it(@"should update placeholder visible property to NO", ^{
                expect(configuration.placeholderVisible).to.beFalsy();
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
                configuration.placeholderVisible = NO;
                block(mock([NSNotification class]));
            });
            
            it(@"should not change placeholder visible property value", ^{
                expect(configuration.placeholderVisible).to.beFalsy();
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
            [configuration configureComposeBar:composeBarMock];
            HCArgumentCaptor *blockArgument = [HCArgumentCaptor new];
            [verify(notificationCenterMock) addObserverForName:UITextViewTextDidChangeNotification
                                                        object:textViewMock
                                                         queue:nil
                                                    usingBlock:(id)blockArgument];
            block = blockArgument.value;
        });
        
        context(@"when placeholder is visible", ^{
            beforeEach(^{
                configuration.placeholderVisible = YES;
                block(mock([NSNotification class]));
            });
            
            it(@"should not update send button's enabled property", ^{
                [[verifyCount(sendButtonMock, never()) withMatcher:anything()] setEnabled:YES];
            });
        });
        
        context(@"when placeholder is not visible", ^{
            beforeEach(^{
                configuration.placeholderVisible = NO;
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
            [configuration configureComposeBar:composeBarMock];
            HCArgumentCaptor *blockArgument = [HCArgumentCaptor new];
            [verify(notificationCenterMock) addObserverForName:UITextViewTextDidEndEditingNotification
                                                        object:textViewMock
                                                         queue:nil
                                                    usingBlock:(id)blockArgument];
            block = blockArgument.value;
            
            configuration.placeholderVisible = NO;
            [given(composeBarMock.placeholderColor) willReturn:[UIColor purpleColor]];
            [given(composeBarMock.placeholder) willReturn:@"test placeholder"];
        });
        
        context(@"when text view text is nil", ^{
            beforeEach(^{
                [given(textViewMock.text) willReturn:nil];
                block(mock([NSNotification class]));
            });
            
            it(@"should update placeholder visible property to YES", ^{
                expect(configuration.placeholderVisible).to.beTruthy();
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
                expect(configuration.placeholderVisible).to.beTruthy();
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
                expect(configuration.placeholderVisible).to.beFalsy();
            });
            it(@"should not set text view's text color", ^{
                [verifyCount(textViewMock, never()) setTextColor:anything()];
            });
            it(@"should not update text view's text", ^{
                [verifyCount(textViewMock, never()) setText:anything()];
            });
        });
    });
    
    describe(@"placeholderUpdated", ^{
        beforeEach(^{
            [given(composeBarMock.placeholder) willReturn:@"test placeholder"];
            [configuration configureComposeBar:composeBarMock];
        });
        
        context(@"when placeholder is visible", ^{
            beforeEach(^{
                configuration.placeholderVisible = YES;
                [configuration observeValueForKeyPath:@"placeholder" ofObject:composeBarMock change:nil context:NULL];
            });
            
            it(@"should not change value of placeholder visible property", ^{
                expect(configuration.placeholderVisible).to.beTruthy();
            });
            it(@"should update text view's text with placeholder", ^{
                [verify(textViewMock) setText:@"test placeholder"];
            });
        });
        
        context(@"when placeholder is not visible", ^{
            beforeEach(^{
                configuration.placeholderVisible = NO;
                [configuration observeValueForKeyPath:@"placeholder" ofObject:composeBarMock change:nil context:NULL];
            });
            
            it(@"should not change value of placeholder visible property", ^{
                expect(configuration.placeholderVisible).to.beFalsy();
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
            [configuration configureComposeBar:composeBarMock];
        });
        
        context(@"when placeholder is visible", ^{
            beforeEach(^{
                configuration.placeholderVisible = YES;
                [configuration observeValueForKeyPath:@"textColor" ofObject:composeBarMock change:nil context:NULL];
            });
            
            it(@"should update text view's text color with compose bar's placeholder color", ^{
                [verify(textViewMock) setTextColor:[UIColor magentaColor]];
            });
        });
        
        context(@"when placeholder is not visible", ^{
            beforeEach(^{
                configuration.placeholderVisible = NO;
                [configuration observeValueForKeyPath:@"placeholderColor" ofObject:composeBarMock change:nil context:NULL];
            });
            
            it(@"should update text view's text color with compose bar's text color", ^{
                [verify(textViewMock) setTextColor:[UIColor purpleColor]];
            });
        });
    });
    
    describe(@"text", ^{
        beforeEach(^{
            [given(textViewMock.text) willReturn:@"test text"];
            [configuration configureComposeBar:composeBarMock];
        });
        
        context(@"getter", ^{
            context(@"when placeholder is visible", ^{
                beforeEach(^{
                    configuration.placeholderVisible = YES;
                });
                
                it(@"should return nil", ^{
                    expect(configuration.text).to.beNil();
                });
            });
            
            context(@"when placeholder is not visible", ^{
                beforeEach(^{
                    configuration.placeholderVisible = NO;
                });
                
                it(@"should return text view's text", ^{
                    expect(configuration.text).to.equal(@"test text");
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
                    configuration.placeholderVisible = NO;
                    configuration.text = nil;
                });
                
                it(@"should update placeholder visible property to YES", ^{
                    expect(configuration.placeholderVisible).to.beTruthy();
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
                    configuration.placeholderVisible = NO;
                    configuration.text = @"";
                });
                
                it(@"should update placeholder visible property to YES", ^{
                    expect(configuration.placeholderVisible).to.beTruthy();
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
                    configuration.placeholderVisible = YES;
                    configuration.text = @"1";
                });
                
                it(@"should update placeholder visible property to NO", ^{
                    expect(configuration.placeholderVisible).to.beFalsy();
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
    
    describe(@"attributedText", ^{
        beforeEach(^{
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"test text"];
            [given(textViewMock.attributedText) willReturn:attributedString];
            [configuration configureComposeBar:composeBarMock];
        });
        
        context(@"getter", ^{
            context(@"when placeholder is visible", ^{
                beforeEach(^{
                    configuration.placeholderVisible = YES;
                });
                
                it(@"should return nil", ^{
                    expect(configuration.attributedText).to.beNil();
                });
            });
            
            context(@"when placeholder is not visible", ^{
                beforeEach(^{
                    configuration.placeholderVisible = NO;
                });
                
                it(@"should return text view's attributed text", ^{
                    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"test text"];
                    expect(configuration.attributedText).to.equal(attributedString);
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
                    configuration.placeholderVisible = NO;
                    configuration.attributedText = nil;
                });
                
                it(@"should update placeholder visible property to YES", ^{
                    expect(configuration.placeholderVisible).to.beTruthy();
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
                    configuration.placeholderVisible = NO;
                    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@""];
                    configuration.attributedText = attributedString;
                });
                
                it(@"should update placeholder visible property to YES", ^{
                    expect(configuration.placeholderVisible).to.beTruthy();
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
                    configuration.placeholderVisible = YES;
                    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"1"];
                    configuration.attributedText = attributedString;
                });
                
                it(@"should update placeholder visible property to NO", ^{
                    expect(configuration.placeholderVisible).to.beFalsy();
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
