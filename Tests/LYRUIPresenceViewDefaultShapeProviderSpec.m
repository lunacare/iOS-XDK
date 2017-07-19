#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIPresenceViewDefaultShapeProvider.h>

SpecBegin(LYRUIPresenceViewDefaultShapeProvider)

describe(@"LYRUIPresenceViewDefaultShapeProvider", ^{
    __block LYRUIPresenceViewDefaultShapeProvider *shapeProvider;
    
    beforeEach(^{
        shapeProvider = [[LYRUIPresenceViewDefaultShapeProvider alloc] init];
    });
    
    afterEach(^{
        shapeProvider = nil;
    });
    
    describe(@"shapeWithSize:", ^{
        __block UIBezierPath *returnedPath;
        
        context(@"for {12, 12} size", ^{
            beforeEach(^{
                returnedPath = [shapeProvider shapeWithSize:CGSizeMake(12, 12)];
            });
            
            it(@"should contain given points", ^{
                expect([returnedPath containsPoint:CGPointMake(2.0, 6.0)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(10.0, 6.0)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(6.0, 2.0)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(6.0, 10.0)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(3.5, 3.5)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(8.5, 3.5)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(8.5, 8.5)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(3.5, 8.5)]).to.beTruthy();
            });
            
            it(@"should not contain given points", ^{
                expect([returnedPath containsPoint:CGPointMake(1.5, 6.0)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(10.5, 6.0)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(6.0, 1.5)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(6.0, 10.5)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(3.0, 3.0)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(9.0, 3.0)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(9.0, 9.0)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(3.0, 9.0)]).to.beFalsy();
            });
        });
        
        context(@"for {14, 14} size", ^{
            beforeEach(^{
                returnedPath = [shapeProvider shapeWithSize:CGSizeMake(14, 14)];
            });
            
            it(@"should contain given points", ^{
                expect([returnedPath containsPoint:CGPointMake(2.0, 7.0)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(12.0, 7.0)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(7.0, 2.0)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(7.0, 12.0)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(3.5, 3.5)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(10.5, 3.5)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(10.5, 10.5)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(3.5, 10.5)]).to.beTruthy();
            });
            
            it(@"should not contain given points", ^{
                expect([returnedPath containsPoint:CGPointMake(1.5, 7.0)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(12.5, 7.0)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(7.0, 1.5)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(7.0, 12.5)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(3.0, 3.0)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(11.0, 3.0)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(11.0, 11.0)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(3.0, 11.0)]).to.beFalsy();
            });
        });
        
        context(@"for {16, 16} size", ^{
            beforeEach(^{
                returnedPath = [shapeProvider shapeWithSize:CGSizeMake(16, 16)];
            });
            
            it(@"should contain given points", ^{
                expect([returnedPath containsPoint:CGPointMake(2.0, 8.0)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(14.0, 8.0)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(8.0, 2.0)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(8.0, 14.0)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(4.0, 4.0)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(12.0, 4.0)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(12.0, 12.0)]).to.beTruthy();
                expect([returnedPath containsPoint:CGPointMake(4.0, 12.0)]).to.beTruthy();
            });
            
            it(@"should not contain given points", ^{
                expect([returnedPath containsPoint:CGPointMake(1.5, 8.0)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(14.5, 8.0)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(8.0, 1.5)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(8.0, 14.5)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(3.5, 3.5)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(12.5, 3.5)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(12.5, 12.5)]).to.beFalsy();
                expect([returnedPath containsPoint:CGPointMake(3.5, 12.5)]).to.beFalsy();
            });
        });
    });
});

SpecEnd
