//
//  FHDDataConnectionAvailability.h
//  500px Diver
//
//  Created by Jaime on 25/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>

// This class is used to check connectivity
@interface FHDDataConnectionAvailability : NSObject

/**
 * Checks if a data conenction is available
 * @return YES if there is an available data connection, NO otherwise
 */
+ (BOOL)isDataSourceAvailable;

@end
