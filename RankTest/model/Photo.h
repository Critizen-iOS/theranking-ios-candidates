//
//  Photo.h
//  RankTest
//
//  Created by Rafael Bartolome on 26/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * camera;
@property (nonatomic, retain) NSString * focal_length;
@property (nonatomic, retain) NSString * image_url;
@property (nonatomic, retain) NSString * photoDescription;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * shutter_speed;
@property (nonatomic, retain) NSString * aperture;
@property (nonatomic, retain) User *user;

@end
