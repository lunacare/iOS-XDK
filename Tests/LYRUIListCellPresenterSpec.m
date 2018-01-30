#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIListCellPresenter.h>
#import <Atlas/LYRUIListDataSource.h>

SpecBegin(LYRUIListCellPresenter)

describe(@"LYRUIListCellPresenter", ^{
    __block LYRUIListCellPresenter *cellPresenter;
    __block id viewPresenterMock;
    __block BOOL cellSetupCalled;
    __block UICollectionViewCell *capturedCell;
    __block NSObject *capturedItem;
    __block id capturedViewPresenter;
    __block BOOL cellRegistrationCalled;
    __block UICollectionView *capturedCollectionView;
    __block UICollectionView *collectionViewMock;
    __block NSIndexPath *indexPath;

    beforeEach(^{
        cellSetupCalled = NO;
        cellRegistrationCalled = NO;
        cellPresenter = [[LYRUIListCellPresenter alloc] initWithCellClass:[UICollectionViewCell class]
                                                                       modelClass:[NSObject class]
                                                                viewPresenter:viewPresenterMock
                                                                       cellHeight:123.0
                                                                   cellSetupBlock:^(UICollectionViewCell *cell, NSObject *item, id viewPresenter) {
                                                                       cellSetupCalled = YES;
                                                                       capturedCell = cell;
                                                                       capturedItem = item;
                                                                       capturedViewPresenter = viewPresenter;
                                                                   } cellRegistrationBlock:^(UICollectionView *collectionView) {
                                                                       cellRegistrationCalled = YES;
                                                                       capturedCollectionView = collectionView;
                                                                   }];
        
        collectionViewMock = mock([UICollectionView class]);
        CGRect collectionViewBounds = CGRectMake(0, 0, 300, 400);
        [given(collectionViewMock.bounds) willReturnStruct:&collectionViewBounds objCType:@encode(CGRect)];
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    });

    afterEach(^{
        cellPresenter = nil;
    });

    it(@"should return `NSObject` class as handled item types", ^{
        expect(cellPresenter.handledItemTypes).to.equal([NSSet setWithObject:[NSObject class]]);
    });
    it(@"should return `UICollectionViewCell` as cell reuse identifier", ^{
        expect(cellPresenter.cellReuseIdentifier).to.equal(@"UICollectionViewCell");
    });
    it(@"should have view presenter set to provided object", ^{
        expect(cellPresenter.viewPresenter).to.equal(viewPresenterMock);
    });
    
    describe(@"cellSizeInCollectionView:forItemAtIndexPath:", ^{
        __block CGSize returnedSize;
        
        beforeEach(^{
            returnedSize = [cellPresenter cellSizeInCollectionView:collectionViewMock forItemAtIndexPath:indexPath];
        });
        
        it(@"should return proper cell size", ^{
            expect(returnedSize).to.equal(CGSizeMake(300.0, 123.0));
        });
    });
    
    describe(@"setupCell:forItemAtIndexPath:", ^{
        __block UICollectionViewCell *cellMock;
        __block NSObject *item;
        
        beforeEach(^{
            cellMock = mock([UICollectionViewCell class]);
            
            id<LYRUIListDataSource> dataSourceMock = mockProtocol(@protocol(LYRUIListDataSource));
            item = [[NSObject alloc] init];
            [given([dataSourceMock itemAtIndexPath:indexPath]) willReturn:item];
            cellPresenter.listDataSource = dataSourceMock;
            
            [cellPresenter setupCell:cellMock forItemAtIndexPath:indexPath];
        });
        
        it(@"should call cell setup block", ^{
            expect(cellSetupCalled).to.beTruthy();
        });
        it(@"should pass the cell to cell setup block", ^{
            expect(capturedCell).to.equal(cellMock);
        });
        it(@"should pass the item to cell setup block", ^{
            expect(capturedItem).to.equal(item);
        });
        it(@"should pass the view presenter to cell setup block", ^{
            expect(capturedViewPresenter).to.equal(viewPresenterMock);
        });
    });
    
    describe(@"registerCellInCollectionView:", ^{
        context(@"when initialized with cell registration block", ^{
            beforeEach(^{
                [cellPresenter registerCellInCollectionView:collectionViewMock];
            });
            
            it(@"should call cell registration block", ^{
                expect(cellRegistrationCalled).to.beTruthy();
            });
            it(@"should pass collection view to cell registration block", ^{
                expect(capturedCollectionView).to.equal(collectionViewMock);
            });
        });
        
        context(@"when initialized with nil cell registration block", ^{
            beforeEach(^{
                cellPresenter = [[LYRUIListCellPresenter alloc] initWithCellClass:[UICollectionViewCell class]
                                                                               modelClass:[NSObject class]
                                                                        viewPresenter:viewPresenterMock
                                                                               cellHeight:123.0
                                                                           cellSetupBlock:^(UICollectionViewCell *cell, NSObject *item, id viewPresenter) {
                                                                               cellSetupCalled = YES;
                                                                               capturedCell = cell;
                                                                               capturedItem = item;
                                                                               capturedViewPresenter = viewPresenter;
                                                                           } cellRegistrationBlock:nil];
                
                [cellPresenter registerCellInCollectionView:collectionViewMock];
            });
            
            it(@"should register the `UICollectionViewCell` class in collection view for proper reuse identifier", ^{
                [verify(collectionViewMock) registerClass:[UICollectionViewCell class]
                               forCellWithReuseIdentifier:@"UICollectionViewCell"];
            });
        });
    });
});

SpecEnd
