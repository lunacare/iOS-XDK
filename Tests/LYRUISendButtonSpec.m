#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUISendButton.h>

@interface LYRUISendButton (PrivateProperties)

- (void)buttonPressed:(LYRUISendButton *)sendButton;

@end

SpecBegin(LYRUISendButton)

describe(@"LYRUISendButton", ^{
    __block LYRUISendButton *button;

    beforeEach(^{
        button = [[LYRUISendButton alloc] init];
    });

    afterEach(^{
        button = nil;
    });
    
    describe(@"after initialization", ^{
        it(@"should have title font set to bold system font of size 14.0", ^{
            UIFont *expectedFont = [UIFont boldSystemFontOfSize:14.0];
            expect(button.titleLabel.font).to.equal(expectedFont);
        });
        it(@"should have enabled color set to blue color", ^{
            UIColor *expectedColor = [UIColor colorWithRed:16.0/255.0 green:148.0/255.0 blue:208.0/255.0 alpha:1.0];
            expect(button.enabledColor).to.equal(expectedColor);
        });
        it(@"should have disabled color set to light gray color", ^{
            UIColor *expectedColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
            expect(button.disabledColor).to.equal(expectedColor);
        });
    });
    
    describe(@"titleFont", ^{
        context(@"getter", ^{
            beforeEach(^{
                button.titleLabel.font = [UIFont systemFontOfSize:20.0];
            });
            
            it(@"should return send button's title label font", ^{
                expect(button.titleFont).to.equal([UIFont systemFontOfSize:20.0]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                button.titleFont = [UIFont systemFontOfSize:30.0];
            });
            
            it(@"should update send button's title label font", ^{
                expect(button.titleLabel.font).to.equal([UIFont systemFontOfSize:30.0]);
            });
        });
    });
    
    describe(@"enabledColor", ^{
        context(@"getter", ^{
            beforeEach(^{
                [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            });
            
            it(@"should return send button's title color for normal state", ^{
                expect(button.enabledColor).to.equal([UIColor greenColor]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                button.enabledColor = [UIColor redColor];
            });
            
            it(@"should update send button's title color for normal state", ^{
                expect([button titleColorForState:UIControlStateNormal]).to.equal([UIColor redColor]);
            });
        });
    });
    
    describe(@"disabledColor", ^{
        context(@"getter", ^{
            beforeEach(^{
                [button setTitleColor:[UIColor greenColor] forState:UIControlStateDisabled];
            });
            
            it(@"should return send button's title color for disabled state", ^{
                expect(button.disabledColor).to.equal([UIColor greenColor]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                button.disabledColor = [UIColor redColor];
            });
            
            it(@"should update send button's title color for disabled state", ^{
                expect([button titleColorForState:UIControlStateDisabled]).to.equal([UIColor redColor]);
            });
        });
    });
    
    describe(@"updateTheme:", ^{
        beforeEach(^{
            id<LYRUISendButtonTheme> themeMock = mockProtocol(@protocol(LYRUISendButtonTheme));
            [given(themeMock.titleFont) willReturn:[UIFont systemFontOfSize:20.0]];
            [given(themeMock.enabledColor) willReturn:[UIColor yellowColor]];
            [given(themeMock.disabledColor) willReturn:[UIColor orangeColor]];
            button.theme = themeMock;
        });
        
        it(@"should update send button's title font", ^{
            expect(button.titleFont).to.equal([UIFont systemFontOfSize:20.0]);
        });
        it(@"should update send button's enabled color", ^{
            expect(button.enabledColor).to.equal([UIColor yellowColor]);
        });
        it(@"should update send button's disabled color", ^{
            expect(button.disabledColor).to.equal([UIColor orangeColor]);
        });
    });
});

SpecEnd
