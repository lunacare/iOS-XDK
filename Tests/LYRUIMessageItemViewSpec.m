#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIMessageItemView.h>
#import <Atlas/LYRUIMessageItemViewLayout.h>

SpecBegin(LYRUIMessageItemView)

describe(@"LYRUIMessageItemView", ^{
    __block LYRUIMessageItemView *view;

    beforeEach(^{
        view = [[LYRUIMessageItemView alloc] init];
    });

    afterEach(^{
        view = nil;
    });
    
    describe(@"after initialization", ^{
        it(@"should not have primary accessoryView set", ^{
            expect(view.primaryAccessoryView).to.beNil();
        });
        it(@"should have primary accessory view container set", ^{
            expect(view.primaryAccessoryViewContainer).notTo.beNil();
        });
        it(@"should have the primary accessory view container added as a subview", ^{
            expect(view.primaryAccessoryViewContainer.superview).to.equal(view);
        });
        it(@"should have content view container set", ^{
            expect(view.contentViewContainer).notTo.beNil();
        });
        it(@"should have the content view container added as a subview", ^{
            expect(view.contentViewContainer.superview).to.equal(view);
        });
        it(@"should not have secondary accessoryView set", ^{
            expect(view.secondaryAccessoryView).to.beNil();
        });
        it(@"should have secondary accessory view container set", ^{
            expect(view.secondaryAccessoryViewContainer).notTo.beNil();
        });
        it(@"should have the secondary accessory view container added as a subview", ^{
            expect(view.secondaryAccessoryViewContainer.superview).to.equal(view);
        });
        it(@"should have layout set to `LYRUIMessageItemViewLayout`", ^{
            expect(view.layout).to.beAKindOf([LYRUIMessageItemViewLayout class]);
        });
    });
    
    describe(@"after initialization with layout", ^{
        __block id<LYRUIMessageItemViewLayout> layoutMock;
        
        beforeEach(^{
            layoutMock = mockProtocol(@protocol(LYRUIMessageItemViewLayout));
            
            view = [[LYRUIMessageItemView alloc] initWithLayout:layoutMock];
        });
        
        it(@"should have layout set to the one passed to initializator", ^{
            expect(view.layout).to.equal(layoutMock);
        });
    });
    
    describe(@"after initialization from xib", ^{
        __block UIView *primaryAccessoryView;
        __block UIView *secondaryAccessoryView;
        
        beforeEach(^{
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSArray *xibViews = [bundle loadNibNamed:@"LYRUIMessageItemView" owner:self options:nil];
            view = [xibViews objectAtIndex:0];
            primaryAccessoryView = [xibViews objectAtIndex:1];
            secondaryAccessoryView = [xibViews objectAtIndex:2];
        });
        
        it(@"should have primary accessory view set by Interface Builder Outlet", ^{
            expect(view.primaryAccessoryView).to.equal(primaryAccessoryView);
        });
        it(@"should have primary accessory view added as a subview in container", ^{
            expect(primaryAccessoryView.superview).to.equal(view.primaryAccessoryViewContainer);
        });
        it(@"should have secondary accessory view set by Interface Builder Outlet", ^{
            expect(view.secondaryAccessoryView).to.equal(secondaryAccessoryView);
        });
        it(@"should have secondary accessory view added as a subview in container", ^{
            expect(secondaryAccessoryView.superview).to.equal(view.secondaryAccessoryViewContainer);
        });
    });
});

SpecEnd
