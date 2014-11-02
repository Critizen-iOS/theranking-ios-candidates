//
//  Photo.h
//  agpaton_PopularPhotos
//
//  Created by Alejandro González Patón on 02/11/14.
//  Copyright (c) 2014 Alejandro González Patón. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Camera, User;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * photo_description;
@property (nonatomic, retain) NSNumber * photo_id;
@property (nonatomic, retain) NSNumber * photo_latitude;
@property (nonatomic, retain) NSNumber * photo_longitude;
@property (nonatomic, retain) NSString * photo_name;
@property (nonatomic, retain) NSNumber * photo_rating;
@property (nonatomic, retain) NSString * photo_imageUrl;
@property (nonatomic, retain) Camera *photo_camera_info;
@property (nonatomic, retain) User *photo_user_info;

@end
