#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIAvatarView.h>
#import <Atlas/LYRUIAvatarViewSingleLayout.h>

SpecBegin(LYRUIAvatarView)

describe(@"LYRUIAvatarView", ^{
    __block LYRUIAvatarView *view;
    
    beforeEach(^{
        view = [[LYRUIAvatarView alloc] init];
    });
    
    afterEach(^{
        view = nil;
    });
    
    describe(@"after initialization", ^{
        it(@"should have layout set to nil", ^{
            expect(view.layout).to.beNil();
        });
    });
    
    describe(@"after initialization from xib", ^{
        beforeEach(^{
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSArray<LYRUIAvatarView *> *xibViews = [bundle loadNibNamed:@"LYRUIAvatarView" owner:self options:nil];
            view = [xibViews objectAtIndex:1];
        });
        
        it(@"should have layout set to object connected via IB outlet", ^{
            expect(view.layout).to.beAKindOf([LYRUIAvatarViewSingleLayout class]);
        });
    });
});

SpecEnd
