#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIListLayout.h>
#import <LayerXDK/LYRUIIdentityListView.h>

SpecBegin(LYRUIListLayout)

describe(@"LYRUIListLayout", ^{
    __block LYRUIListLayout *layout;

    beforeEach(^{
        layout = [[LYRUIListLayout alloc] init];
    });

    afterEach(^{
        layout = nil;
    });

    describe(@"after initialization", ^{
        it(@"should have minimum line spacing set to 0", ^{
            expect(layout.minimumLineSpacing).to.equal(0);
        });
        it(@"should have minimum interitem spacing set to 0", ^{
            expect(layout.minimumInteritemSpacing).to.equal(0);
        });
    });
    
    describe(@"layout", ^{
        __block LYRUIIdentityListView *view;
        
        beforeEach(^{
            view = [[LYRUIIdentityListView alloc] init];
            view.layout = layout;
            
            view.frame = CGRectMake(0, 0, 100, 100);
            [view setNeedsLayout];
            [view layoutIfNeeded];
        });
        
        it(@"should resize collection view to fully fit the view", ^{
            expect(view.collectionView.frame).to.equal(CGRectMake(0, 0, 100, 100));
        });
    });
});

SpecEnd
