//
//  MapCell.m
//  CritizenTestApp
//
//  Created by Patricio on 19/02/15.
//  Copyright (c) 2015 Patricio. All rights reserved.
//

#import "MapCell.h"

@implementation MapCell

@synthesize longitude;
@synthesize latitude;
@synthesize mapView;

- (void)awakeFromNib {
    // Initialization code
    [mapView setMapType:MKMapTypeHybrid];
    mapView.layer.borderWidth = 5.0f;
    mapView.layer.borderColor = [UIColor colorWithWhite:0.5f alpha:1.0f].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
