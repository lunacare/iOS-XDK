#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIAvatarViewSingleLayout.h>
#import <LayerXDK/LYRUIAvatarView+PrivateProperties.h>
#import <LayerXDK/LYRUIImageWithLettersView.h>
#import <LayerXDK/LYRUIPresenceView.h>

SpecBegin(LYRUIAvatarViewSingleLayout)

describe(@"LYRUIAvatarViewSingleLayout", ^{
    __block LYRUIAvatarViewSingleLayout *layout;
    __block LYRUIAvatarView *avatarView;
    __block void(^avatarViewSizeSetup)(CGSize);
    
    beforeEach(^{
        layout = [[LYRUIAvatarViewSingleLayout alloc] init];
        avatarView = [[LYRUIAvatarView alloc] init];
        avatarView.translatesAutoresizingMaskIntoConstraints = NO;
        avatarView.layout = layout;
        
        avatarViewSizeSetup = ^(CGSize size) {
            [avatarView.widthAnchor constraintEqualToConstant:size.width].active = YES;
            [avatarView.heightAnchor constraintEqualToConstant:size.height].active = YES;
            [avatarView setNeedsLayout];
            [avatarView layoutIfNeeded];
        };
    });
    
    afterEach(^{
        layout = nil;
        avatarView = nil;
    });
    
    describe(@"layout", ^{
        context(@"when view has `Tiny` size", ^{
            beforeEach(^{
                avatarViewSizeSetup(CGSizeMake(12, 12));
            });
            
            it(@"should hide primary avatar", ^{
                expect(avatarView.primaryAvatarView.hidden).to.beTruthy();
            });
            it(@"should hide secondary avatar", ^{
                expect(avatarView.secondaryAvatarView.hidden).to.beTruthy();
            });
            it(@"should set proper presence view frame", ^{
                CGRect expectedFrame = CGRectMake(0.0, 0.0, 12.0, 12.0);
                expect(avatarView.presenceView.frame).to.equal(expectedFrame);
            });
        });
        
        context(@"when view has `Tiny` size, bigger than 12x12", ^{
            beforeEach(^{
                avatarViewSizeSetup(CGSizeMake(30, 30));
            });
            
            it(@"should hide primary avatar", ^{
                expect(avatarView.primaryAvatarView.hidden).to.beTruthy();
            });
            it(@"should hide secondary avatar", ^{
                expect(avatarView.secondaryAvatarView.hidden).to.beTruthy();
            });
            it(@"should set proper presence view frame", ^{
                CGRect expectedFrame = CGRectMake(9.0, 9.0, 12.0, 12.0);
                expect(avatarView.presenceView.frame).to.equal(expectedFrame);
            });
        });
        
        context(@"when view has `Small` size", ^{
            beforeEach(^{
                avatarViewSizeSetup(CGSizeMake(32, 32));
            });
            
            it(@"should show primary avatar", ^{
                expect(avatarView.primaryAvatarView.hidden).to.beFalsy();
            });
            it(@"should set proper primary avatar frame", ^{
                CGRect expectedFrame = CGRectMake(0.0, 0.0, 32.0, 32.0);
                expect(avatarView.primaryAvatarView.frame).to.equal(expectedFrame);
            });
            it(@"should hide secondary avatar", ^{
                expect(avatarView.secondaryAvatarView.hidden).to.beTruthy();
            });
            it(@"should set proper presence view frame", ^{
                CGRect expectedFrame = CGRectMake(20.0, 20.0, 12.0, 12.0);
                expect(avatarView.presenceView.frame).to.equal(expectedFrame);
            });
        });
        
        context(@"when view has `Medium` size", ^{
            beforeEach(^{
                avatarViewSizeSetup(CGSizeMake(40, 40));
            });
            
            it(@"should show primary avatar", ^{
                expect(avatarView.primaryAvatarView.hidden).to.beFalsy();
            });
            it(@"should set proper primary avatar frame", ^{
                CGRect expectedFrame = CGRectMake(0.0, 0.0, 40.0, 40.0);
                expect(avatarView.primaryAvatarView.frame).to.equal(expectedFrame);
            });
            it(@"should hide secondary avatar", ^{
                expect(avatarView.secondaryAvatarView.hidden).to.beTruthy();
            });
            it(@"should set proper presence view frame", ^{
                CGRect expectedFrame = CGRectMake(28.0, 28.0, 12.0, 12.0);
                expect(avatarView.presenceView.frame).to.equal(expectedFrame);
            });
        });
        
        context(@"when view has `Large` size", ^{
            beforeEach(^{
                avatarViewSizeSetup(CGSizeMake(48, 48));
            });
            
            it(@"should show primary avatar", ^{
                expect(avatarView.primaryAvatarView.hidden).to.beFalsy();
            });
            it(@"should set proper primary avatar frame", ^{
                CGRect expectedFrame = CGRectMake(0.0, 0.0, 48.0, 48.0);
                expect(avatarView.primaryAvatarView.frame).to.equal(expectedFrame);
            });
            it(@"should hide secondary avatar", ^{
                expect(avatarView.secondaryAvatarView.hidden).to.beTruthy();
            });
            it(@"should set proper presence view frame", ^{
                CGRect expectedFrame = CGRectMake(34.0, 34.0, 14.0, 14.0);
                expect(avatarView.presenceView.frame).to.equal(expectedFrame);
            });
        });
        
        context(@"when view has `XLarge` size", ^{
            beforeEach(^{
                avatarViewSizeSetup(CGSizeMake(72, 72));
            });
            
            it(@"should show primary avatar", ^{
                expect(avatarView.primaryAvatarView.hidden).to.beFalsy();
            });
            it(@"should set proper primary avatar frame", ^{
                CGRect expectedFrame = CGRectMake(0.0, 0.0, 72.0, 72.0);
                expect(avatarView.primaryAvatarView.frame).to.equal(expectedFrame);
            });
            it(@"should hide secondary avatar", ^{
                expect(avatarView.secondaryAvatarView.hidden).to.beTruthy();
            });
            it(@"should set proper presence view frame", ^{
                CGRect expectedFrame = CGRectMake(56.0, 56.0, 16.0, 16.0);
                expect(avatarView.presenceView.frame).to.equal(expectedFrame);
            });
        });
    });
});

SpecEnd
