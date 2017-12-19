#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIConfiguration+DependencyInjection.h>
#import <Atlas/LYRUIIdentityListViewConfiguration.h>
#import <Atlas/LYRUIIdentityListView.h>
#import <Atlas/LYRUIListLayout.h>
#import <Atlas/LYRUIListDataSource.h>
#import <Atlas/LYRUIListDelegate.h>
#import <Atlas/LYRUIListSection.h>
#import <Atlas/LYRUIIdentityItemViewConfiguration.h>
#import <Atlas/LYRUIIdentityCollectionViewCell.h>
#import <Atlas/LYRUIListHeaderView.h>
#import <Atlas/LYRUIListCellConfiguration.h>
#import <Atlas/LYRUIListSupplementaryViewConfiguration.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIIdentityListViewConfiguration)

describe(@"LYRUIIdentityListViewConfiguration", ^{
    describe(@"setupIdentityListView:", ^{
        __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
        __block LYRUIIdentityItemViewConfiguration *itemViewConfigurationMock;
        __block LYRUIListCellConfiguration *cellConfigurationMock;
        __block LYRUIListSupplementaryViewConfiguration *supplementaryViewConfigurationMock;
        __block LYRUIListLayout *layoutMock;
        __block LYRUIListDelegate *delegateMock;
        __block LYRUIListDataSource *dataSourceMock;
        __block LYRUIIdentityListView *viewMock;
        __block UICollectionView *collectionViewMock;
        __block LYRUIIdentityListViewConfiguration *identityListConfiguration;
        
        beforeEach(^{
            configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
            
            itemViewConfigurationMock = mock([LYRUIIdentityItemViewConfiguration class]);
            [given([injectorMock configurationForViewClass:[LYRUIIdentityItemView class]]) willReturn:itemViewConfigurationMock];
            
            cellConfigurationMock = mock([LYRUIListCellConfiguration class]);
            [given([injectorMock configurationForViewClass:[UICollectionViewCell class]]) willReturn:cellConfigurationMock];
            
            supplementaryViewConfigurationMock = mock([LYRUIListSupplementaryViewConfiguration class]);
            [given([injectorMock configurationForViewClass:[LYRUIListHeaderView class]]) willReturn:supplementaryViewConfigurationMock];
            
            layoutMock = mock([LYRUIListLayout class]);
            [given([injectorMock layoutForViewClass:[LYRUIIdentityListView class]]) willReturn:layoutMock];
            
            delegateMock = mock([LYRUIListDelegate class]);
            [given([injectorMock objectOfType:[LYRUIListDelegate class]]) willReturn:delegateMock];
            
            dataSourceMock = mock([LYRUIListDataSource class]);
            [given([injectorMock objectOfType:[LYRUIListDataSource class]]) willReturn:dataSourceMock];
            
            viewMock = mock([LYRUIIdentityListView class]);
            
            collectionViewMock = mock([UICollectionView class]);
            [given(viewMock.collectionView) willReturn:collectionViewMock];
            
            identityListConfiguration = [[LYRUIIdentityListViewConfiguration alloc] initWithConfiguration:configurationMock];
        });
        
        describe(@"setupListView:", ^{
            beforeEach(^{
                [identityListConfiguration setupListView:viewMock];
            });
            
            it(@"should set view layout to LYRUIIdentityListLayout", ^{
                [verify(viewMock) setLayout:layoutMock];
            });
            it(@"should setup cell configuration using Identity item configuration", ^{
                [verify(cellConfigurationMock) setupWithCellClass:[LYRUIIdentityCollectionViewCell class]
                                                       modelClass:[LYRIdentity class]
                                                viewConfiguration:itemViewConfigurationMock
                                                       cellHeight:48.0
                                                   cellSetupBlock:anything()
                                            cellRegistrationBlock:nil];
            });
            it(@"should register cell in collection view", ^{
                [verify(cellConfigurationMock) registerCellInCollectionView:collectionViewMock];
            });
            it(@"should register supplementary view in collection view", ^{
                [verify(supplementaryViewConfigurationMock) registerSupplementaryViewInCollectionView:collectionViewMock];
            });
            it(@"should set list view layout", ^{
                [verify(viewMock) setLayout:layoutMock];
            });
            it(@"should register cell configuration in data source", ^{
                [verify(dataSourceMock) registerCellConfiguration:cellConfigurationMock];
            });
            it(@"should register supplementary view configuration in data source", ^{
                [verify(dataSourceMock) registerSupplementaryViewConfiguration:supplementaryViewConfigurationMock];
            });
            it(@"should set view data source to LYRUIListDataSource", ^{
                [verify(viewMock) setDataSource:dataSourceMock];
            });
            it(@"should register cell configuration as size calculator in delegate", ^{
                [verify(delegateMock) registerCellSizeCalculation:cellConfigurationMock];
            });
            it(@"should register supplementary view configuration as size calculator in delegate", ^{
                [verify(delegateMock) registerSupplementaryViewSizeCalculation:supplementaryViewConfigurationMock];
            });
            it(@"should set view delegate to LYRUIListDelegate", ^{
                [verify(viewMock) setDelegate:delegateMock];
            });
            
            describe(@"cell configuration cell setup block", ^{
                __block LYRUIIdentityItemView *itemViewMock;
                __block LYRIdentity *identityMock;
                
                beforeEach(^{
                    LYRUIIdentityCollectionViewCell *cellMock = mock([LYRUIIdentityCollectionViewCell class]);
                    itemViewMock = mock([LYRUIIdentityItemView class]);
                    [given(cellMock.identityView) willReturn:itemViewMock];
                    
                    identityMock = mock([LYRIdentity class]);
                    
                    HCArgumentCaptor *cellSetupBlockArgument = [HCArgumentCaptor new];
                    [verify(cellConfigurationMock) setupWithCellClass:anything()
                                                           modelClass:anything()
                                                    viewConfiguration:anything()
                                                           cellHeight:48.0
                                                       cellSetupBlock:(id)cellSetupBlockArgument
                                                cellRegistrationBlock:nil];
                    void(^cellSetupBlock)(id, id, id) = cellSetupBlockArgument.value;
                    cellSetupBlock(cellMock, identityMock, itemViewConfigurationMock);
                });
                
                it(@"should use the configuration to setup identity item view with identity", ^{
                    [verify(itemViewConfigurationMock) setupIdentityItemView:itemViewMock withIdentity:identityMock];
                });
            });
        });
    });
});

SpecEnd
