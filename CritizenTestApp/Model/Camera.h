//
//  Camera.h
//  CritizenTestApp
//
//  Created by Patricio on 19/02/15.
//  Copyright (c) 2015 Patricio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Camera : NSManagedObject

@property (nonatomic, retain) NSString * aperture;
@property (nonatomic, retain) NSString * camera;
@property (nonatomic, retain) NSString * focal_length;
@property (nonatomic, retain) NSString * iso;
@property (nonatomic, retain) NSString * lens;
@property (nonatomic, retain) NSString * shutter_speed;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Camera (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
