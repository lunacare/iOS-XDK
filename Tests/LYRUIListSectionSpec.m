#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIListSection.h>

SpecBegin(LYRUIListSection)

describe(@"LYRUIListSection", ^{
    __block LYRUIListSection *section;

    beforeEach(^{
        section = [[LYRUIListSection alloc] init];
    });

    afterEach(^{
        section = nil;
    });

    describe(@"addHeaderWithTitle:", ^{
        beforeEach(^{
            [section addHeaderWithTitle:@"test title"];
        });
        
        it(@"should have header data initialized", ^{
            expect(section.header).notTo.beNil();
        });
        it(@"should have header of LYRUIListSectionHeader type", ^{
            expect(section.header).to.beAKindOf([LYRUIListSectionHeader class]);
        });
        it(@"should have header with title set", ^{
            expect(section.header.title).to.equal(@"test title");
        });
    });
});

SpecEnd
