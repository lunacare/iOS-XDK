#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIConfiguration+DependencyInjection.h>
#import <LayerXDK/LYRUIIdentityListViewPresenter.h>
#import <LayerXDK/LYRUIIdentityListView.h>
#import <LayerXDK/LYRUIListLayout.h>
#import <LayerXDK/LYRUIListDataSource.h>
#import <LayerXDK/LYRUIListDelegate.h>
#import <LayerXDK/LYRUIListSection.h>
#import <LayerXDK/LYRUIIdentityItemViewPresenter.h>
#import <LayerXDK/LYRUIIdentityCollectionViewCell.h>
#import <LayerXDK/LYRUIListHeaderView.h>
#import <LayerXDK/LYRUIListCellPresenter.h>
#import <LayerXDK/LYRUIListSupplementaryViewPresenter.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIIdentityListViewPresenter)

describe(@"LYRUIIdentityListViewPresenter", ^{
    describe(@"setupIdentityListView:", ^{
        __block LYRUIConfiguration *configurationMock;
        __block id<LYRUIDependencyInjection> injectorMock;
        __block LYRUIIdentityItemViewPresenter *itemViewPresenterMock;
        __block LYRUIListCellPresenter *cellPresenterMock;
        __block LYRUIListSupplementaryViewPresenter *supplementaryViewPresenterMock;
        __block LYRUIListLayout *layoutMock;
        __block LYRUIListDelegate *delegateMock;
        __block LYRUIListDataSource *dataSourceMock;
        __block LYRUIIdentityListView *viewMock;
        __block UICollectionView *collectionViewMock;
        __block LYRUIIdentityListViewPresenter *identityListPresenter;
        
        beforeEach(^{
            configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
            
            itemViewPresenterMock = mock([LYRUIIdentityItemViewPresenter class]);
            [given([injectorMock presenterForViewClass:[LYRUIIdentityItemView class]]) willReturn:itemViewPresenterMock];
            
            cellPresenterMock = mock([LYRUIListCellPresenter class]);
            [given([injectorMock presenterForViewClass:[UICollectionViewCell class]]) willReturn:cellPresenterMock];
            
            supplementaryViewPresenterMock = mock([LYRUIListSupplementaryViewPresenter class]);
            [given([injectorMock presenterForViewClass:[LYRUIListHeaderView class]]) willReturn:supplementaryViewPresenterMock];
            
            layoutMock = mock([LYRUIListLayout class]);
            [given([injectorMock layoutForViewClass:[LYRUIIdentityListView class]]) willReturn:layoutMock];
            
            delegateMock = mock([LYRUIListDelegate class]);
            [given([injectorMock objectOfType:[LYRUIListDelegate class]]) willReturn:delegateMock];
            
            dataSourceMock = mock([LYRUIListDataSource class]);
            [given([injectorMock objectOfType:[LYRUIListDataSource class]]) willReturn:dataSourceMock];
            
            viewMock = mock([LYRUIIdentityListView class]);
            
            collectionViewMock = mock([UICollectionView class]);
            [given(viewMock.collectionView) willReturn:collectionViewMock];
            
            identityListPresenter = [[LYRUIIdentityListViewPresenter alloc] initWithConfiguration:configurationMock];
        });
        
        describe(@"setupListView:", ^{
            beforeEach(^{
                [identityListPresenter setupListView:viewMock];
            });
            
            it(@"should set view layout to LYRUIIdentityListLayout", ^{
                [verify(viewMock) setLayout:layoutMock];
            });
            it(@"should setup cell presenter using Identity item presenter", ^{
                [verify(cellPresenterMock) setupWithCellClass:[LYRUIIdentityCollectionViewCell class]
                                                       modelClass:[LYRIdentity class]
                                                viewPresenter:itemViewPresenterMock
                                                       cellHeight:48.0
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
                __block LYRUIIdentityItemView *itemViewMock;
                __block LYRIdentity *identityMock;
                
                beforeEach(^{
                    LYRUIIdentityCollectionViewCell *cellMock = mock([LYRUIIdentityCollectionViewCell class]);
                    itemViewMock = mock([LYRUIIdentityItemView class]);
                    [given(cellMock.identityView) willReturn:itemViewMock];
                    
                    identityMock = mock([LYRIdentity class]);
                    
                    HCArgumentCaptor *cellSetupBlockArgument = [HCArgumentCaptor new];
                    [verify(cellPresenterMock) setupWithCellClass:anything()
                                                           modelClass:anything()
                                                    viewPresenter:anything()
                                                           cellHeight:48.0
                                                       cellSetupBlock:(id)cellSetupBlockArgument
                                                cellRegistrationBlock:nil];
                    void(^cellSetupBlock)(id, id, id) = cellSetupBlockArgument.value;
                    cellSetupBlock(cellMock, identityMock, itemViewPresenterMock);
                });
                
                it(@"should use the presenter to setup identity item view with identity", ^{
                    [verify(itemViewPresenterMock) setupIdentityItemView:itemViewMock withIdentity:identityMock];
                });
            });
        });
    });
});

SpecEnd
