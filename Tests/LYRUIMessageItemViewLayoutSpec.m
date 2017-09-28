#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIMessageItemViewLayout.h>
#import <Atlas/LYRUISampleAccessoryView.h>

SpecBegin(LYRUIMessageItemViewLayout)

describe(@"LYRUIMessageItemViewLayout", ^{
    __block LYRUIMessageItemViewLayout *layout;
    __block LYRUIMessageItemView *messageItemView;
    __block void(^messageItemViewSizeSetup)(CGSize);

    context(@"layout", ^{
        beforeEach(^{
            messageItemView = [[LYRUIMessageItemView alloc] init];
            messageItemView.translatesAutoresizingMaskIntoConstraints = NO;
            UIView *primaryAccessoryView = [[LYRUISampleAccessoryView alloc] init];
            messageItemView.primaryAccessoryView = primaryAccessoryView;
            [primaryAccessoryView.widthAnchor constraintEqualToConstant:32.0].active = YES;
            [primaryAccessoryView.heightAnchor constraintEqualToConstant:32.0].active = YES;
            UIView *secondaryAccessoryView = [[LYRUISampleAccessoryView alloc] init];
            messageItemView.secondaryAccessoryView = secondaryAccessoryView;
            [secondaryAccessoryView.widthAnchor constraintEqualToConstant:32.0].active = YES;
            [secondaryAccessoryView.heightAnchor constraintEqualToConstant:32.0].active = YES;
            UIView *contentView = [[UIView alloc] init];
            messageItemView.contentView = contentView;
            [contentView.widthAnchor constraintLessThanOrEqualToConstant:1000.0].active = YES;
            [contentView.heightAnchor constraintEqualToConstant:100.0].active = YES;
            
            messageItemViewSizeSetup = ^(CGSize size) {
                [[messageItemView.widthAnchor constraintEqualToConstant:size.width] setActive:YES];
                [[messageItemView.heightAnchor constraintEqualToConstant:size.height] setActive:YES];
                [messageItemView setNeedsLayout];
                [messageItemView layoutIfNeeded];
                [messageItemView setNeedsUpdateConstraints];
                [messageItemView updateConstraintsIfNeeded];
                [messageItemView setNeedsLayout];
                [messageItemView layoutIfNeeded];
            };
        });
        
        context(@"with Left direction", ^{
            beforeEach(^{
                layout = [[LYRUIMessageItemViewLayout alloc] initWithLayoutDirection:LYRUIMessageItemViewLayoutDirectionLeft];
                messageItemView.layout = layout;
            });
            
            afterEach(^{
                layout = nil;
                messageItemView = nil;
            });
            
            context(@"with both accessory views added", ^{
                context(@"when view has small width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(320.0, 104.0));
                    });
                    
                    it(@"should set proper primary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 70.0, 32.0, 32.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(52.0, 2.0, 216.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper secondary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(276.0, 36.0, 32.0, 32.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                });
                
                context(@"when view has medium width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(500.0, 104.0));
                    });
                    
                    it(@"should set proper primary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 70.0, 32.0, 32.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(52.0, 2.0, 375.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper secondary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(435.0, 36.0, 32.0, 32.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                });
                
                context(@"when view has big width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(700.0, 104.0));
                    });
                    
                    it(@"should set proper primary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 70.0, 32.0, 32.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(52.0, 2.0, 420.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper secondary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(480.0, 36.0, 32.0, 32.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                });
            });
            
            context(@"with only primary accessory view added", ^{
                beforeEach(^{
                    messageItemView.secondaryAccessoryView = nil;
                });
                
                context(@"when view has small width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(320.0, 104.0));
                    });
                    
                    it(@"should set proper primary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 70.0, 32.0, 32.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(52.0, 2.0, 256.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set secondary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                });
                
                context(@"when view has medium width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(500.0, 104.0));
                    });
                    
                    it(@"should set proper primary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 70.0, 32.0, 32.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(52.0, 2.0, 375.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set secondary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                });
                
                context(@"when view has big width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(700.0, 104.0));
                    });
                    
                    it(@"should set proper primary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 70.0, 32.0, 32.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(52.0, 2.0, 420.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set secondary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                });
            });
            
            context(@"with only secondary accessory view added", ^{
                beforeEach(^{
                    messageItemView.primaryAccessoryView = nil;
                });
                
                context(@"when view has small width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(320.0, 104.0));
                    });
                    
                    it(@"should set primary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 2.0, 256.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper secondary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(276.0, 36.0, 32.0, 32.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                });
                
                context(@"when view has medium width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(500.0, 104.0));
                    });
                    
                    it(@"should set primary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 2.0, 375.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper secondary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(395.0, 36.0, 32.0, 32.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                });
                
                context(@"when view has big width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(700.0, 104.0));
                    });
                    
                    it(@"should set primary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 2.0, 420.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper secondary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(440.0, 36.0, 32.0, 32.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                });
            });
            
            context(@"without both accessory views", ^{
                beforeEach(^{
                    messageItemView.primaryAccessoryView = nil;
                    messageItemView.secondaryAccessoryView = nil;
                });
                
                context(@"when view has small width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(320.0, 104.0));
                    });
                    
                    it(@"should set primary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 2.0, 288.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set secondary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                });
                
                context(@"when view has medium width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(500.0, 104.0));
                    });
                    
                    it(@"should set primary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 2.0, 375.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set secondary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                });
                
                context(@"when view has big width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(700.0, 104.0));
                    });
                    
                    it(@"should set primary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 2.0, 420.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set secondary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                });
            });
        });
        
        context(@"with Right direction", ^{
            beforeEach(^{
                layout = [[LYRUIMessageItemViewLayout alloc] initWithLayoutDirection:LYRUIMessageItemViewLayoutDirectionRight];
                messageItemView.layout = layout;
            });
            
            afterEach(^{
                layout = nil;
                messageItemView = nil;
            });
            
            context(@"with both accessory views added", ^{
                context(@"when view has small width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(320.0, 104.0));
                    });
                    
                    it(@"should set proper primary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(276.0, 70.0, 32.0, 32.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(52.0, 2.0, 216.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper secondary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 36.0, 32.0, 32.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                });
                
                context(@"when view has medium width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(500.0, 104.0));
                    });
                    
                    it(@"should set proper primary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(456.0, 70.0, 32.0, 32.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(73.0, 2.0, 375.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper secondary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(33.0, 36.0, 32.0, 32.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                });
                
                context(@"when view has big width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(700.0, 104.0));
                    });
                    
                    it(@"should set proper primary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(656.0, 70.0, 32.0, 32.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(228.0, 2.0, 420.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper secondary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(188.0, 36.0, 32.0, 32.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                });
            });
            
            context(@"with only primary accessory view added", ^{
                beforeEach(^{
                    messageItemView.secondaryAccessoryView = nil;
                });
                
                context(@"when view has small width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(320.0, 104.0));
                    });
                    
                    it(@"should set proper primary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(276.0, 70.0, 32.0, 32.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 2.0, 256.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set secondary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                });
                
                context(@"when view has medium width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(500.0, 104.0));
                    });
                    
                    it(@"should set proper primary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(456.0, 70.0, 32.0, 32.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(73.0, 2.0, 375.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set secondary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                });
                
                context(@"when view has big width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(700.0, 104.0));
                    });
                    
                    it(@"should set proper primary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(656.0, 70.0, 32.0, 32.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(228.0, 2.0, 420.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set secondary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                });
            });
            
            context(@"with only secondary accessory view added", ^{
                beforeEach(^{
                    messageItemView.primaryAccessoryView = nil;
                });
                
                context(@"when view has small width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(320.0, 104.0));
                    });
                    
                    it(@"should set primary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(52.0, 2.0, 256.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper secondary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(12.0, 36.0, 32.0, 32.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                });
                
                context(@"when view has medium width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(500.0, 104.0));
                    });
                    
                    it(@"should set primary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(113.0, 2.0, 375.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper secondary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(73.0, 36.0, 32.0, 32.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                });
                
                context(@"when view has big width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(700.0, 104.0));
                    });
                    
                    it(@"should set primary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(268.0, 2.0, 420.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set proper secondary accessory view container frame", ^{
                        CGRect expectedFrame = CGRectMake(228.0, 36.0, 32.0, 32.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame).to.equal(expectedFrame);
                    });
                });
            });
            
            context(@"without both accessory views", ^{
                beforeEach(^{
                    messageItemView.primaryAccessoryView = nil;
                    messageItemView.secondaryAccessoryView = nil;
                });
                
                context(@"when view has small width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(320.0, 104.0));
                    });
                    
                    it(@"should set primary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(20.0, 2.0, 288.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set secondary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                });
                
                context(@"when view has medium width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(500.0, 104.0));
                    });
                    
                    it(@"should set primary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(113.0, 2.0, 375.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set secondary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                });
                
                context(@"when view has big width", ^{
                    beforeEach(^{
                        messageItemViewSizeSetup(CGSizeMake(700.0, 104.0));
                    });
                    
                    it(@"should set primary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.primaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                    it(@"should set proper content view container frame", ^{
                        CGRect expectedFrame = CGRectMake(268.0, 2.0, 420.0, 100.0);
                        expect(messageItemView.contentViewContainer.frame).to.equal(expectedFrame);
                    });
                    it(@"should set secondary accessory view container frame to zero size", ^{
                        CGSize expectedSize = CGSizeMake(0.0, 0.0);
                        expect(messageItemView.secondaryAccessoryViewContainer.frame.size).to.equal(expectedSize);
                    });
                });
            });
        });
    });
});

SpecEnd
