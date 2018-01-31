#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIConfiguration+DependencyInjection.h>
#import <Atlas/LYRUIMessageItemViewPresenter.h>
#import <Atlas/LYRUIMessageItemAccessoryViewProviding.h>
#import <Atlas/LYRUIMessageItemView.h>
#import <Atlas/LYRUIAvatarViewProvider.h>
#import <Atlas/LYRUIMessageType.h>
#import <Atlas/LYRUIMessageItemContentPresentersProvider.h>
#import <Atlas/LYRUIMessageItemContentPresenting.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIMessageItemViewPresenter)

describe(@"LYRUIMessageItemViewPresenter", ^{
    __block LYRUIMessageItemViewPresenter *viewPresenter;
    __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
    __block id<LYRUIMessageItemAccessoryViewProviding> accessoryViewProviderMock;
    __block LYRUIMessageItemContentPresentersProvider *contentPresentersProviderMock;
    __block id<LYRUIMessageItemContentPresenting> contentPresenterMock;

    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
        
        accessoryViewProviderMock = mockProtocol(@protocol(LYRUIMessageItemAccessoryViewProviding));
        [given([injectorMock protocolImplementation:@protocol(LYRUIMessageItemAccessoryViewProviding)
                                           forClass:[LYRUIMessageItemViewPresenter class]])
         willReturn:accessoryViewProviderMock];
        
        contentPresentersProviderMock = mock([LYRUIMessageItemContentPresentersProvider class]);
        [given([injectorMock objectOfType:[LYRUIMessageItemContentPresentersProvider class]]) willReturn:contentPresentersProviderMock];
        
        contentPresenterMock = mockProtocol(@protocol(LYRUIMessageItemContentPresenting));
        [given([contentPresentersProviderMock presenterForMessageClass:anything()]) willReturn:contentPresenterMock];
        
        viewPresenter = [[LYRUIMessageItemViewPresenter alloc] initWithConfiguration:configurationMock];
    });

    afterEach(^{
        viewPresenter = nil;
        accessoryViewProviderMock = nil;
    });
    
    describe(@"after initialization", ^{
        it(@"should have default primary accessory view provider set", ^{
            expect(viewPresenter.primaryAccessoryViewProvider).to.equal(accessoryViewProviderMock);
        });
    });
    
    describe(@"setupMessageItemView:withMessage:", ^{
        __block LYRUIMessageItemView *view;
        __block LYRUIMessageType *messageMock;
        __block UIView *accessoryView;
        
        beforeEach(^{
            view = [[LYRUIMessageItemView alloc] init];
            messageMock = mock([LYRUIMessageType class]);
            LYRIdentity *senderMock = mock([LYRIdentity class]);
            [given(senderMock.userID) willReturn:@"test user id"];
            [given(messageMock.sender) willReturn:senderMock];
        });
        
        context(@"with nil 'view' argument", ^{
            it(@"should throw a NSInvalidArgumentException with proper reason", ^{
                void(^callWithNil)() = ^{
                    view = nil;
                    [viewPresenter setupMessageItemView:view
                                                withMessage:messageMock];
                };
                NSString *exceptionReason = @"Cannot setup Message Item View with nil `messageItemView` argument.";
                expect(callWithNil).to.raiseWithReason(NSInvalidArgumentException, exceptionReason);
            });
        });
        
        context(@"with nil 'conversation' argument", ^{
            it(@"should throw a NSInvalidArgumentException with proper reason", ^{
                void(^callWithNil)() = ^{
                    messageMock = nil;
                    [viewPresenter setupMessageItemView:view
                                            withMessage:messageMock];
                };
                NSString *exceptionReason = @"Cannot setup Message Item View with nil `message` argument.";
                expect(callWithNil).to.raiseWithReason(NSInvalidArgumentException, exceptionReason);
            });
        });
        
        context(@"with both arguments passed", ^{
            __block UIView *contentView;
            
            beforeEach(^{
                contentView = [[UIView alloc] init];
                [given([contentPresenterMock viewForMessage:messageMock]) willReturn:contentView];
                [given([contentPresenterMock backgroundColorForMessage:messageMock]) willReturn:UIColor.purpleColor];
                
                accessoryView = [[UIView alloc] init];
                [given([accessoryViewProviderMock accessoryViewForMessage:messageMock]) willReturn:accessoryView];
                
                [viewPresenter setupMessageItemView:view
                                        withMessage:messageMock];
            });
            
            it(@"should set the content view", ^{
                expect(view.contentView).to.equal(contentView);
            });
            it(@"should add the content view as a subview of container", ^{
                expect(contentView.superview).to.equal(view.contentViewContainer);
            });
            it(@"should set the primary accessory view", ^{
                expect(view.primaryAccessoryView).to.equal(accessoryView);
            });
            it(@"should add the primary accessory view as a subview of container", ^{
                expect(accessoryView.superview).to.equal(view.primaryAccessoryViewContainer);
            });
            it(@"should set message content view container color to gray", ^{
                expect(view.contentViewContainer.backgroundColor).to.equal(UIColor.purpleColor);
            });
        });
    });
});

SpecEnd
