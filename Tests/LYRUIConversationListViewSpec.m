#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIConversationListView.h>
#import <Atlas/LYRUIConversationItemViewConfiguration.h>
#import <Atlas/LYRUIListLayout.h>
#import <Atlas/LYRUIListDataSource.h>
#import <Atlas/LYRUIListDelegate.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIConversationListView)

describe(@"LYRUIConversationListView", ^{
    __block LYRUIConversationListView *view;
    __block UICollectionViewLayout<LYRUIListViewLayout> *layoutMock;
    __block id<LYRUIListDelegate> delegateMock;
    __block id<LYRUIListDataSource> dataSourceMock;

    beforeEach(^{
        view = [[LYRUIConversationListView alloc] init];
        
        LYRUIListLayout *layout = [[LYRUIListLayout alloc] init];
        layoutMock = OCMPartialMock(layout);
        [[OCMStub([layoutMock copyWithZone:NSDefaultMallocZone()]) andReturn:layoutMock] ignoringNonObjectArgs];
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
        it(@"should have the collection view added as subview", ^{
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
            
            it(@"should update data source sections array with mutable copy of passed array", ^{
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
            it(@"should setup delegates `indexPathSelected` block", ^{
                [verify(delegateMock) setIndexPathSelected:anything()];
            });
            it(@"should setup delgate `loadMoreItems` block", ^{
                [verify(delegateMock) setLoadMoreItems:anything()];
            });
            
            context(@"`indexPathSelected` block", ^{
                __block void(^indexPathSelectedBlock)(NSIndexPath *);
                __block LYRConversation *conversationMock;
                __block BOOL itemSelectedCalled;
                __block LYRConversation *capturedConversation;
                
                beforeEach(^{
                    conversationMock = mock([LYRConversation class]);
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:2];
                    [given([dataSourceMock itemAtIndexPath:indexPath]) willReturn:conversationMock];
                    view.dataSource = dataSourceMock;
                    
                    itemSelectedCalled = NO;
                    view.itemSelected = ^(LYRConversation *conversation) {
                        itemSelectedCalled = YES;
                        capturedConversation = conversation;
                    };
                    
                    HCArgumentCaptor *blockArgument = [HCArgumentCaptor new];
                    [verify(delegateMock) setIndexPathSelected:(id)blockArgument];
                    indexPathSelectedBlock = blockArgument.value;
                    
                    indexPathSelectedBlock(indexPath);
                });
                
                it(@"should call item selected callback", ^{
                    expect(itemSelectedCalled).to.beTruthy();
                });
                it(@"should call item selected callback with conversation at provided index path, taken from data source", ^{
                    expect(capturedConversation).to.equal(conversationMock);
                });
            });
            
            context(@"`loadMoreItems` block", ^{
                __block void(^loadMoreItemsBlock)();
                __block BOOL loadMoreItemsCalled;
                
                beforeEach(^{
                    loadMoreItemsCalled = NO;
                    view.loadMoreItems = ^() {
                        loadMoreItemsCalled = YES;
                    };
                    
                    HCArgumentCaptor *blockArgument = [HCArgumentCaptor new];
                    [verify(delegateMock) setLoadMoreItems:(id)blockArgument];
                    loadMoreItemsBlock = blockArgument.value;
                    
                    loadMoreItemsBlock();
                });
                
                it(@"should call delegates load more items block", ^{
                    expect(loadMoreItemsCalled).to.beTruthy();
                });
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
});

SpecEnd
