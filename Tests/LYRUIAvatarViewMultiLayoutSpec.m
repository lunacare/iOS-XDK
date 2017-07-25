#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIAvatarViewMultiLayout.h>
#import <Atlas/LYRUIAvatarView+PrivateProperties.h>
#import <Atlas/LYRUIImageWithLettersView.h>
#import <Atlas/LYRUIPresenceView.h>

SpecBegin(LYRUIAvatarViewMultiLayout)

describe(@"LYRUIAvatarViewMultiLayout", ^{
    __block LYRUIAvatarViewMultiLayout *layout;
    __block LYRUIAvatarView *avatarView;
    __block void(^avatarViewSizeSetup)(CGSize);
    
    beforeEach(^{
        layout = [[LYRUIAvatarViewMultiLayout alloc] init];
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
        context(@"without primary avatar view border", ^{
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
                it(@"should show presence view", ^{
                    expect(avatarView.presenceView.hidden).to.beFalsy();
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
                it(@"should show presence view", ^{
                    expect(avatarView.presenceView.hidden).to.beFalsy();
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
                    CGRect expectedFrame = CGRectMake(8.0, 8.0, 24.0, 24.0);
                    expect(avatarView.primaryAvatarView.frame).to.equal(expectedFrame);
                });
                it(@"should show secondary avatar", ^{
                    expect(avatarView.secondaryAvatarView.hidden).to.beFalsy();
                });
                it(@"should set proper secondary avatar frame", ^{
                    CGRect expectedFrame = CGRectMake(0.0, 0.0, 24.0, 24.0);
                    expect(avatarView.secondaryAvatarView.frame).to.equal(expectedFrame);
                });
                it(@"should hide presence view", ^{
                    expect(avatarView.presenceView.hidden).to.beTruthy();
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
                    CGRect expectedFrame = CGRectMake(10.0, 10.0, 30.0, 30.0);
                    expect(avatarView.primaryAvatarView.frame).to.equal(expectedFrame);
                });
                it(@"should show secondary avatar", ^{
                    expect(avatarView.secondaryAvatarView.hidden).to.beFalsy();
                });
                it(@"should set proper secondary avatar frame", ^{
                    CGRect expectedFrame = CGRectMake(0.0, 0.0, 30.0, 30.0);
                    expect(avatarView.secondaryAvatarView.frame).to.equal(expectedFrame);
                });
                it(@"should hide presence view", ^{
                    expect(avatarView.presenceView.hidden).to.beTruthy();
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
                    CGRect expectedFrame = CGRectMake(12.0, 12.0, 36.0, 36.0);
                    expect(avatarView.primaryAvatarView.frame).to.equal(expectedFrame);
                });
                it(@"should show secondary avatar", ^{
                    expect(avatarView.secondaryAvatarView.hidden).to.beFalsy();
                });
                it(@"should set proper secondary avatar frame", ^{
                    CGRect expectedFrame = CGRectMake(0.0, 0.0, 36.0, 36.0);
                    expect(avatarView.secondaryAvatarView.frame).to.equal(expectedFrame);
                });
                it(@"should hide presence view", ^{
                    expect(avatarView.presenceView.hidden).to.beTruthy();
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
                    CGRect expectedFrame = CGRectMake(18.0, 18.0, 54.0, 54.0);
                    expect(avatarView.primaryAvatarView.frame).to.equal(expectedFrame);
                });
                it(@"should show secondary avatar", ^{
                    expect(avatarView.secondaryAvatarView.hidden).to.beFalsy();
                });
                it(@"should set proper secondary avatar frame", ^{
                    CGRect expectedFrame = CGRectMake(0.0, 0.0, 54.0, 54.0);
                    expect(avatarView.secondaryAvatarView.frame).to.equal(expectedFrame);
                });
                it(@"should hide presence view", ^{
                    expect(avatarView.presenceView.hidden).to.beTruthy();
                });
            });
        });
        
        context(@"with primary avatar view border", ^{
            beforeEach(^{
                avatarView.primaryAvatarView.borderWidth = 2.0;
                avatarView.backgroundColor = [UIColor whiteColor];
            });
            
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
                it(@"should show presence view", ^{
                    expect(avatarView.presenceView.hidden).to.beFalsy();
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
                it(@"should show presence view", ^{
                    expect(avatarView.presenceView.hidden).to.beFalsy();
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
                    CGRect expectedFrame = CGRectMake(6.0, 6.0, 28.0, 28.0);
                    expect(avatarView.primaryAvatarView.frame).to.equal(expectedFrame);
                });
                it(@"should show secondary avatar", ^{
                    expect(avatarView.secondaryAvatarView.hidden).to.beFalsy();
                });
                it(@"should set proper secondary avatar frame", ^{
                    CGRect expectedFrame = CGRectMake(0.0, 0.0, 24.0, 24.0);
                    expect(avatarView.secondaryAvatarView.frame).to.equal(expectedFrame);
                });
                it(@"should hide presence view", ^{
                    expect(avatarView.presenceView.hidden).to.beTruthy();
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
                    CGRect expectedFrame = CGRectMake(8.0, 8.0, 34.0, 34.0);
                    expect(avatarView.primaryAvatarView.frame).to.equal(expectedFrame);
                });
                it(@"should show secondary avatar", ^{
                    expect(avatarView.secondaryAvatarView.hidden).to.beFalsy();
                });
                it(@"should set proper secondary avatar frame", ^{
                    CGRect expectedFrame = CGRectMake(0.0, 0.0, 30.0, 30.0);
                    expect(avatarView.secondaryAvatarView.frame).to.equal(expectedFrame);
                });
                it(@"should hide presence view", ^{
                    expect(avatarView.presenceView.hidden).to.beTruthy();
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
                    CGRect expectedFrame = CGRectMake(10.0, 10.0, 40.0, 40.0);
                    expect(avatarView.primaryAvatarView.frame).to.equal(expectedFrame);
                });
                it(@"should show secondary avatar", ^{
                    expect(avatarView.secondaryAvatarView.hidden).to.beFalsy();
                });
                it(@"should set proper secondary avatar frame", ^{
                    CGRect expectedFrame = CGRectMake(0.0, 0.0, 36.0, 36.0);
                    expect(avatarView.secondaryAvatarView.frame).to.equal(expectedFrame);
                });
                it(@"should hide presence view", ^{
                    expect(avatarView.presenceView.hidden).to.beTruthy();
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
                    CGRect expectedFrame = CGRectMake(16.0, 16.0, 58.0, 58.0);
                    expect(avatarView.primaryAvatarView.frame).to.equal(expectedFrame);
                });
                it(@"should show secondary avatar", ^{
                    expect(avatarView.secondaryAvatarView.hidden).to.beFalsy();
                });
                it(@"should set proper secondary avatar frame", ^{
                    CGRect expectedFrame = CGRectMake(0.0, 0.0, 54.0, 54.0);
                    expect(avatarView.secondaryAvatarView.frame).to.equal(expectedFrame);
                });
                it(@"should hide presence view", ^{
                    expect(avatarView.presenceView.hidden).to.beTruthy();
                });
            });
        });
    });
});

SpecEnd
