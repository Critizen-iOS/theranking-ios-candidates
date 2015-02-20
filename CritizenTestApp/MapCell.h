//
//  MapCell.h
//  CritizenTestApp
//
//  Created by Patricio on 19/02/15.
//  Copyright (c) 2015 Patricio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapCell : UITableViewCell <MKMapViewDelegate>

@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
