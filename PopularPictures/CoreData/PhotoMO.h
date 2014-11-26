//
//  PhotoMO.h
//  PopularPictures
//
//  Created by Nelson on 25/11/14.
//  Copyright (c) 2014 Nelson Domínguez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PhotoMO : NSManagedObject

@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * photoId;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userImageUrl;
@property (nonatomic, retain) NSNumber * aperture;
@property (nonatomic, retain) NSString * camera;

@end
