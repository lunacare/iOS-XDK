#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIPresenceView.h>
#import <Atlas/LYRUIPresenceViewDefaultShapeProvider.h>

SpecBegin(LYRUIPresenceView)

describe(@"LYRUIPresenceView", ^{
    __block LYRUIPresenceView *view;
    
    beforeEach(^{
        view = [[LYRUIPresenceView alloc] init];
    });
    
    afterEach(^{
        view = nil;
    });
    
    describe(@"after initialization", ^{
        it(@"should have background color set to clear color", ^{
            expect(view.backgroundColor).to.equal([UIColor clearColor]);
        });
        it(@"should have fill color set to proper color", ^{
            UIColor *expectedColor = [UIColor colorWithRed:(87.0/255.0) green:(191.0/255.0) blue:(70.0/255.0) alpha:1.0];
            expect(view.fillColor).to.equal(expectedColor);
        });
        it(@"should have inside stroke color set to clear color", ^{
            expect(view.insideStrokeColor).to.equal([UIColor clearColor]);
        });
        it(@"should have outside stroke color set to clear color", ^{
            expect(view.outsideStrokeColor).to.equal([UIColor clearColor]);
        });
        it(@"should have default shape provider set", ^{
            expect(view.shapeProvider).to.beAKindOf([LYRUIPresenceViewDefaultShapeProvider class]);
        });
    });
    
    
    describe(@"after initialization from xib", ^{
        beforeEach(^{
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSArray *xibViews = [bundle loadNibNamed:@"LYRUIPresenceView" owner:self options:nil];
            view = [xibViews objectAtIndex:0];
        });
        
        it(@"should have fill color set to value from Interface Builder", ^{
            UIColor *expectedColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
            expect(view.fillColor).to.equal(expectedColor);
        });
        it(@"should have inside stroke color set to value from Interface Builder", ^{
            UIColor *expectedColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
            expect(view.insideStrokeColor).to.equal(expectedColor);
        });
        it(@"should have outside stroke color set to value from Interface Builder", ^{
            UIColor *expectedColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            expect(view.outsideStrokeColor).to.equal(expectedColor);
        });
    });
    
    describe(@"drawRect:", ^{
        __block id<LYRUIPresenceViewShapeProviding> shapeProviderMock;
        __block UIBezierPath *bezierPathMock;
        __block UIColor *fillColorMock;
        __block UIColor *insideStrokeColorMock;
        __block UIColor *outsideStrokeColorMock;
        
        beforeEach(^{
            shapeProviderMock = mockProtocol(@protocol(LYRUIPresenceViewShapeProviding));
            bezierPathMock = mock([UIBezierPath class]);
            [[given([shapeProviderMock shapeWithSize:CGSizeZero]) withMatcher:anything()] willReturn:bezierPathMock];
            view.shapeProvider = shapeProviderMock;
            
            fillColorMock = mock([UIColor class]);
            insideStrokeColorMock = mock([UIColor class]);
            outsideStrokeColorMock = mock([UIColor class]);
            [view updateWithFillColor:[UIColor clearColor]
                    insideStrokeColor:[UIColor clearColor]
                   outsideStrokeColor:[UIColor clearColor]];
        });
        
        context(@"when shape provider returns nil path", ^{
            beforeEach(^{
                [[given([shapeProviderMock shapeWithSize:CGSizeZero]) withMatcher:anything()] willReturn:nil];
            });
            
            it(@"should throw a NSObjectNotAvailableException with proper reason", ^{
                void(^callWithNil)() = ^{
                    [view drawRect:CGRectZero];
                };
                NSString *exceptionReason = @"Object conforming to `LYRUIPresenceViewShapesProviding` returned nil from `nonnull` returning method `shapeForPresenceStatus`.";
                expect(callWithNil).to.raiseWithReason(NSObjectNotAvailableException, exceptionReason);
            });
        });
        
        context(@"when shape provider returns a path", ^{
            context(@"when fill color is a non-clear color", ^{
                beforeEach(^{
                    view.fillColor = fillColorMock;
                    [view drawRect:CGRectZero];
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
                    [view drawRect:CGRectZero];
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
                        view.outsideStrokeColor = outsideStrokeColorMock;
                        [view drawRect:CGRectZero];
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
                        [view drawRect:CGRectZero];
                    });
                    
                    it(@"should not stroke the path", ^{
                        [verifyCount(bezierPathMock, never()) stroke];
                    });
                });
                
                context(@"and inside stroke color is a non-clear color", ^{
                    beforeEach(^{
                        view.insideStrokeColor = insideStrokeColorMock;
                        [view drawRect:CGRectZero];
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
                        [view drawRect:CGRectZero];
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
                        view.outsideStrokeColor = outsideStrokeColorMock;
                        [view drawRect:CGRectZero];
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
                        [view drawRect:CGRectZero];
                    });
                    
                    it(@"should not stroke the path", ^{
                        [verifyCount(bezierPathMock, never()) stroke];
                    });
                });
                
                context(@"and inside stroke color is a non-clear color", ^{
                    beforeEach(^{
                        view.insideStrokeColor = insideStrokeColorMock;
                        [view drawRect:CGRectZero];
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
                        [view drawRect:CGRectZero];
                    });
                    
                    it(@"should not stroke the path", ^{
                        [verifyCount(bezierPathMock, never()) stroke];
                    });
                });
            });
        });
    });
});

SpecEnd
