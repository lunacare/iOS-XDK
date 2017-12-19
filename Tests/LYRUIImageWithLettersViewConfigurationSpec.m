#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIConfiguration+DependencyInjection.h>
#import <Atlas/LYRUIImageWithLettersViewConfiguration.h>
#import <Atlas/LYRUIImageWithLettersView.h>
#import <Atlas/LYRUIImageFetching.h>
#import <Atlas/LYRUIImageCaching.h>
#import <Atlas/LYRUIImageCreating.h>
#import <Atlas/LYRUIInitialsFormatting.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIImageWithLettersViewConfiguration)

describe(@"LYRUIImageWithLettersViewConfiguration", ^{
    __block LYRUIConfiguration *configurationMock;
    __block LYRUIImageWithLettersViewConfiguration *configuration;
    __block LYRUIImageWithLettersView *viewMock;
    __block id<LYRUIImageFetching> imageFetcherMock;
    __block id<LYRUIImageCaching> imagesCacheMock;
    __block id<LYRUIImageCreating> imageFactoryMock;
    __block id<LYRUIInitialsFormatting> initialsFormatterMock;
    
    
    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        
        imageFetcherMock = mockProtocol(@protocol(LYRUIImageFetching));
        [given([configurationMock protocolImplementation:@protocol(LYRUIImageFetching)
                                                forClass:[LYRUIImageWithLettersViewConfiguration class]])
         willReturn:imageFetcherMock];
        
        imagesCacheMock = mockProtocol(@protocol(LYRUIImageCaching));
        [given(configurationMock.imagesCache) willReturn:imagesCacheMock];
        
        imageFactoryMock = mockProtocol(@protocol(LYRUIImageCreating));
        [given([configurationMock protocolImplementation:@protocol(LYRUIImageCreating)
                                                forClass:[LYRUIImageWithLettersViewConfiguration class]])
         willReturn:imageFactoryMock];
        
        initialsFormatterMock = mockProtocol(@protocol(LYRUIInitialsFormatting));
        [given([configurationMock protocolImplementation:@protocol(LYRUIInitialsFormatting)
                                                forClass:[LYRUIImageWithLettersViewConfiguration class]])
         willReturn:initialsFormatterMock];
        
        configuration = [[LYRUIImageWithLettersViewConfiguration alloc] initWithConfiguration:configurationMock];
        
        viewMock = mock([LYRUIImageWithLettersView class]);
    });
    
    afterEach(^{
        configuration = nil;
    });
    
    describe(@"setupImageWithLettersView:withIdentity:", ^{
        __block LYRIdentity *identityMock;
        __block NSURLSessionDownloadTask *oldImageFetchTaskMock;
        
        beforeEach(^{
            identityMock = mock([LYRIdentity class]);
            [given(identityMock.avatarImageURL) willReturn:[NSURL URLWithString:@"http://example.com/avatar.jpg"]];
            [given([initialsFormatterMock initialsForIdentity:identityMock]) willReturn:@"IN"];
            oldImageFetchTaskMock = mock([NSURLSessionDownloadTask class]);
            [given(viewMock.imageFetchTask) willReturn:oldImageFetchTaskMock];
        });
        
        context(@"when identity contains avatar url", ^{
            context(@"and image is cached", ^{
                __block UIImage *cachedImageMock;
                
                beforeEach(^{
                    cachedImageMock = mock([UIImage class]);
                    [given([imagesCacheMock objectForKey:[NSURL URLWithString:@"http://example.com/avatar.jpg"]])
                     willReturn:cachedImageMock];
                    
                    [configuration setupImageWithLettersView:viewMock withIdentity:identityMock];
                });
                
                it(@"should set view's image", ^{
                    [verify(viewMock) setImage:cachedImageMock];
                });
                it(@"should set the letters on view to nil", ^{
                    [verify(viewMock) setLetters:nil];
                });
            });
            
            context(@"and image is not cached", ^{
                __block UIImage *fetchedImageMock;
                
                beforeEach(^{
                    fetchedImageMock = mock([UIImage class]);
                    [given([imagesCacheMock objectForKey:anything()]) willReturn:nil];
                });
                
                context(@"and initials formatter returned initials for the identity", ^{
                    beforeEach(^{
                        [configuration setupImageWithLettersView:viewMock withIdentity:identityMock];
                    });
                    
                    it(@"should set the letters on view", ^{
                        [verify(viewMock) setLetters:@"IN"];
                    });
                    it(@"should set view's image to nil", ^{
                        [(LYRUIImageWithLettersView *)verify(viewMock) setImage:nil];
                    });
                    it(@"should cancel old image fetch task", ^{
                        [verify(oldImageFetchTaskMock) cancel];
                    });
                    it(@"should fetch the image from URL", ^{
                        NSURL *URL = [NSURL URLWithString:@"http://example.com/avatar.jpg"];
                        [verify(imageFetcherMock) fetchImageWithURL:URL andCallback:anything()];
                    });
                    
                    context(@"and image fetcher callback", ^{
                        __block void(^callback)(UIImage *);
                        
                        beforeEach(^{
                            HCArgumentCaptor *callbackArgument = [HCArgumentCaptor new];
                            [verify(imageFetcherMock) fetchImageWithURL:anything() andCallback:(id)callbackArgument];
                            [verify(viewMock) setImage:anything()];
                            [verify(viewMock) setLetters:anything()];
                            callback = callbackArgument.value;
                        });
                        
                        context(@"is called with image", ^{
                            beforeEach(^{
                                callback(fetchedImageMock);
                            });
                            
                            it(@"should set the fetched image on view", ^{
                                [verify(viewMock) setImage:fetchedImageMock];
                            });
                            it(@"should set the view's letters to nil", ^{
                                [verify(viewMock) setLetters:nil];
                            });
                        });
                        
                        context(@"is called with nil", ^{
                            beforeEach(^{
                                callback(nil);
                            });
                            
                            it(@"should not set the view's image to nil", ^{
                                [verifyCount(viewMock, never()) setImage:anything()];
                            });
                            it(@"should not set the view's letters to provided initials", ^{
                                [verifyCount(viewMock, never()) setLetters:anything()];
                            });
                        });
                    });
                });
                
                context(@"and initials formatter returned nil", ^{
                    __block UIImage *placeholderImageMock;
                    
                    beforeEach(^{
                        placeholderImageMock = mock([UIImage class]);
                        [given([imageFactoryMock imageNamed:@"SingleParticipantPlaceholder"]) willReturn:placeholderImageMock];
                        [given([initialsFormatterMock initialsForIdentity:identityMock]) willReturn:nil];
                        [configuration setupImageWithLettersView:viewMock withIdentity:identityMock];
                    });
                    
                    it(@"should set the letters on view to nil", ^{
                        [verify(viewMock) setLetters:nil];
                    });
                    it(@"should set view's image to placeholder", ^{
                        [verify(viewMock) setImage:placeholderImageMock];
                    });
                    it(@"should fetch the image from URL", ^{
                        NSURL *URL = [NSURL URLWithString:@"http://example.com/avatar.jpg"];
                        [verify(imageFetcherMock) fetchImageWithURL:URL andCallback:anything()];
                    });
                    
                    context(@"and image fetcher callback", ^{
                        __block void(^callback)(UIImage *);
                        
                        beforeEach(^{
                            HCArgumentCaptor *callbackArgument = [HCArgumentCaptor new];
                            [verify(imageFetcherMock) fetchImageWithURL:anything() andCallback:(id)callbackArgument];
                            [verify(viewMock) setImage:anything()];
                            [verify(viewMock) setLetters:anything()];
                            callback = callbackArgument.value;
                        });
                        
                        context(@"is called with image", ^{
                            beforeEach(^{
                                callback(fetchedImageMock);
                            });
                            
                            it(@"should set the fetched image on view", ^{
                                [verify(viewMock) setImage:fetchedImageMock];
                            });
                            it(@"should set the view's letters to nil", ^{
                                [verify(viewMock) setLetters:nil];
                            });
                        });
                        
                        context(@"is called with nil", ^{
                            beforeEach(^{
                                callback(nil);
                            });
                            
                            it(@"should not set the view's image to nil", ^{
                                [verifyCount(viewMock, never()) setImage:anything()];
                            });
                            it(@"should not set the view's letters to provided initials", ^{
                                [verifyCount(viewMock, never()) setLetters:anything()];
                            });
                        });
                    });
                });
            });
        });
        
        context(@"when identity does not contain avatar url", ^{
            beforeEach(^{
                [given(identityMock.avatarImageURL) willReturn:nil];
            });
            
            context(@"and initials formatter returned initials for the identity", ^{
                beforeEach(^{
                    [configuration setupImageWithLettersView:viewMock withIdentity:identityMock];
                });
                
                it(@"should not fetch any image", ^{
                    [verifyCount(imageFetcherMock, never()) fetchImageWithURL:anything() andCallback:anything()];
                });
                it(@"should set the view's image to nil", ^{
                    [(LYRUIImageWithLettersView *)verify(viewMock) setImage:nil];
                });
                it(@"should set the view's letters to provided initials", ^{
                    [verify(viewMock) setLetters:@"IN"];
                });
            });
            
            context(@"and initials formatter returned nil", ^{
                __block UIImage *placeholderImageMock;
                
                beforeEach(^{
                    placeholderImageMock = mock([UIImage class]);
                    [given([imageFactoryMock imageNamed:@"SingleParticipantPlaceholder"]) willReturn:placeholderImageMock];
                    [given([initialsFormatterMock initialsForIdentity:identityMock]) willReturn:nil];
                    [configuration setupImageWithLettersView:viewMock withIdentity:identityMock];
                });
                
                it(@"should not fetch any image", ^{
                    [verifyCount(imageFetcherMock, never()) fetchImageWithURL:anything() andCallback:anything()];
                });
                it(@"should set the view's image to nil", ^{
                    [verify(viewMock) setImage:placeholderImageMock];
                });
                it(@"should set the view's letters to nil", ^{
                    [verify(viewMock) setLetters:nil];
                });
            });
        });
    });
});

SpecEnd
