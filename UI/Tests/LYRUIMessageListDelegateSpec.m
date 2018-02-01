#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIMessageListDelegate.h>
#import <LayerXDK/LYRUIListDataSource.h>
#import <LayerXDK/LYRUIListSection.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIMessageListDelegate)

describe(@"LYRUIMessageListDelegate", ^{
    __block LYRUIMessageListDelegate *delegate;
    __block UICollectionView *collectionViewMock;
    __block id<LYRUIListDataSource> dataSourceMock;
    __block LYRUIListLayout *layoutMock;

    beforeEach(^{
        delegate = [[LYRUIMessageListDelegate alloc] init];
        
        collectionViewMock = mock([UICollectionView class]);
        CGRect collectionViewBounds = CGRectMake(0.0, 0.0, 300.0, 400.0);
        [given(collectionViewMock.bounds) willReturnStruct:&collectionViewBounds objCType:@encode(CGRect)];
        
        dataSourceMock = mockProtocol(@protocol(LYRUIListDataSource));
        [given(collectionViewMock.dataSource) willReturn:dataSourceMock];
        
        layoutMock = mock([LYRUIListLayout class]);
    });

    afterEach(^{
        delegate = nil;
        collectionViewMock = nil;
    });

    describe(@"collectionView:layout:insetForSectionAtIndex:", ^{
        __block UIEdgeInsets returnedInsets;
        
        context(@"when there is only one section", ^{
            beforeEach(^{
                [given([dataSourceMock numberOfSectionsInCollectionView:collectionViewMock]) willReturnUnsignedInteger:1];
                
                returnedInsets = [delegate collectionView:collectionViewMock
                                                   layout:layoutMock
                                   insetForSectionAtIndex:0];
            });
            
            it(@"should return {8, 0, 16, 0}", ^{
                expect(returnedInsets).to.equal(UIEdgeInsetsMake(8.0, 0.0, 16.0, 0.0));
            });
        });
        
        context(@"when there are multiple sections", ^{
            beforeEach(^{
                [given([dataSourceMock numberOfSectionsInCollectionView:collectionViewMock]) willReturnUnsignedInteger:3];
            });
            
            context(@"for first section", ^{
                beforeEach(^{
                    returnedInsets = [delegate collectionView:collectionViewMock
                                                       layout:layoutMock
                                       insetForSectionAtIndex:0];
                });
                
                it(@"should return {8, 0, 0, 0}", ^{
                    expect(returnedInsets).to.equal(UIEdgeInsetsMake(8.0, 0.0, 0.0, 0.0));
                });
            });
            
            context(@"for last section", ^{
                beforeEach(^{
                    returnedInsets = [delegate collectionView:collectionViewMock
                                                       layout:layoutMock
                                       insetForSectionAtIndex:2];
                });
                
                it(@"should return {0, 0, 16, 0}", ^{
                    expect(returnedInsets).to.equal(UIEdgeInsetsMake(0.0, 0.0, 16.0, 0.0));
                });
            });
            
            context(@"for middle sections", ^{
                beforeEach(^{
                    returnedInsets = [delegate collectionView:collectionViewMock
                                                       layout:layoutMock
                                       insetForSectionAtIndex:1];
                });
                
                it(@"should return edge insets zero", ^{
                    expect(returnedInsets).to.equal(UIEdgeInsetsZero);
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
