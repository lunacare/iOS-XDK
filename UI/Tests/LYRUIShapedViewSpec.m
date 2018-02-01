#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIShapedView.h>
#import <LayerXDK/LYRUIShapedViewDefaultShapeDrawer.h>

SpecBegin(LYRUIShapedView)

describe(@"LYRUIShapedView", ^{
    __block LYRUIShapedView *view;
    
    beforeEach(^{
        view = [[LYRUIShapedView alloc] init];
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
            expect(view.shapeDrawer).to.beAKindOf([LYRUIShapedViewDefaultShapeDrawer class]);
        });
    });
    
    
    describe(@"after initialization from xib", ^{
        beforeEach(^{
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSArray *xibViews = [bundle loadNibNamed:@"LYRUIShapedView" owner:self options:nil];
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
        __block id<LYRUIShapedViewShapeDrawing> shapeDrawerMock;
        
        beforeEach(^{
            shapeDrawerMock = mockProtocol(@protocol(LYRUIShapedViewShapeDrawing));
            view.shapeDrawer = shapeDrawerMock;
            
            [view updateWithFillColor:[UIColor redColor]
                    insideStrokeColor:[UIColor greenColor]
                   outsideStrokeColor:[UIColor blueColor]];
            [view drawRect:CGRectZero];
        });
        
        it(@"should draw the shape using colors", ^{
            [verify(shapeDrawerMock) drawInRect:CGRectZero
                                  withFillColor:[UIColor redColor]
                              insideStrokeColor:[UIColor greenColor]
                             outsideStrokeColor:[UIColor blueColor]];
        });
    });
});

SpecEnd
