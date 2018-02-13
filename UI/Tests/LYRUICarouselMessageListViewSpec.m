#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUICarouselMessageListView.h>
#import <LayerXDK/LYRUICarouselContentOffsetHandling.h>

SpecBegin(LYRUICarouselMessageListView)

describe(@"LYRUICarouselMessageListView", ^{
    __block LYRUICarouselMessageListView *carouselView;
    
    beforeEach(^{
        carouselView = [[LYRUICarouselMessageListView alloc] init];
    });
    
    afterEach(^{
        carouselView = nil;
    });
    
    context(@"LYRUIViewReusing", ^{
        describe(@"lyr_prepareForReuse", ^{
            __block id<LYRUICarouselContentOffsetHandling> contentOffsetHandlerMock;
            
            beforeEach(^{
                contentOffsetHandlerMock = mockProtocol(@protocol(LYRUICarouselContentOffsetHandling));
                carouselView.contentOffsetHandler = contentOffsetHandlerMock;
                
                [carouselView lyr_prepareForReuse];
            });
            
            it(@"should store carousel content offset, using handler", ^{
                [verify(contentOffsetHandlerMock) storeContentOffsetFromCarousel:carouselView];
            });
        });
    });
});

SpecEnd
