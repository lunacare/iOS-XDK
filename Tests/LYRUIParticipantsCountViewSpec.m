#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIParticipantsCountView.h>

SpecBegin(LYRUIParticipantsCountView)

describe(@"LYRUIParticipantsCountView", ^{
    __block LYRUIParticipantsCountView *view;
    __block __weak UILabel *label;
    
    beforeEach(^{
        view = [[LYRUIParticipantsCountView alloc] init];
        label = view.subviews.firstObject;
    });
    
    afterEach(^{
        view = nil;
    });
    
    describe(@"after initialization", ^{
        it(@"should have a label added as a subview", ^{
            expect(label).to.beAKindOf([UILabel class]);
        });
        it(@"should align text to center in label", ^{
            expect(label.textAlignment).to.equal(NSTextAlignmentCenter);
        });
        it(@"should have border width set to 1", ^{
            expect(view.borderWidth).to.equal(1);
        });
        it(@"should have corner radius set to 4", ^{
            expect(view.cornerRadius).to.equal(4);
        });
        it(@"should have font set to system font with size 9.0", ^{
            UIFont *expectedFont = [UIFont systemFontOfSize:9.0];
            expect(view.font).to.equal(expectedFont);
        });
        it(@"should have default font color set to gray", ^{
            UIColor *expectedColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
            expect(view.textColor).to.equal(expectedColor);
        });
        it(@"should have default border color set to gray", ^{
            UIColor *expectedColor = [UIColor colorWithRed:163.0/255.0 green:168.0/255.0 blue:178.0/255.0 alpha:1.0];
            expect(view.borderColor).to.equal(expectedColor);
        });
        it(@"should have default background color set to clear color", ^{
            expect(view.backgroundColor).to.equal([UIColor clearColor]);
        });
    });
    
    describe(@"after initialization from xib", ^{
        beforeEach(^{
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSArray<UIView *> *xibViews = [bundle loadNibNamed:@"LYRUIParticipantsCountView" owner:self options:nil];
            view = [xibViews objectAtIndex:0].subviews.lastObject;
        });
        
        it(@"should have number of participants set to value from Interface Builder", ^{
            expect(view.numberOfParticipants).to.equal(7);
        });
        it(@"should have border width set to value from Interface Builder", ^{
            expect(view.borderWidth).to.equal(2);
        });
        it(@"should have corner radius set to value from Interface Builder", ^{
            expect(view.cornerRadius).to.equal(9);
        });
        it(@"should have font color set to value from Interface Builder", ^{
            UIColor *expectedColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
            expect(view.textColor).to.equal(expectedColor);
        });
        it(@"should have border color set to value from Interface Builder", ^{
            UIColor *expectedColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
            expect(view.borderColor).to.equal(expectedColor);
        });
    });
    
    describe(@"layout", ^{
        beforeEach(^{
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [view.widthAnchor constraintEqualToConstant:12].active = YES;
            [view.heightAnchor constraintEqualToConstant:12].active = YES;
            [view setNeedsLayout];
            [view layoutIfNeeded];
        });
        
        it(@"should properly resize the label", ^{
            expect(label.frame).to.equal(CGRectMake(0, 0, 12, 12));
        });
    });
    
    describe(@"textColor", ^{
        context(@"getter", ^{
            beforeEach(^{
                label.textColor = [UIColor redColor];
            });
            
            it(@"should return text color of the label", ^{
                expect(view.textColor).to.equal([UIColor redColor]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.textColor = [UIColor greenColor];
            });
            
            it(@"should update text color of the label", ^{
                expect(label.textColor).to.equal([UIColor greenColor]);
            });
        });
    });
    
    describe(@"borderColor", ^{
        context(@"getter", ^{
            beforeEach(^{
                label.layer.borderColor = [UIColor redColor].CGColor;
            });
            
            it(@"should return border color of the label", ^{
                expect(view.borderColor).to.equal([UIColor redColor]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.borderColor = [UIColor greenColor];
            });
            
            it(@"should update border color of the label", ^{
                expect(label.layer.borderColor).to.equal([UIColor greenColor].CGColor);
            });
        });
    });
    
    describe(@"borderWidth", ^{
        context(@"getter", ^{
            beforeEach(^{
                label.layer.borderWidth = 22;
            });
            
            it(@"should return border width of the label", ^{
                expect(view.borderWidth).to.equal(22);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.borderWidth = 44;
            });
            
            it(@"should update border width of the label", ^{
                expect(label.layer.borderWidth).to.equal(44);
            });
        });
    });
    
    describe(@"cornerRadius", ^{
        context(@"getter", ^{
            beforeEach(^{
                label.layer.cornerRadius = 22;
            });
            
            it(@"should return corner radius of the label", ^{
                expect(view.cornerRadius).to.equal(22);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.cornerRadius = 44;
            });
            
            it(@"should update corner radius of the label", ^{
                expect(label.layer.cornerRadius).to.equal(44);
            });
        });
    });
    
    describe(@"font", ^{
        context(@"getter", ^{
            beforeEach(^{
                label.font = [UIFont systemFontOfSize:22];
            });
            
            it(@"should return font of the label", ^{
                expect(view.font).to.equal([UIFont systemFontOfSize:22]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.font = [UIFont systemFontOfSize:44];
            });
            
            it(@"should update font of the label", ^{
                expect(label.font).to.equal([UIFont systemFontOfSize:44]);
            });
        });
    });
    
    describe(@"numberOfParticipants", ^{
        context(@"setter", ^{
            beforeEach(^{
                view.numberOfParticipants = 44;
            });
            
            it(@"should update text of the label", ^{
                expect(label.text).to.equal(@"44");
            });
        });
    });
});

SpecEnd
