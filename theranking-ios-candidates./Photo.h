//
//  Photo.h
//  theranking-ios-candidates.
//
//  Created by Joaquin Perez Barroso on 23/11/14.
//  Copyright (c) 2014 Joaquin Perez Barroso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * resourceId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * itsDescription;
@property (nonatomic, retain) NSString * camera;
@property (nonatomic, retain) NSString * focal_length;
@property (nonatomic, retain) NSString * shutter_speed;
@property (nonatomic, retain) NSString * image_url;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) User *user;

@end
