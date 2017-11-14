#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
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
        __block LYRUIIdentityListView *viewMock;
        
        beforeEach(^{
            viewMock = mock([LYRUIIdentityListView class]);
            
            [LYRUIIdentityListViewConfiguration setupIdentityListView:viewMock];
        });
        
        it(@"should set view layout to LYRUIListLayout", ^{
            [verify(viewMock) setLayout:isA([LYRUIListLayout class])];
        });
        it(@"should set view delegate to LYRUIListDelegate", ^{
            [verify(viewMock) setDelegate:isA([LYRUIListDelegate class])];
        });
        it(@"should set view data source to LYRUIListDataSource", ^{
            [verify(viewMock) setDataSource:isA([LYRUIListDataSource class])];
        });
        
        context(@"data source", ^{
            __block LYRUIListDataSource *dataSource;
            
            beforeEach(^{
                HCArgumentCaptor *dataSourceArgument = [HCArgumentCaptor new];
                [verify(viewMock) setDataSource:(id)dataSourceArgument];
                dataSource = dataSourceArgument.value;
            });
            
            it(@"should have cell configuration of LYRUIListCellConfiguration type set", ^{
                expect(dataSource.allConfigurations.firstObject).to.beKindOf([LYRUIListCellConfiguration class]);
            });
            
            context(@"cell configuration", ^{
                __block LYRUIListCellConfiguration *cellConfiguration;
                
                beforeEach(^{
                    cellConfiguration = dataSource.allConfigurations.firstObject;
                });
                
                it(@"should have `LYRIdentity` set as handled item type", ^{
                    expect(cellConfiguration.handledItemTypes).to.equal([NSSet setWithObject:[LYRIdentity class]]);
                });
                it(@"should have reuse identifier set to `LYRUIIdentityCollectionViewCell`", ^{
                    expect(cellConfiguration.cellReuseIdentifier).to.equal(@"LYRUIIdentityCollectionViewCell");
                });
                it(@"should have `LYRUIIdentityItemViewConfiguration` set as view configuration", ^{
                    expect(cellConfiguration.viewConfiguration).to.beAKindOf([LYRUIIdentityItemViewConfiguration class]);
                });
                it(@"should have cell height set to 48", ^{
                    expect(cellConfiguration.cellHeight).to.equal(48.0);
                });
                
                describe(@"cell setup block", ^{
                    __block LYRUIIdentityItemView *itemViewMock;
                    __block LYRIdentity *identityMock;
                    __block LYRUIIdentityItemViewConfiguration *configuratorMock;
                    
                    beforeEach(^{
                        LYRUIIdentityCollectionViewCell *cellMock = mock([LYRUIIdentityCollectionViewCell class]);
                        itemViewMock = mock([LYRUIIdentityItemView class]);
                        [given(cellMock.identityView) willReturn:itemViewMock];
                        
                        identityMock = mock([LYRIdentity class]);
                        
                        configuratorMock = mock([LYRUIIdentityItemViewConfiguration class]);
                        
                        cellConfiguration.cellSetupBlock(cellMock, identityMock, configuratorMock);
                    });
                    
                    it(@"should use the configuration to setup identity item view with identity", ^{
                        [verify(configuratorMock) setupIdentityItemView:itemViewMock withIdentity:identityMock];
                    });
                });
                
                describe(@"cell registration block", ^{
                    __block UICollectionView *collectionViewMock;
                    
                    beforeEach(^{
                        collectionViewMock = mock([UICollectionView class]);
                        
                        cellConfiguration.cellRegistrationBlock(collectionViewMock);
                    });
                    
                    it(@"should register proper supplementary view class for header with proper reuse identifier", ^{
                        [verify(collectionViewMock) registerClass:[LYRUIIdentityCollectionViewCell class]
                                       forCellWithReuseIdentifier:@"LYRUIIdentityCollectionViewCell"];
                    });
                });
            });
            
            context(@"header configuration", ^{
                __block LYRUIListSupplementaryViewConfiguration *headerConfiguration;
                
                beforeEach(^{
                    headerConfiguration = dataSource.allConfigurations.lastObject;
                });
                
                it(@"should have `UICollectionElementKindSectionHeader` set as view kind", ^{
                    expect(headerConfiguration.viewKind).to.equal(UICollectionElementKindSectionHeader);
                });
                it(@"should have reuse identifier set to `LYRUIListHeaderView`", ^{
                    expect(headerConfiguration.viewReuseIdentifier).to.equal(@"LYRUIListHeaderView");
                });
                it(@"should have view height set to 64", ^{
                    expect(headerConfiguration.supplementaryViewHeight).to.equal(64.0);
                });
                
                describe(@"header visibility block", ^{
                    __block LYRUIListSection *sectionMock;
                    __block id<LYRUIListDataSource> dataSourceMock;
                    
                    beforeEach(^{
                        sectionMock = mock([LYRUIListSection class]);
                        dataSourceMock = mockProtocol(@protocol(LYRUIListDataSource));
                        [given(dataSourceMock.sections) willReturn:@[sectionMock]];
                    });
                    
                    context(@"when section contains header", ^{
                        __block BOOL returnedValue;
                        
                        beforeEach(^{
                            id<LYRUIListSectionHeader> headerMock = mockProtocol(@protocol(LYRUIListSectionHeader));
                            [given(sectionMock.header) willReturn:headerMock];
                            
                            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                            returnedValue = headerConfiguration.supplementaryViewVisibilityBlock(dataSourceMock, indexPath);
                        });
                        
                        it(@"should return YES", ^{
                            expect(returnedValue).to.beTruthy();
                        });
                    });
                    
                    context(@"when section does not contain a header", ^{
                        __block BOOL returnedValue;
                        
                        beforeEach(^{
                            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                            returnedValue = headerConfiguration.supplementaryViewVisibilityBlock(dataSourceMock, indexPath);
                        });
                        
                        it(@"should return NO", ^{
                            expect(returnedValue).to.beFalsy();
                        });
                    });
                });
                
                describe(@"header setup block", ^{
                    __block LYRUIListHeaderView *headerViewMock;
                    
                    beforeEach(^{
                        headerViewMock = mock([LYRUIListHeaderView class]);
                        
                        id<LYRUIListSectionHeader> headerMock = mockProtocol(@protocol(LYRUIListSectionHeader));
                        [given(headerMock.title) willReturn:@"test title"];
                        LYRUIListSection *sectionMock = mock([LYRUIListSection class]);
                        [given(sectionMock.header) willReturn:headerMock];
                        id<LYRUIListDataSource> dataSourceMock = mockProtocol(@protocol(LYRUIListDataSource));
                        [given(dataSourceMock.sections) willReturn:@[sectionMock]];
                        
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                        headerConfiguration.supplementaryViewSetupBlock(headerViewMock, dataSourceMock, indexPath);
                    });
                    
                    it(@"should set the title on header", ^{
                        [verify(headerViewMock) setTitle:@"test title"];
                    });
                });
                
                describe(@"header registration block", ^{
                    __block UICollectionView *collectionViewMock;
                    
                    beforeEach(^{
                        collectionViewMock = mock([UICollectionView class]);
                        
                        headerConfiguration.supplementaryViewRegistrationBlock(collectionViewMock);
                    });
                    
                    it(@"should register proper supplementary view class for header with proper reuse identifier", ^{
                        [verify(collectionViewMock) registerClass:[LYRUIListHeaderView class]
                                       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                              withReuseIdentifier:@"LYRUIListHeaderView"];
                    });
                });
            });
        });
    });
});

SpecEnd
