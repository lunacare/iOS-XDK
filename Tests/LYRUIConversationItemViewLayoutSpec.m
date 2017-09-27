#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <Atlas/LYRUIConversationItemViewLayout.h>
#import <Atlas/LYRUIConversationItemView.h>
#import <Atlas/LYRUISampleAccessoryView.h>

SpecBegin(LYRUIConversationItemViewLayout)

describe(@"LYRUIConversationItemViewLayout", ^{
    __block LYRUIConversationItemViewLayout *layout;
    __block LYRUIConversationItemView *conversationItemView;
    __block void(^conversationItemViewSizeSetup)(CGSize);
    
    beforeEach(^{
        layout = [[LYRUIConversationItemViewLayout alloc] init];
        conversationItemView = [[LYRUIConversationItemView alloc] initWithLayout:layout];
        conversationItemView.translatesAutoresizingMaskIntoConstraints = NO;
        conversationItemView.conversationTitleLabel.text = @"this is a long test conversation title";
        conversationItemView.dateLabel.text = @"8:30am";
        conversationItemView.lastMessageLabel.text = @"test last message";
        
        conversationItemViewSizeSetup = ^(CGSize size) {
            [[conversationItemView.widthAnchor constraintEqualToConstant:size.width] setActive:YES];
            [[conversationItemView.heightAnchor constraintEqualToConstant:size.height] setActive:YES];
            [conversationItemView setNeedsLayout];
            [conversationItemView layoutIfNeeded];
            [conversationItemView setNeedsUpdateConstraints];
            [conversationItemView updateConstraintsIfNeeded];
            [conversationItemView setNeedsLayout];
            [conversationItemView layoutIfNeeded];
        };
    });
    
    afterEach(^{
        layout = nil;
        conversationItemView = nil;
    });
    
    describe(@"layout", ^{
        context(@"without accessory view", ^{
            context(@"when view has `Tiny` size", ^{
                beforeEach(^{
                    conversationItemViewSizeSetup(CGSizeMake(320, 32));
                });
                
                it(@"should set proper accessory view container frame", ^{
                    CGRect expectedFrame = CGRectMake(12.0, 10.0, 12.0, 12.0);
                    expect(conversationItemView.accessoryViewContainer.frame).to.equal(expectedFrame);
                });
                it(@"should set proper conversation title label frame", ^{
                    CGRect expectedFrame = CGRectMake(12.0, 7.5, 296.0, 17.0);
                    expect(conversationItemView.conversationTitleLabel.frame).to.equal(expectedFrame);
                });
                it(@"should set proper conversation title label's font", ^{
                    NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                    UIFont *expectedFont = [UIFont fontWithName:fontName size:14];
                    expect(conversationItemView.conversationTitleLabel.font).to.equal(expectedFont);
                });
                it(@"should hide date message label", ^{
                    expect(conversationItemView.dateLabel.hidden).to.beTruthy();
                });
                it(@"should hide last message label", ^{
                    expect(conversationItemView.lastMessageLabel.hidden).to.beTruthy();
                });
            });
            
            context(@"when view has `Small` size", ^{
                beforeEach(^{
                    conversationItemViewSizeSetup(CGSizeMake(320, 48));
                });
                
                it(@"should set proper accessory view container frame", ^{
                    CGRect expectedFrame = CGRectMake(12.0, 8.0, 32.0, 32.0);
                    expect(conversationItemView.accessoryViewContainer.frame).to.equal(expectedFrame);
                });
                it(@"should set proper conversation title label frame", ^{
                    CGRect expectedFrame = CGRectMake(12.0, 15.5, 230.0, 17.0);
                    expect(conversationItemView.conversationTitleLabel.frame).to.equal(expectedFrame);
                });
                it(@"should set proper conversation title label's font", ^{
                    NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                    UIFont *expectedFont = [UIFont fontWithName:fontName size:14];
                    expect(conversationItemView.conversationTitleLabel.font).to.equal(expectedFont);
                });
                it(@"should show date message label", ^{
                    expect(conversationItemView.dateLabel.hidden).to.beFalsy();
                });
                it(@"should set proper date label frame", ^{
                    CGRect expectedFrame = CGRectMake(271.5, 18.0, 36.5, 12.0);
                    expect(conversationItemView.dateLabel.frame).to.equal(expectedFrame);
                });
                it(@"should set proper date label's font", ^{
                    NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                    UIFont *expectedFont = [UIFont fontWithName:fontName size:10];
                    expect(conversationItemView.dateLabel.font).to.equal(expectedFont);
                });
                it(@"should hide last message label", ^{
                    expect(conversationItemView.lastMessageLabel.hidden).to.beTruthy();
                });
            });
            
            context(@"when view has `Medium` size", ^{
                beforeEach(^{
                    conversationItemViewSizeSetup(CGSizeMake(320, 60));
                });
                
                it(@"should set proper accessory view container frame", ^{
                    CGRect expectedFrame = CGRectMake(12.0, 10.0, 40.0, 40.0);
                    expect(conversationItemView.accessoryViewContainer.frame).to.equal(expectedFrame);
                });
                it(@"should set proper conversation title label frame", ^{
                    CGRect expectedFrame = CGRectMake(12.0, 20.5, 240.5, 19.5);
                    expect(conversationItemView.conversationTitleLabel.frame).to.equal(expectedFrame);
                });
                it(@"should set proper conversation title label's font", ^{
                    NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                    UIFont *expectedFont = [UIFont fontWithName:fontName size:16];
                    expect(conversationItemView.conversationTitleLabel.font).to.equal(expectedFont);
                });
                it(@"should show date message label", ^{
                    expect(conversationItemView.dateLabel.hidden).to.beFalsy();
                });
                it(@"should set proper date label frame", ^{
                    CGRect expectedFrame = CGRectMake(264.5, 23.0, 43.5, 14.5);
                    expect(conversationItemView.dateLabel.frame).to.equal(expectedFrame);
                });
                it(@"should set proper date label's font", ^{
                    NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                    UIFont *expectedFont = [UIFont fontWithName:fontName size:12];
                    expect(conversationItemView.dateLabel.font).to.equal(expectedFont);
                });
                it(@"should hide last message label", ^{
                    expect(conversationItemView.lastMessageLabel.hidden).to.beTruthy();
                });
            });
            
            context(@"when view has `Large` size", ^{
                beforeEach(^{
                    conversationItemViewSizeSetup(CGSizeMake(320, 72));
                });
                
                it(@"should set proper accessory view container frame", ^{
                    CGRect expectedFrame = CGRectMake(12.0, 12.0, 48.0, 48.0);
                    expect(conversationItemView.accessoryViewContainer.frame).to.equal(expectedFrame);
                });
                it(@"should set proper conversation title label frame", ^{
                    CGRect expectedFrame = CGRectMake(12.0, 14.0, 240.5, 19.5);
                    expect(conversationItemView.conversationTitleLabel.frame).to.equal(expectedFrame);
                });
                it(@"should set proper conversation title label's font", ^{
                    NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                    UIFont *expectedFont = [UIFont fontWithName:fontName size:16];
                    expect(conversationItemView.conversationTitleLabel.font).to.equal(expectedFont);
                });
                it(@"should show date message label", ^{
                    expect(conversationItemView.dateLabel.hidden).to.beFalsy();
                });
                it(@"should set proper date label frame", ^{
                    CGRect expectedFrame = CGRectMake(264.5, 14.0, 43.5, 14.5);
                    expect(conversationItemView.dateLabel.frame).to.equal(expectedFrame);
                });
                it(@"should set proper date label's font", ^{
                    NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                    UIFont *expectedFont = [UIFont fontWithName:fontName size:12];
                    expect(conversationItemView.dateLabel.font).to.equal(expectedFont);
                });
                it(@"should show last message label", ^{
                    expect(conversationItemView.lastMessageLabel.hidden).to.beFalsy();
                });
                it(@"should set proper last message label frame", ^{
                    CGRect expectedFrame = CGRectMake(12.0, 37.5, 296.0, 17.0);
                    expect(conversationItemView.lastMessageLabel.frame).to.equal(expectedFrame);
                });
            });
        });
        
        context(@"with accessory view", ^{
            beforeEach(^{
                UIView *accessoryView = [[LYRUISampleAccessoryView alloc] init];
                conversationItemView.accessoryView = accessoryView;
            });
            
            context(@"when view has `Tiny` size", ^{
                beforeEach(^{
                    conversationItemViewSizeSetup(CGSizeMake(320, 32));
                });
                
                it(@"should set proper accessory view container frame", ^{
                    CGRect expectedFrame = CGRectMake(12.0, 10.0, 12.0, 12.0);
                    expect(conversationItemView.accessoryViewContainer.frame).to.equal(expectedFrame);
                });
                it(@"should set proper conversation title label frame", ^{
                    CGRect expectedFrame = CGRectMake(32.0, 7.5, 276.0, 17.0);
                    expect(conversationItemView.conversationTitleLabel.frame).to.equal(expectedFrame);
                });
                it(@"should set proper conversation title label's font", ^{
                    NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                    UIFont *expectedFont = [UIFont fontWithName:fontName size:14];
                    expect(conversationItemView.conversationTitleLabel.font).to.equal(expectedFont);
                });
                it(@"should hide date message label", ^{
                    expect(conversationItemView.dateLabel.hidden).to.beTruthy();
                });
                it(@"should hide last message label", ^{
                    expect(conversationItemView.lastMessageLabel.hidden).to.beTruthy();
                });
            });
            
            context(@"when view has `Small` size", ^{
                beforeEach(^{
                    conversationItemViewSizeSetup(CGSizeMake(320, 48));
                });
                
                it(@"should set proper accessory view container frame", ^{
                    CGRect expectedFrame = CGRectMake(12.0, 8.0, 32.0, 32.0);
                    expect(conversationItemView.accessoryViewContainer.frame).to.equal(expectedFrame);
                });
                it(@"should set proper conversation title label frame", ^{
                    CGRect expectedFrame = CGRectMake(56.0, 15.5, 203.5, 17.0);
                    expect(conversationItemView.conversationTitleLabel.frame).to.equal(expectedFrame);
                });
                it(@"should set proper conversation title label's font", ^{
                    NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                    UIFont *expectedFont = [UIFont fontWithName:fontName size:14];
                    expect(conversationItemView.conversationTitleLabel.font).to.equal(expectedFont);
                });
                it(@"should show date message label", ^{
                    expect(conversationItemView.dateLabel.hidden).to.beFalsy();
                });
                it(@"should set proper date label frame", ^{
                    CGRect expectedFrame = CGRectMake(271.5, 18.0, 36.5, 12.0);
                    expect(conversationItemView.dateLabel.frame).to.equal(expectedFrame);
                });
                it(@"should set proper date label's font", ^{
                    NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                    UIFont *expectedFont = [UIFont fontWithName:fontName size:10];
                    expect(conversationItemView.dateLabel.font).to.equal(expectedFont);
                });
                it(@"should hide last message label", ^{
                    expect(conversationItemView.lastMessageLabel.hidden).to.beTruthy();
                });
            });
            
            context(@"when view has `Medium` size", ^{
                beforeEach(^{
                    conversationItemViewSizeSetup(CGSizeMake(320, 60));
                });
                
                it(@"should set proper accessory view container frame", ^{
                    CGRect expectedFrame = CGRectMake(12.0, 10.0, 40.0, 40.0);
                    expect(conversationItemView.accessoryViewContainer.frame).to.equal(expectedFrame);
                });
                it(@"should set proper conversation title label frame", ^{
                    CGRect expectedFrame = CGRectMake(64.0, 20.5, 188.5, 19.5);
                    expect(conversationItemView.conversationTitleLabel.frame).to.equal(expectedFrame);
                });
                it(@"should set proper conversation title label's font", ^{
                    NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                    UIFont *expectedFont = [UIFont fontWithName:fontName size:16];
                    expect(conversationItemView.conversationTitleLabel.font).to.equal(expectedFont);
                });
                it(@"should show date message label", ^{
                    expect(conversationItemView.dateLabel.hidden).to.beFalsy();
                });
                it(@"should set proper date label frame", ^{
                    CGRect expectedFrame = CGRectMake(264.5, 23.0, 43.5, 14.5);
                    expect(conversationItemView.dateLabel.frame).to.equal(expectedFrame);
                });
                it(@"should set proper date label's font", ^{
                    NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                    UIFont *expectedFont = [UIFont fontWithName:fontName size:12];
                    expect(conversationItemView.dateLabel.font).to.equal(expectedFont);
                });
                it(@"should hide last message label", ^{
                    expect(conversationItemView.lastMessageLabel.hidden).to.beTruthy();
                });
            });
            
            context(@"when view has `Large` size", ^{
                beforeEach(^{
                    conversationItemViewSizeSetup(CGSizeMake(320, 72));
                });
                
                it(@"should set proper accessory view container frame", ^{
                    CGRect expectedFrame = CGRectMake(12.0, 12.0, 48.0, 48.0);
                    expect(conversationItemView.accessoryViewContainer.frame).to.equal(expectedFrame);
                });
                it(@"should set proper conversation title label frame", ^{
                    CGRect expectedFrame = CGRectMake(72.0, 14.0, 180.5, 19.5);
                    expect(conversationItemView.conversationTitleLabel.frame).to.equal(expectedFrame);
                });
                it(@"should set proper conversation title label's font", ^{
                    NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                    UIFont *expectedFont = [UIFont fontWithName:fontName size:16];
                    expect(conversationItemView.conversationTitleLabel.font).to.equal(expectedFont);
                });
                it(@"should show date message label", ^{
                    expect(conversationItemView.dateLabel.hidden).to.beFalsy();
                });
                it(@"should set proper date label frame", ^{
                    CGRect expectedFrame = CGRectMake(264.5, 14.0, 43.5, 14.5);
                    expect(conversationItemView.dateLabel.frame).to.equal(expectedFrame);
                });
                it(@"should set proper date label's font", ^{
                    NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                    UIFont *expectedFont = [UIFont fontWithName:fontName size:12];
                    expect(conversationItemView.dateLabel.font).to.equal(expectedFont);
                });
                it(@"should show last message label", ^{
                    expect(conversationItemView.lastMessageLabel.hidden).to.beFalsy();
                });
                it(@"should set proper last message label frame", ^{
                    CGRect expectedFrame = CGRectMake(72.0, 37.5, 236.0, 17.0);
                    expect(conversationItemView.lastMessageLabel.frame).to.equal(expectedFrame);
                });
            });
        });
    });
});

SpecEnd
