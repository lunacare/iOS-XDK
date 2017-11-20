#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIConversationListViewConfiguration.h>
#import <Atlas/LYRUIConversationListView.h>
#import <Atlas/LYRUIListLayout.h>
#import <Atlas/LYRUIListDataSource.h>
#import <Atlas/LYRUIListDelegate.h>
#import <Atlas/LYRUIConversationItemViewConfiguration.h>
#import <Atlas/LYRUIConversationCollectionViewCell.h>
#import <Atlas/LYRUIListHeaderView.h>
#import <Atlas/LYRUIListSection.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIConversationListViewConfiguration)

describe(@"LYRUIConversationListViewConfiguration", ^{
    describe(@"setupConversationListView:", ^{
        __block LYRUIConversationListView *viewMock;
        __block LYRIdentity *currentUserMock;
        
        beforeEach(^{
            viewMock = mock([LYRUIConversationListView class]);
            
            currentUserMock = mock([LYRIdentity class]);
            
            [LYRUIConversationListViewConfiguration setupConversationListView:viewMock];
        });
        
        it(@"should set view layout to LYRUIConversationListLayout", ^{
            [verify(viewMock) setLayout:isA([LYRUIListLayout class])];
        });
        it(@"should set view delegate to LYRUIListDelegate", ^{
            [verify(viewMock) setDelegate:isA([LYRUIListDelegate class])];
        });
        it(@"should set view data source to LYRUIListDataSource", ^{
            [verify(viewMock) setDataSource:isA([LYRUIListDataSource class])];
        });
    });
});

SpecEnd
