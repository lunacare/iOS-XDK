#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIComposeBar.h>
#import <Atlas/LYRUIComposeBarConfiguration.h>
#import <Atlas/LYRUISendButton.h>
#import "LYRUIComposeBarTestLayout.h"

@interface LYRUIComposeBar ()

- (instancetype)initWithConfiguration:(LYRUIComposeBarConfiguration *)configuration;

@end

SpecBegin(LYRUIComposeBar)

describe(@"LYRUIComposeBar", ^{
    __block LYRUIComposeBar *composeBar;
    __block LYRUIComposeBarConfiguration *configurationMock;

    beforeEach(^{
        configurationMock = mock([LYRUIComposeBarConfiguration class]);
        composeBar = [[LYRUIComposeBar alloc] initWithConfiguration:configurationMock];
    });

    afterEach(^{
        composeBar = nil;
    });

    describe(@"after initialization", ^{
        it(@"should have a text view added as subview", ^{
            expect(composeBar.inputTextView.superview).to.equal(composeBar);
        });
        it(@"should have a send button added as subview", ^{
            expect(composeBar.sendButton.superview).to.equal(composeBar);
        });
        it(@"should have the send button added as right item", ^{
            expect(composeBar.rightItems).to.contain(composeBar.sendButton);
        });
        it(@"should have background color set to gray color", ^{
            UIColor *expectedColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
            expect(composeBar.backgroundColor).to.equal(expectedColor);
        });
        it(@"should have message input corner radius set to 8.0", ^{
            expect(composeBar.messageInputCornerRadius).to.equal(8.0);
        });
        it(@"should have message input color set to white color", ^{
            expect(composeBar.messageInputColor).to.equal([UIColor whiteColor]);
        });
        it(@"should have message input border color set to gray color", ^{
            UIColor *expectedColor = [UIColor colorWithRed:219.0/255.0 green:222.0/255.0 blue:228.0/255.0 alpha:1.0];
            expect(composeBar.messageInputBorderColor).to.equal(expectedColor);
        });
        it(@"should have send button title font set to bold system font of size 14.0", ^{
            UIFont *expectedFont = [UIFont boldSystemFontOfSize:14.0];
            expect(composeBar.sendButton.titleLabel.font).to.equal(expectedFont);
        });
        it(@"should have text font set to system font of size 14.0", ^{
            UIFont *expectedFont = [UIFont systemFontOfSize:14.0];
            expect(composeBar.inputTextView.font).to.equal(expectedFont);
        });
        it(@"should have text color set to black color", ^{
            UIColor *expectedColor = [UIColor colorWithRed:27.0/255.0 green:28.0/255.0 blue:29.0/255.0 alpha:1.0];
            expect(composeBar.textColor).to.equal(expectedColor);
        });
        it(@"should have placeholder color set to light gray color", ^{
            UIColor *expectedColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
            expect(composeBar.placeholderColor).to.equal(expectedColor);
        });
        it(@"should configure itself using configuration", ^{
            [verify(configurationMock) configureComposeBar:composeBar];
        });
    });
    
    describe(@"after initialization from xib", ^{
        __block NSArray *xibObjects;
        
        beforeEach(^{
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            xibObjects = [bundle loadNibNamed:@"LYRUIComposeBar" owner:self options:nil];
            composeBar = (LYRUIComposeBar *)xibObjects.firstObject;
        });
        
        it(@"should have layout set to object connected via IB outlet", ^{
            expect(composeBar.layout).to.beAKindOf([LYRUIComposeBarTestLayout class]);
        });
        it(@"should have message input corner radius set to value from Interface Builder", ^{
            expect(composeBar.messageInputCornerRadius).to.equal(16.0);
        });
        it(@"should have message text set to value from Interface Builder", ^{
            expect(composeBar.text).to.equal(@"message text");
        });
        it(@"should have placeholder set to value from Interface Builder", ^{
            expect(composeBar.placeholder).to.equal(@"placeholder");
        });
        it(@"should have message input color set to value from Interface Builder", ^{
            UIColor *expectedColor = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:1.0];
            expect(composeBar.messageInputColor).to.equal(expectedColor);
        });
        it(@"should have message input border color set to value from Interface Builder", ^{
            UIColor *expectedColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
            expect(composeBar.messageInputBorderColor).to.equal(expectedColor);
        });
        it(@"should have text color set to value from Interface Builder", ^{
            UIColor *expectedColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
            expect(composeBar.textColor).to.equal(expectedColor);
        });
        it(@"should have placeholder color set to value from Interface Builder", ^{
            UIColor *expectedColor = [UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:1.0];
            expect(composeBar.placeholderColor).to.equal(expectedColor);
        });
        it(@"should have left items set to array of views connected via IB outlet", ^{
            expect(composeBar.leftItems).to.equal(@[xibObjects[2], xibObjects[3]]);
        });
    });
    
    describe(@"leftItems", ^{
        context(@"setter", ^{
            __block UIView *view1;
            __block UIView *view2;
            
            beforeEach(^{
                view1 = [UIView new];
                view2 = [UIView new];
                
                composeBar.leftItems = @[view1, view2];
            });
            
            it(@"should add view1 as compose bar subview", ^{
                expect(view1.superview).to.equal(composeBar);
            });
            it(@"should add view2 as compose bar subview", ^{
                expect(view2.superview).to.equal(composeBar);
            });
            
            context(@"when updating", ^{
                context(@"with new views", ^{
                    __block UIView *view3;
                    __block UIView *view4;
                    
                    beforeEach(^{
                        view3 = [UIView new];
                        view4 = [UIView new];
                        
                        composeBar.leftItems = @[view3, view4];
                    });
                    
                    it(@"should remove view1 from compose bar subviews", ^{
                        expect(view1.superview).to.beNil();
                    });
                    it(@"should remove view2 from compose bar subviews", ^{
                        expect(view2.superview).to.beNil();
                    });
                    it(@"should add view3 as compose bar subview", ^{
                        expect(view3.superview).to.equal(composeBar);
                    });
                    it(@"should add view4 as compose bar subview", ^{
                        expect(view4.superview).to.equal(composeBar);
                    });
                });
            
                context(@"with some views that already were in items", ^{
                    __block UIView *view3;
                    
                    beforeEach(^{
                        view3 = [UIView new];
                        
                        composeBar.leftItems = @[view2, view3];
                    });
                    
                    it(@"should remove view1 from compose bar subviews", ^{
                        expect(view1.superview).to.beNil();
                    });
                    it(@"should leave view2 in compose bar subviews", ^{
                        expect(view2.superview).to.equal(composeBar);
                    });
                    it(@"should add view3 as compose bar subview", ^{
                        expect(view3.superview).to.equal(composeBar);
                    });
                });
            });
        });
    });

    describe(@"rightItems", ^{
        context(@"setter", ^{
            __block UIView *view1;
            __block UIView *view2;
            
            beforeEach(^{
                view1 = [UIView new];
                view2 = [UIView new];
                
                composeBar.rightItems = @[view1, view2];
            });
            
            it(@"should add view1 as compose bar subview", ^{
                expect(view1.superview).to.equal(composeBar);
            });
            it(@"should add view2 as compose bar subview", ^{
                expect(view2.superview).to.equal(composeBar);
            });
            
            context(@"when updating", ^{
                context(@"with new views", ^{
                    __block UIView *view3;
                    __block UIView *view4;
                    
                    beforeEach(^{
                        view3 = [UIView new];
                        view4 = [UIView new];
                        
                        composeBar.rightItems = @[view3, view4];
                    });
                    
                    it(@"should remove view1 from compose bar subviews", ^{
                        expect(view1.superview).to.beNil();
                    });
                    it(@"should remove view2 from compose bar subviews", ^{
                        expect(view2.superview).to.beNil();
                    });
                    it(@"should add view3 as compose bar subview", ^{
                        expect(view3.superview).to.equal(composeBar);
                    });
                    it(@"should add view4 as compose bar subview", ^{
                        expect(view4.superview).to.equal(composeBar);
                    });
                });
                
                context(@"with some views that already were in items", ^{
                    __block UIView *view3;
                    
                    beforeEach(^{
                        view3 = [UIView new];
                        
                        composeBar.rightItems = @[view2, view3];
                    });
                    
                    it(@"should remove view1 from compose bar subviews", ^{
                        expect(view1.superview).to.beNil();
                    });
                    it(@"should leave view2 in compose bar subviews", ^{
                        expect(view2.superview).to.equal(composeBar);
                    });
                    it(@"should add view3 as compose bar subview", ^{
                        expect(view3.superview).to.equal(composeBar);
                    });
                });
            });
        });
    });
    
    describe(@"text", ^{
        context(@"getter", ^{
            beforeEach(^{
                [given(configurationMock.text) willReturn:@"test message text"];
            });
            
            it(@"should return value from configuration", ^{
                expect(composeBar.text).to.equal(@"test message text");
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                composeBar.text = @"test message text";
            });
            
            it(@"should pass the value to configuration", ^{
                [verify(configurationMock) setText:@"test message text"];
            });
        });
    });
    
    describe(@"attributedText", ^{
        context(@"getter", ^{
            beforeEach(^{
                NSAttributedString *messageText = [[NSAttributedString alloc] initWithString:@"test message text"];
                [given(configurationMock.attributedText) willReturn:messageText];
            });
            
            it(@"should return value from configuration", ^{
                NSAttributedString *messageText = [[NSAttributedString alloc] initWithString:@"test message text"];
                expect(composeBar.attributedText).to.equal(messageText);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                NSAttributedString *messageText = [[NSAttributedString alloc] initWithString:@"test message text"];
                composeBar.attributedText = messageText;
            });
            
            it(@"should pass the value to configuration", ^{
                NSAttributedString *messageText = [[NSAttributedString alloc] initWithString:@"test message text"];
                [verify(configurationMock) setAttributedText:messageText];
            });
        });
    });
    
    describe(@"messageInputCornerRadius", ^{
        context(@"getter", ^{
            beforeEach(^{
                composeBar.inputTextView.layer.cornerRadius = 10.0;
            });
            
            it(@"should return input text view's corner radius", ^{
                expect(composeBar.messageInputCornerRadius).to.equal(10.0);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                composeBar.messageInputCornerRadius = 15.0;
            });
            
            it(@"should update input text view's corner radius", ^{
                expect(composeBar.inputTextView.layer.cornerRadius).to.equal(15.0);
            });
        });
    });
    
    describe(@"messageInputColor", ^{
        context(@"getter", ^{
            beforeEach(^{
                composeBar.inputTextView.backgroundColor = [UIColor greenColor];
            });
            
            it(@"should return input text view's background color", ^{
                expect(composeBar.messageInputColor).to.equal([UIColor greenColor]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                composeBar.messageInputColor = [UIColor redColor];
            });
            
            it(@"should update input text view's background color", ^{
                expect(composeBar.inputTextView.backgroundColor).to.equal([UIColor redColor]);
            });
        });
    });
    
    describe(@"messageInputBorderColor", ^{
        context(@"getter", ^{
            beforeEach(^{
                composeBar.inputTextView.layer.borderColor = [UIColor greenColor].CGColor;
            });
            
            it(@"should return input text view's border color", ^{
                expect(composeBar.messageInputBorderColor).to.equal([UIColor greenColor]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                composeBar.messageInputBorderColor = [UIColor redColor];
            });
            
            it(@"should update input text view's border color", ^{
                expect(composeBar.inputTextView.layer.borderColor).to.equal([UIColor redColor].CGColor);
            });
        });
    });
    
    describe(@"textFont", ^{
        context(@"getter", ^{
            beforeEach(^{
                composeBar.inputTextView.font = [UIFont systemFontOfSize:20.0];
            });
            
            it(@"should return input text view's text font", ^{
                expect(composeBar.textFont).to.equal([UIFont systemFontOfSize:20.0]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                composeBar.textFont = [UIFont systemFontOfSize:30.0];
            });
            
            it(@"should update input text view's text font", ^{
                expect(composeBar.inputTextView.font).to.equal([UIFont systemFontOfSize:30.0]);
            });
        });
    });
    
    describe(@"updateTheme:", ^{
        beforeEach(^{
            id<LYRUIComposeBarTheme> themeMock = mockProtocol(@protocol(LYRUIComposeBarTheme));
            [given(themeMock.messageInputColor) willReturn:[UIColor redColor]];
            [given(themeMock.messageInputBorderColor) willReturn:[UIColor greenColor]];
            [given(themeMock.textFont) willReturn:[UIFont systemFontOfSize:30.0]];
            [given(themeMock.textColor) willReturn:[UIColor magentaColor]];
            [given(themeMock.placeholderColor) willReturn:[UIColor brownColor]];
            composeBar.theme = themeMock;
        });
        
        it(@"should update compose bar's message input color", ^{
            expect(composeBar.messageInputColor).to.equal([UIColor redColor]);
        });
        it(@"should update compose bar's message input border color", ^{
            expect(composeBar.messageInputBorderColor).to.equal([UIColor greenColor]);
        });
        it(@"should update compose bar's text font", ^{
            expect(composeBar.textFont).to.equal([UIFont systemFontOfSize:30.0]);
        });
        it(@"should update compose bar's text color", ^{
            expect(composeBar.textColor).to.equal([UIColor magentaColor]);
        });
        it(@"should update compose bar's placeholder color", ^{
            expect(composeBar.placeholderColor).to.equal([UIColor brownColor]);
        });
    });
});

SpecEnd
