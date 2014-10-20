//
//  TR500PxPhoto.m
//  TRCodeTest
//
//  Created by Oscar on 18/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import "TR500PxPhoto.h"

@implementation TR500PxPhoto

static NSString * RESPONSE_PHOTOS_JSON = @"photos";
static NSString * RESPONSE_NAME = @"name";
static NSString * RESPONSE_CAMERA = @"camera";
static NSString * RESPONSE_DESCRIPTION = @"description";
static NSString * RESPONSE_IMAGE_URL = @"image_url";
static NSString * RESPONSE_RATING = @"rating";
static NSString * RESPONSE_LATITUDE = @"latitude";
static NSString * RESPONSE_LONGITUDE = @"longitude";
static NSString * RESPONSE_USER = @"user";

+ (NSArray *)initWithResponse:(NSDictionary *)response {
    NSMutableArray *photos = [NSMutableArray array];
    
    for (NSDictionary *photo in response[RESPONSE_PHOTOS_JSON]) {
        TR500PxPhoto *myPhoto = [[TR500PxPhoto alloc] initWithPhoto:photo];
        [photos addObject:myPhoto];
    }
    return photos;
}

- (instancetype)initWithPhoto:(NSDictionary *)photo {
    if (self = [super init]) {
        _name = (photo[RESPONSE_NAME] != [NSNull null] ? photo[RESPONSE_NAME] : @"");
        _summary = (photo[RESPONSE_DESCRIPTION] != [NSNull null] ? photo[RESPONSE_DESCRIPTION] : @"Empty description");
        _camera = (photo[RESPONSE_CAMERA] != [NSNull null] ? photo[RESPONSE_CAMERA] : nil);
        
        _rating = [NSNumber numberWithDouble:[photo[RESPONSE_RATING] doubleValue]];
        
        _url = [NSURL URLWithString:photo[RESPONSE_IMAGE_URL]];
 
        if ([photo objectForKey:RESPONSE_LATITUDE] != [NSNull null]  && [photo objectForKey:RESPONSE_LONGITUDE] != [NSNull null]) {
 
            double latitude = [photo[RESPONSE_LATITUDE] doubleValue];
            double longitude = [photo[RESPONSE_LONGITUDE] doubleValue];

            _location = CLLocationCoordinate2DMake(latitude, longitude);
            _isValidLocation = CLLocationCoordinate2DIsValid(_location);
        }
        
        _user = [[TR500PxUser alloc] initWithUser:photo[RESPONSE_USER]];
    }
    return self;
}

@end
