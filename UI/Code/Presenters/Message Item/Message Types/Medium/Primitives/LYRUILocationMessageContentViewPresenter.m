//
//  LYRUILocationMessageContentViewPresenter.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 03.09.2017.
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

#import "LYRUILocationMessageContentViewPresenter.h"
#import "LYRUIMessageItemView.h"
#import <MapKit/MapKit.h>
#import <LayerKit/LayerKit.h>
#import "NSCache+LYRUIImageCaching.h"
#import "LYRUILocationMessage.h"
#import "LYRUIDispatcher.h"
#import "LYRUIReusableViewsQueue.h"
#import "UIView+LYRUIMessageConfiguration.h"

@interface LYRUILocationMessageView: UIImageView
@end

@implementation LYRUILocationMessageView
@end

@implementation LYRUILocationMessageContentViewPresenter

- (UIImageView *)viewForMessage:(LYRUILocationMessage *)message {
    UIImageView *imageView = [self.reusableViewsQueue dequeueReusableViewOfType:[LYRUILocationMessageView class]];
    if (imageView == nil) {
        imageView = [[LYRUILocationMessageView alloc] init];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    imageView.image = nil;
    
    [self setupViewConstraints:imageView];
    [self setupImageView:imageView withMessageType:message];
    
    return imageView;
}

- (void)setupImageView:(__weak UIImageView *)imageView withMessageType:(LYRUILocationMessage *)messageType {
    CLLocationCoordinate2D location = messageType.location.coordinate;
    
    NSString *cachedImageIdentifier = [NSString stringWithFormat:@"%f,%f", location.latitude, location.longitude];
    UIImage *cachedImage = [self.imagesCache objectForKey:[NSURL fileURLWithPath:cachedImageIdentifier]];
    if (cachedImage) {
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = cachedImage;
        return;
    }
    
    NSString *contextId = [NSUUID UUID].UUIDString;
    imageView.lyr_presentationContextId = contextId;
    
    __weak __typeof(self) weakSelf = self;
    MKMapSnapshotter *snapshotter = [self snapshotterForLocation:location];
    [snapshotter startWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) completionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        if ([imageView lyr_isOutOfContext:contextId]) {
            return;
        }
        if (error) {
            [weakSelf.dispatcher dispatchAsyncOnMainQueue:^{
                imageView.contentMode = UIViewContentModeCenter;
                imageView.image = [UIImage imageNamed:@"layer-logo"];
            }];
            return;
        }
        UIImage *image = [weakSelf pinPhotoForSnapshot:snapshot withLocation:location];
        [weakSelf.dispatcher dispatchAsyncOnMainQueue:^{
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.image = image;
        }];
        [weakSelf.imagesCache setObject:image forKey:[NSURL fileURLWithPath:cachedImageIdentifier]];
    }];
}

- (UIImage *)pinPhotoForSnapshot:(MKMapSnapshot *)snapshot withLocation:(CLLocationCoordinate2D)location {
    // Create a pin image.
    MKAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:@""];
    UIImage *pinImage = pin.image;
    
    // Draw the image.
    UIImage *image = snapshot.image;
    UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
    [image drawAtPoint:CGPointMake(0, 0)];
    
    // Draw the pin.
    CGPoint point = [snapshot pointForCoordinate:location];
    [pinImage drawAtPoint:CGPointMake(point.x, point.y - pinImage.size.height)];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

- (MKMapSnapshotter *)snapshotterForLocation:(CLLocationCoordinate2D)location {
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
    options.region = MKCoordinateRegionMake(location, span);
    options.scale = [UIScreen mainScreen].scale;
    CGFloat size = MIN(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    options.size = CGSizeMake(size, size);
    return  [[MKMapSnapshotter alloc] initWithOptions:options];
}

- (void)setupViewConstraints:(UIView *)view {
    [super setupViewConstraints:view];
    [view.heightAnchor constraintEqualToConstant:152.0].active = YES;
    [view setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [view setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
}

- (CGFloat)viewHeightForMessage:(LYRUILocationMessage *)message minWidth:(CGFloat)minWidth maxWidth:(CGFloat)maxWidth {
    return 152.0;
}

@end
