#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <Atlas/LYRUIConversationItemView.h>

SpecBegin(LYRUIConversationItemView)

describe(@"LYRUIConversationItemView", ^{
    __block LYRUIConversationItemView *view;
    
    beforeEach(^{
        id<LYRUIConversationItemViewLayout> layoutMock = mockProtocol(@protocol(LYRUIConversationItemViewLayout));
        
        view = [[LYRUIConversationItemView alloc] initWithLayout:layoutMock];
    });
    
    afterEach(^{
        view = nil;
    });
    
    describe(@"after initialization", ^{
        it(@"should have conversationTitleLabel set", ^{
            expect(view.conversationTitleLabel).to.beAKindOf([UILabel class]);
        });
        it(@"should have lastMessageLabel set", ^{
            expect(view.lastMessageLabel).to.beAKindOf([UILabel class]);
        });
        it(@"should have dateLabel set", ^{
            expect(view.dateLabel).to.beAKindOf([UILabel class]);
        });
        it(@"should not have accessoryView set", ^{
            expect(view.accessoryView).to.beNil();
        });
        it(@"should have layout set", ^{
            expect(view.layout).to.conformTo(@protocol(LYRUIConversationItemViewLayout));
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
