#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIAvatarView.h>
#import <Atlas/LYRUIAvatarViewSingleLayout.h>
#import <Atlas/LYRUIAvatarViewMultiLayout.h>

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
        context(@"with layout outlet connected to single layout object", ^{
            beforeEach(^{
                NSBundle *bundle = [NSBundle bundleForClass:[self class]];
                NSArray<LYRUIAvatarView *> *xibViews = [bundle loadNibNamed:@"LYRUIAvatarView" owner:self options:nil];
                view = [xibViews objectAtIndex:2];
            });
            
            it(@"should have layout set to object connected via IB outlet", ^{
                expect(view.layout).to.beAKindOf([LYRUIAvatarViewSingleLayout class]);
            });
        });
        
        context(@"with layout outlet connected to multi layout object", ^{
            beforeEach(^{
                NSBundle *bundle = [NSBundle bundleForClass:[self class]];
                NSArray<LYRUIAvatarView *> *xibViews = [bundle loadNibNamed:@"LYRUIAvatarView" owner:self options:nil];
                view = [xibViews objectAtIndex:3];
            });
            
            it(@"should have layout set to object connected via IB outlet", ^{
                expect(view.layout).to.beAKindOf([LYRUIAvatarViewMultiLayout class]);
            });
        });
    });
});

SpecEnd
