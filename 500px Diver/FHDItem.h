//
//  FHDModel.h
//  500px Diver
//
//  Created by Jaime on 24/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>

// This class represent the basic model data inside application
// Is used to store all information about an item (a.k.a. photo)
@interface FHDItem : NSObject

// Unique identifier
@property (nonatomic, strong) NSNumber *identifier;
// Name of the item
@property (nonatomic, copy) NSString *name;
// Description for the item
@property (nonatomic, copy) NSString *desc;
// URL where the item image is stored
@property (nonatomic, copy) NSString *imageUrl;
// Rating for this item
@property (nonatomic, strong) NSNumber *rating;
// Info about the camera used in this item
@property (nonatomic, copy) NSString *camera;
// Latitude where the item was created
@property (nonatomic, strong) NSNumber *latitude;
// Longitude where the item was created
@property (nonatomic, strong) NSNumber *longitude;
// Name of the user owner of the item
@property (nonatomic, copy) NSString *userName;
// URL where the avatar for the user owner of the item is stored
@property (nonatomic, copy) NSString *userAvatarUrl;

/**
 * Creates a new item object with the given JSON
 * @param json JSON where data is allocated
 * @return a new item with data
 */
+ (instancetype)itemWithJSON:(NSDictionary *)json;

@end
