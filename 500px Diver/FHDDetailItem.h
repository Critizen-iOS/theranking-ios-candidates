//
//  FHDDetailItem.h
//  500px Diver
//
//  Created by Jaime on 25/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>

// This class represents the model used by Presenter and View
// It contains just the information that View needs to show
@interface FHDDetailItem : NSObject

// Name for this item
@property (nonatomic, copy) NSString *name;
// Description for this item
@property (nonatomic, copy) NSString *desc;
// Name of the user owner of this item
@property (nonatomic, copy) NSString *userName;
// URL image for the avatar for the user owner of this item
@property (nonatomic, copy) NSString *userAvatarUrl;
// Information about the camera used in this item
@property (nonatomic, copy) NSString *camera;
// Latitude where item was created
@property (nonatomic, strong) NSNumber *latitude;
// Longitude where item was created
@property (nonatomic, strong) NSNumber *longitude;

@end
