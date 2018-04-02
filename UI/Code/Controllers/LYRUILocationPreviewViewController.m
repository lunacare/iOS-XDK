//
//  LYRUILocationPreviewViewController.m
//  Layer-XDK-UI-iOS
//
//  Created by Łukasz Przytuła on 16.01.2018.
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

#import "LYRUILocationPreviewViewController.h"
#import <MapKit/MapKit.h>

@interface LYRUILocationPreviewViewController ()

@property (nonatomic, readonly) MKMapView *mapView;

@end

@implementation LYRUILocationPreviewViewController

- (void)loadView {
    self.view = [[MKMapView alloc] init];
}

- (void)viewDidLoad {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                          target:self
                                                                                          action:@selector(donePressed:)];
}

- (void)showCoordinate:(CLLocationCoordinate2D)coordinate {
    self.mapView.centerCoordinate = coordinate;
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    pin.coordinate = coordinate;
//    myAnnotation.title = "Current location"
    [self.mapView addAnnotation:pin];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
    self.mapView.region = viewRegion;
}

- (MKMapView *)mapView {
    if ([self.view isKindOfClass:[MKMapView class]]) {
        return (MKMapView *)self.view;
    }
    return nil;
}

- (IBAction)donePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
