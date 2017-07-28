#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIImageFetcher.h>
#import <Atlas/LYRUIImageCaching.h>
#import <Atlas/LYRUIImageCreating.h>
#import <Atlas/LYRUIDataCreating.h>
#import "LYRUISpecDispatcher.h"

SpecBegin(LYRUIImageFetcher)

describe(@"LYRUIImageFetcher", ^{
    __block LYRUIImageFetcher *fetcher;
    __block id<LYRUIImageCaching> imagesCacheMock;
    __block id<LYRUIImageCreating> imagesFactoryMock;
    __block id<LYRUIDataCreating> dataFactoryMock;
    __block id<LYRUIDispatching> dispatcher;
    __block NSURLSession *sessionMock;
    
    beforeEach(^{
        imagesCacheMock = mockProtocol(@protocol(LYRUIImageCaching));
        imagesFactoryMock = mockProtocol(@protocol(LYRUIImageCreating));
        dataFactoryMock = mockProtocol(@protocol(LYRUIDataCreating));
        dispatcher = [[LYRUISpecDispatcher alloc] init];
        sessionMock = mock([NSURLSession class]);
        fetcher = [[LYRUIImageFetcher alloc] initWithImagesCache:imagesCacheMock
                                                    imageFactory:imagesFactoryMock
                                                     dataFactory:dataFactoryMock
                                                      dispatcher:dispatcher
                                                      andSession:sessionMock];
    });
    
    afterEach(^{
        fetcher = nil;
    });
    
    describe(@"downloadTaskWithURL:completionHandler:", ^{
        __block BOOL callbackCalled;
        __block UIImage *capturedImage;
        __block NSURL *URL;
        __block NSURLSessionDownloadTask *downloadTaskMock;
        
        beforeEach(^{
            downloadTaskMock = mock([NSURLSessionDownloadTask class]);
            [given([sessionMock downloadTaskWithURL:anything() completionHandler:anything()]) willReturn:downloadTaskMock];
            
            callbackCalled = NO;
            URL = [NSURL URLWithString:@"http://example.com/image.jpg"];
        });
        
        context(@"when image was cached", ^{
            __block UIImage *cachedImageMock;
            
            beforeEach(^{
                cachedImageMock = mock([UIImage class]);
                [given([imagesCacheMock objectForKey:URL]) willReturn:cachedImageMock];
                
                [fetcher fetchImageWithURL:URL andCallback:^(UIImage * _Nullable image) {
                    callbackCalled = YES;
                    capturedImage = image;
                }];
            });
            
            it(@"should call the callback", ^{
                expect(callbackCalled).to.beTruthy();
            });
            it(@"should pass the cached image to callback", ^{
                expect(capturedImage).to.equal(cachedImageMock);
            });
        });
        
        context(@"when image was not cached", ^{
            beforeEach(^{
                [fetcher fetchImageWithURL:URL andCallback:^(UIImage * _Nullable image) {
                    callbackCalled = YES;
                    capturedImage = image;
                }];
            });
            
            it(@"should not call the callback", ^{
                expect(callbackCalled).to.beFalsy();
            });
            it(@"should create download task", ^{
                [verify(sessionMock) downloadTaskWithURL:URL completionHandler:anything()];
            });
            it(@"should resume the download task", ^{
                [verify(downloadTaskMock) resume];
            });
            
            context(@"when task completion handler", ^{
                __block void(^completionHandler)(NSURL *, NSURLResponse *, NSError *);
                
                beforeEach(^{
                    HCArgumentCaptor *completionHandlerArgument = [HCArgumentCaptor new];
                    [verify(sessionMock) downloadTaskWithURL:URL completionHandler:(id)completionHandlerArgument];
                    completionHandler = completionHandlerArgument.value;
                });
                
                context(@"is called without error and with data location", ^{
                    __block UIImage *fetchedImageMock;
                    
                    beforeEach(^{
                        fetchedImageMock = mock([UIImage class]);
                        NSData *imageDataMock = mock([NSData class]);
                        NSURL *dataURL = [NSURL URLWithString:@"data://path/to/file.jpg"];
                        [given([dataFactoryMock dataWithContentsOfURL:dataURL]) willReturn:imageDataMock];
                        [given([imagesFactoryMock imageWithData:imageDataMock]) willReturn:fetchedImageMock];
                        completionHandler(dataURL, mock([NSURLResponse class]), nil);
                    });
                    
                    it(@"should call the callback", ^{
                        expect(callbackCalled).to.beTruthy();
                    });
                    it(@"should pass the fetched image to callback", ^{
                        expect(capturedImage).to.equal(fetchedImageMock);
                    });
                });
                
                context(@"is called with error", ^{
                    beforeEach(^{
                        completionHandler(nil, mock([NSURLResponse class]), mock([NSError class]));
                    });
                    
                    it(@"should call the callback", ^{
                        expect(callbackCalled).to.beTruthy();
                    });
                    it(@"should call callback with nil argument", ^{
                        expect(capturedImage).to.beNil();
                    });
                });
            });
        });
    });
});

SpecEnd
