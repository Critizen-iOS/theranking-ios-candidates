//
//  CZCamera.h
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CZPhoto;

@interface CZCamera : NSManagedObject

@property (nonatomic, retain) NSString * lens;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSSet *photos;
@end

@interface CZCamera (CoreDataGeneratedAccessors)

+ (CZCamera *) createCameraWithJSONData:(NSDictionary *) jsonData context:(NSManagedObjectContext *) context;

- (void)addPhotosObject:(CZPhoto *)value;
- (void)removePhotosObject:(CZPhoto *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
