#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIConfiguration+DependencyInjection.h>
#import <Atlas/LYRUIConversationItemView.h>
#import <Atlas/LYRUIBaseItemViewLayout.h>
#import <Atlas/LYRUIBaseItemViewDefaultTheme.h>
#import <Atlas/LYRUIConversationItemViewUnreadTheme.h>

SpecBegin(LYRUIConversationItemView)

describe(@"LYRUIConversationItemView", ^{
    __block LYRUIConversationItemView *view;
    
    beforeEach(^{
        view = [[LYRUIConversationItemView alloc] init];
    });
    
    afterEach(^{
        view = nil;
    });
    
    describe(@"after initialization", ^{
        it(@"should have titleLabel set", ^{
            expect(view.titleLabel).to.beAKindOf([UILabel class]);
        });
        it(@"should have titleLabel's default font set", ^{
            UIFont *expectedFont = [UIFont systemFontOfSize:16];
            expect(view.titleLabel.font).to.equal(expectedFont);
        });
        it(@"should have titleLabel's default text color set", ^{
            UIColor *blackColor = [UIColor colorWithRed:27.0/255.0 green:28.0/255.0 blue:29.0/255.0 alpha:1.0];
            expect(view.titleLabel.textColor).to.equal(blackColor);
        });
        it(@"should have subtitleLabel set", ^{
            expect(view.subtitleLabel).to.beAKindOf([UILabel class]);
        });
        it(@"should have subtitleLabel's default font set", ^{
            expect(view.subtitleLabel.font).to.equal([UIFont systemFontOfSize:14]);
        });
        it(@"should have subtitleLabel's default text color set", ^{
            UIColor *grayColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
            expect(view.subtitleLabel.textColor).to.equal(grayColor);
        });
        it(@"should have detailLabel set", ^{
            expect(view.detailLabel).to.beAKindOf([UILabel class]);
        });
        it(@"should have detailLabel's default font set", ^{
            UIFont *expectedFont = [UIFont systemFontOfSize:12];
            expect(view.detailLabel.font).to.equal(expectedFont);
        });
        it(@"should have detailLabel's default text color set", ^{
            UIColor *grayColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
            expect(view.detailLabel.textColor).to.equal(grayColor);
        });
        it(@"should not have accessoryView set", ^{
            expect(view.accessoryView).to.beNil();
        });
        it(@"should not have layout set", ^{
            expect(view.layout).to.beNil();
        });
        it(@"should not have theme set", ^{
            expect(view.theme).to.beNil();
        });
        it(@"should not have unread theme set", ^{
            expect(view.unreadTheme).to.beNil();
        });
    });
    
    describe(@"after initialization with configuration", ^{
        __block LYRUIConfiguration *configurationMock;
        __block id<LYRUIDependencyInjection> injectorMock;
        __block NSObject<LYRUIBaseItemViewTheme> *themeMock;
        __block NSObject<LYRUIBaseItemViewTheme> *unreadThemeMock;
        __block NSObject<LYRUIBaseItemViewLayout> *layoutMock;
        
        beforeEach(^{
            configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
            
            themeMock = mockObjectAndProtocol([NSObject class], @protocol(LYRUIBaseItemViewTheme));
            [[given([(id<NSCopying>)themeMock copyWithZone:NSDefaultMallocZone()]) withMatcher:anything()] willReturn:themeMock];
            [given([injectorMock themeForViewClass:[LYRUIConversationItemView class]]) willReturn:themeMock];
            
            unreadThemeMock = mockObjectAndProtocol([NSObject class], @protocol(LYRUIBaseItemViewTheme));
            [[given([(id<NSCopying>)unreadThemeMock copyWithZone:NSDefaultMallocZone()]) withMatcher:anything()] willReturn:unreadThemeMock];
            [given([injectorMock alternativeThemeForViewClass:[LYRUIConversationItemView class]]) willReturn:unreadThemeMock];
            
            layoutMock = mockObjectAndProtocol([NSObject class], @protocol(LYRUIBaseItemViewLayout));
            [[given([(id<NSCopying>)layoutMock copyWithZone:NSDefaultMallocZone()]) withMatcher:anything()] willReturn:layoutMock];
            [given([injectorMock layoutForViewClass:[LYRUIConversationItemView class]]) willReturn:layoutMock];
            
            view = [[LYRUIConversationItemView alloc] initWithConfiguration:configurationMock];
        });
        
        it(@"should have layout set to the one from configuration", ^{
            expect(view.layout).to.equal(layoutMock);
        });
        it(@"should have theme set to the one from configuration", ^{
            expect(view.theme).to.equal(themeMock);
        });
        it(@"should have unread theme set to the one from configuration", ^{
            expect(view.unreadTheme).to.equal(unreadThemeMock);
        });
    });
    
    describe(@"after initialization from xib", ^{
        __block UIView *otherView;
        
        beforeEach(^{
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSArray *xibViews = [bundle loadNibNamed:@"LYRUIConversationItemView" owner:self options:nil];
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
        it(@"should have subtitleLabel's text color set to value from Interface Builder", ^{
            UIColor *greenColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
            expect(view.subtitleLabel.textColor).to.equal(greenColor);
        });
        it(@"should have detailLabel's text color set to value from Interface Builder", ^{
            UIColor *blueColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
            expect(view.detailLabel.textColor).to.equal(blueColor);
        });
    });
    
    describe(@"layerConfiguration", ^{
        context(@"setter", ^{
            __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
            __block NSObject<LYRUIBaseItemViewTheme> *themeMock;
            __block NSObject<LYRUIBaseItemViewTheme> *unreadThemeMock;
            __block NSObject<LYRUIBaseItemViewLayout> *layoutMock;
            
            beforeEach(^{
                configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
                
                themeMock = mockObjectAndProtocol([NSObject class], @protocol(LYRUIBaseItemViewTheme));
                [[given([(id<NSCopying>)themeMock copyWithZone:NSDefaultMallocZone()]) withMatcher:anything()] willReturn:themeMock];
                [given([injectorMock themeForViewClass:[LYRUIConversationItemView class]]) willReturn:themeMock];
                
                unreadThemeMock = mockObjectAndProtocol([NSObject class], @protocol(LYRUIBaseItemViewTheme));
                [[given([(id<NSCopying>)unreadThemeMock copyWithZone:NSDefaultMallocZone()]) withMatcher:anything()] willReturn:unreadThemeMock];
                [given([injectorMock alternativeThemeForViewClass:[LYRUIConversationItemView class]]) willReturn:unreadThemeMock];
                
                layoutMock = mockObjectAndProtocol([NSObject class], @protocol(LYRUIBaseItemViewLayout));
                [[given([(id<NSCopying>)layoutMock copyWithZone:NSDefaultMallocZone()]) withMatcher:anything()] willReturn:layoutMock];
                [given([injectorMock layoutForViewClass:[LYRUIConversationItemView class]]) willReturn:layoutMock];
                
                view.layerConfiguration = configurationMock;
            });
            
            it(@"should update layout to the one from configuration", ^{
                expect(view.layout).to.equal(layoutMock);
            });
            it(@"should update theme to the one from configuration", ^{
                expect(view.theme).to.equal(themeMock);
            });
            it(@"should update unread theme to the one from configuration", ^{
                expect(view.unreadTheme).to.equal(unreadThemeMock);
            });
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
    
    describe(@"subtitleLabelFont", ^{
        __block UIFont *fontMock;
        
        beforeEach(^{
            fontMock = mock([UIFont class]);
        });
        
        context(@"getter", ^{
            beforeEach(^{
                view.subtitleLabel.font = fontMock;
            });
            
            it(@"should return the font of subtitleLabel", ^{
                expect(view.subtitleLabelFont).to.equal(fontMock);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.subtitleLabelFont = fontMock;
            });
            
            it(@"should update the font of subtitleLabel", ^{
                expect(view.subtitleLabel.font).to.equal(fontMock);
            });
        });
    });
    
    describe(@"subtitleLabelColor", ^{
        context(@"getter", ^{
            beforeEach(^{
                view.subtitleLabel.textColor = [UIColor redColor];
            });
            
            it(@"should return the text color of subtitleLabel", ^{
                expect(view.subtitleLabelColor).to.equal([UIColor redColor]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.subtitleLabelColor = [UIColor greenColor];
            });
            
            it(@"should update the text color of subtitleLabel", ^{
                expect(view.subtitleLabel.textColor).to.equal([UIColor greenColor]);
            });
        });
    });
    
    describe(@"detailLabelFont", ^{
        __block UIFont *fontMock;
        
        beforeEach(^{
            fontMock = mock([UIFont class]);
        });
        
        context(@"getter", ^{
            beforeEach(^{
                view.detailLabel.font = fontMock;
            });
            
            it(@"should return the font of detailLabel", ^{
                expect(view.detailLabelFont).to.equal(fontMock);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.detailLabelFont = fontMock;
            });
            
            it(@"should update the font of detailLabel", ^{
                expect(view.detailLabel.font).to.equal(fontMock);
            });
        });
    });
    
    describe(@"detailLabelColor", ^{
        context(@"getter", ^{
            beforeEach(^{
                view.detailLabel.textColor = [UIColor redColor];
            });
            
            it(@"should return the text color of detailLabel", ^{
                expect(view.detailLabelColor).to.equal([UIColor redColor]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.detailLabelColor = [UIColor greenColor];
            });
            
            it(@"should update the text color of detailLabel", ^{
                expect(view.detailLabel.textColor).to.equal([UIColor greenColor]);
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
                [given(themeMock.subtitleLabelFont) willReturn:[UIFont italicSystemFontOfSize:6.0]];
                [given(themeMock.subtitleLabelColor) willReturn:[UIColor greenColor]];
                [given(themeMock.detailLabelFont) willReturn:[UIFont italicSystemFontOfSize:7.0]];
                [given(themeMock.detailLabelColor) willReturn:[UIColor blueColor]];
            });
            
            context(@"when view state is read", ^{
                beforeEach(^{
                    view.state = LYRUIConversationItemViewStateRead;
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
                    expect(view.subtitleLabelFont).to.equal([UIFont italicSystemFontOfSize:6.0]);
                });
                it(@"should change message label color", ^{
                    expect(view.subtitleLabelColor).to.equal([UIColor greenColor]);
                });
                it(@"should change time label font", ^{
                    expect(view.detailLabelFont).to.equal([UIFont italicSystemFontOfSize:7.0]);
                });
                it(@"should change time label color", ^{
                    expect(view.detailLabelColor).to.equal([UIColor blueColor]);
                });
            });
            
            context(@"when view state is unread", ^{
                beforeEach(^{
                    view.state = LYRUIConversationItemViewStateUnread;
                    view.theme = themeMock;
                });
                
                it(@"should set theme property", ^{
                    expect(view.theme).to.equal(themeMock);
                });
                it(@"should not change title label font", ^{
                    expect(view.titleLabelFont).notTo.equal([UIFont italicSystemFontOfSize:5.0]);
                });
                it(@"should not change title label color", ^{
                    expect(view.titleLabelColor).notTo.equal([UIColor redColor]);
                });
                it(@"should not change message label font", ^{
                    expect(view.subtitleLabelFont).notTo.equal([UIFont italicSystemFontOfSize:6.0]);
                });
                it(@"should not change message label color", ^{
                    expect(view.subtitleLabelColor).notTo.equal([UIColor greenColor]);
                });
                it(@"should not change time label font", ^{
                    expect(view.detailLabelFont).notTo.equal([UIFont italicSystemFontOfSize:7.0]);
                });
                it(@"should not change time label color", ^{
                    expect(view.detailLabelColor).notTo.equal([UIColor blueColor]);
                });
            });
        });
    });
    
    describe(@"unreadTheme", ^{
        context(@"setter", ^{
            __block id<LYRUIBaseItemViewTheme> themeMock;
            
            beforeEach(^{
                themeMock = mockProtocol(@protocol(LYRUIBaseItemViewTheme));
                [given(themeMock.titleLabelFont) willReturn:[UIFont italicSystemFontOfSize:5.0]];
                [given(themeMock.titleLabelColor) willReturn:[UIColor redColor]];
                [given(themeMock.subtitleLabelFont) willReturn:[UIFont italicSystemFontOfSize:6.0]];
                [given(themeMock.subtitleLabelColor) willReturn:[UIColor greenColor]];
                [given(themeMock.detailLabelFont) willReturn:[UIFont italicSystemFontOfSize:7.0]];
                [given(themeMock.detailLabelColor) willReturn:[UIColor blueColor]];
            });
            
            context(@"when view state is unread", ^{
                beforeEach(^{
                    view.state = LYRUIConversationItemViewStateUnread;
                    view.unreadTheme = themeMock;
                });
                
                it(@"should set unread theme property", ^{
                    expect(view.unreadTheme).to.equal(themeMock);
                });
                it(@"should change title label font", ^{
                    expect(view.titleLabelFont).to.equal([UIFont italicSystemFontOfSize:5.0]);
                });
                it(@"should change title label color", ^{
                    expect(view.titleLabelColor).to.equal([UIColor redColor]);
                });
                it(@"should change message label font", ^{
                    expect(view.subtitleLabelFont).to.equal([UIFont italicSystemFontOfSize:6.0]);
                });
                it(@"should change message label color", ^{
                    expect(view.subtitleLabelColor).to.equal([UIColor greenColor]);
                });
                it(@"should change time label font", ^{
                    expect(view.detailLabelFont).to.equal([UIFont italicSystemFontOfSize:7.0]);
                });
                it(@"should change time label color", ^{
                    expect(view.detailLabelColor).to.equal([UIColor blueColor]);
                });
            });
            
            context(@"when view state is read", ^{
                beforeEach(^{
                    view.state = LYRUIConversationItemViewStateRead;
                    view.unreadTheme = themeMock;
                });
                
                it(@"should set unread theme property", ^{
                    expect(view.unreadTheme).to.equal(themeMock);
                });
                it(@"should not change title label font", ^{
                    expect(view.titleLabelFont).notTo.equal([UIFont italicSystemFontOfSize:5.0]);
                });
                it(@"should not change title label color", ^{
                    expect(view.titleLabelColor).notTo.equal([UIColor redColor]);
                });
                it(@"should not change message label font", ^{
                    expect(view.subtitleLabelFont).notTo.equal([UIFont italicSystemFontOfSize:6.0]);
                });
                it(@"should not change message label color", ^{
                    expect(view.subtitleLabelColor).notTo.equal([UIColor greenColor]);
                });
                it(@"should not change time label font", ^{
                    expect(view.detailLabelFont).notTo.equal([UIFont italicSystemFontOfSize:7.0]);
                });
                it(@"should not change time label color", ^{
                    expect(view.detailLabelColor).notTo.equal([UIColor blueColor]);
                });
            });
        });
    });
    
    describe(@"state", ^{
        context(@"setter", ^{
            beforeEach(^{
                id<LYRUIBaseItemViewTheme> themeMock = mockProtocol(@protocol(LYRUIBaseItemViewTheme));
                [given(themeMock.titleLabelFont) willReturn:[UIFont italicSystemFontOfSize:5.0]];
                [given(themeMock.titleLabelColor) willReturn:[UIColor redColor]];
                [given(themeMock.subtitleLabelFont) willReturn:[UIFont italicSystemFontOfSize:6.0]];
                [given(themeMock.subtitleLabelColor) willReturn:[UIColor greenColor]];
                [given(themeMock.detailLabelFont) willReturn:[UIFont italicSystemFontOfSize:7.0]];
                [given(themeMock.detailLabelColor) willReturn:[UIColor blueColor]];
                view.theme = themeMock;
                
                id<LYRUIBaseItemViewTheme> unreadThemeMock = mockProtocol(@protocol(LYRUIBaseItemViewTheme));
                [given(unreadThemeMock.titleLabelFont) willReturn:[UIFont italicSystemFontOfSize:2.0]];
                [given(unreadThemeMock.titleLabelColor) willReturn:[UIColor yellowColor]];
                [given(unreadThemeMock.subtitleLabelFont) willReturn:[UIFont italicSystemFontOfSize:3.0]];
                [given(unreadThemeMock.subtitleLabelColor) willReturn:[UIColor purpleColor]];
                [given(unreadThemeMock.detailLabelFont) willReturn:[UIFont italicSystemFontOfSize:4.0]];
                [given(unreadThemeMock.detailLabelColor) willReturn:[UIColor orangeColor]];
                view.unreadTheme = unreadThemeMock;
            });
            
            context(@"when set to read", ^{
                beforeEach(^{
                    view.state = LYRUIConversationItemViewStateRead;
                });
                
                it(@"should set title label font from theme", ^{
                    expect(view.titleLabelFont).to.equal([UIFont italicSystemFontOfSize:5.0]);
                });
                it(@"should set title label color from theme", ^{
                    expect(view.titleLabelColor).to.equal([UIColor redColor]);
                });
                it(@"should set message label font from theme", ^{
                    expect(view.subtitleLabelFont).to.equal([UIFont italicSystemFontOfSize:6.0]);
                });
                it(@"should set message label color from theme", ^{
                    expect(view.subtitleLabelColor).to.equal([UIColor greenColor]);
                });
                it(@"should set time label font from theme", ^{
                    expect(view.detailLabelFont).to.equal([UIFont italicSystemFontOfSize:7.0]);
                });
                it(@"should set time label color from theme", ^{
                    expect(view.detailLabelColor).to.equal([UIColor blueColor]);
                });
            });
            
            context(@"when set to unread", ^{
                beforeEach(^{
                    view.state = LYRUIConversationItemViewStateUnread;
                });
                
                it(@"should set title label font from unread theme", ^{
                    expect(view.titleLabelFont).to.equal([UIFont italicSystemFontOfSize:2.0]);
                });
                it(@"should set title label color from unread theme", ^{
                    expect(view.titleLabelColor).to.equal([UIColor yellowColor]);
                });
                it(@"should set message label font from unread theme", ^{
                    expect(view.subtitleLabelFont).to.equal([UIFont italicSystemFontOfSize:3.0]);
                });
                it(@"should set message label color from unread theme", ^{
                    expect(view.subtitleLabelColor).to.equal([UIColor purpleColor]);
                });
                it(@"should set time label font from unread theme", ^{
                    expect(view.detailLabelFont).to.equal([UIFont italicSystemFontOfSize:4.0]);
                });
                it(@"should set time label color from unread theme", ^{
                    expect(view.detailLabelColor).to.equal([UIColor orangeColor]);
                });
            });
        });
    });
});

SpecEnd
