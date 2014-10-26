//
//  FHDPopularViewInterface.h
//  500px Diver
//
//  Created by Jaime on 24/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>

// This protocol is used by the Presenter to send data to the View
// Must be implemented by the View
@protocol FHDPopularViewInterface <NSObject>

/**
 * Receives a list of items with data and show those items in View
 * @param items an array of items to show
 */
- (void)showPopularItems:(NSArray *)items;

@end
