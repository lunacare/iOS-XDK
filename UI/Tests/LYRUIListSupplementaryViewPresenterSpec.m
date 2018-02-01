#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIListSupplementaryViewPresenter.h>
#import <LayerXDK/LYRUIListDataSource.h>

SpecBegin(LYRUIListSupplementaryViewPresenter)

describe(@"LYRUIListSupplementaryViewPresenter", ^{
    __block LYRUIListSupplementaryViewPresenter *viewPresenter;
    __block BOOL viewSetupCalled;
    __block UICollectionViewCell *capturedView;
    __block id<LYRUIListDataSource> capturedDataSource;
    __block NSIndexPath *capturedIndexPath;
    __block BOOL viewVisibilityCalled;
    __block BOOL viewVisibilityReturnValue;
    __block BOOL viewRegistrationCalled;
    __block UICollectionView *capturedCollectionView;
    __block UICollectionView *collectionViewMock;
    __block NSIndexPath *indexPath;

    beforeEach(^{
        viewSetupCalled = NO;
        viewVisibilityCalled = NO;
        viewRegistrationCalled = NO;
        
        viewPresenter = [[LYRUIListSupplementaryViewPresenter alloc] initWithSupplementaryViewClass:[UICollectionReusableView class]
                                                                                                       kind:@"test kind"
                                                                                            reuseIdentifier:@"test reuse identifier"
                                                                                    supplementaryViewHeight:123.0
                                                                           supplementaryViewVisibilityBlock:^BOOL(id<LYRUIListDataSource> dataSource, NSIndexPath *indexPath) {
                                                                               viewVisibilityCalled = YES;
                                                                               capturedDataSource = dataSource;
                                                                               capturedIndexPath = indexPath;
                                                                               return viewVisibilityReturnValue;
                                                                           }
                                                                                supplementaryViewSetupBlock:^(id view, id<LYRUIListDataSource> dataSource, NSIndexPath *indexPath) {
                                                                                    viewSetupCalled = YES;
                                                                                    capturedView = view;
                                                                                    capturedDataSource = dataSource;
                                                                                    capturedIndexPath = indexPath;
                                                                                }
                                                                         supplementaryViewRegistrationBlock:^(UICollectionView *collectionView) {
                                                                             viewRegistrationCalled = YES;
                                                                             capturedCollectionView = collectionView;
                                                                         }];
        
        collectionViewMock = mock([UICollectionView class]);
        CGRect collectionViewBounds = CGRectMake(0, 0, 300, 400);
        [given(collectionViewMock.bounds) willReturnStruct:&collectionViewBounds objCType:@encode(CGRect)];
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    });

    afterEach(^{
        viewPresenter = nil;
    });

    
    it(@"should return `test kind` as handled view kind", ^{
        expect(viewPresenter.viewKind).to.equal(@"test kind");
    });
    it(@"should return `test reuse identifier` as view reuse identifier", ^{
        expect(viewPresenter.viewReuseIdentifier).to.equal(@"test reuse identifier");
    });
    
    
    describe(@"supplementaryViewSizeInCollectionView:forItemAtIndexPath:", ^{
        __block CGSize returnedSize;
        
        context(@"when view should be visible", ^{
            beforeEach(^{
                viewVisibilityReturnValue = YES;
                
                returnedSize = [viewPresenter supplementaryViewSizeInCollectionView:collectionViewMock forItemAtIndexPath:indexPath];
            });
            
            it(@"should return proper cell size", ^{
                expect(returnedSize).to.equal(CGSizeMake(300.0, 123.0));
            });
        });
        
        context(@"when view should not be visible", ^{
            beforeEach(^{
                viewVisibilityReturnValue = NO;
                
                returnedSize = [viewPresenter supplementaryViewSizeInCollectionView:collectionViewMock forItemAtIndexPath:indexPath];
            });
            
            it(@"should return size zero", ^{
                expect(returnedSize).to.equal(CGSizeZero);
            });
        });
    });
    
    describe(@"setupSupplementaryView:forItemAtIndexPath:", ^{
        __block UICollectionReusableView *viewMock;
        __block id<LYRUIListDataSource> dataSourceMock;
        __block NSObject *item;
        
        beforeEach(^{
            viewMock = mock([UICollectionReusableView class]);
            
            dataSourceMock = mockProtocol(@protocol(LYRUIListDataSource));
            item = [[NSObject alloc] init];
            [given([dataSourceMock itemAtIndexPath:indexPath]) willReturn:item];
            viewPresenter.listDataSource = dataSourceMock;
            
            [viewPresenter setupSupplementaryView:viewMock forItemAtIndexPath:indexPath];
        });
        
        it(@"should call view setup block", ^{
            expect(viewSetupCalled).to.beTruthy();
        });
        it(@"should pass the view to view setup block", ^{
            expect(capturedView).to.equal(viewMock);
        });
        it(@"should pass the data source to view setup block", ^{
            expect(capturedDataSource).to.equal(dataSourceMock);
        });
        it(@"should pass the index path to view setup block", ^{
            expect(capturedIndexPath).to.equal(indexPath);
        });
    });
    
    describe(@"registerSupplementaryViewInCollectionView:", ^{
        context(@"when initialized with view registration block", ^{
            beforeEach(^{
                [viewPresenter registerSupplementaryViewInCollectionView:collectionViewMock];
            });
            
            it(@"should call view registration block", ^{
                expect(viewRegistrationCalled).to.beTruthy();
            });
            it(@"should pass collection view to view registration block", ^{
                expect(capturedCollectionView).to.equal(collectionViewMock);
            });
        });
        
        context(@"when initialized with nil cell registration block", ^{
            beforeEach(^{
                viewPresenter = [[LYRUIListSupplementaryViewPresenter alloc] initWithSupplementaryViewClass:[UICollectionReusableView class]
                                                                                                               kind:@"test kind"
                                                                                                    reuseIdentifier:@"test reuse identifier"
                                                                                            supplementaryViewHeight:123.0
                                                                                   supplementaryViewVisibilityBlock:^BOOL(id<LYRUIListDataSource> dataSource, NSIndexPath *indexPath) {
                                                                                       return viewVisibilityReturnValue;
                                                                                   }
                                                                                        supplementaryViewSetupBlock:^(id view, id<LYRUIListDataSource> dataSource, NSIndexPath *indexPath) {}
                                                                                 supplementaryViewRegistrationBlock:nil];
                
                [viewPresenter registerSupplementaryViewInCollectionView:collectionViewMock];
            });
            
            it(@"should register the `UICollectionReusableView` class in collection view for proper kind and reuse identifier", ^{
                [verify(collectionViewMock) registerClass:[UICollectionReusableView class]
                               forSupplementaryViewOfKind:@"test kind"
                                      withReuseIdentifier:@"test reuse identifier"];
            });
        });
    });
});

SpecEnd
