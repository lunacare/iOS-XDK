#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIConfiguration+DependencyInjection.h>
#import <LayerXDK/LYRUICarouselContentOffsetsCache.h>

SpecBegin(LYRUICarouselContentOffsetsCache)

describe(@"LYRUICarouselContentOffsetsCache", ^{
    __block LYRUICarouselContentOffsetsCache *cache;

    beforeEach(^{
        cache = [[LYRUICarouselContentOffsetsCache alloc] init];
    });

    afterEach(^{
        cache = nil;
    });

    describe(@"setContentOffset:forCarouselMessageId:", ^{
        beforeEach(^{
            [cache setContentOffset:CGPointMake(100, 200) forCarouselMessageId:@"test message identifier"];
        });
        
        it(@"should store the content offset for given identifier", ^{
            expect([cache contentOffsetForCarouselMessageId:@"test message identifier"]).to.equal(CGPointMake(100, 200));
        });
        
        context(@"when called twice for the same message id", ^{
            beforeEach(^{
                [cache setContentOffset:CGPointMake(200, 100) forCarouselMessageId:@"test message identifier"];
            });
            
            it(@"should update stored content offset for given identifier", ^{
                expect([cache contentOffsetForCarouselMessageId:@"test message identifier"]).to.equal(CGPointMake(200, 100));
            });
        });
    });
    
    describe(@"contentOffsetForCarouselMessageId:", ^{
        context(@"when no content offset was stored for given identifier", ^{
            it(@"should return `CGPointZero`", ^{
                expect([cache contentOffsetForCarouselMessageId:@"test message identifier"]).to.equal(CGPointZero);
            });
        });
        
        context(@"when content offset for given identifier was stored previously", ^{
            beforeEach(^{
                [cache setContentOffset:CGPointMake(100, 200) forCarouselMessageId:@"test message identifier"];
            });
            
            it(@"should returned the content offset stored for given identifier", ^{
                expect([cache contentOffsetForCarouselMessageId:@"test message identifier"]).to.equal(CGPointMake(100, 200));
            });
        });
    });
});

SpecEnd
