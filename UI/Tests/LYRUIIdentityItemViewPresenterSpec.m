#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIConfiguration+DependencyInjection.h>
#import <LayerXDK/LYRUIIdentityItemViewPresenter.h>
#import <LayerXDK/LYRUIIdentityItemView.h>
#import <LayerXDK/LYRUITimeAgoFormatter.h>
#import <LayerXDK/LYRUIIdentityNameFormatter.h>
#import <LayerXDK/LYRUIIdentityItemAccessoryViewProviding.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIIdentityItemViewPresenter)

describe(@"LYRUIIdentityItemViewPresenter", ^{
    __block LYRUIIdentityItemViewPresenter *viewPresenter;
    __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
    __block id<LYRUIIdentityItemAccessoryViewProviding> accessoryViewProviderMock;
    __block id<LYRUIIdentityNameFormatting> nameFormatterMock;
    __block id<LYRUITimeFormatting> lastSeenAtTimeFormatter;
    __block LYRUIIdentityMetadataFormatting metadataFormatter;
    
    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
        
        accessoryViewProviderMock = mockProtocol(@protocol(LYRUIIdentityItemAccessoryViewProviding));
        [given([injectorMock protocolImplementation:@protocol(LYRUIIdentityItemAccessoryViewProviding)
                                                forClass:[LYRUIIdentityItemViewPresenter class]])
         willReturn:accessoryViewProviderMock];
        
        nameFormatterMock = mockProtocol(@protocol(LYRUIIdentityNameFormatting));
        [given([injectorMock protocolImplementation:@protocol(LYRUIIdentityNameFormatting)
                                                forClass:[LYRUIIdentityItemViewPresenter class]])
         willReturn:nameFormatterMock];
          
        lastSeenAtTimeFormatter = mockProtocol(@protocol(LYRUITimeFormatting));
        [given([injectorMock protocolImplementation:@protocol(LYRUITimeFormatting)
                                                forClass:[LYRUIIdentityItemViewPresenter class]])
         willReturn:lastSeenAtTimeFormatter];
           
        viewPresenter = [[LYRUIIdentityItemViewPresenter alloc] initWithConfiguration:configurationMock];
        
        metadataFormatter = ^ NSString *(NSDictionary *metadata) {
            return metadata[@"test key"];
        };
        viewPresenter.metadataFormatter = metadataFormatter;
    });
    
    afterEach(^{
        viewPresenter = nil;
    });
    
    describe(@"setupIdentityItemView:withIdentity:", ^{
        __block LYRUIIdentityItemView *view;
        __block LYRIdentity *identityMock;
        __block UIView *accessoryView;
        
        beforeEach(^{
            view = [[LYRUIIdentityItemView alloc] init];
            identityMock = mock([LYRIdentity class]);
        });
        
        context(@"with nil 'view' argument", ^{
            it(@"should throw a NSInvalidArgumentException with proper reason", ^{
                void(^callWithNil)() = ^{
                    view = nil;
                    [viewPresenter setupIdentityItemView:view
                                                withIdentity:identityMock];
                };
                NSString *exceptionReason = @"Cannot setup Identity Item View with nil `view` argument.";
                expect(callWithNil).to.raiseWithReason(NSInvalidArgumentException, exceptionReason);
            });
        });
        
        context(@"with nil 'conversation' argument", ^{
            it(@"should throw a NSInvalidArgumentException with proper reason", ^{
                void(^callWithNil)() = ^{
                    identityMock = nil;
                    [viewPresenter setupIdentityItemView:view
                                                withIdentity:identityMock];
                };
                NSString *exceptionReason = @"Cannot setup Identity Item View with nil `identity` argument.";
                expect(callWithNil).to.raiseWithReason(NSInvalidArgumentException, exceptionReason);
            });
        });
        
        context(@"with both arguments passed", ^{
            beforeEach(^{
                NSDate *lastSeenAtMock = mock([NSDate class]);
                [given(identityMock.lastSeenAt) willReturn:lastSeenAtMock];
                accessoryView = [[UIView alloc] init];
                
                [given([accessoryViewProviderMock accessoryViewForIdentity:identityMock]) willReturn:accessoryView];
                [given([nameFormatterMock nameForIdentity:identityMock]) willReturn:@"test title"];
                [given([lastSeenAtTimeFormatter stringForTime:lastSeenAtMock withCurrentTime:anything()]) willReturn:@"test time description"];
                [given(identityMock.metadata) willReturn:@{ @"test key": @"test metadata value" }];
                
                [viewPresenter setupIdentityItemView:view
                                           withIdentity:identityMock];
            });
            
            it(@"should setup view with presenter", ^{
                expect(view.layerConfiguration).to.equal(configurationMock);
            });
            it(@"should set the text of titleLabel", ^{
                expect(view.titleLabel.text).to.equal(@"test title");
            });
            it(@"should set the text of subtitleLabel", ^{
                expect(view.subtitleLabel.text).to.equal(@"test metadata value");
            });
            it(@"should set the text of detailLabel", ^{
                expect(view.detailLabel.text).to.equal(@"test time description");
            });
            it(@"should set the accessory view", ^{
                expect(view.accessoryView).to.equal(accessoryView);
            });
            it(@"should add the accessory view as a subview of conversation item view", ^{
                expect(accessoryView.superview).to.equal(view.accessoryViewContainer);
            });
        });
        
        context(@"with both arguments passed, and identity `lastSeenAt` is nil", ^{
            beforeEach(^{
                [given(identityMock.lastSeenAt) willReturn:nil];
                [viewPresenter setupIdentityItemView:view
                                        withIdentity:identityMock];
            });
            
            it(@"should set the text of detailLabel to \"Not seen\"", ^{
                expect(view.detailLabel.text).to.equal(@"Not seen");
            });
        });
    });
});

SpecEnd
