//
//  PXPhoto.m
//  Ranking 500px
//
//  Created by Moisés Moreno on 25/11/14.
//  Copyright (c) 2014 sés. All rights reserved.
//

#import "PXPhoto.h"

#import "NSDictionary+Data.h"
#import <CoreLocation/CoreLocation.h>


#pragma mark - = Lookup tables = -

//! Number of categories.
static const NSInteger NUM_CATEGORIES = 28;
//! Category names.
static NSString *const CATEGORY_NAME[NUM_CATEGORIES] = {
    @"Uncategorized",
    @"Celebrities",
    @"Film",
    @"Journalism",
    @"Nude",
    @"Black and White",
    @"Still Life",
    @"People",
    @"Landscapes",
    @"City and Architecture",
    @"Abstract",
    @"Animals",
    @"Macro",
    @"Travel",
    @"Fashion",
    @"Commercial",
    @"Concert",
    @"Sport",
    @"Nature",
    @"Performing Arts",
    @"Family",
    @"Street",
    @"Underwater",
    @"Food",
    @"Fine Art",
    @"Wedding",
    @"Transportation",
    @"Urban Exploration"
};

//! Number of licenses
static const NSInteger NUM_LICENSES = 7;
//! License names.
static NSString *const LICENSE_NAME[NUM_LICENSES] = {
    @"Standard 500px License",
    @"Creative Commons License Non Commercial Attribution",
    @"Creative Commons License Non Commercial No Derivatives",
    @"Creative Commons License Non Commercial Share Alike",
    @"Creative Commons License Attribution",
    @"Creative Commons License No Derivatives",
    @"Creative Commons License Share Alike"
};


#pragma mark - = PXImage = -

@implementation PXImage

#pragma mark - Creation -

/*
 * Create a new image object from JSON.
 *
 * \param json JSON object.
 */
- (instancetype)initWithJSON:(NSDictionary *)json
{
    if( (self = [super init]) ) {
        _size = [json shortForKey:@"size"];
        _url = [json valueForKey:@"url"];
        _httpsUrl = [json valueForKey:@"https_url"];
        _format = [json valueForKey:@"format"];
    }

    return self;
}

@end



#pragma mark - = PXPhoto = -

@implementation PXPhoto

#pragma mark - Creation -

/*
 * Create a new photo object from JSON.
 *
 * \param json JSON object.
 */
- (instancetype)initWithJSON:(NSDictionary *)json
{
    if( (self = [super init]) ) {
        _photoId = [json integerForKey:@"id"];
        _name = [json valueForKey:@"name"];
        _photoDescription = [json valueForKey:@"description"];
        _rating = [json floatForKey:@"rating"];
        
        _camera = [json valueForKey:@"camera"];
        _lens = [json valueForKey:@"lens"];
        _focalLength = [json valueForKey:@"focal_length"];
        _iso = [json valueForKey:@"iso"];
        _shutterSpeed = [json valueForKey:@"shutter_speed"];
        _aperture = [json valueForKey:@"aperture"];
        
        _location = [json valueForKey:@"location"];
        
        NSString *strLat = [json valueForKey:@"latitude"];
        _latitude = strLat ? [strLat doubleValue] : kCLLocationCoordinate2DInvalid.latitude;
        NSString *strLon = [json valueForKey:@"longitude"];
        _longitude = strLon ? [strLon doubleValue] : kCLLocationCoordinate2DInvalid.longitude;
        
        // read images
        if( true ) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for( NSDictionary *jsonImage in [json valueForKey:@"images"] ) {
                PXImage *pxImage = [[PXImage alloc] initWithJSON:jsonImage];
                [arr addObject:pxImage];
            }
            
            _images = [[NSArray alloc] initWithArray:arr];
        }
        
        // read user
        _user = [[PXUser alloc] initWithJSON:[json valueForKey:@"user"]];
    }

    return self;
}

@end
