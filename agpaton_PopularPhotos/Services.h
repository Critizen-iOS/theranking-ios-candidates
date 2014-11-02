//
//  Services.h
//  agpaton_PopularPhotos
//
//  Created by Alejandro González Patón on 31/10/14.
//  Copyright (c) 2014 Alejandro González Patón. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"
#import "Photo.h"
#import "Camera.h"

@interface Services : NSObject

+ (void)GetMostPopularPhotosWithPage:(NSNumber *)page completion:(void (^)(BOOL success))callback;

@end
