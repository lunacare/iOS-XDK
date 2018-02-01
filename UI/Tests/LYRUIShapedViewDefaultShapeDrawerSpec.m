#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIShapedViewDefaultShapeDrawer.h>

SpecBegin(LYRUIShapedViewDefaultShapeDrawer)

describe(@"LYRUIShapedViewDefaultShapeDrawer", ^{
    __block LYRUIShapedViewDefaultShapeDrawer *shapeDrawer;
    
    beforeEach(^{
        shapeDrawer = [[LYRUIShapedViewDefaultShapeDrawer alloc] init];
    });
    
    afterEach(^{
        shapeDrawer = nil;
    });
    
    describe(@"bezierPathForSize:", ^{
        __block UIBezierPath *returnedPath;
        
        context(@"for {12, 12} size", ^{
            beforeEach(^{
                returnedPath = [shapeDrawer bezierPathForSize:CGSizeMake(12, 12)];
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
                returnedPath = [shapeDrawer bezierPathForSize:CGSizeMake(14, 14)];
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
                returnedPath = [shapeDrawer bezierPathForSize:CGSizeMake(16, 16)];
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
    
    describe(@"", ^{
        __block UIBezierPath *bezierPathMock;
        __block UIColor *fillColorMock;
        __block UIColor *insideStrokeColorMock;
        __block UIColor *outsideStrokeColorMock;
        
        beforeEach(^{
            bezierPathMock = mock([UIBezierPath class]);
            
            fillColorMock = mock([UIColor class]);
            insideStrokeColorMock = mock([UIColor class]);
            outsideStrokeColorMock = mock([UIColor class]);
        });
        
        context(@"when fill color is a non-clear color", ^{
            beforeEach(^{
                [shapeDrawer drawBezierPath:bezierPathMock
                              withFillColor:fillColorMock
                          insideStrokeColor:[UIColor clearColor]
                         outsideStrokeColor:[UIColor clearColor]];
            });
            
            it(@"should set fill color", ^{
                [verify(fillColorMock) setFill];
            });
            it(@"should fill the path", ^{
                [verify(bezierPathMock) fill];
            });
        });
        
        context(@"and fill color is a clear color", ^{
            beforeEach(^{
                [shapeDrawer drawBezierPath:bezierPathMock
                              withFillColor:[UIColor clearColor]
                          insideStrokeColor:[UIColor clearColor]
                         outsideStrokeColor:[UIColor clearColor]];
            });
            
            it(@"should not fill the path", ^{
                [verifyCount(bezierPathMock, never()) fill];
            });
        });
        
        context(@"when path line width is 0", ^{
            beforeEach(^{
                [given(bezierPathMock.lineWidth) willReturnFloat:0.0];
            });
            
            context(@"and outside stroke color is a non-clear color", ^{
                beforeEach(^{
                    [shapeDrawer drawBezierPath:bezierPathMock
                                  withFillColor:[UIColor clearColor]
                              insideStrokeColor:[UIColor clearColor]
                             outsideStrokeColor:outsideStrokeColorMock];
                });
                
                it(@"should not set stroke color", ^{
                    [verifyCount(outsideStrokeColorMock, never()) setStroke];
                });
                it(@"should not stroke the path", ^{
                    [verifyCount(bezierPathMock, never()) stroke];
                });
            });
            
            context(@"and outside stroke color is a clear color", ^{
                beforeEach(^{
                    [shapeDrawer drawBezierPath:bezierPathMock
                                  withFillColor:[UIColor clearColor]
                              insideStrokeColor:[UIColor clearColor]
                             outsideStrokeColor:[UIColor clearColor]];
                });
                
                it(@"should not stroke the path", ^{
                    [verifyCount(bezierPathMock, never()) stroke];
                });
            });
            
            context(@"and inside stroke color is a non-clear color", ^{
                beforeEach(^{
                    [shapeDrawer drawBezierPath:bezierPathMock
                                  withFillColor:[UIColor clearColor]
                              insideStrokeColor:insideStrokeColorMock
                             outsideStrokeColor:[UIColor clearColor]];
                });
                
                it(@"should not set stroke color", ^{
                    [verifyCount(insideStrokeColorMock, never()) setStroke];
                });
                it(@"should not stroke the path", ^{
                    [verifyCount(bezierPathMock, never()) stroke];
                });
            });
            
            context(@"and inside stroke color is a clear color", ^{
                beforeEach(^{
                    [shapeDrawer drawBezierPath:bezierPathMock
                                  withFillColor:[UIColor clearColor]
                              insideStrokeColor:[UIColor clearColor]
                             outsideStrokeColor:[UIColor clearColor]];
                });
                
                it(@"should not stroke the path", ^{
                    [verifyCount(bezierPathMock, never()) stroke];
                });
            });
        });
        
        context(@"when path line width is higher than 0", ^{
            beforeEach(^{
                [given(bezierPathMock.lineWidth) willReturnFloat:1.0];
            });
            
            context(@"and outside stroke color is a non-clear color", ^{
                beforeEach(^{
                    [shapeDrawer drawBezierPath:bezierPathMock
                                  withFillColor:[UIColor clearColor]
                              insideStrokeColor:[UIColor clearColor]
                             outsideStrokeColor:outsideStrokeColorMock];
                });
                
                it(@"should set stroke color", ^{
                    [verify(outsideStrokeColorMock) setStroke];
                });
                it(@"should stroke the path", ^{
                    [verify(bezierPathMock) stroke];
                });
            });
            
            context(@"and outside stroke color is a clear color", ^{
                beforeEach(^{
                    [shapeDrawer drawBezierPath:bezierPathMock
                                  withFillColor:[UIColor clearColor]
                              insideStrokeColor:[UIColor clearColor]
                             outsideStrokeColor:[UIColor clearColor]];
                });
                
                it(@"should not stroke the path", ^{
                    [verifyCount(bezierPathMock, never()) stroke];
                });
            });
            
            context(@"and inside stroke color is a non-clear color", ^{
                beforeEach(^{
                    [shapeDrawer drawBezierPath:bezierPathMock
                                  withFillColor:[UIColor clearColor]
                              insideStrokeColor:insideStrokeColorMock
                             outsideStrokeColor:[UIColor clearColor]];
                });
                
                it(@"should set stroke color", ^{
                    [verify(insideStrokeColorMock) setStroke];
                });
                it(@"should stroke the path", ^{
                    [verify(bezierPathMock) stroke];
                });
            });
            
            context(@"and inside stroke color is a clear color", ^{
                beforeEach(^{
                    [shapeDrawer drawBezierPath:bezierPathMock
                                  withFillColor:[UIColor clearColor]
                              insideStrokeColor:[UIColor clearColor]
                             outsideStrokeColor:[UIColor clearColor]];
                });
                
                it(@"should not stroke the path", ^{
                    [verifyCount(bezierPathMock, never()) stroke];
                });
            });
        });
    });
});

SpecEnd
