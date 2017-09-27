#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <Atlas/LYRUIIdentityItemView.h>
#import <Atlas/LYRUIBaseItemViewLayout.h>
#import <Atlas/LYRUIBaseItemViewDefaultTheme.h>

SpecBegin(LYRUIIdentityItemView)

describe(@"LYRUIIdentityItemView", ^{
    __block LYRUIIdentityItemView *view;
    
    beforeEach(^{
        
        view = [[LYRUIIdentityItemView alloc] init];
    });
    
    afterEach(^{
        view = nil;
    });
    
    describe(@"after initialization", ^{
        it(@"should have titleLabel set", ^{
            expect(view.titleLabel).to.beAKindOf([UILabel class]);
        });
        it(@"should have titleLabel's font set by the default layout", ^{
            NSString *fontName = [UIFont systemFontOfSize:1].fontName;
            UIFont *expectedFont = [UIFont fontWithName:fontName size:14];
            expect(view.titleLabel.font).to.equal(expectedFont);
        });
        it(@"should have titleLabel's default text color set", ^{
            UIColor *blackColor = [UIColor colorWithRed:27.0/255.0 green:28.0/255.0 blue:29.0/255.0 alpha:1.0];
            expect(view.titleLabel.textColor).to.equal(blackColor);
        });
        it(@"should have messageLabel set", ^{
            expect(view.messageLabel).to.beAKindOf([UILabel class]);
        });
        it(@"should have messageLabel's default font set by the default layout", ^{
            expect(view.messageLabel.font).to.equal([UIFont systemFontOfSize:14]);
        });
        it(@"should have messageLabel's default text color set", ^{
            UIColor *grayColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
            expect(view.messageLabel.textColor).to.equal(grayColor);
        });
        it(@"should have timeLabel set", ^{
            expect(view.timeLabel).to.beAKindOf([UILabel class]);
        });
        it(@"should have timeLabel's default font set", ^{
            NSString *fontName = [UIFont systemFontOfSize:1].fontName;
            UIFont *expectedFont = [UIFont fontWithName:fontName size:10];
            expect(view.timeLabel.font).to.equal(expectedFont);
        });
        it(@"should have timeLabel's default text color set", ^{
            UIColor *grayColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
            expect(view.timeLabel.textColor).to.equal(grayColor);
        });
        it(@"should not have accessoryView set", ^{
            expect(view.accessoryView).to.beNil();
        });
        it(@"should have layout set to `LYRUIBaseItemViewLayout`", ^{
            expect(view.layout).to.beAKindOf([LYRUIBaseItemViewLayout class]);
        });
        it(@"should have theme set to `LYRUIBaseItemViewDefaultTheme`", ^{
            expect(view.theme).to.beAKindOf([LYRUIBaseItemViewDefaultTheme class]);
        });
    });
    
    describe(@"after initialization with layout", ^{
        __block id<LYRUIBaseItemViewLayout> layoutMock;
        
        beforeEach(^{
            layoutMock = mockProtocol(@protocol(LYRUIBaseItemViewLayout));
            
            view = [[LYRUIIdentityItemView alloc] initWithLayout:layoutMock];
        });
        
        it(@"should have layout set to the one passed to initializator", ^{
            expect(view.layout).to.equal(layoutMock);
        });
        it(@"should have titleLabel's default font set", ^{
            expect(view.titleLabel.font).to.equal([UIFont systemFontOfSize:16]);
        });
        it(@"should have timeLabel's default font set", ^{
            expect(view.timeLabel.font).to.equal([UIFont systemFontOfSize:12]);
        });
    });
    
    describe(@"after initialization from xib", ^{
        __block UIView *otherView;
        
        beforeEach(^{
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSArray *xibViews = [bundle loadNibNamed:@"LYRUIIdentityItemView" owner:self options:nil];
            view = [xibViews objectAtIndex:0];
            otherView = [xibViews objectAtIndex:1];
        });
        
        it(@"should have accessory view set by Interface Builder Outlet", ^{
            expect(view.accessoryView).to.equal(otherView);
        });
        it(@"should have accessory view added as a subview in container", ^{
            expect(otherView.superview).to.equal(view.accessoryViewContainer);
        });
        it(@"should have titleLabel's text color set to value from Interface Builder", ^{
            UIColor *redColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
            expect(view.titleLabel.textColor).to.equal(redColor);
        });
        it(@"should have messageLabel's text color set to value from Interface Builder", ^{
            UIColor *greenColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
            expect(view.messageLabel.textColor).to.equal(greenColor);
        });
        it(@"should have timeLabel's text color set to value from Interface Builder", ^{
            UIColor *blueColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
            expect(view.timeLabel.textColor).to.equal(blueColor);
        });
    });
    
    describe(@"titleLabelFont", ^{
        __block UIFont *fontMock;
        
        beforeEach(^{
            fontMock = mock([UIFont class]);
        });
        
        context(@"getter", ^{
            beforeEach(^{
                view.titleLabel.font = fontMock;
            });
            
            it(@"should return the font of titleLabel", ^{
                expect(view.titleLabelFont).to.equal(fontMock);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.titleLabelFont = fontMock;
            });
            
            it(@"should update the font of titleLabel", ^{
                expect(view.titleLabel.font).to.equal(fontMock);
            });
        });
    });
    
    describe(@"titleLabelColor", ^{
        context(@"getter", ^{
            beforeEach(^{
                view.titleLabel.textColor = [UIColor redColor];
            });
            
            it(@"should return the text color of titleLabel", ^{
                expect(view.titleLabelColor).to.equal([UIColor redColor]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.titleLabelColor = [UIColor greenColor];
            });
            
            it(@"should update the text color of titleLabel", ^{
                expect(view.titleLabel.textColor).to.equal([UIColor greenColor]);
            });
        });
    });
    
    describe(@"messageLabelFont", ^{
        __block UIFont *fontMock;
        
        beforeEach(^{
            fontMock = mock([UIFont class]);
        });
        
        context(@"getter", ^{
            beforeEach(^{
                view.messageLabel.font = fontMock;
            });
            
            it(@"should return the font of messageLabel", ^{
                expect(view.messageLabelFont).to.equal(fontMock);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.messageLabelFont = fontMock;
            });
            
            it(@"should update the font of messageLabel", ^{
                expect(view.messageLabel.font).to.equal(fontMock);
            });
        });
    });
    
    describe(@"messageLabelColor", ^{
        context(@"getter", ^{
            beforeEach(^{
                view.messageLabel.textColor = [UIColor redColor];
            });
            
            it(@"should return the text color of messageLabel", ^{
                expect(view.messageLabelColor).to.equal([UIColor redColor]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.messageLabelColor = [UIColor greenColor];
            });
            
            it(@"should update the text color of messageLabel", ^{
                expect(view.messageLabel.textColor).to.equal([UIColor greenColor]);
            });
        });
    });
    
    describe(@"timeLabelFont", ^{
        __block UIFont *fontMock;
        
        beforeEach(^{
            fontMock = mock([UIFont class]);
        });
        
        context(@"getter", ^{
            beforeEach(^{
                view.timeLabel.font = fontMock;
            });
            
            it(@"should return the font of timeLabel", ^{
                expect(view.timeLabelFont).to.equal(fontMock);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.timeLabelFont = fontMock;
            });
            
            it(@"should update the font of timeLabel", ^{
                expect(view.timeLabel.font).to.equal(fontMock);
            });
        });
    });
    
    describe(@"timeLabelColor", ^{
        context(@"getter", ^{
            beforeEach(^{
                view.timeLabel.textColor = [UIColor redColor];
            });
            
            it(@"should return the text color of timeLabel", ^{
                expect(view.timeLabelColor).to.equal([UIColor redColor]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.timeLabelColor = [UIColor greenColor];
            });
            
            it(@"should update the text color of timeLabel", ^{
                expect(view.timeLabel.textColor).to.equal([UIColor greenColor]);
            });
        });
    });
    
    describe(@"theme", ^{
        context(@"setter", ^{
            __block id<LYRUIBaseItemViewTheme> themeMock;
            
            beforeEach(^{
                themeMock = mockProtocol(@protocol(LYRUIBaseItemViewTheme));
                [given(themeMock.titleLabelFont) willReturn:[UIFont italicSystemFontOfSize:5.0]];
                [given(themeMock.titleLabelColor) willReturn:[UIColor redColor]];
                [given(themeMock.messageLabelFont) willReturn:[UIFont italicSystemFontOfSize:6.0]];
                [given(themeMock.messageLabelColor) willReturn:[UIColor greenColor]];
                [given(themeMock.timeLabelFont) willReturn:[UIFont italicSystemFontOfSize:7.0]];
                [given(themeMock.timeLabelColor) willReturn:[UIColor blueColor]];
                
                view.theme = themeMock;
            });
            
            it(@"should set theme property", ^{
                expect(view.theme).to.equal(themeMock);
            });
            it(@"should change title label font", ^{
                expect(view.titleLabelFont).to.equal([UIFont italicSystemFontOfSize:5.0]);
            });
            it(@"should change title label color", ^{
                expect(view.titleLabelColor).to.equal([UIColor redColor]);
            });
            it(@"should change message label font", ^{
                expect(view.messageLabelFont).to.equal([UIFont italicSystemFontOfSize:6.0]);
            });
            it(@"should change message label color", ^{
                expect(view.messageLabelColor).to.equal([UIColor greenColor]);
            });
            it(@"should change time label font", ^{
                expect(view.timeLabelFont).to.equal([UIFont italicSystemFontOfSize:7.0]);
            });
            it(@"should change time label color", ^{
                expect(view.timeLabelColor).to.equal([UIColor blueColor]);
            });
        });
    });
});

SpecEnd
