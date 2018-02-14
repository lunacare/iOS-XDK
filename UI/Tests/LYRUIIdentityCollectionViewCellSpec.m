#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIIdentityCollectionViewCell.h>
#import <LayerXDK/LYRUIIdentityItemView.h>

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
    
    describe(@"selected", ^{
        context(@"setter", ^{
            context(@"when set to `YES`", ^{
                beforeEach(^{
                    beforeEach(^{
                        cell.selected = YES;
                    });
                    
                    it(@"should update identity item view's background color to light gray", ^{
                        UIColor *expectedColor = [UIColor colorWithWhite:242.0/255.0 alpha:1.0];
                        expect(cell.identityView.backgroundColor).to.equal(expectedColor);
                    });
                });
            });
            
            context(@"when set to `NO`", ^{
                beforeEach(^{
                    beforeEach(^{
                        cell.selected = NO;
                    });
                    
                    it(@"should update identity item view's background color to white", ^{
                        expect(cell.identityView.backgroundColor).to.equal(UIColor.whiteColor);
                    });
                });
            });
        });
    });
});

SpecEnd
