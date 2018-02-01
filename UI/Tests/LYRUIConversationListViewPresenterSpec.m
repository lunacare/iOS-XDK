#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIConfiguration+DependencyInjection.h>
#import <LayerXDK/LYRUIConversationListViewPresenter.h>
#import <LayerXDK/LYRUIConversationListView.h>
#import <LayerXDK/LYRUIListLayout.h>
#import <LayerXDK/LYRUIListDataSource.h>
#import <LayerXDK/LYRUIListDelegate.h>
#import <LayerXDK/LYRUIConversationItemViewPresenter.h>
#import <LayerXDK/LYRUIConversationCollectionViewCell.h>
#import <LayerXDK/LYRUIListCellPresenter.h>
#import <LayerXDK/LYRUIListSupplementaryViewPresenter.h>
#import <LayerXDK/LYRUIListHeaderView.h>
#import <LayerXDK/LYRUIListSection.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIConversationListViewPresenter)

describe(@"LYRUIConversationListViewPresenter", ^{
    describe(@"setupConversationListView:", ^{
        __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
        __block LYRUIConversationItemViewPresenter *itemViewPresenterMock;
        __block LYRUIListCellPresenter *cellPresenterMock;
        __block LYRUIListSupplementaryViewPresenter *supplementaryViewPresenterMock;
        __block LYRUIListLayout *layoutMock;
        __block LYRUIListDelegate *delegateMock;
        __block LYRUIListDataSource *dataSourceMock;
        __block LYRUIConversationListView *viewMock;
        __block UICollectionView *collectionViewMock;
        __block LYRUIConversationListViewPresenter *conversationsListPresenter;
        
        beforeEach(^{
            configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
            
            itemViewPresenterMock = mock([LYRUIConversationItemViewPresenter class]);
            [given([injectorMock presenterForViewClass:[LYRUIConversationItemView class]]) willReturn:itemViewPresenterMock];
            
            cellPresenterMock = mock([LYRUIListCellPresenter class]);
            [given([injectorMock presenterForViewClass:[UICollectionViewCell class]]) willReturn:cellPresenterMock];
            
            supplementaryViewPresenterMock = mock([LYRUIListSupplementaryViewPresenter class]);
            [given([injectorMock presenterForViewClass:[LYRUIListHeaderView class]]) willReturn:supplementaryViewPresenterMock];
            
            layoutMock = mock([LYRUIListLayout class]);
            [given([injectorMock layoutForViewClass:[LYRUIConversationListView class]]) willReturn:layoutMock];
            
            delegateMock = mock([LYRUIListDelegate class]);
            [given([injectorMock objectOfType:[LYRUIListDelegate class]]) willReturn:delegateMock];
            
            dataSourceMock = mock([LYRUIListDataSource class]);
            [given([injectorMock objectOfType:[LYRUIListDataSource class]]) willReturn:dataSourceMock];
            
            viewMock = mock([LYRUIConversationListView class]);
            
            collectionViewMock = mock([UICollectionView class]);
            [given(viewMock.collectionView) willReturn:collectionViewMock];
            
            conversationsListPresenter = [[LYRUIConversationListViewPresenter alloc] initWithConfiguration:configurationMock];
        });
        
        describe(@"setupListView:", ^{
            beforeEach(^{
                [conversationsListPresenter setupListView:viewMock];
            });
            
            it(@"should set view layout to LYRUIConversationListLayout", ^{
                [verify(viewMock) setLayout:layoutMock];
            });
            it(@"should setup cell presenter using conversation item presenter", ^{
                [verify(cellPresenterMock) setupWithCellClass:[LYRUIConversationCollectionViewCell class]
                                                       modelClass:[LYRConversation class]
                                                viewPresenter:itemViewPresenterMock
                                                       cellHeight:72.0
                                                   cellSetupBlock:anything()
                                            cellRegistrationBlock:nil];
            });
            it(@"should register cell in collection view", ^{
                [verify(cellPresenterMock) registerCellInCollectionView:collectionViewMock];
            });
            it(@"should register supplementary view in collection view", ^{
                [verify(supplementaryViewPresenterMock) registerSupplementaryViewInCollectionView:collectionViewMock];
            });
            it(@"should set list view layout", ^{
                [verify(viewMock) setLayout:layoutMock];
            });
            it(@"should register cell presenter in data source", ^{
                [verify(dataSourceMock) registerCellPresenter:cellPresenterMock];
            });
            it(@"should register supplementary view presenter in data source", ^{
                [verify(dataSourceMock) registerSupplementaryViewPresenter:supplementaryViewPresenterMock];
            });
            it(@"should set view data source to LYRUIListDataSource", ^{
                [verify(viewMock) setDataSource:dataSourceMock];
            });
            it(@"should register cell presenter as size calculator in delegate", ^{
                [verify(delegateMock) registerCellSizeCalculation:cellPresenterMock];
            });
            it(@"should register supplementary view presenter as size calculator in delegate", ^{
                [verify(delegateMock) registerSupplementaryViewSizeCalculation:supplementaryViewPresenterMock];
            });
            it(@"should set view delegate to LYRUIListDelegate", ^{
                [verify(viewMock) setDelegate:delegateMock];
            });
            
            describe(@"cell presenter cell setup block", ^{
                __block LYRUIConversationItemView *itemViewMock;
                __block LYRConversation *ConversationMock;
                
                beforeEach(^{
                    LYRUIConversationCollectionViewCell *cellMock = mock([LYRUIConversationCollectionViewCell class]);
                    itemViewMock = mock([LYRUIConversationItemView class]);
                    [given(cellMock.conversationView) willReturn:itemViewMock];
                    
                    ConversationMock = mock([LYRConversation class]);
                    
                    HCArgumentCaptor *cellSetupBlockArgument = [HCArgumentCaptor new];
                    [verify(cellPresenterMock) setupWithCellClass:anything()
                                                           modelClass:anything()
                                                    viewPresenter:anything()
                                                           cellHeight:72.0
                                                       cellSetupBlock:(id)cellSetupBlockArgument
                                                cellRegistrationBlock:nil];
                    void(^cellSetupBlock)(id, id, id) = cellSetupBlockArgument.value;
                    cellSetupBlock(cellMock, ConversationMock, itemViewPresenterMock);
                });
                
                it(@"should use the presenter to setup Conversation item view with Conversation", ^{
                    [verify(itemViewPresenterMock) setupConversationItemView:itemViewMock withConversation:ConversationMock];
                });
            });
        });
    });
});

SpecEnd
