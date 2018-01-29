#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIIdentityCollectionViewCell.h>
#import <Atlas/LYRUIIdentityItemView.h>

SpecBegin(LYRUIIdentityCollectionViewCell)

describe(@"LYRUIIdentityCollectionViewCell", ^{
    __block LYRUIIdentityCollectionViewCell *cell;

    beforeEach(^{
        cell = [[LYRUIIdentityCollectionViewCell alloc] init];
    });

    afterEach(^{
        cell = nil;
    });

    describe(@"after initialization", ^{
        it(@"should have the identity view set", ^{
            expect(cell.identityView).notTo.beNil();
        });
        it(@"should have the identity view added as subview of content view", ^{
            expect(cell.identityView.superview).to.equal(cell.contentView);
        });
    });
});

SpecEnd
