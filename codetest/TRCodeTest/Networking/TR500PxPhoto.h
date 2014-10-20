//
//  TR500PxPhoto.h
//  TRCodeTest
//
//  Created by Oscar on 18/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import "TR500PxUser.h"

@interface TR500PxPhoto : NSObject 

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *summary;
@property (strong, nonatomic, readonly) NSString *camera;

@property (strong, nonatomic, readonly) NSNumber *rating;
@property (strong, nonatomic, readonly) NSURL *url;

@property (assign, nonatomic, readonly) CLLocationCoordinate2D location;

@property (strong, nonatomic, readonly) TR500PxUser *user;

@property (assign, nonatomic, getter=hasLocation, readonly) BOOL isValidLocation;

/**
 *  Return list of TR500PxPhotos
 *
 *  @param response raw response data
 *
 *  @return list of TR500PxPhotos
 */
+ (NSArray *)initWithResponse:(NSDictionary *)response;

@end
