#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIListDataSource.h>
#import <Atlas/LYRUIListSection.h>
#import <Atlas/LYRUIListCellConfiguring.h>
#import <Atlas/LYRUIListSupplementaryViewConfiguring.h>

SpecBegin(LYRUIListDataSource)

describe(@"LYRUIListDataSource", ^{
    __block LYRUIListDataSource *dataSource;
    __block NSObject *configurationMock;

    beforeEach(^{
        dataSource = [[LYRUIListDataSource alloc] init];
        
        configurationMock = mock([NSObject class]);
    });

    afterEach(^{
        dataSource = nil;
    });
    
    describe(@"numberOfSectionsInCollectionView:", ^{
        __block NSUInteger returnedNumber;
        
        beforeEach(^{
            LYRUIListSection *sectionMock1 = mock([LYRUIListSection class]);
            LYRUIListSection *sectionMock2 = mock([LYRUIListSection class]);
            
            dataSource.sections = [@[sectionMock1, sectionMock2] mutableCopy];
            
            returnedNumber = [dataSource numberOfSectionsInCollectionView:mock([UICollectionView class])];
        });
        
        it(@"should return 2", ^{
            expect(returnedNumber).to.equal(2);
        });
    });

    describe(@"collectionView:numberOfItemsInSection:", ^{
        __block NSUInteger returnedNumber;
        
        beforeEach(^{
            LYRUIListSection *sectionMock1 = mock([LYRUIListSection class]);
            NSArray *sectionItemsMock1 = mock([NSArray class]);
            [given(sectionItemsMock1.count) willReturnInteger:2];
            [given(sectionMock1.items) willReturn:sectionItemsMock1];
            
            LYRUIListSection *sectionMock2 = mock([LYRUIListSection class]);
            NSArray *sectionItemsMock2 = mock([NSArray class]);
            [given(sectionItemsMock2.count) willReturnInteger:4];
            [given(sectionMock2.items) willReturn:sectionItemsMock2];
            
            dataSource.sections = [@[sectionMock1, sectionMock2] mutableCopy];
        });
        
        context(@"for first section", ^{
            beforeEach(^{
                returnedNumber = [dataSource collectionView:mock([UICollectionView class]) numberOfItemsInSection:0];
            });
            
            it(@"should return 2", ^{
                expect(returnedNumber).to.equal(2);
            });
        });
        
        context(@"for second section", ^{
            beforeEach(^{
                returnedNumber = [dataSource collectionView:mock([UICollectionView class]) numberOfItemsInSection:1];
            });
            
            it(@"should return 4", ^{
                expect(returnedNumber).to.equal(4);
            });
        });
    });
    
    describe(@"collectionView:cellForItemAtIndexPath:", ^{
        __block UICollectionViewCell *cellMock;
        __block UICollectionViewCell *returnedCell;
        __block UICollectionView *collectionViewMock;
        
        beforeEach(^{
            LYRUIListSection *sectionMock1 = mock([LYRUIListSection class]);
            NSObject *item = [NSObject new];
            [given(sectionMock1.items) willReturn:@[item]];
            dataSource.sections = [@[sectionMock1] mutableCopy];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            
            cellMock = mock([UICollectionViewCell class]);
            
            collectionViewMock = mock([UICollectionView class]);
            [given([collectionViewMock dequeueReusableCellWithReuseIdentifier:@"test reuse identifier"
                                                                 forIndexPath:indexPath])
             willReturn:cellMock];
        });
        
        context(@"when cell configuration for item type was registered", ^{
            __block id<LYRUIListCellConfiguring> cellConfirgurationMock;
            
            beforeEach(^{
                cellConfirgurationMock = mockProtocol(@protocol(LYRUIListCellConfiguring));
                [given(cellConfirgurationMock.handledItemTypes) willReturn:[NSSet setWithObject:[NSObject class]]];
                [given(cellConfirgurationMock.cellReuseIdentifier) willReturn:@"test reuse identifier"];
                [dataSource registerCellConfiguration:cellConfirgurationMock];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                returnedCell = [dataSource collectionView:collectionViewMock cellForItemAtIndexPath:indexPath];
            });
            
            it(@"should return cell dequeued from collection view", ^{
                expect(returnedCell).to.equal(cellMock);
            });
            it(@"should setup dequeued cell using configuration", ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                [verify(cellConfirgurationMock) setupCell:cellMock forItemAtIndexPath:indexPath];
            });
        });
        
        context(@"when there is no configuration registered for item type", ^{
            beforeEach(^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                returnedCell = [dataSource collectionView:collectionViewMock cellForItemAtIndexPath:indexPath];
            });
            
            it(@"should return nil", ^{
                expect(returnedCell).to.beNil();
            });
        });
    });
    
    describe(@"collectionView:viewForSupplementaryElementOfKind:atIndexPath:", ^{
        __block UICollectionReusableView *viewMock;
        __block UIView *returnedView;
        __block UICollectionView *collectionViewMock;
        
        beforeEach(^{
            LYRUIListSection *sectionMock1 = mock([LYRUIListSection class]);
            id<LYRUIListSectionHeader> headerMock = mockProtocol(@protocol(LYRUIListSectionHeader));
            [given(headerMock.title) willReturn:@"test title"];
            [given(sectionMock1.header) willReturn:headerMock];
            dataSource.sections = [@[sectionMock1] mutableCopy];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            
            viewMock = mock([UICollectionReusableView class]);
            
            collectionViewMock = mock([UICollectionView class]);
            [given([collectionViewMock dequeueReusableSupplementaryViewOfKind:@"test kind"
                                                          withReuseIdentifier:@"test reuse identifier"
                                                                 forIndexPath:indexPath])
             willReturn:viewMock];
        });
        
        context(@"when cell configuration for item type was registered", ^{
            __block id<LYRUIListSupplementaryViewConfiguring> supplementaryViewConfirgurationMock;
            
            beforeEach(^{
                supplementaryViewConfirgurationMock = mockProtocol(@protocol(LYRUIListSupplementaryViewConfiguring));
                [given(supplementaryViewConfirgurationMock.viewKind) willReturn:@"test kind"];
                [given(supplementaryViewConfirgurationMock.viewReuseIdentifier) willReturn:@"test reuse identifier"];
                [dataSource registerSupplementaryViewConfiguration:supplementaryViewConfirgurationMock];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                returnedView = [dataSource collectionView:collectionViewMock
                        viewForSupplementaryElementOfKind:@"test kind"
                                              atIndexPath:indexPath];
            });
            
            it(@"should return view dequeued from collection view", ^{
                expect(returnedView).to.equal(viewMock);
            });
            it(@"should setup dequeued view using configuration", ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                [verify(supplementaryViewConfirgurationMock) setupSupplementaryView:viewMock forItemAtIndexPath:indexPath];
            });
        });
        
        context(@"when there is no configuration registered for item type", ^{
            beforeEach(^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                returnedView = [dataSource collectionView:collectionViewMock
                        viewForSupplementaryElementOfKind:@"test kind"
                                              atIndexPath:indexPath];
            });
            
            it(@"should return nil", ^{
                expect(returnedView).to.beNil();
            });
        });
    });
    
    describe(@"selectedItemsInCollectionView:", ^{
        __block NSArray *expectedSelectedItems;
        __block NSArray *returnedSelectedItems;
        
        beforeEach(^{
            LYRUIListSection *sectionMock1 = mock([LYRUIListSection class]);
            NSObject *itemMock1 = mock([NSObject class]);
            NSObject *itemMock2 = mock([NSObject class]);
            NSObject *itemMock3 = mock([NSObject class]);
            NSObject *itemMock4 = mock([NSObject class]);
            [given(sectionMock1.items) willReturn:@[itemMock1, itemMock2, itemMock3, itemMock4]];
            
             LYRUIListSection *sectionMock2 = mock([LYRUIListSection class]);
             NSObject *itemMock5 = mock([NSObject class]);
             NSObject *itemMock6 = mock([NSObject class]);
             NSObject *itemMock7 = mock([NSObject class]);
             NSObject *itemMock8 = mock([NSObject class]);
            [given(sectionMock2.items) willReturn:@[itemMock5, itemMock6, itemMock7, itemMock8]];
            
            dataSource.sections = [@[sectionMock1, sectionMock2] mutableCopy];
            
            expectedSelectedItems = @[itemMock2, itemMock4, itemMock5, itemMock8];
            
            UICollectionView *collectionViewMock = mock([UICollectionView class]);
            [given(collectionViewMock.indexPathsForSelectedItems) willReturn:@[
                    [NSIndexPath indexPathForItem:1 inSection:0],
                    [NSIndexPath indexPathForItem:3 inSection:0],
                    [NSIndexPath indexPathForItem:0 inSection:1],
                    [NSIndexPath indexPathForItem:3 inSection:1],
            ]];
            
            returnedSelectedItems = [dataSource selectedItemsInCollectionView:collectionViewMock];
        });
        
        it(@"should return array of items under index paths for selected cells", ^{
            expect(returnedSelectedItems).to.equal(expectedSelectedItems);
        });
    });
    
    describe(@"itemAtIndexPath:", ^{
        __block NSObject *itemMock;
        __block NSObject *returnedItem;
        
        beforeEach(^{
            itemMock = mock([NSObject class]);
            
            LYRUIListSection *sectionMock1 = mock([LYRUIListSection class]);
            LYRUIListSection *sectionMock2 = mock([LYRUIListSection class]);
            
            NSObject *itemMock1 = mock([NSObject class]);
            NSObject *itemMock2 = mock([NSObject class]);
            NSObject *itemMock3 = mock([NSObject class]);
            NSObject *itemMock4 = mock([NSObject class]);
            [given(sectionMock2.items) willReturn:@[itemMock1, itemMock2, itemMock, itemMock3, itemMock4]];
            
            dataSource.sections = [@[sectionMock1, sectionMock2] mutableCopy];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:1];
            returnedItem = [dataSource itemAtIndexPath:indexPath];
        });
        
        it(@"should return item under provided index paths", ^{
            expect(returnedItem).to.equal(itemMock);
        });
    });
    
    describe(@"indexPathOfItem:", ^{
        __block NSObject *itemMock;
        __block NSIndexPath *returnedIndexPath;
        
        beforeEach(^{
            itemMock = mock([NSObject class]);
            
            LYRUIListSection *sectionMock1 = mock([LYRUIListSection class]);
            LYRUIListSection *sectionMock2 = mock([LYRUIListSection class]);
            
            NSObject *itemMock1 = mock([NSObject class]);
            NSObject *itemMock2 = mock([NSObject class]);
            NSObject *itemMock3 = mock([NSObject class]);
            NSObject *itemMock4 = mock([NSObject class]);
            [given(sectionMock2.items) willReturn:@[itemMock1, itemMock2, itemMock, itemMock3, itemMock4]];
            
            dataSource.sections = [@[sectionMock1, sectionMock2] mutableCopy];
            
            returnedIndexPath = [dataSource indexPathOfItem:itemMock];
        });
        
        it(@"should return index path 1-2", ^{
            NSIndexPath *expectedIndexPath = [NSIndexPath indexPathForItem:2 inSection:1];
            expect(returnedIndexPath).to.equal(expectedIndexPath);
        });
    });
});

SpecEnd
