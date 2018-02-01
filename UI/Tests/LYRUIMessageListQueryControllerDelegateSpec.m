#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIConfiguration+DependencyInjection.h>
#import <LayerXDK/LYRUIMessageListQueryControllerDelegate.h>
#import <LayerXDK/LYRUIListDataSource.h>
#import <LayerXDK/LYRUIListSection.h>
#import <LayerKit/LayerKit.h>
#import <LayerXDK/LYRUIMessageType.h>
#import <LayerXDK/LYRUIMessageSerializer.h>

@interface LYRUIMessageListQueryControllerDelegate (PrivateProperties)

@property (nonatomic, strong) NSArray *itemsSelectedBeforeContentChange;
@property (nonatomic, strong) NSMutableArray *insertedIndexPaths;
@property (nonatomic, strong) NSMutableArray *adjacentToInsertedIndexPaths;
@property (nonatomic, strong) NSMutableArray *deletedIndexPaths;
@property (nonatomic, strong) NSMutableArray *updatedIndexPaths;

@end

SpecBegin(LYRUIMessageListQueryControllerDelegate)

describe(@"LYRUIMessageListQueryControllerDelegate", ^{
    __block LYRUIMessageListQueryControllerDelegate *delegate;
    __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
    __block id<LYRUIListDataSource> listDataSourceMock;
    __block UICollectionView *collectionViewMock;
    __block LYRQueryController *queryControllerMock;
    __block LYRUIMessageSerializer *messageSerializerMock;

    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
        
        messageSerializerMock = mock([LYRUIMessageSerializer class]);
        [given([injectorMock objectOfType:[LYRUIMessageSerializer class]]) willReturn:messageSerializerMock];
        
        delegate = [[LYRUIMessageListQueryControllerDelegate alloc] initWithConfiguration:configurationMock];
        
        listDataSourceMock = mockProtocol(@protocol(LYRUIListDataSource));
        delegate.listDataSource = listDataSourceMock;
        
        collectionViewMock = mock([UICollectionView class]);
        delegate.collectionView = collectionViewMock;
        
        queryControllerMock = mock([LYRQueryController class]);
    });

    afterEach(^{
        delegate = nil;
    });
    
    describe(@"queryController:didChangeObject:atIndexPath:forChangeType:newIndexPath:", ^{
        context(@"with `Insert` type", ^{
            beforeEach(^{
                [given(queryControllerMock.count) willReturnUnsignedInteger:3];
            });
            
            context(@"when index path is index path of first item", ^{
                beforeEach(^{
                    [delegate queryController:queryControllerMock
                              didChangeObject:mock([NSObject class])
                                  atIndexPath:nil
                                forChangeType:LYRQueryControllerChangeTypeInsert
                                 newIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
                });
                
                it(@"should not add any index path to deleted index paths array", ^{
                    expect(delegate.deletedIndexPaths).to.haveCount(0);
                });
                it(@"should add new index path to the inserted index paths array", ^{
                    expect(delegate.insertedIndexPaths).to.contain([NSIndexPath indexPathForItem:0 inSection:1]);
                });
                it(@"should add one index path to adjacent to inserted index paths array", ^{
                    expect(delegate.adjacentToInsertedIndexPaths).to.haveCount(1);
                });
                it(@"should add next index path to the adjacent to inserted index paths array", ^{
                    expect(delegate.adjacentToInsertedIndexPaths).to.contain([NSIndexPath indexPathForItem:1 inSection:1]);
                });
                it(@"should not add any index path to updated index paths array", ^{
                    expect(delegate.updatedIndexPaths).to.haveCount(0);
                });
            });
            
            context(@"when index path is index path of middle item", ^{
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
                it(@"should add two index paths to adjacent to inserted index paths array", ^{
                    expect(delegate.adjacentToInsertedIndexPaths).to.haveCount(2);
                });
                it(@"should add previous index path to the adjacent to inserted index paths array", ^{
                    expect(delegate.adjacentToInsertedIndexPaths).to.contain([NSIndexPath indexPathForItem:0 inSection:1]);
                });
                it(@"should add next index path to the adjacent to inserted index paths array", ^{
                    expect(delegate.adjacentToInsertedIndexPaths).to.contain([NSIndexPath indexPathForItem:2 inSection:1]);
                });
                it(@"should not add any index path to updated index paths array", ^{
                    expect(delegate.updatedIndexPaths).to.haveCount(0);
                });
            });
            
            context(@"when index path is index path of last item", ^{
                beforeEach(^{
                    [delegate queryController:queryControllerMock
                              didChangeObject:mock([NSObject class])
                                  atIndexPath:nil
                                forChangeType:LYRQueryControllerChangeTypeInsert
                                 newIndexPath:[NSIndexPath indexPathForItem:2 inSection:1]];
                });
                
                it(@"should not add any index path to deleted index paths array", ^{
                    expect(delegate.deletedIndexPaths).to.haveCount(0);
                });
                it(@"should add new index path to the inserted index paths array", ^{
                    expect(delegate.insertedIndexPaths).to.contain([NSIndexPath indexPathForItem:2 inSection:1]);
                });
                it(@"should add one index path to adjacent to inserted index paths array", ^{
                    expect(delegate.adjacentToInsertedIndexPaths).to.haveCount(1);
                });
                it(@"should add previous index path to the adjacent to inserted index paths array", ^{
                    expect(delegate.adjacentToInsertedIndexPaths).to.contain([NSIndexPath indexPathForItem:1 inSection:1]);
                });
                it(@"should not add any index path to updated index paths array", ^{
                    expect(delegate.updatedIndexPaths).to.haveCount(0);
                });
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
            it(@"should not add any index path to adjacent to inserted index paths array", ^{
                expect(delegate.adjacentToInsertedIndexPaths).to.haveCount(0);
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
            it(@"should not add any index path to adjacent to inserted index paths array", ^{
                expect(delegate.adjacentToInsertedIndexPaths).to.haveCount(0);
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
                it(@"should not add any index path to adjacent to inserted index paths array", ^{
                    expect(delegate.adjacentToInsertedIndexPaths).to.haveCount(0);
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
        __block NSMutableArray *deletedIndexPaths;
        __block NSMutableArray *insertedIndexPaths;
        __block NSMutableArray *adjacentToInsertedIndexPaths;
        __block NSMutableArray *updatedIndexPaths;
        __block LYRUIMessageType *messageMock1;
        __block LYRUIMessageType *messageMock2;
        __block LYRUIMessageType *messageMock3;
        
        beforeEach(^{
            sectionMock = mock([LYRUIListSection class]);
            [given(listDataSourceMock.sections) willReturn:@[sectionMock]];
            
            objectMock1 = mockObjectAndProtocol([NSObject class], @protocol(LYRQueryable));
            objectMock2 = mockObjectAndProtocol([NSObject class], @protocol(LYRQueryable));
            objectMock3 = mockObjectAndProtocol([NSObject class], @protocol(LYRQueryable));
            NSOrderedSet *allObjects = [NSOrderedSet orderedSetWithArray:@[objectMock1, objectMock2]];
            [given(queryControllerMock.paginatedObjects) willReturn:allObjects];
            
            deletedIndexPaths = [@[[NSIndexPath indexPathForItem:5 inSection:0]] mutableCopy];
            delegate.deletedIndexPaths = deletedIndexPaths;
            insertedIndexPaths = [@[
                    [NSIndexPath indexPathForItem:0 inSection:0],
                    [NSIndexPath indexPathForItem:1 inSection:0],
            ] mutableCopy];
            delegate.insertedIndexPaths = insertedIndexPaths;
            adjacentToInsertedIndexPaths = [@[
                    [NSIndexPath indexPathForItem:0 inSection:0],
                    [NSIndexPath indexPathForItem:1 inSection:0],
                    [NSIndexPath indexPathForItem:2 inSection:0],
            ] mutableCopy];
            delegate.adjacentToInsertedIndexPaths = adjacentToInsertedIndexPaths;
            updatedIndexPaths = [@[[NSIndexPath indexPathForItem:4 inSection:0]] mutableCopy];
            delegate.updatedIndexPaths = updatedIndexPaths;
            
            [given([queryControllerMock objectAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]]) willReturn:objectMock1];
            [given([queryControllerMock indexPathForObject:objectMock1]) willReturn:[NSIndexPath indexPathForItem:0 inSection:0]];
            [given([queryControllerMock indexPathForObject:objectMock2]) willReturn:[NSIndexPath indexPathForItem:1 inSection:0]];
            [given([queryControllerMock indexPathForObject:objectMock3]) willReturn:nil];
            
            [given([listDataSourceMock indexPathOfItem:objectMock1]) willReturn:[NSIndexPath indexPathForItem:0 inSection:0]];
            
            messageMock1 = mock([LYRUIMessageType class]);
            [given([messageSerializerMock typedMessageWithLayerMessage:(LYRMessage *)objectMock1]) willReturn:messageMock1];
            messageMock2 = mock([LYRUIMessageType class]);
            [given([messageSerializerMock typedMessageWithLayerMessage:(LYRMessage *)objectMock2]) willReturn:messageMock2];
            messageMock3 = mock([LYRUIMessageType class]);
            [given([messageSerializerMock typedMessageWithLayerMessage:(LYRMessage *)objectMock3]) willReturn:messageMock3];
            
            [delegate queryControllerDidChangeContent:queryControllerMock];
        });
        
        it(@"should add unique index paths from adjacent to inserted indes paths to the deleted index paths", ^{
            NSArray *expectedDeletedIndexPaths = [@[
                                                    [NSIndexPath indexPathForItem:5 inSection:0],
                                                    [NSIndexPath indexPathForItem:0 inSection:0],
                                                    ] mutableCopy];
            expect(deletedIndexPaths).to.equal(expectedDeletedIndexPaths);
        });
        it(@"should add unique index paths from adjacent to inserted indes paths to the inserted index paths", ^{
            NSArray *expectedInsertedIndexPaths = [@[
                                                     [NSIndexPath indexPathForItem:0 inSection:0],
                                                     [NSIndexPath indexPathForItem:1 inSection:0],
                                                     [NSIndexPath indexPathForItem:2 inSection:0],
                                                     ] mutableCopy];
            expect(insertedIndexPaths).to.equal(expectedInsertedIndexPaths);
        });
        it(@"should perform batch updates on collection view", ^{
            [verify(collectionViewMock) performBatchUpdates:anything() completion:anything()];
        });
        
        context(@"perform batch updates block", ^{
            __block UICollectionViewLayout *collectionViewLayoutMock;
            
            beforeEach(^{
                collectionViewLayoutMock = mock([UICollectionViewLayout class]);
                [given(collectionViewMock.collectionViewLayout) willReturn:collectionViewLayoutMock];
                
                HCArgumentCaptor *batchUpdatesArgument = [HCArgumentCaptor new];
                [verify(collectionViewMock) performBatchUpdates:(id)batchUpdatesArgument completion:anything()];
                void(^batchUpdates)() = batchUpdatesArgument.value;
                batchUpdates();
            });
            
            it(@"should update data source objects", ^{
                [verify(sectionMock) setItems:[@[messageMock1, messageMock2] mutableCopy]];
            });
            it(@"should inform collection view about deleted index paths", ^{
                [verify(collectionViewMock) deleteItemsAtIndexPaths:deletedIndexPaths];
            });
            it(@"should inform collection view about inserted index paths", ^{
                [verify(collectionViewMock) insertItemsAtIndexPaths:insertedIndexPaths];
            });
            it(@"should inform collection view about updated index paths", ^{
                [verify(collectionViewMock) reloadItemsAtIndexPaths:updatedIndexPaths];
            });
            it(@"should invalidate layout", ^{
                [verify(collectionViewLayoutMock) invalidateLayout];
            });
            it(@"should remove all objects from deleted index paths", ^{
                expect(deletedIndexPaths).to.haveCount(0);
            });
            it(@"should remove all objects from inserted index paths", ^{
                expect(insertedIndexPaths).to.haveCount(0);
            });
            it(@"should remove all objects from adjacent to inserted index paths", ^{
                expect(adjacentToInsertedIndexPaths).to.haveCount(0);
            });
            it(@"should remove all objects from updated index paths", ^{
                expect(updatedIndexPaths).to.haveCount(0);
            });
        });
        
        context(@"perform batch updates completion block", ^{
            beforeEach(^{
                HCArgumentCaptor *completionArgument = [HCArgumentCaptor new];
                [verify(collectionViewMock) performBatchUpdates:anything() completion:(id)completionArgument];
                void(^completion)(BOOL) = completionArgument.value;
                completion(YES);
            });
        });
    });
});

SpecEnd
