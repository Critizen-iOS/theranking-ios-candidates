//
//  Camera.h
//  agpaton_PopularPhotos
//
//  Created by Alejandro González Patón on 31/10/14.
//  Copyright (c) 2014 Alejandro González Patón. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Camera : NSManagedObject

@property (nonatomic, retain) NSString * camera_name;
@property (nonatomic, retain) NSString * camera_iso;
@property (nonatomic, retain) NSString * camera_lens;
@property (nonatomic, retain) NSString * camera_shutter_speed;
@property (nonatomic, retain) NSString * camera_aperture;
@property (nonatomic, retain) NSString * camera_focal_length;
@property (nonatomic, retain) Photo *photo;

@end
