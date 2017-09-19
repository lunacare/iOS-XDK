#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIIdentityItemViewConfigurator.h>
#import <Atlas/LYRUIIdentityItemView.h>
#import <Atlas/LYRUITimeAgoFormatter.h>
#import <Atlas/LYRUIIdentityNameFormatter.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIIdentityItemViewConfigurator)

describe(@"LYRUIIdentityItemViewConfigurator", ^{
    __block LYRUIIdentityItemViewConfigurator *viewConfigurator;
    __block id<LYRUIIdentityItemAccessoryViewProviding> accessoryViewProviderMock;
    __block id<LYRUIIdentityNameFormatting> nameFormatterMock;
    __block id<LYRUITimeFormatting> lastSeenAtTimeFormatter;
    
    beforeEach(^{
        accessoryViewProviderMock = mockProtocol(@protocol(LYRUIIdentityItemAccessoryViewProviding));
        nameFormatterMock = mockProtocol(@protocol(LYRUIIdentityNameFormatting));
        lastSeenAtTimeFormatter = mockProtocol(@protocol(LYRUITimeFormatting));
        viewConfigurator = [[LYRUIIdentityItemViewConfigurator alloc] initWithAccessoryViewProvider:accessoryViewProviderMock
                                                                                    nameFormatter:nameFormatterMock
                                                                          lastSeenAtTimeFormatter:lastSeenAtTimeFormatter];
    });
    
    afterEach(^{
        viewConfigurator = nil;
    });
    
    describe(@"after initialization with convenience initializer", ^{
        beforeEach(^{
            viewConfigurator = [[LYRUIIdentityItemViewConfigurator alloc] init];
        });
        
        it(@"should have default name formatter set", ^{
            expect(viewConfigurator.nameFormatter).to.beAKindOf([LYRUIIdentityNameFormatter class]);
        });
        
        it(@"should have default last seen at time formatter set", ^{
            expect(viewConfigurator.lastSeenAtTimeFormatter).to.beAKindOf([LYRUITimeAgoFormatter class]);
        });
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
                    [viewConfigurator setupIdentityItemView:view
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
                    [viewConfigurator setupIdentityItemView:view
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
                
                [viewConfigurator setupIdentityItemView:view
                                           withIdentity:identityMock];
            });
            
            it(@"should set the text of titleLabel", ^{
                expect(view.titleLabel.text).to.equal(@"test title");
            });
            it(@"should not set the text of messageLabel", ^{
                expect(view.messageLabel.text).to.beNil();
            });
            it(@"should set the text of timeLabel", ^{
                expect(view.timeLabel.text).to.equal(@"test time description");
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
