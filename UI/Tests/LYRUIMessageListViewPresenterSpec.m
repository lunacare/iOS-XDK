#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIConfiguration+DependencyInjection.h>
#import <LayerXDK/LYRUIMessageListViewPresenter.h>
#import <LayerXDK/LYRUIMessageListView.h>
#import <LayerXDK/LYRUIMessageListLayout.h>
#import <LayerXDK/LYRUIMessageCellPresenter.h>
#import <LayerXDK/LYRUICarouselMessageCellPresenter.h>
#import <LayerXDK/LYRUIMessageListTimeSupplementaryViewPresenter.h>
#import <LayerXDK/LYRUIMessageListStatusSupplementaryViewPresenter.h>
#import <LayerXDK/LYRUIListLoadingIndicatorPresenter.h>
#import <LayerXDK/LYRUIMessageListTypingIndicatorsController.h>
#import <LayerXDK/LYRUITypingIndicatorCellPresenter.h>
#import <LayerXDK/LYRUITypingIndicatorFooterPresenter.h>
#import <LayerXDK/LYRUIStatusCellPresenter.h>
#import <LayerXDK/LYRUIListDataSource.h>
#import <LayerXDK/LYRUIMessageListDelegate.h>

@interface LYRUIMessageListView (Tests)
@property (nonatomic, strong, readwrite) UICollectionView *collectionView;
@end

SpecBegin(LYRUIMessageListViewPresenter)

describe(@"LYRUIMessageListViewPresenter", ^{
    __block LYRUIMessageListViewPresenter *presenter;
    __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
    __block LYRUIMessageListLayout *layoutMock;
    __block LYRUIMessageCellPresenter *cellPresenterMock;
    __block LYRUICarouselMessageCellPresenter *carouselCellPresenterMock;
    __block LYRUIStatusCellPresenter *statusCellPresenterMock;
    __block LYRUIMessageListTimeSupplementaryViewPresenter *timeViewPresenterMock;
    __block LYRUIMessageListStatusSupplementaryViewPresenter *statusViewPresenterMock;
    __block LYRUIListLoadingIndicatorPresenter *loadingIndicatorPresenterMock;
    __block LYRUIMessageListTypingIndicatorsController *typingIndicatorsControllerMock;
    __block LYRUITypingIndicatorCellPresenter *typingIndicatorCellPresenterMock;
    __block LYRUITypingIndicatorFooterPresenter *typingIndicatorFooterPresenterMock;
    __block LYRUIListDataSource *dataSourceMock;
    __block LYRUIMessageListDelegate *delegateMock;
    __block LYRUIMessageListView *view;
    __block UICollectionView *collectionViewMock;

    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
        
        layoutMock = mock([LYRUIMessageListLayout class]);
        [[given([layoutMock copyWithZone:NSDefaultMallocZone()]) withMatcher:anything()] willReturn:layoutMock];
        [given([injectorMock layoutForViewClass:[LYRUIMessageListView class]]) willReturn:layoutMock];
        
        cellPresenterMock = mock([LYRUIMessageCellPresenter class]);
        [given([injectorMock objectOfType:[LYRUIMessageCellPresenter class]]) willReturn:cellPresenterMock];
        
        carouselCellPresenterMock = mock([LYRUICarouselMessageCellPresenter class]);
        [given([injectorMock objectOfType:[LYRUICarouselMessageCellPresenter class]]) willReturn:carouselCellPresenterMock];
        
        statusCellPresenterMock = mock([LYRUIStatusCellPresenter class]);
        [given([injectorMock objectOfType:[LYRUIStatusCellPresenter class]]) willReturn:statusCellPresenterMock];
        
        timeViewPresenterMock = mock([LYRUIMessageListTimeSupplementaryViewPresenter class]);
        [given([injectorMock objectOfType:[LYRUIMessageListTimeSupplementaryViewPresenter class]]) willReturn:timeViewPresenterMock];
        
        statusViewPresenterMock = mock([LYRUIMessageListStatusSupplementaryViewPresenter class]);
        [given([injectorMock objectOfType:[LYRUIMessageListStatusSupplementaryViewPresenter class]]) willReturn:statusViewPresenterMock];
        
        loadingIndicatorPresenterMock = mock([LYRUIListLoadingIndicatorPresenter class]);
        [given([injectorMock objectOfType:[LYRUIListLoadingIndicatorPresenter class]]) willReturn:loadingIndicatorPresenterMock];
        
        typingIndicatorsControllerMock = mock([LYRUIMessageListTypingIndicatorsController class]);
        [given([injectorMock objectOfType:[LYRUIMessageListTypingIndicatorsController class]]) willReturn:typingIndicatorsControllerMock];
        
        typingIndicatorCellPresenterMock = mock([LYRUITypingIndicatorCellPresenter class]);
        [given([injectorMock objectOfType:[LYRUITypingIndicatorCellPresenter class]]) willReturn:typingIndicatorCellPresenterMock];
        
        typingIndicatorFooterPresenterMock = mock([LYRUITypingIndicatorFooterPresenter class]);
        [given([injectorMock objectOfType:[LYRUITypingIndicatorFooterPresenter class]]) willReturn:typingIndicatorFooterPresenterMock];
        
        dataSourceMock = mock([LYRUIListDataSource class]);
        [given([injectorMock objectOfType:[LYRUIListDataSource class]]) willReturn:dataSourceMock];
        
        delegateMock = mock([LYRUIMessageListDelegate class]);
        [given([injectorMock objectOfType:[LYRUIMessageListDelegate class]]) willReturn:delegateMock];

        presenter = [[LYRUIMessageListViewPresenter alloc] initWithConfiguration:configurationMock];
        
        view = [[LYRUIMessageListView alloc] init];
        
        collectionViewMock = mock([UICollectionView class]);
        [view setCollectionView:collectionViewMock];
    });

    afterEach(^{
        presenter = nil;
        injectorMock = nil;
        configurationMock = nil;
    });

    describe(@"setupListView:", ^{
        beforeEach(^{
            [presenter setupListView:view];
        });
        
        it(@"should set default list view message grouping time interval", ^{
            expect(view.messageGroupingTimeInterval).to.equal(1800);
        });
        it(@"should set default list view page size", ^{
            expect(view.pageSize).to.equal(30);
        });
        it(@"should set list view layout", ^{
            expect(view.layout).to.equal(layoutMock);
        });
        it(@"should set list view data source", ^{
            expect(view.dataSource).to.equal(dataSourceMock);
        });
        it(@"should set list view delegate", ^{
            expect(view.delegate).to.equal(delegateMock);
        });
        it(@"should set typing indicators controller", ^{
            expect(view.typingIndicatorsController).to.equal(typingIndicatorsControllerMock);
        });
        it(@"should set typing indicators controller's message list view", ^{
            [verify(typingIndicatorsControllerMock) setMessageListView:view];
        });
        
        it(@"should register message cell presenter cell", ^{
            [verify(cellPresenterMock) registerCellInCollectionView:collectionViewMock];
        });
        it(@"should register carousel cell presenter cell", ^{
            [verify(carouselCellPresenterMock) registerCellInCollectionView:collectionViewMock];
        });
        it(@"should register typing indicator cell presenter cell", ^{
            [verify(typingIndicatorCellPresenterMock) registerCellInCollectionView:collectionViewMock];
        });
        it(@"should register status message cell presenter cell", ^{
            [verify(statusCellPresenterMock) registerCellInCollectionView:collectionViewMock];
        });
        
        it(@"should register time view presenter supplementary view", ^{
            [verify(timeViewPresenterMock) registerSupplementaryViewInCollectionView:collectionViewMock];
        });
        it(@"should register message status view presenter supplementary view", ^{
            [verify(statusViewPresenterMock) registerSupplementaryViewInCollectionView:collectionViewMock];
        });
        it(@"should register loading indicator presenter supplementary view", ^{
            [verify(loadingIndicatorPresenterMock) registerSupplementaryViewInCollectionView:collectionViewMock];
        });
        it(@"should register typing indicator footer presenter supplementary view", ^{
            [verify(typingIndicatorFooterPresenterMock) registerSupplementaryViewInCollectionView:collectionViewMock];
        });
        it(@"should set typing indicator footer presenter's message list view", ^{
            [verify(typingIndicatorFooterPresenterMock) setMessageListView:view];
        });
        it(@"should set typing indicator footer presenter's typing indicators controller", ^{
            [verify(typingIndicatorFooterPresenterMock) setTypingIndicatorsController:typingIndicatorsControllerMock];
        });
        
        context(@"data source", ^{
            it(@"should have default cell presenter set to message cell presenter", ^{
                [verify(dataSourceMock) setDefaultCellPresenter:cellPresenterMock];
            });
            it(@"should have a carousel cell presenter registered", ^{
                [verify(dataSourceMock) registerCellPresenter:carouselCellPresenterMock];
            });
            it(@"should have a typing indicator cell presenter registered", ^{
                [verify(dataSourceMock) registerCellPresenter:typingIndicatorCellPresenterMock];
            });
            it(@"should have a status message cell presenter registered", ^{
                [verify(dataSourceMock) registerCellPresenter:statusCellPresenterMock];
            });
            it(@"should have a message time supplementary view presenter registered", ^{
                [verify(dataSourceMock) registerSupplementaryViewPresenter:timeViewPresenterMock];
            });
            it(@"should have a message status supplementary view presenter registered", ^{
                [verify(dataSourceMock) registerSupplementaryViewPresenter:statusViewPresenterMock];
            });
            it(@"should have a loading indicator supplementary view presenter registered", ^{
                [verify(dataSourceMock) registerSupplementaryViewPresenter:loadingIndicatorPresenterMock];
            });
            it(@"should have a typing indicator supplementary view presenter registered", ^{
                [verify(dataSourceMock) registerSupplementaryViewPresenter:typingIndicatorFooterPresenterMock];
            });
        });
        
        context(@"delegate", ^{
            it(@"should have default cell size calculator set to message cell presenter", ^{
                [verify(delegateMock) setDefaultCellSizeCalculation:cellPresenterMock];
            });
            it(@"should have a carousel cell size calculator registered", ^{
                [verify(delegateMock) registerCellSizeCalculation:carouselCellPresenterMock];
            });
            it(@"should have a typing indicator cell size calculator registered", ^{
                [verify(delegateMock) registerCellSizeCalculation:typingIndicatorCellPresenterMock];
            });
            it(@"should have a status message cell size calculator registered", ^{
                [verify(delegateMock) registerCellSizeCalculation:statusCellPresenterMock];
            });
            it(@"should have a message time supplementary view size calculator registered", ^{
                [verify(delegateMock) registerSupplementaryViewSizeCalculation:timeViewPresenterMock];
            });
            it(@"should have a message status supplementary view size calculator registered", ^{
                [verify(delegateMock) registerSupplementaryViewSizeCalculation:statusViewPresenterMock];
            });
            it(@"should have a loading indicator supplementary view size calculator registered", ^{
                [verify(delegateMock) registerSupplementaryViewSizeCalculation:loadingIndicatorPresenterMock];
            });
            it(@"should have a typing indicator supplementary view size calculator registered", ^{
                [verify(delegateMock) registerSupplementaryViewSizeCalculation:typingIndicatorFooterPresenterMock];
            });
            it(@"should have loading delegate set to loading indicator presenter", ^{
                [verify(delegateMock) setLoadingDelegate:loadingIndicatorPresenterMock];
            });
        });
    });
});

SpecEnd
