//
//  FHDPopularViewDelegate.h
//  500px Diver
//
//  Created by Jaime on 24/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FHDPopularItem.h"

// This protocol is used by the View to send events to the Presenter
// Must be implemented by the Presenter
@protocol FHDPopularViewDelegate <NSObject>

/**
 * Called when user selects an item to see its details
 * @param item item selected
 */
- (void)popularDidSelectItem:(FHDPopularItem *)item;

/**
 * Called when user reaches the end of the View and more data is required
 */
- (void)popularDidEndScroll;

@end
