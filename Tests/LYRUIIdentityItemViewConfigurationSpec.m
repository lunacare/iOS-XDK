#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIConfiguration+DependencyInjection.h>
#import <Atlas/LYRUIIdentityItemViewConfiguration.h>
#import <Atlas/LYRUIIdentityItemView.h>
#import <Atlas/LYRUITimeAgoFormatter.h>
#import <Atlas/LYRUIIdentityNameFormatter.h>
#import <Atlas/LYRUIIdentityItemAccessoryViewProvider.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIIdentityItemViewConfiguration)

describe(@"LYRUIIdentityItemViewConfiguration", ^{
    __block LYRUIIdentityItemViewConfiguration *viewConfiguration;
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
                                                forClass:[LYRUIIdentityItemViewConfiguration class]])
         willReturn:accessoryViewProviderMock];
        
        nameFormatterMock = mockProtocol(@protocol(LYRUIIdentityNameFormatting));
        [given([injectorMock protocolImplementation:@protocol(LYRUIIdentityNameFormatting)
                                                forClass:[LYRUIIdentityItemViewConfiguration class]])
         willReturn:nameFormatterMock];
          
        lastSeenAtTimeFormatter = mockProtocol(@protocol(LYRUITimeFormatting));
        [given([injectorMock protocolImplementation:@protocol(LYRUITimeFormatting)
                                                forClass:[LYRUIIdentityItemViewConfiguration class]])
         willReturn:lastSeenAtTimeFormatter];
           
        viewConfiguration = [[LYRUIIdentityItemViewConfiguration alloc] initWithConfiguration:configurationMock];
        
        metadataFormatter = ^ NSString *(NSDictionary *metadata) {
            return metadata[@"test key"];
        };
        viewConfiguration.metadataFormatter = metadataFormatter;
    });
    
    afterEach(^{
        viewConfiguration = nil;
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
                    [viewConfiguration setupIdentityItemView:view
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
                    [viewConfiguration setupIdentityItemView:view
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
                
                [viewConfiguration setupIdentityItemView:view
                                           withIdentity:identityMock];
            });
            
            it(@"should setup view with configuration", ^{
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
    });
});

SpecEnd
