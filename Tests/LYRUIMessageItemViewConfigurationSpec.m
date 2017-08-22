#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIMessageItemViewConfiguration.h>
#import <Atlas/LYRUIMessageItemAccessoryViewProviding.h>
#import <Atlas/LYRUIMessageItemView.h>
#import <Atlas/LYRUIAvatarViewProvider.h>
#import <LayerKit/LayerKit.h>

SpecBegin(LYRUIMessageItemViewConfiguration)

describe(@"LYRUIMessageItemViewConfiguration", ^{
    __block LYRUIMessageItemViewConfiguration *viewConfiguration;
    __block id<LYRUIMessageItemAccessoryViewProviding> accessoryViewProviderMock;

    beforeEach(^{
        accessoryViewProviderMock = mockProtocol(@protocol(LYRUIMessageItemAccessoryViewProviding));
        viewConfiguration = [[LYRUIMessageItemViewConfiguration alloc] initWithPrimaryAccessoryViewProvider:accessoryViewProviderMock];
    });

    afterEach(^{
        viewConfiguration = nil;
        accessoryViewProviderMock = nil;
    });
    
    describe(@"after initialization with convenience initializer", ^{
        beforeEach(^{
            viewConfiguration = [[LYRUIMessageItemViewConfiguration alloc] init];
        });
        
        it(@"should have default primary accessory view provider set", ^{
            expect(viewConfiguration.primaryAccessoryViewProvider).to.beAKindOf([LYRUIAvatarViewProvider class]);
        });
    });
    
    describe(@"setupMessageItemView:withMessage:", ^{
        __block LYRUIMessageItemView *view;
        __block LYRMessage *messageMock;
        __block UIView *accessoryView;
        
        beforeEach(^{
            view = [[LYRUIMessageItemView alloc] init];
            messageMock = mock([LYRMessage class]);
            LYRIdentity *senderMock = mock([LYRIdentity class]);
            [given(senderMock.userID) willReturn:@"test user id"];
            [given(messageMock.sender) willReturn:senderMock];
        });
        
        context(@"with nil 'view' argument", ^{
            it(@"should throw a NSInvalidArgumentException with proper reason", ^{
                void(^callWithNil)() = ^{
                    view = nil;
                    [viewConfiguration setupMessageItemView:view
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
                    [viewConfiguration setupMessageItemView:view
                                                withMessage:messageMock];
                };
                NSString *exceptionReason = @"Cannot setup Message Item View with nil `message` argument.";
                expect(callWithNil).to.raiseWithReason(NSInvalidArgumentException, exceptionReason);
            });
        });
        
        context(@"with both arguments passed", ^{
            __block LYRIdentity *currentUserMock;
            
            beforeEach(^{
                accessoryView = [[UIView alloc] init];
                [given([accessoryViewProviderMock accessoryViewForMessage:messageMock]) willReturn:accessoryView];
                
                currentUserMock = mock([LYRIdentity class]);
                viewConfiguration.currentUser = currentUserMock;
            });
            
            context(@"always", ^{
                beforeEach(^{
                    [viewConfiguration setupMessageItemView:view
                                                withMessage:messageMock];
                });
                
                it(@"should set the content view", ^{
                    expect(view.contentView).to.beAKindOf([UITextView class]);
                });
                it(@"should add the content view as a subview of container", ^{
                    expect(view.contentView.superview).to.equal(view.contentViewContainer);
                });
                it(@"should set the primary accessory view", ^{
                    expect(view.primaryAccessoryView).to.equal(accessoryView);
                });
                it(@"should add the primary accessory view as a subview of container", ^{
                    expect(accessoryView.superview).to.equal(view.primaryAccessoryViewContainer);
                });
            });
            
            context(@"when message is incoming", ^{
                beforeEach(^{
                    [given(currentUserMock.userID) willReturn:@"other id"];
                    
                    [viewConfiguration setupMessageItemView:view
                                                withMessage:messageMock];
                });
                
                it(@"should set message content view color to gray", ^{
                    UIColor *expectedColor = [UIColor colorWithWhite:242.0/255.0 alpha:1.0];
                    expect(view.contentViewColor).to.equal(expectedColor);
                });
                it(@"should set text color to black", ^{
                    UIColor *expectedColor = UIColor.blackColor;
                    UITextView *textView = (UITextView *)view.contentView;
                    expect(textView.textColor).to.equal(expectedColor);
                });
            });
            
            context(@"when message is outgoing", ^{
                beforeEach(^{
                    [given(currentUserMock.userID) willReturn:@"test user id"];
                    
                    [viewConfiguration setupMessageItemView:view
                                                withMessage:messageMock];
                });
                
                it(@"should set message content view color to blue", ^{
                    UIColor *expectedColor = [UIColor colorWithRed:16.0/255.0 green:148.0/255.0 blue:208.0/255.0 alpha:1.0];
                    expect(view.contentViewColor).to.equal(expectedColor);
                });
                it(@"should set text color to white", ^{
                    UIColor *expectedColor = UIColor.whiteColor;
                    UITextView *textView = (UITextView *)view.contentView;
                    expect(textView.textColor).to.equal(expectedColor);
                });
            });
        });
    });
});

SpecEnd
