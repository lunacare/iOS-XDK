#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIConversationCollectionViewCell.h>
#import <Atlas/LYRUIConversationItemView.h>

SpecBegin(LYRUIConversationCollectionViewCell)

describe(@"LYRUIConversationCollectionViewCell", ^{
    __block LYRUIConversationCollectionViewCell *cell;

    beforeEach(^{
        cell = [[LYRUIConversationCollectionViewCell alloc] init];
    });

    afterEach(^{
        cell = nil;
    });
    
    describe(@"after initialization", ^{
        it(@"should have the conversation view set", ^{
            expect(cell.conversationView).notTo.beNil();
        });
        it(@"should have the conversation view added as subview of content view", ^{
            expect(cell.conversationView.superview).to.equal(cell.contentView);
        });
        it(@"should have the autoresizing mask of conversation view set to resizable width and height", ^{
            expect(cell.conversationView.autoresizingMask).to.equal(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        });
    });
});

SpecEnd
