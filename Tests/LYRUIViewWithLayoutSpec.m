#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <Atlas/LYRUIViewWithLayout.h>

SpecBegin(LYRUIViewWithLayout)

describe(@"LYRUIViewWithLayout", ^{
    __block LYRUIViewWithLayout *view;
    
    beforeEach(^{
        view = [[LYRUIViewWithLayout alloc] init];
    });
    
    afterEach(^{
        view = nil;
    });
    
    describe(@"setLayout:", ^{
        __block id<LYRUIViewLayout> layoutMock;
        
        beforeEach(^{
            layoutMock = mockProtocol(@protocol(LYRUIViewLayout));
            
            view.layout = layoutMock;
        });
        
        it(@"should set the view's layout property", ^{
            expect(view.layout).to.equal(layoutMock);
        });
        it(@"should add constraints in the view", ^{
            [verify(layoutMock) addConstraintsInView:view];
        });
        
        context(@"when updating layout", ^{
            __block id<LYRUIViewLayout> newLayoutMock;
            
            beforeEach(^{
                newLayoutMock = mockProtocol(@protocol(LYRUIViewLayout));
                
                view.layout = newLayoutMock;
            });
            
            it(@"should remove old layout constraints from view", ^{
                [verify(layoutMock) removeConstraintsFromView:view];
            });
            it(@"should add new constraints in view", ^{
                [verify(newLayoutMock) addConstraintsInView:view];
            });
            it(@"should update the layout property of view", ^{
                expect(view.layout).to.equal(newLayoutMock);
            });
        });
    });
});

SpecEnd
