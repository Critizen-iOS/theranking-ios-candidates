//
//  CZPhoto.h
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CZCamera, CZUser;

@interface CZPhoto : NSManagedObject

@property (nonatomic, retain) NSString * descrip;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) CZUser *author;
@property (nonatomic, retain) CZCamera *camera;


+ (CZPhoto *) createPhotoWithJSONData:(NSDictionary *) jsonData context:(NSManagedObjectContext *) context;

@end
