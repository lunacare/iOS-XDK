#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <Atlas/LYRUIConversationItemView.h>
#import <Atlas/LYRUIConversationItemViewMediumLayout.h>

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
        it(@"should have conversationTitleLabel set", ^{
            expect(view.conversationTitleLabel).to.beAKindOf([UILabel class]);
        });
        it(@"should have conversationTitleLabel's default font set", ^{
            expect(view.conversationTitleLabel.font).to.equal([UIFont systemFontOfSize:16]);
        });
        it(@"should have conversationTitleLabel's default text color set", ^{
            UIColor *blackColor = [UIColor colorWithRed:27.0/255.0 green:28.0/255.0 blue:29.0/255.0 alpha:1.0];
            expect(view.conversationTitleLabel.textColor).to.equal(blackColor);
        });
        it(@"should have lastMessageLabel set", ^{
            expect(view.lastMessageLabel).to.beAKindOf([UILabel class]);
        });
        it(@"should have lastMessageLabel's default font set", ^{
            expect(view.lastMessageLabel.font).to.equal([UIFont systemFontOfSize:14]);
        });
        it(@"should have lastMessageLabel's default text color set", ^{
            UIColor *grayColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
            expect(view.lastMessageLabel.textColor).to.equal(grayColor);
        });
        it(@"should have dateLabel set", ^{
            expect(view.dateLabel).to.beAKindOf([UILabel class]);
        });
        it(@"should have dateLabel's default font set", ^{
            expect(view.dateLabel.font).to.equal([UIFont systemFontOfSize:12]);
        });
        it(@"should have dateLabel's default text color set", ^{
            UIColor *grayColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
            expect(view.dateLabel.textColor).to.equal(grayColor);
        });
        it(@"should not have accessoryView set", ^{
            expect(view.accessoryView).to.beNil();
        });
        it(@"should have layout set to Medium Layout", ^{
            expect(view.layout).to.beAKindOf([LYRUIConversationItemViewMediumLayout class]);
        });
    });
    
    describe(@"after initialization with layout", ^{
        __block id<LYRUIConversationItemViewLayout> layoutMock;
        
        beforeEach(^{
            layoutMock = mockProtocol(@protocol(LYRUIConversationItemViewLayout));
            
            view = [[LYRUIConversationItemView alloc] initWithLayout:layoutMock];
        });
        
        it(@"should have layout set to the one passed to initializator", ^{
            expect(view.layout).to.equal(layoutMock);
        });
    });
    
    describe(@"after initialization from xib", ^{
        beforeEach(^{
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSArray *xibViews = [bundle loadNibNamed:@"LYRUIConversationItemView" owner:self options:nil];
            view = [xibViews objectAtIndex:0];
        });
        
        it(@"should have conversationTitleLabel's text color set to value from Interface Builder", ^{
            UIColor *redColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
            expect(view.conversationTitleLabel.textColor).to.equal(redColor);
        });
        it(@"should have lastMessageLabel's text color set to value from Interface Builder", ^{
            UIColor *greenColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
            expect(view.lastMessageLabel.textColor).to.equal(greenColor);
        });
        it(@"should have dateLabel's text color set to value from Interface Builder", ^{
            UIColor *blueColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
            expect(view.dateLabel.textColor).to.equal(blueColor);
        });
    });
    
    describe(@"conversationTitleLabelFont", ^{
        __block UIFont *fontMock;
        
        beforeEach(^{
            fontMock = mock([UIFont class]);
        });
        
        context(@"getter", ^{
            beforeEach(^{
                view.conversationTitleLabel.font = fontMock;
            });
            
            it(@"should return the font of conversationTitleLabel", ^{
                expect(view.conversationTitleLabelFont).to.equal(fontMock);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.conversationTitleLabelFont = fontMock;
            });
            
            it(@"should update the font of conversationTitleLabel", ^{
                expect(view.conversationTitleLabel.font).to.equal(fontMock);
            });
        });
    });
    
    describe(@"conversationTitleLabelColor", ^{
        context(@"getter", ^{
            beforeEach(^{
                view.conversationTitleLabel.textColor = [UIColor redColor];
            });
            
            it(@"should return the text color of conversationTitleLabel", ^{
                expect(view.conversationTitleLabelColor).to.equal([UIColor redColor]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.conversationTitleLabelColor = [UIColor greenColor];
            });
            
            it(@"should update the text color of conversationTitleLabel", ^{
                expect(view.conversationTitleLabel.textColor).to.equal([UIColor greenColor]);
            });
        });
    });
    
    describe(@"lastMessageLabelFont", ^{
        __block UIFont *fontMock;
        
        beforeEach(^{
            fontMock = mock([UIFont class]);
        });
        
        context(@"getter", ^{
            beforeEach(^{
                view.lastMessageLabel.font = fontMock;
            });
            
            it(@"should return the font of lastMessageLabel", ^{
                expect(view.lastMessageLabelFont).to.equal(fontMock);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.lastMessageLabelFont = fontMock;
            });
            
            it(@"should update the font of lastMessageLabel", ^{
                expect(view.lastMessageLabel.font).to.equal(fontMock);
            });
        });
    });
    
    describe(@"lastMessageLabelColor", ^{
        context(@"getter", ^{
            beforeEach(^{
                view.lastMessageLabel.textColor = [UIColor redColor];
            });
            
            it(@"should return the text color of lastMessageLabel", ^{
                expect(view.lastMessageLabelColor).to.equal([UIColor redColor]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.lastMessageLabelColor = [UIColor greenColor];
            });
            
            it(@"should update the text color of lastMessageLabel", ^{
                expect(view.lastMessageLabel.textColor).to.equal([UIColor greenColor]);
            });
        });
    });
    
    describe(@"dateLabelFont", ^{
        __block UIFont *fontMock;
        
        beforeEach(^{
            fontMock = mock([UIFont class]);
        });
        
        context(@"getter", ^{
            beforeEach(^{
                view.dateLabel.font = fontMock;
            });
            
            it(@"should return the font of dateLabel", ^{
                expect(view.dateLabelFont).to.equal(fontMock);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.dateLabelFont = fontMock;
            });
            
            it(@"should update the font of dateLabel", ^{
                expect(view.dateLabel.font).to.equal(fontMock);
            });
        });
    });
    
    describe(@"dateLabelColor", ^{
        context(@"getter", ^{
            beforeEach(^{
                view.dateLabel.textColor = [UIColor redColor];
            });
            
            it(@"should return the text color of dateLabel", ^{
                expect(view.dateLabelColor).to.equal([UIColor redColor]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.dateLabelColor = [UIColor greenColor];
            });
            
            it(@"should update the text color of dateLabel", ^{
                expect(view.dateLabel.textColor).to.equal([UIColor greenColor]);
            });
        });
    });
});

SpecEnd
