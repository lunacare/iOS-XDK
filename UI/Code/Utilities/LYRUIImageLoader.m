
//  LYRUIImageLoader.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 02.10.2017.
//  Copyright (c) 2017 Layer. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "LYRUIImageLoader.h"
#import <ImageIO/ImageIO.h>
#import "LYRUIDataFactory.h"
#import "LYRUIImageFactory.h"

@interface LYRUIImageLoader ()

@property (nonatomic, strong) LYRUIDataFactory *dataFactory;
@property (nonatomic, strong) LYRUIImageFactory *imageFactory;

@end

@implementation LYRUIImageLoader

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataFactory = [[LYRUIDataFactory alloc] init];
        self.imageFactory = [[LYRUIImageFactory alloc] init];
    }
    return self;
}

#pragma mark - Public methods

- (UIImage *)imageForImageURL:(NSURL *)imageURL {
    NSData *imageData = [self.dataFactory dataWithContentsOfURL:imageURL];
    if (imageData == nil) {
        return nil;
    }
    
    if ([self isGifImageData:imageData]) {
        return [self animatedImageWithAnimatedGIFData:imageData];
    }
    return [self preloadedImage:[self.imageFactory imageWithData:imageData]];
}

- (UIImage *)animatedImageWithAnimatedGIFData:(NSData *)data {
    return [self animatedImageWithAnimatedGIFReleasingImageSource:CGImageSourceCreateWithData((__bridge CFTypeRef) data, NULL)];
}

- (UIImage *)animatedImageWithAnimatedGIFURL:(NSURL *)url {
    return [self animatedImageWithAnimatedGIFReleasingImageSource:CGImageSourceCreateWithURL((__bridge CFTypeRef) url, NULL)];
}

#pragma mark - Private methods

- (int)delayCentisecondsForImageWithSource:(CGImageSourceRef)source index:(size_t) index {
    int delayCentiseconds = 1;
    CFDictionaryRef const properties = CGImageSourceCopyPropertiesAtIndex(source, index, NULL);
    if (properties) {
        CFDictionaryRef const gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
        if (gifProperties) {
            NSNumber *gifFrameDuration = (__bridge id)CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFUnclampedDelayTime);
            if (gifFrameDuration == NULL || [gifFrameDuration doubleValue] == 0) {
                gifFrameDuration = (__bridge id)CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
            }
            if ([gifFrameDuration doubleValue] > 0) {
                // Even though the GIF stores the delay as an integer number of centiseconds, ImageIO “helpfully” converts that to seconds for us.
                delayCentiseconds = (int)lrint([gifFrameDuration doubleValue] * 100);
            }
        }
        CFRelease(properties);
    }
    return delayCentiseconds;
}

- (void)createImages:(CGImageRef[])imagesOut
           andDelays:(int[])delayCentisecondsOut
          withSource:(CGImageSourceRef)source
            andCount:(size_t)count {
    for (size_t i = 0; i < count; ++i) {
        imagesOut[i] = CGImageSourceCreateImageAtIndex(source, i, NULL);
        delayCentisecondsOut[i] = [self delayCentisecondsForImageWithSource:source index:i];
    }
}

- (int)sumValues:(int const *const)values withCount:(size_t const)count
{
    int theSum = 0;
    for (size_t i = 0; i < count; ++i) {
        theSum += values[i];
    }
    return theSum;
}

- (int)pairGCD:(int)gcd withDuration:(int)duration {
    if (duration < gcd) {
        return [self pairGCD:duration withDuration:gcd];
    }
    while (true) {
        int const r = duration % gcd;
        if (r == 0) {
            return gcd;
        }
        duration = gcd;
        gcd = r;
    }
}

- (int)vectorGCDWithCount:(size_t)count andValues:(int const *const)values {
    int gcd = values[0];
    for (size_t i = 1; i < count; ++i) {
        gcd = [self pairGCD:values[i] withDuration:gcd];
    }
    return gcd;
}

- (NSArray *)frameArrayWithCount:(size_t)count
                          images:(CGImageRef[])images
                          delays:(int[])delayCentiseconds
                   totalDuration:(int)totalDurationCentiseconds {
    int const gcd = [self vectorGCDWithCount:count andValues:delayCentiseconds];
    size_t const frameCount = totalDurationCentiseconds / gcd;
    UIImage *frames[frameCount];
    for (size_t i = 0, f = 0; i < count; ++i) {
        UIImage *const frame = [UIImage imageWithCGImage:images[i]];
        for (size_t j = delayCentiseconds[i] / gcd; j > 0; --j) {
            frames[f++] = frame;
        }
    }
    return [NSArray arrayWithObjects:frames count:frameCount];
}

- (void)releaseImages:(CGImageRef[])images withCount:(size_t)count {
    for (size_t i = 0; i < count; ++i) {
        CGImageRelease(images[i]);
    }
}

- (UIImage *)animatedImageWithAnimatedGIFImageSource:(CGImageSourceRef const)source {
    size_t const count = CGImageSourceGetCount(source);
    CGImageRef images[count];
    int delayCentiseconds[count]; // in centiseconds
    [self createImages:images andDelays:delayCentiseconds withSource:source andCount:count];
    int const totalDurationCentiseconds = [self sumValues:delayCentiseconds withCount:count];
    NSArray *const frames = [self frameArrayWithCount:count
                                               images:images
                                               delays:delayCentiseconds
                                        totalDuration:totalDurationCentiseconds];
    UIImage *const animation = [UIImage animatedImageWithImages:frames duration:(NSTimeInterval)totalDurationCentiseconds / 100.0];
    [self releaseImages:images withCount:count];
    return animation;
}

- (UIImage *)animatedImageWithAnimatedGIFReleasingImageSource:(CGImageSourceRef CF_RELEASES_ARGUMENT)source {
    if (source) {
        UIImage *const image = [self animatedImageWithAnimatedGIFImageSource:source];
        CFRelease(source);
        return image;
    } else {
        return nil;
    }
}

- (UIImage *)preloadedImage:(UIImage *)image {
    CGImageRef cgImage = image.CGImage;
    
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef imageContext =  CGBitmapContextCreate(NULL, width, height, 8, width*4, colourSpace,
                                                       kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(colourSpace);
    CGContextDrawImage(imageContext, CGRectMake(0, 0, width, height), cgImage);
    CGImageRef outputImage = CGBitmapContextCreateImage(imageContext);
    UIImage *cachedImage = [UIImage imageWithCGImage:outputImage];
    
    CGImageRelease(outputImage);
    CGContextRelease(imageContext);
    
    return cachedImage;
}

- (BOOL)isGifImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0x47:
            return YES;
        default:
            return NO;
    }
}

@end
