//
//  CZUser.h
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CZPhoto;

@interface CZUser : NSManagedObject

@property (nonatomic, retain) NSString * avatarURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *photos;

@end

@interface CZUser (CoreDataGeneratedAccessors)

+ (CZUser *) createUserWithJSONData:(NSDictionary *) jsonData context:(NSManagedObjectContext *) context;

- (void)addPhotosObject:(CZPhoto *)value;
- (void)removePhotosObject:(CZPhoto *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
