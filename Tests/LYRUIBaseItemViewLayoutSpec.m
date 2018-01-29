#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <Atlas/LYRUIBaseItemViewLayout.h>
#import <Atlas/LYRUIBaseItemView.h>
#import <Atlas/LYRUIBaseItemViewLayoutMetrics.h>

SpecBegin(LYRUIBaseItemViewLayout)

describe(@"LYRUIBaseItemViewLayout", ^{
    __block LYRUIBaseItemViewLayout *layout;
    __block LYRUIBaseItemView *baseItemView;
    __block void(^baseItemViewSizeSetup)(CGSize);
    
    context(@"using LYRUIBaseItemViewLayoutMetrics", ^{
        beforeEach(^{
            id<LYRUIBaseItemViewLayoutMetricsProviding> metrics = [[LYRUIBaseItemViewLayoutMetrics alloc] init];
            layout = [[LYRUIBaseItemViewLayout alloc] initWithMetrics:metrics];
            baseItemView = [[LYRUIBaseItemView alloc] init];
            baseItemView.layout = layout;
            baseItemView.translatesAutoresizingMaskIntoConstraints = NO;
            baseItemView.titleLabel.text = @"this is a long test conversation title";
            baseItemView.detailLabel.text = @"8:30am";
            baseItemView.subtitleLabel.text = @"test last message";
            
            baseItemViewSizeSetup = ^(CGSize size) {
                [[baseItemView.widthAnchor constraintEqualToConstant:size.width] setActive:YES];
                [[baseItemView.heightAnchor constraintEqualToConstant:size.height] setActive:YES];
                [baseItemView setNeedsLayout];
                [baseItemView layoutIfNeeded];
                [baseItemView setNeedsUpdateConstraints];
                [baseItemView updateConstraintsIfNeeded];
                [baseItemView setNeedsLayout];
                [baseItemView layoutIfNeeded];
            };
        });
        
        afterEach(^{
            layout = nil;
            baseItemView = nil;
        });
        
        describe(@"layout", ^{
            context(@"without accessory view", ^{
                context(@"when view has `Tiny` size", ^{
                    beforeEach(^{
                        baseItemViewSizeSetup(CGSizeMake(320, 32));
                    });
                    
                    it(@"should set proper accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 10.0, 12.0, 12.0);
                        expect(baseItemView.accessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper conversation title label frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 7.5, 296.0, 17.0);
                        expect(baseItemView.titleLabel.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper conversation title label's font", ^{
                        NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                        UIFont *expectedFont = [UIFont fontWithName:fontName size:14];
                        expect(baseItemView.titleLabel.font).to.equal(expectedFont);
                    });
                    it(@"should hide date message label", ^{
                        expect(baseItemView.detailLabel.hidden).to.beTruthy();
                    });
                    it(@"should hide last message label", ^{
                        expect(baseItemView.subtitleLabel.hidden).to.beTruthy();
                    });
                });
                
                context(@"when view has `Small` size", ^{
                    beforeEach(^{
                        baseItemViewSizeSetup(CGSizeMake(320, 48));
                    });
                    
                    it(@"should set proper accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 8.0, 32.0, 32.0);
                        expect(baseItemView.accessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper conversation title label frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 15.5, 230.0, 17.0);
                        expect(baseItemView.titleLabel.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper conversation title label's font", ^{
                        NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                        UIFont *expectedFont = [UIFont fontWithName:fontName size:14];
                        expect(baseItemView.titleLabel.font).to.equal(expectedFont);
                    });
                    it(@"should show date message label", ^{
                        expect(baseItemView.detailLabel.hidden).to.beFalsy();
                    });
                    it(@"should set proper date label frame", ^{
                        CGRect expectedFrame = CGRectMake(271.5, 18.0, 36.5, 12.0);
                        expect(baseItemView.detailLabel.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper date label's font", ^{
                        NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                        UIFont *expectedFont = [UIFont fontWithName:fontName size:10];
                        expect(baseItemView.detailLabel.font).to.equal(expectedFont);
                    });
                    it(@"should hide last message label", ^{
                        expect(baseItemView.subtitleLabel.hidden).to.beTruthy();
                    });
                });
                
                context(@"when view has `Medium` size", ^{
                    beforeEach(^{
                        baseItemViewSizeSetup(CGSizeMake(320, 60));
                    });
                    
                    it(@"should set proper accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 10.0, 40.0, 40.0);
                        expect(baseItemView.accessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper conversation title label frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 20.5, 240.5, 19.5);
                        expect(baseItemView.titleLabel.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper conversation title label's font", ^{
                        NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                        UIFont *expectedFont = [UIFont fontWithName:fontName size:16];
                        expect(baseItemView.titleLabel.font).to.equal(expectedFont);
                    });
                    it(@"should show date message label", ^{
                        expect(baseItemView.detailLabel.hidden).to.beFalsy();
                    });
                    it(@"should set proper date label frame", ^{
                        CGRect expectedFrame = CGRectMake(264.5, 23.0, 43.5, 14.5);
                        expect(baseItemView.detailLabel.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper date label's font", ^{
                        NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                        UIFont *expectedFont = [UIFont fontWithName:fontName size:12];
                        expect(baseItemView.detailLabel.font).to.equal(expectedFont);
                    });
                    it(@"should hide last message label", ^{
                        expect(baseItemView.subtitleLabel.hidden).to.beTruthy();
                    });
                });
                
                context(@"when view has `Large` size", ^{
                    beforeEach(^{
                        baseItemViewSizeSetup(CGSizeMake(320, 72));
                    });
                    
                    it(@"should set proper accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 12.0, 48.0, 48.0);
                        expect(baseItemView.accessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper conversation title label frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 14.0, 240.5, 19.5);
                        expect(baseItemView.titleLabel.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper conversation title label's font", ^{
                        NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                        UIFont *expectedFont = [UIFont fontWithName:fontName size:16];
                        expect(baseItemView.titleLabel.font).to.equal(expectedFont);
                    });
                    it(@"should show date message label", ^{
                        expect(baseItemView.detailLabel.hidden).to.beFalsy();
                    });
                    it(@"should set proper date label frame", ^{
                        CGRect expectedFrame = CGRectMake(264.5, 14.0, 43.5, 14.5);
                        expect(baseItemView.detailLabel.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper date label's font", ^{
                        NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                        UIFont *expectedFont = [UIFont fontWithName:fontName size:12];
                        expect(baseItemView.detailLabel.font).to.equal(expectedFont);
                    });
                    it(@"should show last message label", ^{
                        expect(baseItemView.subtitleLabel.hidden).to.beFalsy();
                    });
                    it(@"should set proper last message label frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 37.5, 296.0, 17.0);
                        expect(baseItemView.subtitleLabel.frame).to.equal(expectedFrame);
                    });
                });
            });
            
            context(@"with accessory view", ^{
                beforeEach(^{
                    UIView *accessoryView = [[UIView alloc] init];
                    baseItemView.accessoryView = accessoryView;
                });
                
                context(@"when view has `Tiny` size", ^{
                    beforeEach(^{
                        baseItemViewSizeSetup(CGSizeMake(320, 32));
                    });
                    
                    it(@"should set proper accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 10.0, 12.0, 12.0);
                        expect(baseItemView.accessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper conversation title label frame", ^{
                        CGRect expectedFrame = CGRectMake(32.0, 7.5, 276.0, 17.0);
                        expect(baseItemView.titleLabel.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper conversation title label's font", ^{
                        NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                        UIFont *expectedFont = [UIFont fontWithName:fontName size:14];
                        expect(baseItemView.titleLabel.font).to.equal(expectedFont);
                    });
                    it(@"should hide date message label", ^{
                        expect(baseItemView.detailLabel.hidden).to.beTruthy();
                    });
                    it(@"should hide last message label", ^{
                        expect(baseItemView.subtitleLabel.hidden).to.beTruthy();
                    });
                });
                
                context(@"when view has `Small` size", ^{
                    beforeEach(^{
                        baseItemViewSizeSetup(CGSizeMake(320, 48));
                    });
                    
                    it(@"should set proper accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 8.0, 32.0, 32.0);
                        expect(baseItemView.accessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper conversation title label frame", ^{
                        CGRect expectedFrame = CGRectMake(56.0, 15.5, 203.5, 17.0);
                        expect(baseItemView.titleLabel.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper conversation title label's font", ^{
                        NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                        UIFont *expectedFont = [UIFont fontWithName:fontName size:14];
                        expect(baseItemView.titleLabel.font).to.equal(expectedFont);
                    });
                    it(@"should show date message label", ^{
                        expect(baseItemView.detailLabel.hidden).to.beFalsy();
                    });
                    it(@"should set proper date label frame", ^{
                        CGRect expectedFrame = CGRectMake(271.5, 18.0, 36.5, 12.0);
                        expect(baseItemView.detailLabel.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper date label's font", ^{
                        NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                        UIFont *expectedFont = [UIFont fontWithName:fontName size:10];
                        expect(baseItemView.detailLabel.font).to.equal(expectedFont);
                    });
                    it(@"should hide last message label", ^{
                        expect(baseItemView.subtitleLabel.hidden).to.beTruthy();
                    });
                });
                
                context(@"when view has `Medium` size", ^{
                    beforeEach(^{
                        baseItemViewSizeSetup(CGSizeMake(320, 60));
                    });
                    
                    it(@"should set proper accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 10.0, 40.0, 40.0);
                        expect(baseItemView.accessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper conversation title label frame", ^{
                        CGRect expectedFrame = CGRectMake(64.0, 20.5, 188.5, 19.5);
                        expect(baseItemView.titleLabel.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper conversation title label's font", ^{
                        NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                        UIFont *expectedFont = [UIFont fontWithName:fontName size:16];
                        expect(baseItemView.titleLabel.font).to.equal(expectedFont);
                    });
                    it(@"should show date message label", ^{
                        expect(baseItemView.detailLabel.hidden).to.beFalsy();
                    });
                    it(@"should set proper date label frame", ^{
                        CGRect expectedFrame = CGRectMake(264.5, 23.0, 43.5, 14.5);
                        expect(baseItemView.detailLabel.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper date label's font", ^{
                        NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                        UIFont *expectedFont = [UIFont fontWithName:fontName size:12];
                        expect(baseItemView.detailLabel.font).to.equal(expectedFont);
                    });
                    it(@"should hide last message label", ^{
                        expect(baseItemView.subtitleLabel.hidden).to.beTruthy();
                    });
                });
                
                context(@"when view has `Large` size", ^{
                    beforeEach(^{
                        baseItemViewSizeSetup(CGSizeMake(320, 72));
                    });
                    
                    it(@"should set proper accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 12.0, 48.0, 48.0);
                        expect(baseItemView.accessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper conversation title label frame", ^{
                        CGRect expectedFrame = CGRectMake(72.0, 14.0, 180.5, 19.5);
                        expect(baseItemView.titleLabel.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper conversation title label's font", ^{
                        NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                        UIFont *expectedFont = [UIFont fontWithName:fontName size:16];
                        expect(baseItemView.titleLabel.font).to.equal(expectedFont);
                    });
                    it(@"should show date message label", ^{
                        expect(baseItemView.detailLabel.hidden).to.beFalsy();
                    });
                    it(@"should set proper date label frame", ^{
                        CGRect expectedFrame = CGRectMake(264.5, 14.0, 43.5, 14.5);
                        expect(baseItemView.detailLabel.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper date label's font", ^{
                        NSString *fontName = [UIFont systemFontOfSize:1].fontName;
                        UIFont *expectedFont = [UIFont fontWithName:fontName size:12];
                        expect(baseItemView.detailLabel.font).to.equal(expectedFont);
                    });
                    it(@"should show last message label", ^{
                        expect(baseItemView.subtitleLabel.hidden).to.beFalsy();
                    });
                    it(@"should set proper last message label frame", ^{
                        CGRect expectedFrame = CGRectMake(72.0, 37.5, 236.0, 17.0);
                        expect(baseItemView.subtitleLabel.frame).to.equal(expectedFrame);
                    });
                });
            });
        });
    });
});

SpecEnd
