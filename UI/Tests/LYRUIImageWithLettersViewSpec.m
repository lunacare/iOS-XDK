#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIImageWithLettersView.h>

SpecBegin(LYRUIImageWithLettersView)

describe(@"LYRUIImageWithLettersView", ^{
    __block LYRUIImageWithLettersView *view;
    
    beforeEach(^{
        view = [[LYRUIImageWithLettersView alloc] init];
    });
    
    afterEach(^{
        view = nil;
    });
    
    describe(@"after initialization", ^{
        it(@"should have default letters color set to clear color", ^{
            expect(view.backgroundColor).to.equal([UIColor clearColor]);
        });
        it(@"should have default avatar background color set to gray", ^{
            UIColor *expectedColor = [UIColor colorWithRed:219.0/255.0 green:222.0/255.0 blue:228.0/255.0 alpha:1.0];
            expect(view.avatarBackgroundColor).to.equal(expectedColor);
        });
        it(@"should have default letters color set to white", ^{
            expect(view.lettersColor).to.equal([UIColor whiteColor]);
        });
    });
    
    describe(@"after initialization from xib", ^{
        context(@"with colors and text set", ^{
            beforeEach(^{
                NSBundle *bundle = [NSBundle bundleForClass:[self class]];
                NSArray<LYRUIImageWithLettersView *> *xibViews = [bundle loadNibNamed:@"LYRUIImageWithLettersView" owner:self options:nil];
                view = [xibViews objectAtIndex:0];
            });
            
            it(@"should have avatar background color set to value from Interface Builder", ^{
                UIColor *expectedColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
                expect(view.avatarBackgroundColor).to.equal(expectedColor);
            });
            it(@"should have letters color set to value from Interface Builder", ^{
                UIColor *expectedColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
                expect(view.lettersColor).to.equal(expectedColor);
            });
            it(@"should have letters set to value from Interface Builder", ^{
                expect(view.letters).to.equal(@"NC");
            });
            it(@"should have border color set to value from Interface Builder", ^{
                UIColor *expectedColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
                expect(view.borderColor).to.equal(expectedColor);
            });
            it(@"should have border width set to value from Interface Builder", ^{
                expect(view.borderWidth).to.equal(2.0);
            });
        });
        
        context(@"with image set", ^{
            beforeEach(^{
                NSBundle *bundle = [NSBundle bundleForClass:[self class]];
                NSArray<LYRUIImageWithLettersView *> *xibViews = [bundle loadNibNamed:@"LYRUIImageWithLettersView" owner:self options:nil];
                view = [xibViews objectAtIndex:1];
            });
            
            it(@"should have image set to value from Interface Builder", ^{
                expect(view.image).notTo.beNil();
            });
        });
        
        context(@"with image and text set", ^{
            beforeEach(^{
                NSBundle *bundle = [NSBundle bundleForClass:[self class]];
                NSArray<LYRUIImageWithLettersView *> *xibViews = [bundle loadNibNamed:@"LYRUIImageWithLettersView" owner:self options:nil];
                view = [xibViews objectAtIndex:1];
            });
            
            it(@"should have image set to value from Interface Builder", ^{
                expect(view.image).notTo.beNil();
            });
        });
    });
    
    describe(@"layout", ^{
        __block void(^setViewSize)(CGSize);
        
        beforeEach(^{
            view.translatesAutoresizingMaskIntoConstraints = NO;
            setViewSize = ^(CGSize size) {
                [view.widthAnchor constraintEqualToConstant:size.width].active = YES;
                [view.heightAnchor constraintEqualToConstant:size.height].active = YES;
                [view setNeedsLayout];
                [view layoutIfNeeded];
            };
        });
        
        context(@"when text is not nil", ^{
            beforeEach(^{
                view.letters = @"NC";
            });
            
            context(@"when view is square", ^{
                beforeEach(^{
                    setViewSize(CGSizeMake(32.0, 32.0));
                });
                
                it(@"should resize the image view to fill view", ^{
                    expect(view.subviews.firstObject.frame).to.equal(CGRectMake(0.0, 0.0, 32.0, 32.0));
                });
                it(@"should set label frame to fit text, centered in superview", ^{
                    expect(view.subviews.lastObject.frame).to.equal(CGRectMake(4.0, 6.0, 24.5, 20.5));
                });
            });
            
            context(@"when view is horizontal rectangle", ^{
                beforeEach(^{
                    setViewSize(CGSizeMake(64.0, 32.0));
                });
                
                it(@"should resize the image view to be a centered square", ^{
                    expect(view.subviews.firstObject.frame).to.equal(CGRectMake(16.0, 0.0, 32.0, 32.0));
                });
                it(@"should set label frame to fit text, centered in superview", ^{
                    expect(view.subviews.lastObject.frame).to.equal(CGRectMake(20.0, 6.0, 24.5, 20.5));
                });
            });
            
            context(@"when view is vertical rectangle", ^{
                beforeEach(^{
                    setViewSize(CGSizeMake(32.0, 64.0));
                });
                
                it(@"should resize the image view to be a centered square", ^{
                    expect(view.subviews.firstObject.frame).to.equal(CGRectMake(0.0, 16.0, 32.0, 32.0));
                });
                it(@"should set label frame to fit text, centered in superview", ^{
                    expect(view.subviews.lastObject.frame).to.equal(CGRectMake(4.0, 22.0, 24.5, 20.5));
                });
            });
        });
        
        context(@"when text is nil", ^{
            beforeEach(^{
                view.letters = nil;
            });
            
            context(@"when view is square", ^{
                beforeEach(^{
                    setViewSize(CGSizeMake(32.0, 32.0));
                });
                
                it(@"should resize the image view to fill view", ^{
                    expect(view.subviews.firstObject.frame).to.equal(CGRectMake(0.0, 0.0, 32.0, 32.0));
                });
                it(@"should set label frame to centered zero size", ^{
                    expect(view.subviews.lastObject.frame).to.equal(CGRectMake(16.0, 16.0, 0.0, 0.0));
                });
            });
            
            context(@"when view is horizontal rectangle", ^{
                beforeEach(^{
                    setViewSize(CGSizeMake(64.0, 32.0));
                });
                
                it(@"should resize the image view to be a centered square", ^{
                    expect(view.subviews.firstObject.frame).to.equal(CGRectMake(16.0, 0.0, 32.0, 32.0));
                });
                it(@"should set label frame to centered zero size", ^{
                    expect(view.subviews.lastObject.frame).to.equal(CGRectMake(32.0, 16.0, 0.0, 0.0));
                });
            });

            context(@"when view is vertical rectangle", ^{
                beforeEach(^{
                    setViewSize(CGSizeMake(32.0, 64.0));
                });
                
                it(@"should resize the image view to be a centered square", ^{
                    expect(view.subviews.firstObject.frame).to.equal(CGRectMake(0.0, 16.0, 32.0, 32.0));
                });
                it(@"should set label frame to centered zero size", ^{
                    expect(view.subviews.lastObject.frame).to.equal(CGRectMake(16.0, 32.0, 0.0, 0.0));
                });
            });
        });
    });
    
    describe(@"letters", ^{
        context(@"getter", ^{
            beforeEach(^{
                ((UILabel *)view.subviews.lastObject).text = @"NC";
            });
            
            it(@"should return text of the label", ^{
                expect(view.letters).to.equal(@"NC");
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.letters = @"AH";
            });
            
            it(@"should update text of the label", ^{
                expect(((UILabel *)view.subviews.lastObject).text).to.equal(@"AH");
            });
        });
    });
    
    describe(@"lettersColor", ^{
        context(@"getter", ^{
            beforeEach(^{
                ((UILabel *)view.subviews.lastObject).textColor = [UIColor redColor];
            });
            
            it(@"should return text color of the label", ^{
                expect(view.lettersColor).to.equal([UIColor redColor]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.lettersColor = [UIColor blueColor];
            });
            
            it(@"should update text of the label", ^{
                expect(((UILabel *)view.subviews.lastObject).textColor).to.equal([UIColor blueColor]);
            });
        });
    });
    
    describe(@"font", ^{
        context(@"getter", ^{
            beforeEach(^{
                ((UILabel *)view.subviews.lastObject).font = [UIFont systemFontOfSize:10.0];
            });
            
            it(@"should return text color of the label", ^{
                expect(view.font).to.equal([UIFont systemFontOfSize:10.0]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.font = [UIFont systemFontOfSize:20.0];
            });
            
            it(@"should update text of the label", ^{
                expect(((UILabel *)view.subviews.lastObject).font).to.equal([UIFont systemFontOfSize:20.0]);
            });
        });
    });
    
    describe(@"image", ^{
        __block UIImage *image;
        
        beforeEach(^{
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            image = [UIImage imageNamed:@"boatgif.gif" inBundle:bundle compatibleWithTraitCollection:nil];
        });
        
        context(@"getter", ^{
            beforeEach(^{
                ((UIImageView *)view.subviews.firstObject).image = image;
            });
            
            it(@"should return image from image view", ^{
                expect(view.image).to.equal(image);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.image = image;
            });
            
            it(@"should update image of the image view", ^{
                expect(((UIImageView *)view.subviews.firstObject).image).to.equal(image);
            });
        });
    });
    
    describe(@"borderColor", ^{
        context(@"getter", ^{
            beforeEach(^{
                ((UIImageView *)view.subviews.firstObject).layer.borderColor = [UIColor redColor].CGColor;
            });
            
            it(@"should return border color of image view", ^{
                expect(view.borderColor).to.equal([UIColor redColor]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.borderColor = [UIColor blueColor];
            });
            
            it(@"should update border color of the image view", ^{
                expect(((UIImageView *)view.subviews.firstObject).layer.borderColor).to.equal([UIColor blueColor].CGColor);
            });
        });
    });
    
    describe(@"borderWidth", ^{
        context(@"getter", ^{
            beforeEach(^{
                ((UIImageView *)view.subviews.firstObject).layer.borderWidth = 2.0;
            });
            
            it(@"should return border width of image view", ^{
                expect(view.borderWidth).to.equal(2.0);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.borderWidth = 4.0;
            });
            
            it(@"should update border width of the image view", ^{
                expect(((UIImageView *)view.subviews.firstObject).layer.borderWidth).to.equal(4.0);
            });
        });
    });
    
    describe(@"avatarBackgroundColor", ^{
        context(@"getter", ^{
            beforeEach(^{
                ((UIImageView *)view.subviews.firstObject).backgroundColor = [UIColor redColor];
            });
            
            it(@"should return border width of image view", ^{
                expect(view.avatarBackgroundColor).to.equal([UIColor redColor]);
            });
        });
        
        context(@"setter", ^{
            beforeEach(^{
                view.avatarBackgroundColor = [UIColor blueColor];
            });
            
            it(@"should update border width of the image view", ^{
                expect(((UIImageView *)view.subviews.firstObject).backgroundColor).to.equal([UIColor blueColor]);
            });
        });
    });
});

SpecEnd
