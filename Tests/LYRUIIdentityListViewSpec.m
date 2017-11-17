#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIIdentityListView.h>
#import <Atlas/LYRUIListLayout.h>
#import <Atlas/LYRUIListDataSource.h>
#import <Atlas/LYRUIListDelegate.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIIdentityListView)

describe(@"LYRUIIdentityListView", ^{
    __block LYRUIIdentityListView *view;
    __block UICollectionViewLayout<LYRUIListViewLayout> *layoutMock;
    __block id<LYRUIListDelegate> delegateMock;
    __block id<LYRUIListDataSource> dataSourceMock;

    beforeEach(^{
        view = [[LYRUIIdentityListView alloc] init];
        
        LYRUIListLayout *layout = [[LYRUIListLayout alloc] init];
        layoutMock = OCMPartialMock(layout);
        delegateMock = mockProtocol(@protocol(LYRUIListDelegate));
        dataSourceMock = mockProtocol(@protocol(LYRUIListDataSource));
    });

    afterEach(^{
        view = nil;
    });

    describe(@"after initialization", ^{
        it(@"should have the collection view set", ^{
            expect(view.collectionView).notTo.beNil();
        });
        it(@"should have the collectin view added as subview", ^{
            expect(view.collectionView.superview).to.equal(view);
        });
    });
    
    describe(@"items", ^{
        __block NSMutableArray *arrayMock;
        
        beforeEach(^{
            view.dataSource = dataSourceMock;
        });
        
        context(@"getter", ^{
            beforeEach(^{
                arrayMock = mock([NSMutableArray class]);
                [given(dataSourceMock.sections) willReturn:arrayMock];
            });
            
            it(@"should return data source sections array", ^{
                expect(view.items).to.equal(arrayMock);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                arrayMock = mock([NSMutableArray class]);
                view.items = arrayMock;
            });
            
            it(@"should update data source sections array", ^{
                [verify(dataSourceMock) setSections:arrayMock];
            });
        });
    });
    
    describe(@"layout", ^{
        context(@"setter", ^{
            beforeEach(^{
                view.layout = layoutMock;
            });
            
            it(@"should set collection view's layout", ^{
                expect(view.collectionView.collectionViewLayout).to.equal(layoutMock);
            });
            it(@"should install constraints", ^{
                OCMVerify([layoutMock addConstraintsInView:view]);
            });
        });
    });
    
    describe(@"delegate", ^{
        context(@"setter", ^{
            beforeEach(^{
                view.delegate = delegateMock;
            });
            
            it(@"should set collection view's delegate", ^{
                expect(view.collectionView.delegate).to.equal(delegateMock);
            });
        });
    });
    
    describe(@"dataSource", ^{
        context(@"setter", ^{
            beforeEach(^{
                view.dataSource = dataSourceMock;
            });
            
            it(@"should set collection view's dataSource", ^{
                expect(view.collectionView.dataSource).to.equal(dataSourceMock);
            });
        });
    });
    
    describe(@"selecteditems", ^{
        __block NSArray *returneditems;
        __block NSArray *selecteditems;
        
        beforeEach(^{
            view.dataSource = dataSourceMock;
            selecteditems = @[
                    mock([LYRIdentity class]),
                    mock([LYRIdentity class]),
                    mock([LYRIdentity class]),
            ];
            [given([dataSourceMock selectedItemsInCollectionView:view.collectionView]) willReturn:selecteditems];
            
            returneditems = view.selectedItems;
        });
        
        it(@"should return selected items for view's collection view, returned from data source", ^{
            expect(returneditems).to.equal(selecteditems);
        });
    });
});

SpecEnd
