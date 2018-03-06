#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIConfiguration+DependencyInjection.h>
#import <LayerXDK/LYRUICarouselContentOffsetHandler.h>
#import <LayerXDK/LYRUICarouselContentOffsetsCache.h>
#import <LayerXDK/LYRUICarouselMessageListView.h>

SpecBegin(LYRUICarouselContentOffsetHandler)

describe(@"LYRUICarouselContentOffsetHandler", ^{
    __block LYRUICarouselContentOffsetHandler *contentOffsetHandler;
    __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
    __block LYRUICarouselContentOffsetsCache *cacheMock;
    __block LYRUICarouselMessageListView *carouselMock;
    __block UICollectionView *collectionViewMock;

    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
        
        cacheMock = mock([LYRUICarouselContentOffsetsCache class]);
        [given([injectorMock objectOfType:[LYRUICarouselContentOffsetsCache class]]) willReturn:cacheMock];
        
        contentOffsetHandler = [[LYRUICarouselContentOffsetHandler alloc] initWithConfiguration:configurationMock];
        contentOffsetHandler.messageIdentifier = @"test message identifier";
        
        carouselMock = mock([LYRUICarouselMessageListView class]);
        collectionViewMock = mock([UICollectionView class]);
        CGPoint contentOffset = CGPointMake(100, 200);
        [given(collectionViewMock.contentOffset) willReturnStruct:&contentOffset objCType:@encode(CGPoint)];
        [given(carouselMock.collectionView) willReturn:collectionViewMock];
    });

    afterEach(^{
        contentOffsetHandler = nil;
        injectorMock = nil;
        configurationMock = nil;
    });

    describe(@"storeContentOffsetFromCarousel:", ^{
        beforeEach(^{
            [contentOffsetHandler storeContentOffsetFromCarousel:carouselMock];
        });
        
        it(@"should store carousel's content offset for the given message id", ^{
            [verify(cacheMock) setContentOffset:CGPointMake(100, 200) forCarouselMessageId:@"test message identifier"];
        });
    });
    
    describe(@"restoreContentOffsetFromCarousel:", ^{
        context(@"when there is content offset cached", ^{
            beforeEach(^{
                CGPoint contentOffset = CGPointMake(10, 20);
                [given([cacheMock contentOffsetForCarouselMessageId:@"test message identifier"])
                 willReturnStruct:&contentOffset objCType:@encode(CGPoint)];
                
                [contentOffsetHandler restoreContentOffsetInCarousel:carouselMock];
            });
            
            it(@"should set the cached content offset on carousel's collection view", ^{
                [verify(collectionViewMock) setContentOffset:CGPointMake(10, 20)];
            });
        });
        
        context(@"when there's no content offset cached", ^{
            beforeEach(^{
                [contentOffsetHandler restoreContentOffsetInCarousel:carouselMock];
            });
            
            it(@"should not set the cached content offset on carousel's collection view", ^{
                [[verifyCount(collectionViewMock, never()) withMatcher:anything()] setContentOffset:CGPointZero];
            });
        });
    });
});

SpecEnd
