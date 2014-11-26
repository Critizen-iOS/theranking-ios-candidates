//
//  MapViewAnnotation.m
//  PopularPictures
//
//  Created by Nelson on 26/11/14.
//  Copyright (c) 2014 Nelson Domínguez. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)paramCoordinates
{
    self = [super init];
    if (self) {
        coordinate = paramCoordinates;
    }
    return self;
}

@end
