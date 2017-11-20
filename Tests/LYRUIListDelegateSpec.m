#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIListDelegate.h>
#import <Atlas/LYRUIListCellSizeCalculating.h>
#import <Atlas/LYRUIListSupplementaryViewSizeCalculating.h>
#import <Atlas/LYRUIListDataSource.h>
#import <Atlas/LYRUIListSection.h>
#import <Atlas/LYRUIListLayout.h>

SpecBegin(LYRUIListDelegate)

describe(@"LYRUIListDelegate", ^{
    __block LYRUIListDelegate *delegate;
    __block UICollectionView *collectionViewMock;

    beforeEach(^{
        delegate = [[LYRUIListDelegate alloc] init];
        
        collectionViewMock = mock([UICollectionView class]);
        CGRect collectionViewBounds = CGRectMake(0, 0, 300, 400);
        [given(collectionViewMock.bounds) willReturnStruct:&collectionViewBounds objCType:@encode(CGRect)];
    });

    afterEach(^{
        delegate = nil;
        collectionViewMock = nil;
    });

    describe(@"collectionView:layout:sizeForItemAtIndexPath:", ^{
        __block CGSize returnedSize;
        __block UICollectionViewLayout *layoutMock;
        __block NSIndexPath *indexPath;
        
        beforeEach(^{
            layoutMock = mock([UICollectionViewLayout class]);
            
            indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            
            id<LYRUIListDataSource> dataSourceMock = mockProtocol(@protocol(LYRUIListDataSource));
            NSObject *item = [NSObject new];
            [given([dataSourceMock itemAtIndexPath:indexPath]) willReturn:item];
            [given(collectionViewMock.dataSource) willReturn:dataSourceMock];
        });
        
        context(@"when cell size calculation for item type was registered", ^{
            __block id<LYRUIListCellSizeCalculating> cellSizeCalculationMock;
            
            beforeEach(^{
                cellSizeCalculationMock = mockProtocol(@protocol(LYRUIListCellSizeCalculating));
                [given(cellSizeCalculationMock.handledItemTypes) willReturn:[NSSet setWithObject:[NSObject class]]];
                CGSize cellSize = CGSizeMake(300, 50);
                [given([cellSizeCalculationMock cellSizeInCollectionView:collectionViewMock forItemAtIndexPath:indexPath])
                 willReturnStruct:&cellSize objCType:@encode(CGSize)];
                [delegate registerCellSizeCalculation:cellSizeCalculationMock];
                
                returnedSize = [delegate collectionView:collectionViewMock
                                                 layout:layoutMock
                                 sizeForItemAtIndexPath:indexPath];
            });
            
            it(@"should return size provided by cell size calculation", ^{
                expect(returnedSize).to.equal(CGSizeMake(300, 50));
            });
        });
        
        context(@"when there is no size calculation registered for item type", ^{
            beforeEach(^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                returnedSize = [delegate collectionView:collectionViewMock
                                                 layout:layoutMock
                                 sizeForItemAtIndexPath:indexPath];
            });
            
            it(@"should return size zero", ^{
                expect(returnedSize).to.equal(CGSizeZero);
            });
        });
    });
    
    describe(@"collectionView:layout:referenceSizeForHeaderInSection:", ^{
        __block CGSize returnedSize;
        __block UICollectionViewLayout *layoutMock;
        
        beforeEach(^{
            layoutMock = mock([UICollectionViewLayout class]);
        });
        
        context(@"when supplementary view size calculation for UICollectionElementKindSectionHeader was registered", ^{
            __block id<LYRUIListSupplementaryViewSizeCalculating> supplementaryViewSizeCalculationMock;
            
            beforeEach(^{
                supplementaryViewSizeCalculationMock = mockProtocol(@protocol(LYRUIListSupplementaryViewSizeCalculating));
                [given(supplementaryViewSizeCalculationMock.viewKind) willReturn:UICollectionElementKindSectionHeader];
                CGSize cellSize = CGSizeMake(300, 50);
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                [given([supplementaryViewSizeCalculationMock supplementaryViewSizeInCollectionView:collectionViewMock
                                                                                forItemAtIndexPath:indexPath])
                 willReturnStruct:&cellSize objCType:@encode(CGSize)];
                [delegate registerSupplementaryViewSizeCalculation:supplementaryViewSizeCalculationMock];
                
                returnedSize = [delegate collectionView:collectionViewMock
                                                 layout:layoutMock
                        referenceSizeForHeaderInSection:0];
            });
            
            it(@"should return size provided by supplementary view size calculation", ^{
                expect(returnedSize).to.equal(CGSizeMake(300, 50));
            });
        });
        
        context(@"when there is no size calculation registered for UICollectionElementKindSectionHeader", ^{
            beforeEach(^{
                returnedSize = [delegate collectionView:collectionViewMock
                                                 layout:layoutMock
                        referenceSizeForHeaderInSection:0];
            });
            
            it(@"should return size zero", ^{
                expect(returnedSize).to.equal(CGSizeZero);
            });
        });
    });
    
    describe(@"collectionView:layout:referenceSizeForFooterInSection:", ^{
        __block CGSize returnedSize;
        __block UICollectionViewLayout *layoutMock;
        
        beforeEach(^{
            layoutMock = mock([UICollectionViewLayout class]);
        });
        
        context(@"when supplementary view size calculation for UICollectionElementKindSectionFooter was registered", ^{
            __block id<LYRUIListSupplementaryViewSizeCalculating> supplementaryViewSizeCalculationMock;
            
            beforeEach(^{
                supplementaryViewSizeCalculationMock = mockProtocol(@protocol(LYRUIListSupplementaryViewSizeCalculating));
                [given(supplementaryViewSizeCalculationMock.viewKind) willReturn:UICollectionElementKindSectionFooter];
                CGSize cellSize = CGSizeMake(300, 50);
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                [given([supplementaryViewSizeCalculationMock supplementaryViewSizeInCollectionView:collectionViewMock
                                                                                forItemAtIndexPath:indexPath])
                 willReturnStruct:&cellSize objCType:@encode(CGSize)];
                [delegate registerSupplementaryViewSizeCalculation:supplementaryViewSizeCalculationMock];
                
                returnedSize = [delegate collectionView:collectionViewMock
                                                 layout:layoutMock
                        referenceSizeForFooterInSection:0];
            });
            
            it(@"should return size provided by supplementary view size calculation", ^{
                expect(returnedSize).to.equal(CGSizeMake(300, 50));
            });
        });
        
        context(@"when there is no size calculation registered for UICollectionElementKindSectionFooter", ^{
            beforeEach(^{
                returnedSize = [delegate collectionView:collectionViewMock
                                                 layout:layoutMock
                        referenceSizeForFooterInSection:0];
            });
            
            it(@"should return size zero", ^{
                expect(returnedSize).to.equal(CGSizeZero);
            });
        });
    });
    
    describe(@"collectionView:layout:sizeOfViewOfKind:atIndexPath:", ^{
        __block CGSize returnedSize;
        __block LYRUIListLayout *layoutMock;
        
        beforeEach(^{
            layoutMock = mock([LYRUIListLayout class]);
        });
        
        context(@"when supplementary view size calculation for view kind was registered", ^{
            __block id<LYRUIListSupplementaryViewSizeCalculating> supplementaryViewSizeCalculationMock;
            
            beforeEach(^{
                supplementaryViewSizeCalculationMock = mockProtocol(@protocol(LYRUIListSupplementaryViewSizeCalculating));
                [given(supplementaryViewSizeCalculationMock.viewKind) willReturn:@"test view kind"];
                CGSize cellSize = CGSizeMake(300, 50);
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                [given([supplementaryViewSizeCalculationMock supplementaryViewSizeInCollectionView:collectionViewMock
                                                                                forItemAtIndexPath:indexPath])
                 willReturnStruct:&cellSize objCType:@encode(CGSize)];
                [delegate registerSupplementaryViewSizeCalculation:supplementaryViewSizeCalculationMock];
                
                returnedSize = [delegate collectionView:collectionViewMock
                                                 layout:layoutMock
                                       sizeOfViewOfKind:@"test view kind"
                                            atIndexPath:indexPath];
            });
            
            it(@"should return size provided by supplementary view size calculation", ^{
                expect(returnedSize).to.equal(CGSizeMake(300, 50));
            });
        });
        
        context(@"when there is no size calculation registered for view kind", ^{
            beforeEach(^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                returnedSize = [delegate collectionView:collectionViewMock
                                                 layout:layoutMock
                                       sizeOfViewOfKind:@"test view kind"
                                            atIndexPath:indexPath];
            });
            
            it(@"should return size zero", ^{
                expect(returnedSize).to.equal(CGSizeZero);
            });
        });
    });
    
    describe(@"invalidateAllSupplementaryViewSizes", ^{
        __block id<LYRUIListSupplementaryViewSizeCalculating> sizeCalculation1;
        __block id<LYRUIListSupplementaryViewSizeCalculating> sizeCalculation2;
        __block id<LYRUIListSupplementaryViewSizeCalculating> sizeCalculation3;
        
        beforeEach(^{
            sizeCalculation1 = mockProtocol(@protocol(LYRUIListSupplementaryViewSizeCalculating));
            [given(sizeCalculation1.viewKind) willReturn:UICollectionElementKindSectionHeader];
            sizeCalculation2 = mockProtocol(@protocol(LYRUIListSupplementaryViewSizeCalculating));
            [given(sizeCalculation2.viewKind) willReturn:@"test size calculation"];
            sizeCalculation3 = mockProtocol(@protocol(LYRUIListSupplementaryViewSizeCalculating));
            [given(sizeCalculation3.viewKind) willReturn:UICollectionElementKindSectionFooter];
            
            [delegate registerSupplementaryViewSizeCalculation:sizeCalculation1];
            [delegate registerSupplementaryViewSizeCalculation:sizeCalculation2];
            [delegate registerSupplementaryViewSizeCalculation:sizeCalculation3];

            [delegate invalidateAllSupplementaryViewSizes];
        });
        
        it(@"should invalidate header size calculation", ^{
            [verify(sizeCalculation1) invalidateAllSupplementaryViewSizes];
        });
        it(@"should invalidate supplementary view size calculation", ^{
            [verify(sizeCalculation2) invalidateAllSupplementaryViewSizes];
        });
        it(@"should invalidate footer size calculation", ^{
            [verify(sizeCalculation3) invalidateAllSupplementaryViewSizes];
        });
    });
    
    describe(@"collectionView:didSelectItemAtIndexPath:", ^{
        __block BOOL indexPathSelectedCalled;
        __block NSIndexPath *capturedIndexPath;
        
        beforeEach(^{
            indexPathSelectedCalled = NO;
            delegate.indexPathSelected = ^(NSIndexPath *indexPath) {
                indexPathSelectedCalled = YES;
                capturedIndexPath = indexPath;
            };
            
            UICollectionView *collectionViewMock = mock([UICollectionView class]);
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:2];
            [delegate collectionView:collectionViewMock didSelectItemAtIndexPath:indexPath];
        });
        
        it(@"should call the block", ^{
            expect(indexPathSelectedCalled).to.beTruthy();
        });
        it(@"should call the block with proper index path", ^{
            expect(capturedIndexPath).to.equal([NSIndexPath indexPathForItem:1 inSection:2]);
        });
    });
    
    describe(@"UIScrollViewDelegate", ^{
        __block id<LYRUIListLoadingMoreDelegate> loadMoreDelegateMock;
        __block UIScrollView *scrollViewMock;
        __block BOOL loadMoreItemsCalled;
        
        beforeEach(^{
            loadMoreDelegateMock = mockProtocol(@protocol(LYRUIListLoadingMoreDelegate));
            delegate.loadingDelegate = loadMoreDelegateMock;
            
            scrollViewMock = mock([UIScrollView class]);
            
            loadMoreItemsCalled = NO;
            delegate.loadMoreItems = ^{
                loadMoreItemsCalled = YES;
            };
        });
        
        describe(@"scrollViewDidEndDragging:willDecelerate:", ^{
            context(@"when can load more items", ^{
                beforeEach(^{
                    delegate.canLoadMoreItems = YES;
                });
                
                context(@"and should try to load more items", ^{
                    beforeEach(^{
                        [given([loadMoreDelegateMock shouldLoadMoreItemsWithScrollView:scrollViewMock]) willReturnBool:YES];
                        
                        [delegate scrollViewDidEndDragging:scrollViewMock willDecelerate:YES];
                    });
                    
                    it(@"should load more items", ^{
                        expect(loadMoreItemsCalled).to.beTruthy();
                    });
                });
                
                context(@"and should not try to load more items", ^{
                    beforeEach(^{
                        [given([loadMoreDelegateMock shouldLoadMoreItemsWithScrollView:scrollViewMock]) willReturnBool:NO];
                        
                        [delegate scrollViewDidEndDragging:scrollViewMock willDecelerate:YES];
                    });
                    
                    it(@"should not load more items", ^{
                        expect(loadMoreItemsCalled).to.beFalsy();
                    });
                });
            });
            
            context(@"when can't load more items", ^{
                beforeEach(^{
                    delegate.canLoadMoreItems = NO;
                });
                
                context(@"and should try to load more items", ^{
                    beforeEach(^{
                        [given([loadMoreDelegateMock shouldLoadMoreItemsWithScrollView:scrollViewMock]) willReturnBool:YES];
                        
                        [delegate scrollViewDidEndDragging:scrollViewMock willDecelerate:YES];
                    });
                    
                    it(@"should not load more items", ^{
                        expect(loadMoreItemsCalled).to.beFalsy();
                    });
                });
                
                context(@"and should not try to load more items", ^{
                    beforeEach(^{
                        [given([loadMoreDelegateMock shouldLoadMoreItemsWithScrollView:scrollViewMock]) willReturnBool:NO];
                        
                        [delegate scrollViewDidEndDragging:scrollViewMock willDecelerate:YES];
                    });
                    
                    it(@"should not load more items", ^{
                        expect(loadMoreItemsCalled).to.beFalsy();
                    });
                });
            });
        });
        
        describe(@"scrollViewDidEndDecelerating:", ^{
            context(@"when can load more items", ^{
                beforeEach(^{
                    delegate.canLoadMoreItems = YES;
                });
                
                context(@"and should try to load more items", ^{
                    beforeEach(^{
                        [given([loadMoreDelegateMock shouldLoadMoreItemsWithScrollView:scrollViewMock]) willReturnBool:YES];
                        
                        [delegate scrollViewDidEndDecelerating:scrollViewMock];
                    });
                    
                    it(@"should load more items", ^{
                        expect(loadMoreItemsCalled).to.beTruthy();
                    });
                });
                
                context(@"and should not try to load more items", ^{
                    beforeEach(^{
                        [given([loadMoreDelegateMock shouldLoadMoreItemsWithScrollView:scrollViewMock]) willReturnBool:NO];
                        
                        [delegate scrollViewDidEndDecelerating:scrollViewMock];
                    });
                    
                    it(@"should not load more items", ^{
                        expect(loadMoreItemsCalled).to.beFalsy();
                    });
                });
            });
            
            context(@"when can't load more items", ^{
                beforeEach(^{
                    delegate.canLoadMoreItems = NO;
                });
                
                context(@"and should try to load more items", ^{
                    beforeEach(^{
                        [given([loadMoreDelegateMock shouldLoadMoreItemsWithScrollView:scrollViewMock]) willReturnBool:YES];
                        
                        [delegate scrollViewDidEndDecelerating:scrollViewMock];
                    });
                    
                    it(@"should not load more items", ^{
                        expect(loadMoreItemsCalled).to.beFalsy();
                    });
                });
                
                context(@"and should not try to load more items", ^{
                    beforeEach(^{
                        [given([loadMoreDelegateMock shouldLoadMoreItemsWithScrollView:scrollViewMock]) willReturnBool:NO];
                        
                        [delegate scrollViewDidEndDecelerating:scrollViewMock];
                    });
                    
                    it(@"should not load more items", ^{
                        expect(loadMoreItemsCalled).to.beFalsy();
                    });
                });
            });
        });
        
        describe(@"scrollViewDidScrollToTop:", ^{
            context(@"when can load more items", ^{
                beforeEach(^{
                    delegate.canLoadMoreItems = YES;
                });
                
                context(@"and should try to load more items", ^{
                    beforeEach(^{
                        [given([loadMoreDelegateMock shouldLoadMoreItemsWithScrollView:scrollViewMock]) willReturnBool:YES];
                        
                        [delegate scrollViewDidScrollToTop:scrollViewMock];
                    });
                    
                    it(@"should load more items", ^{
                        expect(loadMoreItemsCalled).to.beTruthy();
                    });
                });
                
                context(@"and should not try to load more items", ^{
                    beforeEach(^{
                        [given([loadMoreDelegateMock shouldLoadMoreItemsWithScrollView:scrollViewMock]) willReturnBool:NO];
                        
                        [delegate scrollViewDidScrollToTop:scrollViewMock];
                    });
                    
                    it(@"should not load more items", ^{
                        expect(loadMoreItemsCalled).to.beFalsy();
                    });
                });
            });
            
            context(@"when can't load more items", ^{
                beforeEach(^{
                    delegate.canLoadMoreItems = NO;
                });
                
                context(@"and should try to load more items", ^{
                    beforeEach(^{
                        [given([loadMoreDelegateMock shouldLoadMoreItemsWithScrollView:scrollViewMock]) willReturnBool:YES];
                        
                        [delegate scrollViewDidScrollToTop:scrollViewMock];
                    });
                    
                    it(@"should not load more items", ^{
                        expect(loadMoreItemsCalled).to.beFalsy();
                    });
                });
                
                context(@"and should not try to load more items", ^{
                    beforeEach(^{
                        [given([loadMoreDelegateMock shouldLoadMoreItemsWithScrollView:scrollViewMock]) willReturnBool:NO];
                        
                        [delegate scrollViewDidScrollToTop:scrollViewMock];
                    });
                    
                    it(@"should not load more items", ^{
                        expect(loadMoreItemsCalled).to.beFalsy();
                    });
                });
            });
        });
    });
    
    describe(@"collectionView:didSelectItemAtIndexPath:", ^{
        __block BOOL indexPathSelectedCalled;
        __block NSIndexPath *capturedIndexPath;
        
        beforeEach(^{
            indexPathSelectedCalled = NO;
            delegate.indexPathSelected = ^(NSIndexPath *indexPath) {
                indexPathSelectedCalled = YES;
                capturedIndexPath = indexPath;
            };
            
            UICollectionView *collectionViewMock = mock([UICollectionView class]);
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:2];
            [delegate collectionView:collectionViewMock didSelectItemAtIndexPath:indexPath];
        });
        
        it(@"should call the block", ^{
            expect(indexPathSelectedCalled).to.beTruthy();
        });
        it(@"should call the block with proper index path", ^{
            expect(capturedIndexPath).to.equal([NSIndexPath indexPathForItem:1 inSection:2]);
        });
    });
});

SpecEnd
