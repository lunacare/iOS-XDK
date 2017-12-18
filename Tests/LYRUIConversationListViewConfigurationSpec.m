#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIConfiguration+DependencyInjection.h>
#import <Atlas/LYRUIConversationListViewConfiguration.h>
#import <Atlas/LYRUIConversationListView.h>
#import <Atlas/LYRUIListLayout.h>
#import <Atlas/LYRUIListDataSource.h>
#import <Atlas/LYRUIListDelegate.h>
#import <Atlas/LYRUIConversationItemViewConfiguration.h>
#import <Atlas/LYRUIConversationCollectionViewCell.h>
#import <Atlas/LYRUIListCellConfiguration.h>
#import <Atlas/LYRUIListSupplementaryViewConfiguration.h>
#import <Atlas/LYRUIListHeaderView.h>
#import <Atlas/LYRUIListSection.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIConversationListViewConfiguration)

describe(@"LYRUIConversationListViewConfiguration", ^{
    describe(@"setupConversationListView:", ^{
        __block LYRUIConfiguration *configurationMock;
        __block LYRUIConversationItemViewConfiguration *itemViewConfigurationMock;
        __block LYRUIListCellConfiguration *cellConfigurationMock;
        __block LYRUIListSupplementaryViewConfiguration *supplementaryViewConfigurationMock;
        __block LYRUIListLayout *layoutMock;
        __block LYRUIListDelegate *delegateMock;
        __block LYRUIListDataSource *dataSourceMock;
        __block LYRUIConversationListView *viewMock;
        __block UICollectionView *collectionViewMock;
        __block LYRUIConversationListViewConfiguration *conversationsListConfiguration;
        
        beforeEach(^{
            configurationMock = mock([LYRUIConfiguration class]);
            
            itemViewConfigurationMock = mock([LYRUIConversationItemViewConfiguration class]);
            [given([configurationMock configurationForViewClass:[LYRUIConversationItemView class]]) willReturn:itemViewConfigurationMock];
            
            cellConfigurationMock = mock([LYRUIListCellConfiguration class]);
            [given([configurationMock configurationForViewClass:[UICollectionViewCell class]]) willReturn:cellConfigurationMock];
            
            supplementaryViewConfigurationMock = mock([LYRUIListSupplementaryViewConfiguration class]);
            [given([configurationMock configurationForViewClass:[LYRUIListHeaderView class]]) willReturn:supplementaryViewConfigurationMock];
            
            layoutMock = mock([LYRUIListLayout class]);
            [given([configurationMock layoutForViewClass:[LYRUIConversationListView class]]) willReturn:layoutMock];
            
            delegateMock = mock([LYRUIListDelegate class]);
            [given([configurationMock objectOfType:[LYRUIListDelegate class]]) willReturn:delegateMock];
            
            dataSourceMock = mock([LYRUIListDataSource class]);
            [given([configurationMock objectOfType:[LYRUIListDataSource class]]) willReturn:dataSourceMock];
            
            viewMock = mock([LYRUIConversationListView class]);
            
            collectionViewMock = mock([UICollectionView class]);
            [given(viewMock.collectionView) willReturn:collectionViewMock];
            
            conversationsListConfiguration = [[LYRUIConversationListViewConfiguration alloc] initWithConfiguration:configurationMock];
        });
        
        describe(@"setupListView:", ^{
            beforeEach(^{
                [conversationsListConfiguration setupListView:viewMock];
            });
            
            it(@"should set view layout to LYRUIConversationListLayout", ^{
                [verify(viewMock) setLayout:layoutMock];
            });
            it(@"should setup cell configuration using conversation item configuration", ^{
                [verify(cellConfigurationMock) setupWithCellClass:[LYRUIConversationCollectionViewCell class]
                                                       modelClass:[LYRConversation class]
                                                viewConfiguration:itemViewConfigurationMock
                                                       cellHeight:72.0
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
                __block LYRUIConversationItemView *itemViewMock;
                __block LYRConversation *ConversationMock;
                
                beforeEach(^{
                    LYRUIConversationCollectionViewCell *cellMock = mock([LYRUIConversationCollectionViewCell class]);
                    itemViewMock = mock([LYRUIConversationItemView class]);
                    [given(cellMock.conversationView) willReturn:itemViewMock];
                    
                    ConversationMock = mock([LYRConversation class]);
                    
                    HCArgumentCaptor *cellSetupBlockArgument = [HCArgumentCaptor new];
                    [verify(cellConfigurationMock) setupWithCellClass:anything()
                                                           modelClass:anything()
                                                    viewConfiguration:anything()
                                                           cellHeight:72.0
                                                       cellSetupBlock:(id)cellSetupBlockArgument
                                                cellRegistrationBlock:nil];
                    void(^cellSetupBlock)(id, id, id) = cellSetupBlockArgument.value;
                    cellSetupBlock(cellMock, ConversationMock, itemViewConfigurationMock);
                });
                
                it(@"should use the configuration to setup Conversation item view with Conversation", ^{
                    [verify(itemViewConfigurationMock) setupConversationItemView:itemViewMock withConversation:ConversationMock];
                });
            });
        });
    });
});

SpecEnd
