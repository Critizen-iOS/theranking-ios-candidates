//
//  FHDManagedItem.h
//  500px Diver
//
//  Created by Jaime on 24/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

// This class represents the Managed Object model for item, used in Core Data
// All properties have correspondence with FHDItem properties
@interface FHDManagedItem : NSManagedObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, copy) NSString *camera;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userAvatarUrl;

@end
