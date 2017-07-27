#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIListCellConfiguration.h>
#import <Atlas/LYRUIListDataSource.h>

SpecBegin(LYRUIListCellConfiguration)

describe(@"LYRUIListCellConfiguration", ^{
    __block LYRUIListCellConfiguration *cellConfiguration;
    __block id viewConfigurationMock;
    __block BOOL cellSetupCalled;
    __block UICollectionViewCell *capturedCell;
    __block NSObject *capturedItem;
    __block id capturedViewConfiguration;
    __block BOOL cellRegistrationCalled;
    __block UICollectionView *capturedCollectionView;
    __block UICollectionView *collectionViewMock;
    __block NSIndexPath *indexPath;

    beforeEach(^{
        cellSetupCalled = NO;
        cellRegistrationCalled = NO;
        cellConfiguration = [[LYRUIListCellConfiguration alloc] initWithCellClass:[UICollectionViewCell class]
                                                                       modelClass:[NSObject class]
                                                                viewConfiguration:viewConfigurationMock
                                                                       cellHeight:123.0
                                                                   cellSetupBlock:^(UICollectionViewCell *cell, NSObject *item, id viewConfiguration) {
                                                                       cellSetupCalled = YES;
                                                                       capturedCell = cell;
                                                                       capturedItem = item;
                                                                       capturedViewConfiguration = viewConfiguration;
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
        cellConfiguration = nil;
    });

    it(@"should return `NSObject` class as handled item types", ^{
        expect(cellConfiguration.handledItemTypes).to.equal([NSSet setWithObject:[NSObject class]]);
    });
    it(@"should return `UICollectionViewCell` as cell reuse identifier", ^{
        expect(cellConfiguration.cellReuseIdentifier).to.equal(@"UICollectionViewCell");
    });
    it(@"should have view configuration set to provided object", ^{
        expect(cellConfiguration.viewConfiguration).to.equal(viewConfigurationMock);
    });
    
    describe(@"cellSizeInCollectionView:forItemAtIndexPath:", ^{
        __block CGSize returnedSize;
        
        beforeEach(^{
            returnedSize = [cellConfiguration cellSizeInCollectionView:collectionViewMock forItemAtIndexPath:indexPath];
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
            cellConfiguration.listDataSource = dataSourceMock;
            
            [cellConfiguration setupCell:cellMock forItemAtIndexPath:indexPath];
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
        it(@"should pass the view configuration to cell setup block", ^{
            expect(capturedViewConfiguration).to.equal(viewConfigurationMock);
        });
    });
    
    describe(@"registerCellInCollectionView:", ^{
        context(@"when initialized with cell registration block", ^{
            beforeEach(^{
                [cellConfiguration registerCellInCollectionView:collectionViewMock];
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
                cellConfiguration = [[LYRUIListCellConfiguration alloc] initWithCellClass:[UICollectionViewCell class]
                                                                               modelClass:[NSObject class]
                                                                        viewConfiguration:viewConfigurationMock
                                                                               cellHeight:123.0
                                                                           cellSetupBlock:^(UICollectionViewCell *cell, NSObject *item, id viewConfiguration) {
                                                                               cellSetupCalled = YES;
                                                                               capturedCell = cell;
                                                                               capturedItem = item;
                                                                               capturedViewConfiguration = viewConfiguration;
                                                                           } cellRegistrationBlock:nil];
                
                [cellConfiguration registerCellInCollectionView:collectionViewMock];
            });
            
            it(@"should register the `UICollectionViewCell` class in collection view for proper reuse identifier", ^{
                [verify(collectionViewMock) registerClass:[UICollectionViewCell class]
                               forCellWithReuseIdentifier:@"UICollectionViewCell"];
            });
        });
    });
});

SpecEnd
