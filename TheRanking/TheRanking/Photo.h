//
//  Photo.h
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 26/10/14.
//  Copyright (c) 2014 Jesús Emilio Fernández de Frutos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * camera;
@property (nonatomic, retain) NSString * description_;
@property (nonatomic, retain) NSString * image_url;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSManagedObject *user;

@end
