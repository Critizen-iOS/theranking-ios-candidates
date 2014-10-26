//
//  FHDAppInitializer.h
//  500px Diver
//
//  Created by Jaime on 25/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>

// This class is used to initialize and connect all VIPER design pattern actors
@interface FHDAppInitializer : NSObject

/**
 * Returns the root view controller
 * @return root view controller
 */
- (UIViewController *)getRootViewController;

@end
