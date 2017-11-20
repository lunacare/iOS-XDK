#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIListQueryControllerDelegate.h>
#import <Atlas/LYRUIListDataSource.h>
#import <Atlas/LYRUIListSection.h>
#import <LayerKit/LayerKit.h>

@interface LYRUIListQueryControllerDelegate (PrivateProperties)

@property (nonatomic, strong) NSArray *itemsSelectedBeforeContentChange;
@property (nonatomic, strong) NSMutableArray *insertedIndexPaths;
@property (nonatomic, strong) NSMutableArray *deletedIndexPaths;
@property (nonatomic, strong) NSMutableArray *updatedIndexPaths;

@end

SpecBegin(LYRUIListQueryControllerDelegate)

describe(@"LYRUIListQueryControllerDelegate", ^{
    __block LYRUIListQueryControllerDelegate *delegate;
    __block id<LYRUIListDataSource> listDataSourceMock;
    __block UICollectionView *collectionViewMock;
    __block LYRQueryController *queryControllerMock;

    beforeEach(^{
        delegate = [[LYRUIListQueryControllerDelegate alloc] init];
        
        listDataSourceMock = mockProtocol(@protocol(LYRUIListDataSource));
        delegate.listDataSource = listDataSourceMock;
        
        collectionViewMock = mock([UICollectionView class]);
        delegate.collectionView = collectionViewMock;
        
        queryControllerMock = mock([LYRQueryController class]);
    });

    afterEach(^{
        delegate = nil;
    });

    describe(@"queryControllerWillChangeContent:", ^{
        __block NSObject *objectMock1;
        __block NSObject *objectMock2;
        
        beforeEach(^{
            NSIndexPath *indexPath1 = [NSIndexPath indexPathForItem:0 inSection:0];
            NSIndexPath *indexPath2 = [NSIndexPath indexPathForItem:3 inSection:0];
            
            objectMock1 = mock([NSObject class]);
            objectMock2 = mock([NSObject class]);
            [given([listDataSourceMock itemAtIndexPath:indexPath1]) willReturn:objectMock1];
            [given([listDataSourceMock itemAtIndexPath:indexPath2]) willReturn:objectMock2];
            
            [given(collectionViewMock.indexPathsForSelectedItems) willReturn:@[
                    indexPath1,
                    indexPath2,
            ]];
            
            [delegate queryControllerWillChangeContent:queryControllerMock];
        });
        
        it(@"should store items selected before content change", ^{
            expect(delegate.itemsSelectedBeforeContentChange).to.equal(@[objectMock1, objectMock2]);
        });
    });
    
    describe(@"queryController:didChangeObject:atIndexPath:forChangeType:newIndexPath:", ^{
        context(@"with `Insert` type", ^{
            beforeEach(^{
                [delegate queryController:queryControllerMock
                          didChangeObject:mock([NSObject class])
                              atIndexPath:nil
                            forChangeType:LYRQueryControllerChangeTypeInsert
                             newIndexPath:[NSIndexPath indexPathForItem:1 inSection:1]];
            });
            
            it(@"should not add any index path to deleted index paths array", ^{
                expect(delegate.deletedIndexPaths).to.haveCount(0);
            });
            it(@"should add new index path to the inserted index paths array", ^{
                expect(delegate.insertedIndexPaths).to.contain([NSIndexPath indexPathForItem:1 inSection:1]);
            });
            it(@"should not add any index path to updated index paths array", ^{
                expect(delegate.updatedIndexPaths).to.haveCount(0);
            });
        });
        
        context(@"with `Delete` type", ^{
            beforeEach(^{
                [delegate queryController:queryControllerMock
                          didChangeObject:mock([NSObject class])
                              atIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]
                            forChangeType:LYRQueryControllerChangeTypeDelete
                             newIndexPath:nil];
            });
            
            it(@"should add index path to the deleted index paths array", ^{
                expect(delegate.deletedIndexPaths).to.contain([NSIndexPath indexPathForItem:0 inSection:1]);
            });
            it(@"should not add any index path to inserted index paths array", ^{
                expect(delegate.insertedIndexPaths).to.haveCount(0);
            });
            it(@"should not add any index path to updated index paths array", ^{
                expect(delegate.updatedIndexPaths).to.haveCount(0);
            });
        });
        
        context(@"with `Move` type", ^{
            beforeEach(^{
                [delegate queryController:queryControllerMock
                          didChangeObject:mock([NSObject class])
                              atIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]
                            forChangeType:LYRQueryControllerChangeTypeMove
                             newIndexPath:[NSIndexPath indexPathForItem:1 inSection:1]];
            });
            
            it(@"should add index path to the deleted index paths array", ^{
                expect(delegate.deletedIndexPaths).to.contain([NSIndexPath indexPathForItem:0 inSection:1]);
            });
            it(@"should add new index path to the inserted index paths array", ^{
                expect(delegate.insertedIndexPaths).to.contain([NSIndexPath indexPathForItem:1 inSection:1]);
            });
            it(@"should not add any index path to updated index paths array", ^{
                expect(delegate.updatedIndexPaths).to.haveCount(0);
            });
        });
        
        context(@"with `Update` type", ^{
            context(@"when object's position did not change", ^{
                beforeEach(^{
                    NSObject<LYRQueryable> *objectMock = mockObjectAndProtocol([NSObject class], @protocol(LYRQueryable));
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
                    
                    [given([queryControllerMock indexPathForObject:objectMock]) willReturn:indexPath];
                    
                    [delegate queryController:queryControllerMock
                              didChangeObject:objectMock
                                  atIndexPath:indexPath
                                forChangeType:LYRQueryControllerChangeTypeUpdate
                                 newIndexPath:nil];
                });
                
                it(@"should not add any index path to deleted index paths array", ^{
                    expect(delegate.deletedIndexPaths).to.haveCount(0);
                });
                it(@"should not add any index path to inserted index paths array", ^{
                    expect(delegate.insertedIndexPaths).to.haveCount(0);
                });
                it(@"should add index path to the updated index paths array", ^{
                    expect(delegate.updatedIndexPaths).to.contain([NSIndexPath indexPathForItem:0 inSection:1]);
                });
            });
            
            context(@"when object's position changed", ^{
                beforeEach(^{
                    NSObject<LYRQueryable> *objectMock = mockObjectAndProtocol([NSObject class], @protocol(LYRQueryable));
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
                    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:1 inSection:1];
                    
                    [given([queryControllerMock indexPathForObject:objectMock]) willReturn:newIndexPath];
                    
                    [delegate queryController:queryControllerMock
                              didChangeObject:objectMock
                                  atIndexPath:indexPath
                                forChangeType:LYRQueryControllerChangeTypeUpdate
                                 newIndexPath:nil];
                });
                
                it(@"should not add any index path to deleted index paths array", ^{
                    expect(delegate.deletedIndexPaths).to.haveCount(0);
                });
                it(@"should not add any index path to inserted index paths array", ^{
                    expect(delegate.insertedIndexPaths).to.haveCount(0);
                });
                it(@"should not add any index path to updated index paths array", ^{
                    expect(delegate.updatedIndexPaths).to.haveCount(0);
                });
            });
        });
    });
    
    describe(@"queryControllerDidChangeContent:", ^{
        __block LYRUIListSection *sectionMock;
        __block NSObject<LYRQueryable> *objectMock1;
        __block NSObject<LYRQueryable> *objectMock2;
        __block NSObject<LYRQueryable> *objectMock3;
        __block NSMutableArray *deletedIndexPathsMock;
        __block NSMutableArray *insertedIndexPathsMock;
        __block NSMutableArray *updatedIndexPathsMock;
        
        beforeEach(^{
            sectionMock = mock([LYRUIListSection class]);
            [given(listDataSourceMock.sections) willReturn:@[sectionMock]];
            
            objectMock1 = mockObjectAndProtocol([NSObject class], @protocol(LYRQueryable));
            objectMock2 = mockObjectAndProtocol([NSObject class], @protocol(LYRQueryable));
            objectMock3 = mockObjectAndProtocol([NSObject class], @protocol(LYRQueryable));
            NSOrderedSet *allObjects = [NSOrderedSet orderedSetWithArray:@[objectMock1, objectMock2]];
            [given(queryControllerMock.allObjects) willReturn:allObjects];
            
            deletedIndexPathsMock = mock([NSMutableArray class]);
            delegate.deletedIndexPaths = deletedIndexPathsMock;
            insertedIndexPathsMock = mock([NSMutableArray class]);
            delegate.insertedIndexPaths = insertedIndexPathsMock;
            updatedIndexPathsMock = mock([NSMutableArray class]);
            delegate.updatedIndexPaths = updatedIndexPathsMock;
            delegate.itemsSelectedBeforeContentChange = @[objectMock1, objectMock2, objectMock3];
            
            [given([queryControllerMock indexPathForObject:objectMock1]) willReturn:[NSIndexPath indexPathForItem:0 inSection:0]];
            [given([queryControllerMock indexPathForObject:objectMock2]) willReturn:[NSIndexPath indexPathForItem:1 inSection:0]];
            [given([queryControllerMock indexPathForObject:objectMock3]) willReturn:nil];
            
            [delegate queryControllerDidChangeContent:queryControllerMock];
        });
        
        it(@"should perform batch updates on collection view", ^{
            [verify(collectionViewMock) performBatchUpdates:anything() completion:nil];
        });
        
        context(@"perform batch updates block", ^{
            beforeEach(^{
                HCArgumentCaptor *batchUpdatesArgument = [HCArgumentCaptor new];
                [verify(collectionViewMock) performBatchUpdates:(id)batchUpdatesArgument completion:nil];
                void(^batchUpdates)() = batchUpdatesArgument.value;
                batchUpdates();
            });
            
            it(@"should update data source objects", ^{
                [verify(sectionMock) setItems:[@[objectMock1, objectMock2] mutableCopy]];
            });
            it(@"should inform collection view about deleted index paths", ^{
                [verify(collectionViewMock) deleteItemsAtIndexPaths:deletedIndexPathsMock];
            });
            it(@"should inform collection view about inserted index paths", ^{
                [verify(collectionViewMock) insertItemsAtIndexPaths:insertedIndexPathsMock];
            });
            it(@"should inform collection view about updated index paths", ^{
                [verify(collectionViewMock) reloadItemsAtIndexPaths:updatedIndexPathsMock];
            });
            it(@"should remove all objects from deleted index paths", ^{
                [verify(deletedIndexPathsMock) removeAllObjects];
            });
            it(@"should remove all objects from inserted index paths", ^{
                [verify(insertedIndexPathsMock) removeAllObjects];
            });
            it(@"should remove all objects from updated index paths", ^{
                [verify(updatedIndexPathsMock) removeAllObjects];
            });
            it(@"should re-select 2 items", ^{
                [verifyCount(collectionViewMock, times(2)) selectItemAtIndexPath:anything()
                                                                        animated:NO
                                                                  scrollPosition:UICollectionViewScrollPositionNone];
            });
            it(@"should re-select objects that were selected before updates", ^{
                [verify(collectionViewMock) selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                                         animated:NO
                                                   scrollPosition:UICollectionViewScrollPositionNone];
                [verify(collectionViewMock) selectItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]
                                                         animated:NO
                                                   scrollPosition:UICollectionViewScrollPositionNone];
            });
        });
    });
});

SpecEnd
