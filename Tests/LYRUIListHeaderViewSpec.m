#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIListHeaderView.h>

SpecBegin(LYRUIListHeaderView)

describe(@"LYRUIListHeaderView", ^{
    __block LYRUIListHeaderView *view;
    __block UILabel *label;

    beforeEach(^{
        view = [[LYRUIListHeaderView alloc] init];
        label = view.subviews.firstObject;
    });

    afterEach(^{
        view = nil;
    });

    describe(@"after initialization ", ^{
        it(@"should have an label added as a subview", ^{
            expect(label).notTo.beNil();
        });
    });
    
    describe(@"layout", ^{
        beforeEach(^{
            view.title = @"test title";
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [view.widthAnchor constraintEqualToConstant:100].active = YES;
            [view.heightAnchor constraintEqualToConstant:100].active = YES;
            [view setNeedsLayout];
            [view layoutIfNeeded];
        });
        
        it(@"should properly resize label", ^{
            expect(label.frame).to.equal(CGRectMake(12, 72, 76, 16));
        });
    });
    
    describe(@"title", ^{
        context(@"getter", ^{
            beforeEach(^{
                label.text = @"test text";
            });
            
            it(@"should return the label's text", ^{
                expect(view.title).to.equal(@"test text");
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.title = @"other test text";
            });
            
            it(@"should update label's text", ^{
                expect(label.text).to.equal(@"other test text");
            });
        });
    });
});

SpecEnd
