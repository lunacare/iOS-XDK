#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIConfiguration+DependencyInjection.h>
#import <LayerXDK/LYRUIMessageListViewPreviewingDelegate.h>
#import <LayerXDK/LYRUIViewWithAction.h>

SpecBegin(LYRUIMessageListViewPreviewingDelegate)

describe(@"LYRUIMessageListViewPreviewingDelegate", ^{
    __block LYRUIMessageListViewPreviewingDelegate *previewingDelegate;
    __block UIViewController *viewControllerMock;
    __block UIView *viewMock;

    beforeEach(^{
        previewingDelegate = [[LYRUIMessageListViewPreviewingDelegate alloc] init];
        viewControllerMock = mock([UIViewController class]);
        viewMock = mock([UIView class]);
    });

    afterEach(^{
        previewingDelegate = nil;
    });

    describe(@"registerViewControllerForPreviewing:withSourceView:", ^{
        beforeEach(^{
            [previewingDelegate registerViewControllerForPreviewing:viewControllerMock withSourceView:viewMock];
        });
        
        it(@"should register view controlling for previewing with delegate and source view", ^{
            [viewControllerMock registerForPreviewingWithDelegate:previewingDelegate sourceView:viewMock];
        });
    });
    
    describe(@"previewingContext:commitViewController:", ^{
        __block UIViewController *previewViewControllerMock;
        
        beforeEach(^{
            previewViewControllerMock = mock([UIViewController class]);
            [previewingDelegate registerViewControllerForPreviewing:viewControllerMock withSourceView:viewMock];
            
            [previewingDelegate previewingContext:mockProtocol(@protocol(UIViewControllerPreviewing))
                             commitViewController:previewViewControllerMock];
        });
        
        it(@"should present preview view controller using the view controller registered for previewing", ^{
            [verify(viewControllerMock) presentViewController:previewViewControllerMock
                                                     animated:YES
                                                   completion:nil];
        });
    });
    
    describe(@"previewingContext:viewControllerForLocation:", ^{
        __block UIViewController *returnedViewController;
        __block UIView *touchedViewMock;
        
        beforeEach(^{
            touchedViewMock = mock([UIView class]);
            CGPoint location = CGPointMake(100, 200);
            [given([viewMock hitTest:location withEvent:nil]) willReturn:touchedViewMock];
            
            [previewingDelegate registerViewControllerForPreviewing:viewControllerMock withSourceView:viewMock];
        });
        
        context(@"when there is no view conforming to `LYRUIViewWithAction` in hierarchy", ^{
            beforeEach(^{
                returnedViewController = [previewingDelegate  previewingContext:mockProtocol(@protocol(UIViewControllerPreviewing))
                                                      viewControllerForLocation:CGPointMake(100, 200)];
            });
            
            it(@"should return nil", ^{
                expect(returnedViewController).to.beNil();
            });
        });
        
        context(@"when there is a view conforming to `LYRUIViewWithAction` in hierarchy", ^{
            __block UIView<LYRUIViewWithAction> *viewWithActionMock;
            
            beforeEach(^{
                viewWithActionMock = mockObjectAndProtocol([UIView class], @protocol(LYRUIViewWithAction));
                [given([touchedViewMock superview]) willReturn:viewWithActionMock];
            });
            
            context(@"but does not have action preview handler set", ^{
                beforeEach(^{
                    returnedViewController = [previewingDelegate  previewingContext:mockProtocol(@protocol(UIViewControllerPreviewing))
                                                          viewControllerForLocation:CGPointMake(100, 200)];
                });
                
                it(@"should return nil", ^{
                    expect(returnedViewController).to.beNil();
                });
            });
            
            context(@"and it has a action preview handler set", ^{
                __block UIViewController *previewViewControllerMock;
                
                beforeEach(^{
                    previewViewControllerMock = mock([UIViewController class]);
                    [given(viewWithActionMock.actionPreviewHandler) willReturn:^UIViewController *{
                        return previewViewControllerMock;
                    }];
                    
                    returnedViewController = [previewingDelegate  previewingContext:mockProtocol(@protocol(UIViewControllerPreviewing))
                                                          viewControllerForLocation:CGPointMake(100, 200)];
                });
                
                it(@"should return preview view controller returned by action preview handler", ^{
                    expect(returnedViewController).to.equal(previewViewControllerMock);
                });
            });
        });
    });
});

SpecEnd
